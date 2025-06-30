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
	const panel = document.getElementById("settingPanel");

	// 기존 숨김 클래스 제거
	panel.classList.remove("hidden", "animate__slideOutRight");

	// slideInLeft 애니메이션 추가
	panel.classList.add("animate__animated", "animate__slideInRight");

	// 패널 바깥 클릭 감지 시작
	setTimeout(() => {
		document.addEventListener("mousedown", handleOutsideClick);
	}, 0);
}

// 설정 닫기
function closeSetting() {
	const panel = document.getElementById("settingPanel");

	// slideOutRight 애니메이션 적용
	panel.classList.remove("animate__slideInRight");
	panel.classList.add("animate__slideOutRight");

	// 패널 닫힐 때 바깥 클릭 감지 제거
	panel.addEventListener("animationend", function handler() {
		panel.classList.add("hidden");
		document.removeEventListener("mousedown", handleOutsideClick);
		panel.removeEventListener("animationend", handler);
	});
}

// 화면 바깥에서 클릭
function handleOutsideClick(e) {
	const panel = document.getElementById("settingPanel");
	if (!panel.contains(e.target)) { // 패널 공간이 아닌 곳을 클릭시
		closeSetting(); // closeSetting 실행
	}
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

// 메시지 1개씩 아래에 추가(중복 방지, 캐릭터 이미지 포함)
function appendMessage({ type, body, emoTagId }) {
	const chatBox = document.getElementById("chatBox");

	// 메시지 컨테이너
	const wrapper = document.createElement("div");
	wrapper.className = "chat-msg-wrapper " + (type === "user" ? "user" : "ai");

	// 사용자 메시지 (오른쪽)
	if (type === "user") {
		const msgDiv = document.createElement("div");
		msgDiv.className = "msg you";
		msgDiv.textContent = body;
		wrapper.appendChild(msgDiv);
	} else {
		// AI 메시지 (왼쪽) - 캐릭터 이미지 + 메시지
		const img = document.createElement("img");
		let charaId = window.charaId || 1; // 없으면 1(기본)
		let emoId = emoTagId || 5; // 없으면 5(기본)
		img.src = `/resource/img/chara_${charaId}_${emoId}.png`;
		img.className = "character-img w-40 h-40";
		img.alt = "AI 캐릭터";
		wrapper.appendChild(img);

		const msgDiv = document.createElement("div");
		msgDiv.className = "msg him";
		msgDiv.textContent = body;
		wrapper.appendChild(msgDiv);
	}

	chatBox.appendChild(wrapper);
}

// 전체 메시지(과거 대화) 복원하기 (새로고침, 입장시)
function renderMessages(messages) {
	const chatBox = document.getElementById("chatBox");
	chatBox.innerHTML = ''; // 먼저 모두 비우기
	let hasFirst = false;

	messages.forEach(msg => {
		// AI 첫 메시지(시작)
		if (!msg.user && msg.body && msg.body.trim() === "오늘 어떻게 보냈어?") {
			appendMessage({ type: "ai", body: msg.body, emoTagId: msg.emoTagId });
			hasFirst = true;
			return;
		}
	});

	messages.forEach(msg => {
		if (msg.user) {
			if (msg.body && msg.body.trim() === "오늘 어떻게 보냈어?") return;
			appendMessage({ type: "user", body: msg.body });
		} else if (!msg.user && (!msg.aiReply || msg.aiReply.trim() === "")) {
			// (첫 메시지는 위에서 처리했으므로 제외)
		}
		if (msg.aiReply && msg.aiReply.trim() !== "") {
			appendMessage({ type: "ai", body: msg.aiReply, emoTagId: msg.emoTagId });
		}
	});

	// 혹시라도 없으면 강제로 출력
	if (!hasFirst) {
		appendMessage({ type: "ai", body: "오늘 어떻게 보냈어?", emoTagId: 5 });
	}
	setTimeout(() => {
		chatBox.scrollTop = chatBox.scrollHeight;
	}, 0);
}


// 대화 수정 시, 입력창 활성화 (이후 추가 예정)
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
		appendMessage({ type: "ai", body: "오늘 어떻게 보냈어?", emoTagId: 5 });
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
