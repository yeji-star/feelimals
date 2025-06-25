package com.example.feel.controller;

import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.feel.service.DiaryWithChatService;
import com.example.feel.service.SettingService;
import com.example.feel.vo.DiaryWithChat;
import com.example.feel.vo.Member;
import com.example.feel.vo.ResultData;
import com.example.feel.vo.Rq;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/feelimals/setting")
public class SettingController {

	@Autowired
	private Rq rq;

	@Autowired
	private SettingService settingService;

	// 캐릭터 설정

	@PostMapping("/changeChara")
	@ResponseBody
	public ResultData changeChara(@RequestParam int charaId) {
		Member member = rq.getLoginedMember();

		if (member == null) {
			return ResultData.from("F-1", "로그인이 되어있지 않아.");
		}

		settingService.changeChara(member.getId(), charaId);

		return ResultData.from("S-1", "캐릭터가 변경됐어!");
	}

}
