from flask import Flask, request, make_response, jsonify
from dotenv import load_dotenv
load_dotenv()
from openai import OpenAI
import os
import json


app = Flask(__name__)


client = OpenAI()


# 1차: 감정 추출용 프롬프트
EMOTION_SYSTEM_PROMPT = """
아래 문장에서 감정(emotion)을 딱 하나만 골라서 반환해.
[기쁨, 슬픔, 분노, 불안, 무감정] 중 하나의 단어만 반환해.
반드시 하나만, 답변에 다른 말 쓰지마. 리스트 중 택1.
"""


# 2차: 감정 피드백용 프롬프트
FEEDBACK_SYSTEM_PROMPT = """
너는 사용자와 진심으로 대화를 나누는 동물 캐릭터야. 무조건 반말로 말해.
아래 감정 키워드를 참고해서 상황에 맞는 공감과 피드백 한 마디(2~3줄 이내), 필요할 경우 위로까지 해줘.
반드시 감정 키워드에 어울리는 피드백을 해주고, 너무 기계적이지 않게 말해줘. 대화를 무조건 끝내지말고 사용자와 주고받아줘.
"""


def ask_gpt(system_prompt, user_message):
    """GPT에 system prompt와 user message를 보내고 응답을 받음"""


    # 프롬프트와 유저 메시지를 system/user 역할로 분리
    response = client.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=[
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": user_message}
    ],
        temperature=0.7, #창의성을 얼마나 발휘하는가?
    )
    print("GPT 응답:", response)
    return response.choices[0].message.content.strip()


# 1. 감정만 추출하기
@app.route('/get-emotion', methods=['POST']) # 예외 오류 대응을 위해 try-except
def getEmotion():
    try:
        data = request.get_json()
        user_message = data['message']
        emotion = ask_gpt(EMOTION_SYSTEM_PROMPT, user_message)
        result = {"emotion": emotion}
        result_json = json.dumps(result, ensure_ascii=False)
        res = make_response(result_json)
        res.headers['Content-Type'] = 'application/json; charset=utf-8'
        return res
    except Exception as e:
        # 에러 발생시
        result = {"emotion": "무감정", "error": str(e)}
        result_json = json.dumps(result, ensure_ascii=False)
        res = make_response(result_json)
        res.headers['Content-Type'] = 'application/json; charset=utf-8'
        return res


# 1. 답변(피드백) 생성
@app.route('/send-feedback', methods=['POST'])
def send_feedback(): # 여기도 예외 오류 대응 추가
    try:
        data = request.get_json()
        user_message = data.get('message', '')
        emotion = data.get('emotion', '')


        # 감정 키워드와 유저 메시지 모두 전달
        feedback_prompt = f"감정: {emotion}\n유저: {user_message}\n---\n"
        feedback = ask_gpt(FEEDBACK_SYSTEM_PROMPT, feedback_prompt)
        result = {"feedback": feedback}
        result_json = json.dumps(result, ensure_ascii=False)
        res = make_response(result_json)
        res.headers['Content-Type'] = 'application/json; charset=utf-8'
        return res
    except Exception as e:
        result = {"feedback": "힘내!", "error": str(e)}
        result_json = json.dumps(result, ensure_ascii=False)
        res = make_response(result_json)
        res.headers['Content-Type'] = 'application/json; charset=utf-8'
        return res


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True)





