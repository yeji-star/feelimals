// 1. 설정 관련(그대로)
$('select[data-value]').each(function(index, el) {
	const $el = $(el);
	const defaultValue = $el.attr('data-value').trim();
	if (defaultValue.length > 0) {
		$el.val(defaultValue);
	}
});

// 설정 열기
function openSetting() {
	document.getElementById("settingOverlay").classList.remove("hidden");
	const panel = document.getElementById("settingPanel");
	panel.classList.remove("translate-x-full", "opacity-0", "pointer-events-none");
}

// 설정 닫기
function closeSetting() {
	document.getElementById("settingOverlay").classList.add("hidden");
	const panel = document.getElementById("settingPanel");
	panel.classList.add("translate-x-full", "opacity-0", "pointer-events-none");
}

// 수정/삭제 메뉴 토글
function toggleEditMenu() {
	const menu = document.getElementById("editMenu");
	menu.classList.toggle("hidden");
}

// 동물 캐릭터 선택
function selectCharacter(animalId) {
	fetch("/feelimals/setting/changeChara", {
		method: "POST",
		headers: {
			"Content-Type": "application/x-www-form-urlencoded"
		},
		body: `charaId=${animalId}`
	})
		.then(res => res.json())
		.then(data => {
			if (data.resultCode === "S-1") {
				alert("캐릭터가 변경됐어!");
				location.reload(); // 또는 캐릭터 이미지만 변경
			} else {
				alert("실패: " + (data.msg || "알 수 없는 오류"));
			}
		})
		.catch(err => {
			alert("서버 오류: " + err);
		});
}



////////////////////////////////////////////////


// 채팅 세션ID(서버에서 새로 받으면 자동 갱신)
var sessionId = window.sessionId || "";

// 채팅 입력/전송
function sendMessage() {
	const input = document.getElementById('userInput');
	const message = input.value.trim();

	// 빈값이면 전송안함
	if (message === "") return;

	// 내 메시지 바로 추가
	//	appendMessage({ type: "user", body: message });
	input.value = "";
	input.disabled = true;

	// 서버로 메시지 전송 준비 (세션ID 있으면 이어쓰기, 없으면 새 대화 시작)
	let url = '';
	let bodyData = '';

	if (!sessionId || sessionId === "null" || sessionId === "") {
		// 새 대화
		url = '/feelimals/chat';
		bodyData = `body=${encodeURIComponent(message)}`;
	} else {
		// 기존 세션에 추가
		url = '/feelimals/chat/add';
		bodyData = `sessionId=${sessionId}&body=${encodeURIComponent(message)}`;
	}

	// 서버에 메시지 보내고, AI 답변 받기 (ajax)
	fetch(url, {
		method: 'POST',
		headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
		body: bodyData
	})
		.then(res => res.json())
		.then(res => {
			// ★★★ 응답에서 sessionId 갱신 꼭 해줘야 함 ★★★
			if (res.data1 && res.data1.sessionId) {
				// 응답 데이터에서 세션ID 추출(최신 채팅의 sessionId)
				sessionId = res.data1.sessionId;
				window.sessionId = sessionId;
			}
			let messages = res.data1.messages;
			if (!Array.isArray(messages) || messages.length === 0) {
				alert('서버 응답 오류');
				input.disabled = false;
				return;
			}
			// 렌더링(기존 appendMessage 대신)
			renderMessages(messages);
			input.disabled = false;
			input.focus();
		})
		.catch(err => {
			alert('오류 발생: ' + err);
			input.disabled = false;
		});
}

// 메시지 1개씩 아래에 추가(중복 방지)
function appendMessage({ type, body }) {
	const chatBox = document.getElementById("chatBox");
	// 마지막 메시지와 중복 체크 (같은 내용, 같은 타입이면 추가 X)
	const lastMsg = chatBox.lastElementChild;
	if (lastMsg && lastMsg.textContent === body &&
		((type === "user" && lastMsg.classList.contains("you")) || (type === "ai" && lastMsg.classList.contains("him")))) {
		return;
	}
	// 메시지 타입(사용자/AI)에 따라 CSS 다르게 적용
	const div = document.createElement("div");
	div.className = type === "user" ? "msg you" : "msg him";
	div.textContent = body;
	chatBox.appendChild(div);
}

// 전체 메시지(과거 대화) 복원하기 (새로고침, 입장시)
function renderMessages(messages) {
	const chatBox = document.getElementById("chatBox");
	chatBox.innerHTML = ''; // 먼저 모두 비우기
	if (!messages || messages.length === 0) { // 아무 대화 없을 시 ai의 말 추가
		appendMessage({ type: "ai", body: "오늘 어떻게 보냈어?" });
		return;
	}
	messages.forEach(msg => {
		if (msg.isUser || msg.thisChat) {
			appendMessage({ type: "user", body: msg.body });
		}
		if (msg.aiReply && msg.aiReply.trim() !== "") {
			appendMessage({ type: "ai", body: msg.aiReply });
		}
	});
	setTimeout(() => { // 채팅박스 갱신 시킴 (항상 맨마지막에)
		chatBox.scrollTop = chatBox.scrollHeight;
	}, 0);
}

function continueChat(sessionId) {
	// 입력창 활성화
	document.getElementById('userInput').disabled = false;
	document.querySelector('.chat-input button').disabled = false;
	// 포커스 이동
	document.getElementById('userInput').focus();
}

// 엔터키로도 전송
const inputBox = document.getElementById('userInput');
if (inputBox) {
	inputBox.addEventListener('keydown', function(e) {
		if (e.key === 'Enter') {
			e.preventDefault();
			sendMessage();
		}
	});
}

// 채팅방 처음 들어왔을 때 메시지
document.addEventListener("DOMContentLoaded", function() {
	const chatBox = document.getElementById("chatBox");
	if (chatBox && chatBox.children.length === 0) {
		appendMessage({ type: "ai", body: "오늘 어떻게 보냈어?" });
	}
});

// ------- 아래는 밑줄 효과(기존과 동일) -------

gsap.registerPlugin(DrawSVGPlugin);

function initDrawRandomUnderline() {
	const svgVariants = [/* ...SVG 배열 그대로... */];
	function decorateSVG(svgEl) {
		svgEl.setAttribute('class', 'text-draw__box-svg');
		svgEl.setAttribute('preserveAspectRatio', 'none');
		svgEl.querySelectorAll('path').forEach(path => {
			path.setAttribute('stroke', 'currentColor');
		});
	}
	let nextIndex = null;
	document.querySelectorAll('[data-draw-line]').forEach(container => {
		const box = container.querySelector('[data-draw-line-box]');
		if (!box) return;
		let enterTween = null;
		let leaveTween = null;
		container.addEventListener('mouseenter', () => {
			if (enterTween && enterTween.isActive()) return;
			if (leaveTween && leaveTween.isActive()) leaveTween.kill();
			if (nextIndex === null) {
				nextIndex = Math.floor(Math.random() * svgVariants.length);
			}
			box.innerHTML = svgVariants[nextIndex];
			const svg = box.querySelector('svg');
			if (svg) {
				decorateSVG(svg);
				const path = svg.querySelector('path');
				if (path) {
					gsap.set(path, { drawSVG: '0%' });
					enterTween = gsap.to(path, {
						duration: 0.5,
						drawSVG: '100%',
						ease: 'power2.inOut',
						onComplete: () => { enterTween = null; }
					});
				}
			}
			nextIndex = (nextIndex + 1) % svgVariants.length;
		});
		container.addEventListener('mouseleave', () => {
			const path = box.querySelector('path');
			if (!path) return;
			const playOut = () => {
				if (leaveTween && leaveTween.isActive()) return;
				leaveTween = gsap.to(path, {
					duration: 0.5,
					drawSVG: '100% 100%',
					ease: 'power2.inOut',
					onComplete: () => {
						leaveTween = null;
						box.innerHTML = '';
					}
				});
			};
			if (enterTween && enterTween.isActive()) {
				enterTween.eventCallback('onComplete', playOut);
			} else {
				playOut();
			}
		});
	});
}
document.addEventListener('DOMContentLoaded', function() {
	initDrawRandomUnderline();
});
