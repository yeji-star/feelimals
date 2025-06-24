package com.example.feel.vo;

import java.io.IOException;

import org.springframework.context.annotation.Scope;
import org.springframework.context.annotation.ScopedProxyMode;
import org.springframework.stereotype.Component;

import com.example.feel.service.MemberService;
import com.example.feel.util.Ut;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.Getter;
import lombok.Setter;

@Component
@Scope(value = "request", proxyMode = ScopedProxyMode.TARGET_CLASS)
@Getter
@Setter
public class Rq {

	private final HttpServletRequest req;
	private final HttpServletResponse resp;
	private final HttpSession session;

	private boolean isLogined = false;
	private int loginedMemberId = 0;

	@Getter
	private Member loginedMember;

	public Rq(HttpServletRequest req, HttpServletResponse resp, MemberService memberService) {
		this.req = req;
		this.resp = resp;
		this.session = req.getSession();

		if (session.getAttribute("loginedMemberId") != null) {
			isLogined = true;
			loginedMemberId = (int) session.getAttribute("loginedMemberId");
			loginedMember = memberService.getMemberById(loginedMemberId);
		}

		this.req.setAttribute("rq", this);
	}

	public void printHistoryBack(String msg) throws IOException {
		resp.setContentType("text/html; charset=UTF-8");
		println("<script>");
		if (!Ut.isEmpty(msg)) {
			println("alert('" + msg.replace("'", "\\'") + "');");
		}
		println("history.back();");
		println("</script>");
		resp.getWriter().flush();
		resp.getWriter().close();
	}

	private void println(String str) throws IOException {
		print(str + "\n");
	}

	private void print(String str) throws IOException {
		resp.getWriter().append(str);
	}

	public void logout() {
		session.removeAttribute("loginedMemberId");
		session.removeAttribute("loginedMember");
	}

	public void login(Member member) {
		session.setAttribute("loginedMemberId", member.getId());
		session.setAttribute("loginedMember", member);
	}

	public void initBeforeActionInterceptor() {
		System.err.println("initBeforeActionInterceptor 실행됨");
	}

	public String historyBackOnView(String msg) {
		req.setAttribute("msg", msg);
		req.setAttribute("historyBack", true);
		return "feelimals/common/js";
	}

	public String getCurrentUri() {
		String currentUri = req.getRequestURI();
		String queryString = req.getQueryString();

		System.out.println(currentUri);
		System.out.println(queryString);

		if (currentUri != null && queryString != null) {
			currentUri += "?" + queryString;
		}

		return currentUri;
	}
	
	public void printReplace(String resultCode, String msg, String replaceUri) throws IOException {
		resp.setContentType("text/html; charset=UTF-8");
		print(Ut.jsReplace(resultCode, msg, replaceUri));
	}

	public String getEncodedCurrentUri() {
		return Ut.getEncodedCurrentUri(getCurrentUri());
	}
	
	public String getLoginUri() {
		return "../member/login?afterLoginUri=" + getAfterLoginUri();
	}

	private String getAfterLoginUri() {
		return getEncodedCurrentUri();
	}
	
	public String getFindLoginIdUri() {
		return "../member/findLoginId?afterFindLoginIdUri=" + getAfterFindLoginIdUri();
	}

	private String getAfterFindLoginIdUri() {
		return getEncodedCurrentUri();
	}

	public String getFindLoginPwUri() {
		return "../member/findLoginPw?afterFindLoginPwUri=" + getAfterFindLoginPwUri();
	}

	private String getAfterFindLoginPwUri() {
		return getEncodedCurrentUri();
	}
}