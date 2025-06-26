<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<!-- 상단 메뉴 -->
<%@ include file="/WEB-INF/jsp/feelimals/common/head.jspf"%>
<%@ include file="/WEB-INF/jsp/feelimals/common/header.jspf"%>
<%@ include file="/WEB-INF/jsp/feelimals/common/settings.jspf"%>
<title>대화 상세보기</title>
<link rel="stylesheet" href="/resource/style.css">
<style>
body {
	background-color: #FAF7F5;
	font-family: 'Lato', sans-serif;
	margin: 0;
}

.chat-msg-wrapper {
	display: flex;
	align-items: flex-end;
	gap: 0.5rem;
}

.chat-msg-wrapper.ai {
	justify-content: flex-start;
}

.chat-msg-wrapper.user {
	justify-content: flex-end;
}

.character-img {
	width: 60px;
	height: 60px;
	object-fit: contain;
	flex-shrink: 0;
}

.chat-container {
	max-width: 600px;
	margin: 0 auto;
	padding: 1rem;
	position: relative;
	display: flex;
	flex-direction: column;
	height: 90vh;
}

.chat-box {
	flex: 1;
	overflow-y: auto;
	display: flex;
	flex-direction: column;
	gap: 0.5rem;
	padding: 1rem 0;
}

.msg {
	display: inline-block;
	max-width: 70%;
	padding: 0.75rem 1rem;
	border-radius: 1rem;
	word-break: break-word;
	font-size: 0.95rem;
}

.msg.him {
	background-color: #e0e0e0;
	align-self: flex-start;
	border-bottom-left-radius: 0.2rem;
}

.msg.you {
	background-color: #FFD8B1;
	align-self: flex-end;
	border-bottom-right-radius: 0.2rem;
}

.chat-input {
	display: flex;
	gap: 0.5rem;
	padding-top: 1rem;
}

.chat-input input {
	flex: 1;
	padding: 0.5rem 1rem;
	font-size: 1rem;
	border: 1px solid #ccc;
	border-radius: 1rem;
}

.chat-input button {
	background-color: #FFA726;
	border: none;
	padding: 0.5rem 1rem;
	border-radius: 1rem;
	cursor: pointer;
	color: white;
}
</style>
</head>
<script>
	window.sessionId = "${sessionId}";
</script>

<body class="bg-[#FAF7F5] min-h-screen">

	<div class="relative">
		${item.body}

		<!-- 메뉴 버튼 -->
		<button onclick="toggleEditMenu()" class="absolute top-4 right-4 hover:opacity-80 transition"
			style="color: #FFA726; font-size: 21px;">☰</button>

		<!-- 수정/삭제 -->
		<div id="editMenu"
			class="absolute top-4 right-4 px-3 py-2 rounded-xl text-base shadow space-y-1 hidden border transition-all"
			style="background-color: #FFD8A1; border-color: #FDC78A;">

			<button onclick="toggleEditMenu()" class="float-right text-sm font-bold" style="color: #FB8C00;">✕</button>
			<br>
			<a href="/feelimals/chat/deleteChat?id=${sessionId}" onclick="return confirm('정말 삭제할까?');"
				class="block text-center py-1 rounded font-semibold transition" style="color: #E53935;">삭제</a>
		</div>
	</div>

	<div class="chat-container">
		<div class="chat-box" id="chatBox">
			<!-- 캐릭터가 먼저 말하기 -->
			<div class="chat-msg-wrapper ai">
				<img src="/resource/img/chara_${rq.loginedMember.charaId }_5.png" class="character-img" alt="AI 캐릭터" />
				<div class="msg him">오늘 어떻게 보냈어?</div>
			</div>

			<c:forEach var="items" items="${messages}">

				<div class="msg you">${items.body}</div>

				<div class="chat-msg-wrapper ai">
					<c:choose>
						<c:when test="${not empty items.emoTagId}">
							<img src="/resource/img/chara_${rq.loginedMember.charaId }_${items.emoTagId}.png" class="character-img" />
						</c:when>
						<c:otherwise>
							<img src="/resource/img/chara_${rq.loginedMember.charaId }_5.png" class="character-img" />
						</c:otherwise>
					</c:choose>
					<div class="msg him">${items.aiReply}</div>
				</div>

			</c:forEach>
		</div>

		<!-- 입력창 -->
		<div class="chat-input">
			<input type="text" id="userInput" placeholder="오늘 있었던 일을 말해봐." class="input input-warning" disabled>
			<button onclick="sendMessage()" disabled>보내기</button>
		</div>
	</div>
	


	<script>
		function sendMessage() {
			const input = document.getElementById("userInput");
			const message = input.value.trim();
			if (message === "")
				return;

			const chatBox = document.getElementById("chatBox");
			const userMsg = document.createElement("div");
			userMsg.className = "msg you";
			userMsg.textContent = message;
			chatBox.appendChild(userMsg);

			input.value = "";

			// 스크롤 맨 아래로
			chatBox.scrollTop = chatBox.scrollHeight;
		}

		// 엔터로도 전송
		document.getElementById("userInput").addEventListener("keydown",
				function(e) {
					if (e.key === "Enter") {
						e.preventDefault();
						sendMessage();
					}
				});

		function toggleEditMenu(button) {
			const menu = button.nextElementSibling;
			menu.classList.toggle('hidden');
		}

		// 수정 가능 상태로 만들기
		function enableEdit(chatId) {
			const input = document.getElementById("userInput");
			input.disabled = false;
			input.focus();

			document.getElementById("sendBtn").innerText = "수정 저장";
			document.getElementById("sendBtn").setAttribute("data-edit-id",
					chatId);
		}
	</script>

</body>
</html>
