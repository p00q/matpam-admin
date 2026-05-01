import sys
import json
import urllib.request
import urllib.error

# Ensure stdout uses UTF-8 to handle emojis and special characters
if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')

def call_gemma(prompt):
    """
    로컬 Ollama의 Gemma 4 26B 모델과 통신하는 브릿지 함수
    """
    url = "http://localhost:11434/v1/chat/completions"
    headers = {"Content-Type": "application/json"}
    
    # 설정 기반 payload 구성
    payload = {
        "model": "gemma4:26b",
        "messages": [{"role": "user", "content": prompt}],
        "temperature": 0.2,
        "max_tokens": 4096,
        "stream": False
    }

    try:
        # HTTP POST 요청 수행 (Timeout 60초)
        req = urllib.request.Request(url, data=json.dumps(payload).encode('utf-8'), headers=headers)
        with urllib.request.urlopen(req, timeout=60) as response:
            res_data = json.loads(response.read().decode('utf-8'))
            
            # OpenAI 호환 규격에서 답변 본문만 추출
            if "choices" in res_data and len(res_data["choices"]) > 0:
                answer = res_data["choices"][0]["message"]["content"]
                if answer:
                    # PM님 요청에 따라 [gemma4] 식별자 추가
                    print(f"[gemma4] {answer}")
                else:
                    print("Error: Empty response content from model.")
            else:
                print("Error: Invalid response format from Ollama.")
                
    except urllib.error.URLError as e:
        print(f"Error: Ollama 서버에 접속할 수 없습니다. (상태: {e.reason})")
    except Exception as e:
        print(f"Error: {str(e)}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python gemma_bridge.py \"<prompt>\"")
        sys.exit(1)
    
    user_prompt = sys.argv[1]
    call_gemma(user_prompt)
