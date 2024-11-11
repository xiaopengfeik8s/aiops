from openai import OpenAI

client = OpenAI(

    base_url="https://api.apiyi.com/v1",
)

completion = client.chat.completions.create(
    model="gpt-4o-mini",
    messages=[
        {
            "role": "system",
            "content": "你现在是一个运维专家，你的工作是帮助用户解决技术问题。",
        },
        {
            "role": "user",
            "content": "linux 端口被占用怎么排查？直接给我一条命令即可。",
        },
    ],
)

print(completion.choices[0].message.content)
