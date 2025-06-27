<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/jsp/feelimals/common/head.jspf"%>

<meta charset="UTF-8">
<title>일기 작성</title>
<script src="https://cdn.tailwindcss.com"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r134/three.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/vanta/0.5.24/vanta.clouds.min.js"></script>

<style>
html, body {
	margin: 0;
	padding: 0;
	height: 100%;
}

header {
	z-index: 5;
	position: relative;
}

body, main {
	background-color: transparent !important;
}

#vanta-bg {
	position: fixed;
	z-index: 0;
	top: 0;
	left: 0;
	width: 100vw;
	height: 100vh;
}
</style>

</head>
<body class="bg-[#FAF7F5] min-h-screen">

	<%@ include file="/WEB-INF/jsp/feelimals/common/header.jspf"%>
	<%@ include file="/WEB-INF/jsp/feelimals/common/settings.jspf"%>

	<div id="vanta-bg" style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; z-index: 0;"></div>

	<main class="flex justify-center items-center py-16">
		<form action="/feelimals/diary/doWrite" method="post"
			class="relative w-full max-w-2xl bg-[#FFF3E9] p-6 rounded-2xl shadow space-y-4">

			<!-- 질문 -->
			<div class="text-gray-600 text-lg font-medium">오늘 하루는 어땠어?</div>
			<!-- 감정태그 버튼 -->
			<div class="flex justify-center gap-4 py-2">
				<input type="hidden" name="emoTagId" id="emoTagIdInput" value="1" />
				<button type="button" id="emoTagBtn-1"
					class="emotag-btn w-14 h-14 rounded-full flex flex-col items-center justify-center bg-[#FFE082] text-2xl shadow border-2 border-transparent focus:outline-none ring-4 ring-orange-300 transition"
					onclick="selectEmoTag(1)">
					<i class="fa-solid fa-paw" style="color: #ffcb2e;"></i>
					<span class="block text-xs mt-1">기쁨</span>
				</button>
				<button type="button" id="emoTagBtn-2"
					class="emotag-btn w-14 h-14 rounded-full flex flex-col items-center justify-center bg-[#90CAF9] text-2xl shadow border-2 border-transparent focus:outline-none transition"
					onclick="selectEmoTag(2)">
					<i class="fa-solid fa-paw" style="color: #51abfb;"></i>
					<span class="block text-xs mt-1">슬픔</span>
				</button>
				<button type="button" id="emoTagBtn-3"
					class="emotag-btn w-14 h-14 rounded-full flex flex-col items-center justify-center bg-[#FF8A65] text-2xl shadow border-2 border-transparent focus:outline-none transition"
					onclick="selectEmoTag(3)">
					<i class="fa-solid fa-paw" style="color: #ff4405;"></i>
					<span class="block text-xs mt-1">분노</span>
				</button>
				<button type="button" id="emoTagBtn-4"
					class="emotag-btn w-14 h-14 rounded-full flex flex-col items-center justify-center bg-[#B39DDB] text-2xl shadow border-2 border-transparent focus:outline-none transition"
					onclick="selectEmoTag(4)">
					<i class="fa-solid fa-paw" style="color: #895ed9;"></i>
					<span class="block text-xs mt-1">불안</span>
				</button>
				<button type="button" id="emoTagBtn-5"
					class="emotag-btn w-14 h-14 rounded-full flex flex-col items-center justify-center bg-[#E0E0E0] text-2xl shadow border-2 border-transparent focus:outline-none transition"
					onclick="selectEmoTag(5)">
					<i class="fa-solid fa-paw" style="color: #8a8a8a;"></i>
					<span class="block text-xs mt-1">평온</span>
				</button>
			</div>

			<!-- 일기 입력 -->
			<textarea name="body" rows="12" placeholder="여기에 오늘 어땠는지 적어봐."
				class="w-full p-4 rounded-md border border-transparent resize-none focus:outline-none focus:ring-2 focus:ring-orange-200"></textarea>

			<!-- 버튼 -->
			<div class="text-right">
				<button type="submit" class="bg-[#FFD8A1] px-5 py-2 rounded-full shadow hover:bg-[#ffc987] transition">다 됐어
				</button>
			</div>

		</form>
	</main>
	<script>
  $(function() {
	  VANTA.CLOUDS({
	      el: "#vanta-bg",
	      mouseControls: true,
	      touchControls: true,
	      gyroControls: false,
	      minHeight: 200.00,
	      minWidth: 200.00,
	      skyColor: 0x93674a,
	      speed: 0.50
	    });
   
  });
</script>
</body>
</html>

<script>
  function selectEmoTag(id) {
    document.querySelectorAll('.emotag-btn').forEach(btn => btn.classList.remove('ring-4', 'ring-orange-300'));
    document.getElementById('emoTagBtn-' + id).classList.add('ring-4', 'ring-orange-300');
    document.getElementById('emoTagIdInput').value = id;
  }
</script>

