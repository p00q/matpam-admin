import sys
import json
import urllib.request
import urllib.error

# Ensure stdout uses UTF-8 to handle emojis and special characters
if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')

def call_qwen(prompt):
    """
    로컬 Ollama의 Qwen 3.6 35b 모델과 통신하는 브릿지 함수
    """
    url = "http://localhost:11434/v1/chat/completions"
    headers = {"Content-Type": "application/json"}
    
    # Qwen 3.6 모델 기반 payload 구성
    payload = {
        "model": "qwen3.6-35b",
        "messages": [{"role": "user", "content": prompt}],
        "temperature": 0.3, # Qwen의 특성에 맞춰 살짝 조정
        "max_tokens": 4096,
        "stream": False
    }

    try:
        # HTTP POST 요청 수행
        req = urllib.request.Request(url, data=json.dumps(payload).encode('utf-8'), headers=headers)
        with urllib.request.urlopen(req, timeout=90) as response: # 35b 모델이므로 타임아웃 넉넉히 설정
            res_data = json.loads(response.read().decode('utf-8'))
            
            if "choices" in res_data and len(res_data["choices"]) > 0:
                answer = res_data["choices"][0]["message"]["content"]
                if answer:
                    # Qwen 전용 식별자 주입
                    print(f"[qwen3.6] {answer}")
                else:
                    print("Error: Empty response content from Qwen.")
            else:
                print("Error: Invalid response format from Ollama.")
                
    except urllib.error.URLError as e:
        print(f"Error: Ollama 서버 혹은 Qwen 모델에 접근할 수 없습니다. (상태: {e.reason})")
    except Exception as e:
        print(f"Error: {str(e)}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python qwen_bridge.py \"<prompt>\"")
        sys.exit(1)
    
    user_prompt = sys.argv[1]
    call_qwen(user_prompt)
