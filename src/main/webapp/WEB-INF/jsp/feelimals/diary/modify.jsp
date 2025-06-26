<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/jsp/feelimals/common/head.jspf"%>

<meta charset="UTF-8">
<title>일기 수정</title>
<script src="https://cdn.tailwindcss.com"></script>
<script>
  function selectEmoTag(id) {
    document.querySelectorAll('.emotag-btn').forEach(btn => btn.classList.remove('ring-4', 'ring-orange-300'));
    document.getElementById('emoTagBtn-' + id).classList.add('ring-4', 'ring-orange-300');
    document.getElementById('emoTagIdInput').value = id;
  }
  // 페이지 진입 시 선택된 태그에 강조 적용
  window.onload = function() {
    var selected = document.getElementById('emoTagIdInput').value;
    if(selected){
      selectEmoTag(selected);
    }
  }
</script>
</head>
<body class="bg-[#FAF7F5] min-h-screen">

	<%@ include file="/WEB-INF/jsp/feelimals/common/header.jspf"%>
	<%@ include file="/WEB-INF/jsp/feelimals/common/settings.jspf"%>
	
	<main class="flex justify-center items-center py-16">
		<form action="/feelimals/diary/doModify" method="post" onsubmit="return DiaryModify__submit(this);"
			class="relative w-full max-w-2xl bg-[#FFF3E9] p-6 rounded-2xl shadow space-y-4">

			<input type="hidden" name="id" value="${diary.id}" />

			<!-- 감정태그 버튼 -->
			<div class="flex justify-center gap-4 py-2">
				<input type="hidden" name="emoTagId" id="emoTagIdInput" value="${diary.emoTagId}" />
				<button type="button" id="emoTagBtn-1"
					class="emotag-btn w-14 h-14 rounded-full flex flex-col items-center justify-center bg-[#FFE082] text-2xl shadow border-2 border-transparent focus:outline-none transition"
					onclick="selectEmoTag(1)">
					😊
					<span class="block text-xs mt-1">기쁨</span>
				</button>
				<button type="button" id="emoTagBtn-2"
					class="emotag-btn w-14 h-14 rounded-full flex flex-col items-center justify-center bg-[#90CAF9] text-2xl shadow border-2 border-transparent focus:outline-none transition"
					onclick="selectEmoTag(2)">
					😔
					<span class="block text-xs mt-1">슬픔</span>
				</button>
				<button type="button" id="emoTagBtn-3"
					class="emotag-btn w-14 h-14 rounded-full flex flex-col items-center justify-center bg-[#FF8A65] text-2xl shadow border-2 border-transparent focus:outline-none transition"
					onclick="selectEmoTag(3)">
					😠
					<span class="block text-xs mt-1">분노</span>
				</button>
				<button type="button" id="emoTagBtn-4"
					class="emotag-btn w-14 h-14 rounded-full flex flex-col items-center justify-center bg-[#B39DDB] text-2xl shadow border-2 border-transparent focus:outline-none transition"
					onclick="selectEmoTag(4)">
					😰
					<span class="block text-xs mt-1">불안</span>
				</button>
				<button type="button" id="emoTagBtn-5"
					class="emotag-btn w-14 h-14 rounded-full flex flex-col items-center justify-center bg-[#E0E0E0] text-2xl shadow border-2 border-transparent focus:outline-none transition"
					onclick="selectEmoTag(5)">
					❓
					<span class="block text-xs mt-1">분류안함</span>
				</button>
			</div>

			<!-- 질문 -->
			<div class="text-gray-600 text-lg font-medium">어떻게 바꾸고 싶어?</div>

			<!-- 일기 입력 -->
			<textarea name="body" rows="12"
				class="w-full p-4 rounded-md border border-transparent resize-none focus:outline-none focus:ring-2 focus:ring-orange-200">${diary.body}</textarea>

			<!-- 버튼 -->
			<div class="text-right space-x-2">
				<a href="/feelimals/diary/detail?id=${diary.id}" class="text-sm text-gray-500">취소</a>
				<button type="submit" class="bg-[#FFD8A1] px-5 py-2 rounded-full shadow hover:bg-[#ffc987] transition">이걸로
					할게</button>
			</div>

			<!-- 캐릭터 이미지 (우측 하단) -->
			<div class="absolute bottom-10 right-10 w-24 h-24 rounded-full bg-center bg-contain bg-no-repeat"
				style="background-image: url('/resource/images/animals/${sessionScope.user.characterImg}');"></div>
		</form>
	</main>
</body>
</html>
