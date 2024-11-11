from openai import OpenAI
import json
import time

client = OpenAI(

    base_url="https://api.apiyi.com/v1",
)


def analyze_loki_log(query_str):
    print("\n函数调用的参数: ", query_str)
    return json.dumps({"log": "this is error log"})


def run_conversation():
    """Query: 查看 app=grafana 且关键字包含 Error 的日志"""

    # 步骤一：把所有预定义的 function 传给 chatgpt
    query = input("输入查询指令：")
    messages = [
        {
            "role": "system",
            "content": "你是一个 Loki 日志分析助手，你可以帮助用户分析 Loki 日志，你可以调用多个函数来帮助用户完成任务，并最终尝试分析错误产生的原因",
        },
        {
            "role": "user",
            "content": query,
        },
    ]
    tools = [
        {
            "type": "function",
            "function": {
                "name": "analyze_loki_log",
                "description": "从 Loki 获取日志",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "query_str": {
                            "type": "string",
                            "description": 'Loki 查询字符串，例如：{app="grafana"} |= "Error"',
                        },
                    },
                },
                "required": ["query_str"],
            },
        }
    ]

    response = client.chat.completions.create(
        model="gpt-4o",
        messages=messages,
        tools=tools,
        tool_choice="auto",
    )
    response_message = response.choices[0].message
    tool_calls = response_message.tool_calls
    print("\nChatGPT want to call function: ", tool_calls)
    # 步骤二：检查 LLM 是否调用了 function
    if tool_calls is None:
        print("not tool_calls")
    if tool_calls:
        available_functions = {
            "analyze_loki_log": analyze_loki_log,
        }
        messages.append(response_message)
        # 步骤三：把每次 function 调用和返回的信息传给 model
        for tool_call in tool_calls:
            function_name = tool_call.function.name
            function_to_call = available_functions[function_name]
            function_args = json.loads(tool_call.function.arguments)
            function_response = function_to_call(**function_args)
            messages.append(
                {
                    "tool_call_id": tool_call.id,
                    "role": "tool",
                    "name": function_name,
                    "content": function_response,
                }
            )
        # 步骤四：把 function calling 的结果传给 model，进行对话
        response = client.chat.completions.create(
            model="gpt-4o",
            messages=messages,
        )
        return response.choices[0].message.content


print("LLM Res: ", run_conversation())
