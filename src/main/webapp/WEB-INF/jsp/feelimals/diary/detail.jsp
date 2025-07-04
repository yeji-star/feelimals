<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="/WEB-INF/jsp/feelimals/common/head.jspf"%>


<body class="bg-[#FAF7F5] min-h-screen">

	<%@ include file="/WEB-INF/jsp/feelimals/common/header.jspf"%>
	<%@ include file="/WEB-INF/jsp/feelimals/common/settings.jspf"%>

	<!-- 본문 -->
	<div class="flex justify-center gap-6 items-start px-10 pt-12">
		<!-- 일기 내용 박스 -->

		<div class="relative bg-[#FFF3E9] p-6 rounded-2xl w-full max-w-2xl mx-auto shadow-md min-h-[350px]">

			<!-- 감정태그 출력 (일기 내용 위) -->
			<div class="flex items-center mb-3">
				<c:choose>
					<c:when test="${diary.emoTagId == 1}">
						<span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold"
							style="background-color: #FFE082; color: #6d4c00;">
							<i class="fa-solid fa-paw" style="color: #ffcb2e;"></i>
							<span class="ml-2">기쁨</span>
						</span>
					</c:when>
					<c:when test="${diary.emoTagId == 2}">
						<span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold"
							style="background-color: #90CAF9; color: #19427c;">
							<i class="fa-solid fa-paw" style="color: #51abfb;"></i>
							<span class="ml-2">슬픔</span>
						</span>
					</c:when>
					<c:when test="${diary.emoTagId == 3}">
						<span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold"
							style="background-color: #FF8A65; color: #702009;">
							<i class="fa-solid fa-paw" style="color: #ff4405;"></i>
							<span class="ml-2">분노</span>
						</span>
					</c:when>
					<c:when test="${diary.emoTagId == 4}">
						<span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold"
							style="background-color: #B39DDB; color: #4b2c6d;">
							<i class="fa-solid fa-paw" style="color: #895ed9;"></i>
							<span class="ml-2">불안</span>
						</span>
					</c:when>
					<c:otherwise>
						<span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-semibold"
							style="background-color: #E0E0E0; color: #4e4e4e;">
							<i class="fa-solid fa-paw" style="color: #8a8a8a;"></i>
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
		<div class="flex flex-col items-end self-end">
			<div class="text-sm group mr-2">
				<a href="/feelimals/chatDiary/list" class="text-sm group-hover:text-blue-500">목록</a>
				으로 갈래?
			</div>

			<img src="/resource/img/chara_${rq.loginedMember.charaId }_5.png" alt="캐릭터" alt="AI 캐릭터"
				class="w-40 h-40 object-contain" />
		</div>
	</div>
</body>
