frontend 通过json 格式返回数据给backend 

LLM ：large language model
LLM 使用JSON Mode可以稳定输出 JSON来跟backend 交互

JSON Mode：让 LLM 稳定输出 JSON 的技术

要求：
• 参数配置 response_format={"type": "json_object"}
• system prompt 包含 JSON 关键字
使用场景：
• 从语义化内容中提取参数，然后交由程序处理
• few-shot 表现更稳定
缺点：
• JSON Schema 相对固定，难以实现复杂业务逻辑

root@devops-shawn-workspace:~/geekbang/aiops/module_4/demo_4# python3 main.py 
{"service_name":"payment","action":"restart"}




