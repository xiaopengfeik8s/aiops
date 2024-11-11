Fine-tuning
微调通过喂给大模型更多的样本数据来改进模型的表现，使其在一些特定的任务上输出更好的结果。
使用场景：
• 要求输出特定的风格和格式等
• 提高输出的可靠性
• 纠正无法遵循复杂提示语的问题
• 执行一项难以用语言表达的新技能或任务


Fine-tuning 日志分析专家
log 优先级
[2024-08-07 12:00:00] Database connection failed. System is down. P0
[2024-08-07 13:30:00] High memory leak detected. System may become unstable. P0
[2024-08-07 13:35:00] Unauthorized access attempt from an unknown IP. P0
[2024-08-07 12:20:00] Critical security breach detected. All systems locked down. P0
[2024-08-07 13:40:00] Payment gateway is temporarily unavailable. P1
[2024-08-07 13:45:00] Deprecated feature X is still in use. Plan to phase out. P1
[2024-08-07 13:50:00] Failed to synchronize data with remote server. P1
使用真实的已标注数据进行 Fine-tuning，使模型具备判断日志故障优先级的能力
Fine-tuning 数据格式：jsonl
包含 system prompt、user、assistant
每行代表一条日志标注数据

Fine-tuning 日志分析专家
流程：
• 准备微调数据
• 上传微调文件
• 创建微调任务
• 获取微调后的模型 ID
注意：
• 微调时间取决于微调数据量大小，耗时较长
• 可微调模型包括：gpt-4o-mini-2024-07-18、
gpt-3.5-turbo-0125 等

