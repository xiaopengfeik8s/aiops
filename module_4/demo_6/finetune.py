from openai import OpenAI

client = OpenAI()

# 上传微调数据
file_name = client.files.create(file=open("log.jsonl", "rb"), purpose="fine-tune")
file_id = file_name.id
print("file_id is: ", file_id)

# 创建微调任务
finetune_job = client.fine_tuning.jobs.create(
    training_file=file_id, model="gpt-4o-mini-2024-07-18"
)
job_id = finetune_job.id
print("job_id is: ", job_id)
