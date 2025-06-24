<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="/WEB-INF/jsp/feelimals/common/head.jspf"%>
<%@ include file="/WEB-INF/jsp/feelimals/common/header.jspf"%>

<body class="bg-[#FAF7F5] min-h-screen">


	<!-- 본문 -->
	<div class="relative px-6 py-12 ">
		<!-- 일기 내용 박스 -->

		<div class="relative bg-[#FFF3E9] p-6 rounded-2xl w-[80%] max-w-2xl mx-auto shadow-md min-h-[350px]">

			<!-- 감정태그 출력 (일기 내용 위) -->
			<div class="flex items-center mb-3">
				<c:choose>
					<c:when test="${diary.emoTagId == 1}">
						<span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold"
							style="background-color: #FFE082; color: #6d4c00;">
							😊
							<span class="ml-2">기쁨</span>
						</span>
					</c:when>
					<c:when test="${diary.emoTagId == 2}">
						<span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold"
							style="background-color: #90CAF9; color: #19427c;">
							😔
							<span class="ml-2">슬픔</span>
						</span>
					</c:when>
					<c:when test="${diary.emoTagId == 3}">
						<span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold"
							style="background-color: #FF8A65; color: #702009;">
							😠
							<span class="ml-2">분노</span>
						</span>
					</c:when>
					<c:when test="${diary.emoTagId == 4}">
						<span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold"
							style="background-color: #B39DDB; color: #4b2c6d;">
							😰
							<span class="ml-2">불안</span>
						</span>
					</c:when>
					<c:otherwise>
						<span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold"
							style="background-color: #E0E0E0; color: #4e4e4e;">
							❓
							<span class="ml-2">분류안함</span>
						</span>
					</c:otherwise>
				</c:choose>
			</div>

			<c:if test="${diary.userCanModify}">
				<button onclick="toggleEditMenu()" class="absolute top-4 right-4 hover:opacity-80 transition"
					style="color: #FFA726; font-size: 21px;">☰</button>
				<div id="editMenu"
					class="absolute top-4 right-4 px-3 py-2 rounded-xl text-base shadow space-y-1 hidden border transition-all"
					style="background-color: #FFD8A1; border-color: #FDC78A;">

					<button onclick="toggleEditMenu()" class="float-right text-sm font-bold" style="color: #FB8C00;">✕</button>
					<br>
					<a href="/feelimals/diary/modify?id=${diary.id}" class="block text-center py-1 rounded font-semibold transition"
						style="color: #FB8C00;">수정</a>
					<a href="/feelimals/diary/doDelete?id=${diary.id}" onclick="return confirm('정말 삭제할까?');"
						class="block text-center py-1 rounded font-semibold transition" style="color: #E53935;">삭제</a>
				</div>
			</c:if>
			<div class="text-gray-800 text-base whitespace-pre-line">${diary.body}</div>

			<!-- 그만 볼래 버튼 -->
			<div class="absolute bottom-4 right-4">
				<a href="/feelimals/chatDiary/list" class="bg-[#FFD8A1] px-3 py-1 rounded-md shadow text-sm">그만 볼래</a>
			</div>
		</div>

		<!-- 캐릭터 이미지 -->
		<div class="absolute bottom-6 right-6">
			<img src="/resource/images/animals/${sessionScope.user.characterImg}" class="w-20 h-20 object-contain" />
		</div>
	</div>
</body>
