# LangChain Memory
• 最简单的使用方式  ConversationBufferMemory
• 根据对话次数控制记忆长度 ConversationBufferWindowMemory
• 根据 Token 控制记忆长度 ConversationTokenBufferMemory
• 总结对话，实现更长的记忆 ConversationSummaryMemory




LangChain ConversationBufferMemory
• 容易使用，通过传递历史消息来实现记忆 
• 程序退出后对话上下文不会被保存 (若想保存，考虑存进数据库)


root@devops-shawn-workspace:~/geekbang/aiops/module_4/demo_3# python3 main.py 
WARNING! timeout is not default parameter.
                    timeout was transferred to model_kwargs.
                    Please confirm that timeout is what you intended.
输入问题：linux 端口被占用怎么排查？直接给我一条命令即可。
当前聊天上下文： chat_memory=ChatMessageHistory(messages=[HumanMessage(content='linux 端口被占用怎么排查？直接给我一条命令即可。'), AIMessage(content='你可以使用以下命令来查看哪些进程占用了特定端口：\n\n```bash\nsudo lsof -i :端口号\n```\n\n将`端口号`替换为你要检查的端口号，例如 `sudo lsof -i :80` 用于检查80端口。')])


运维专家: 你可以使用以下命令来查看哪些进程占用了特定端口：

```bash
sudo lsof -i :端口号
```

将`端口号`替换为你要检查的端口号，例如 `sudo lsof -i :80` 用于检查80端口。
输入问题：之前你给哦的命令是什么？
当前聊天上下文： chat_memory=ChatMessageHistory(messages=[HumanMessage(content='linux 端口被占用怎么排查？直接给我一条命令即可。'), AIMessage(content='你可以使用以下命令来查看哪些进程占用了特定端口：\n\n```bash\nsudo lsof -i :端口号\n```\n\n将`端口号`替换为你要检查的端口号，例如 `sudo lsof -i :80` 用于检查80端口。'), HumanMessage(content='之前你给哦的命令是什么？'), AIMessage(content='之前我给出的命令是：\n\n```bash\nsudo lsof -i :端口号\n```')])


运维专家: 之前我给出的命令是：

```bash
sudo lsof -i :端口号
```
输入问题：









LangChain ConversationBufferWindowMemory
只记住最后 30 轮的对话
```
memory = ConversationBufferWindowMemory(k=30)
conversation = ConversationChain(
    llm=llm,
    memory=memory,
    verbose=False,
)
```


LangChain ConversationTokenBufferMemory
只记住 128k 以内 token 的对话

llm = ChatOpenAI()
memory = ConversationTokenBufferMemory(llm=llm, max_token_limit=128000)
conversation = ConversationChain(
    llm=llm,
    memory=memory,
    verbose=False,
)



LangChain ConversationSummaryBufferMemory
费用很大
• 对超过 128K Token 的上下文进行总结，实现记住更多的内容
llm = ChatOpenAI()
memory = ConversationSummaryBufferMemory(llm=llm, max_token_limit=128000)
conversation = ConversationChain(
    llm=llm,
    memory=memory,
    verbose=False,
)
