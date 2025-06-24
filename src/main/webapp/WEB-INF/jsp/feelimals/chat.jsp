<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/jsp/feelimals/common/head.jspf"%>
<%@ include file="/WEB-INF/jsp/feelimals/common/header.jspf"%>
<title>Feelimals Chat</title>
<link rel="stylesheet" href="/resource/style.css">
<style>
body {
	background-color: #FAF7F5;
	font-family: 'Lato', sans-serif;
	margin: 0;
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
<body class="bg-[#FAF7F5] min-h-screen">

	<div class="chat-container">
		<div class="chat-box" id="chatBox">

			<!-- 캐릭터가 먼저 말하기 -->
			 <div class="msg him">오늘 어떻게 보냈어?</div> 

			<c:forEach var="msg" items="${messages}">
				<c:if test="${msg.thisChat}">
					<div class="msg you">${msg.body}</div>
				</c:if>
				<c:if test="${not empty msg.aiReply}">
					<div class="msg him">${msg.aiReply}</div>
				</c:if>
			</c:forEach>
		</div>

		<!-- 입력창 -->
		<div class="chat-input">
			<input type="text" id="userInput" placeholder="오늘 있었던 일을 말해봐." class="bg-white" autocomplete="off" />
			<button type="button" onclick="sendMessage()">보내기</button>
		</div>
	</div>

	<script>
	
	window.sessionId = "${param.sessionId}";
	

	
		/* function sendMessage() {
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
				}); */
	</script>

</body>
</html>
