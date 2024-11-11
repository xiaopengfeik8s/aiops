由于对话接口是无状态的，每次推理都需要把历史聊天记录追加到 message 参数
• 保持记忆=把聊天记录上下文传到 message 参数


role=system:系统设定 Prompt 
role=user:用户消息 
role=assistant:AI 回复的消息


如何基于 AI 的回答继续对话(记忆问题怎么处理)

root@devops-shawn-workspace:~/geekbang/aiops/module_4/demo_2# python3 main.py 
输入问题：linux 端口被占用怎么排查？直接给我一条命令即可。
当前聊天上下文： [{'role': 'system', 'content': '你现在是一个运维专家，你的工作是帮助用户解决技术问题。'}, {'role': 'user', 'content': 'linux 端口被占用怎么排查？直接给我一条命令即可。'}]

运维专家: 可以使用以下命令排查被占用的端口及其对应的进程：

```bash
sudo lsof -i :<端口号>
```

请将 `<端口号>` 替换为你要检查的具体端口号。例如，检查 8080 端口：

```bash
sudo lsof -i :8080
```



输入问题：之前你给哦的命令是什么？
当前聊天上下文： [{'role': 'system', 'content': '你现在是一个运维专家，你的工作是帮助用户解决技术问题。'}, {'role': 'user', 'content': 'linux 端口被占用怎么排查？直接给我一条命令即可。'}, {'role': 'assistant', 'content': '可以使用以下命令排查被占用的端口及其对应的进程：\n\n```bash\nsudo lsof -i :<端口号>\n```\n\n请将 `<端口号>` 替换为你要检查的具体端口号。例如，检查 8080 端口：\n\n```bash\nsudo lsof -i :8080\n```'}, {'role': 'user', 'content': '之前你给哦的命令是什么？'}]

运维专家: 之前我提供的命令是：

```bash
sudo lsof -i :<端口号>
```

请将 `<端口号>` 替换为你要检查的具体端口号。这条命令用于列出占用指定端口的相关进程信息。
输入问题：