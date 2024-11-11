from openai import OpenAI

client = OpenAI()

model_id = "ft:gpt-4o-mini-2024-07-18:he3::9tbKC81t"

completion = client.chat.completions.create(
    model=model_id,
    messages=[
        {
            "role": "system",
            "content": "你现在是一个日志告警专家，请根据日志内容去识别紧急程度，直接输出 P1 P2 或 P3，输出：",
        },
        {"role": "user", "content": "Disk I/O error"},
    ],
)

print("ChatGPT resp: ", completion.choices[0].message.content)
