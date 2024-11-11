
Function Calling
作用：
• ChatGPT 选择合适函数来完成任务
• 从语义解析函数所需的参数
• 实现大模型和程序的连接
入参：
• Tools 列表（函数）、功能描述、函数入参
使用场景：
• 任何需要通过和外部系统交互的功能
• ChatOps












root@devops-shawn-workspace:~/geekbang/aiops/module_4/demo_5# python3 main.py 
输入查询指令：查看 app=grafana 且关键字包含 Error 的日志

ChatGPT want to call function:  [ChatCompletionMessageToolCall(id='call_A9zL1aJ3GAuipUGGDBanpgeU', function=Function(arguments='{"query_str":"{app=\\"grafana\\"} |= \\"Error\\""}', name='analyze_loki_log'), type='function')]

函数调用的参数:  {app="grafana"} |= "Error"
LLM Res:  在 `app=grafana` 的日志中找到了包含关键字 “Error” 的一条日志，内容如下：

```
this is error log
```

请问您希望对此日志进行什么样的分析或处理？
root@devops-shawn-workspace:~/geekbang/aiops/module_4/demo_5# 


