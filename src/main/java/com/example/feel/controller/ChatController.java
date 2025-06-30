package com.example.feel.controller;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;

import com.example.feel.service.ChatService;
import com.example.feel.service.DiaryService;
import com.example.feel.util.Ut;
import com.example.feel.vo.Chat;
import com.example.feel.vo.ChatSession;
import com.example.feel.vo.ChatWithAi;
import com.example.feel.vo.Diary;
import com.example.feel.vo.ResultData;
import com.example.feel.vo.Rq;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/feelimals/chat")
public class ChatController {

	@Autowired
	private Rq rq;

	@Autowired
	private ChatService chatService;

	// 채팅 시작 (1차 감정 분석 -> 2차 피드백 생성 -> DB 저장)

	@PostMapping("")
	@ResponseBody
	public ResultData<Map<String, Object>> doWrite(@RequestParam String body) {

		// 사용자
		int memberId = rq.getLoginedMemberId();

		// 새 세션 생성
		int sessionId = chatService.createNewChatSession(memberId);
		
		String firstAi = "오늘 어떻게 보냈어?";
		int firstChatAi = chatService.writeUserMessage(memberId, sessionId, firstAi, 5, false, true);

		// 1. 1차- 감정 추출 요청
		String emotion = chatService.getEmotion(body);

		// 2. db에서 추출한 감정 이름 찾기
		int emoTagId = chatService.getEmoTagIdByEmotion(emotion);

		// 3. 사용자 메시지 저장
		int chatId = chatService.writeUserMessage(memberId, sessionId, body, emoTagId, true, true);

		// 4. 2차- 피드백 생성 요청
		String feedback = chatService.sendFeedback(body, emotion);

		// 6. AI 응답 저장
		chatService.writeAiReply(chatId, feedback, "gpt-3.5-turbo");

		// 7. 사용자 메시지 리턴
		List<ChatWithAi> messages = chatService.getChatsWithAiBySessionId(sessionId);

		Map<String, Object> result = new HashMap<>();
		result.put("messages", messages);
		result.put("sessionId", sessionId);
		return ResultData.from("S-1", "채팅 성공", "data1", result);
	}

	// 채팅 쌓기
	@PostMapping("/add")
	@ResponseBody
	public ResultData<Map<String, Object>> addMessage(@RequestParam int sessionId, @RequestParam String body) {
		int memberId = rq.getLoginedMemberId();

		// 1차 감정
		String emotion = chatService.getEmotion(body);

		// emoTagId 찾기
		int emoTagId = chatService.getEmoTagIdByEmotion(emotion);

		// 사용자 메시지 저장
		int chatId = chatService.writeUserMessage(memberId, sessionId, body, emoTagId, true, true);

		// 2차 피드백
		String feedback = chatService.sendFeedback(body, emotion);

		// AI 응답 저장
		chatService.writeAiReply(chatId, feedback, "gpt-3.5-turbo");

		// 전체 메시지 리턴
		List<ChatWithAi> messages = chatService.getChatsWithAiBySessionId(sessionId);

		Map<String, Object> result = new HashMap<>();
		result.put("messages", messages);
		result.put("sessionId", sessionId);
		return ResultData.from("S-1", "메시지 추가 성공", "data1", result);
	}

	// 상세 화면

	@GetMapping("/detail")
	public String showDetail(HttpServletRequest req, @RequestParam int sessionId, Model model) {
		Rq rq = (Rq) req.getAttribute("rq");
		int memberId = rq.getLoginedMemberId();

		List<ChatWithAi> messages = chatService.getChatsWithAiBySessionId(sessionId);

		System.out.println("sessionId: " + sessionId);
		System.out.println("불러온 메시지 수: " + messages.size());

		model.addAttribute("messages", messages);
		model.addAttribute("sessionId", sessionId);

		ChatSession session = chatService.getChatSessionById(sessionId);
		boolean userCanDelete = (session != null && session.getMemberId() == memberId);
		model.addAttribute("userCanDelete", userCanDelete);

		return "feelimals/chat/detail";
	}

	// 대화 한개만 삭제하기 (나중에 하던가 해야지...)

//    @PostMapping("/delete")
//    @ResponseBody
//    public ResultData<?> doDelete(@RequestParam int chatId) {
//        int memberId = rq.getLoginedMemberId();
//        
//        chatService.deleteById(memberId, chatId);
//        
//        return ResultData.from("S-1", "삭제 했어.");
//    }

	// 대화 전체 삭제

	@RequestMapping("/deleteChat")
	@ResponseBody
	public String doDeleteChatSession(HttpServletRequest req, Model model, int id) {

		Rq rq = (Rq) req.getAttribute("rq");

		ChatSession sessionId = chatService.getChatSessionById(id);

		if (sessionId == null) {
			return Ut.jsHistoryBack("F-1", Ut.f("%d번 대화는 없어.", id));
		}

		ResultData userCanDeleteRd = chatService.userCanDeleteSession(rq.getLoginedMemberId(), sessionId);

		if (userCanDeleteRd.isFail()) {
			return Ut.jsHistoryBack(userCanDeleteRd.getResultCode(), userCanDeleteRd.getMsg());
		}

		if (userCanDeleteRd.isSuccess()) {
			chatService.doDeleteChatSession(id);
		}

		return Ut.jsReplace(userCanDeleteRd.getResultCode(), userCanDeleteRd.getMsg(), "../chatDiary/list");
	}

}
