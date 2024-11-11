from openai import OpenAI

client = OpenAI()

job_id = "ftjob-q8AhUAUIzdlaeLAPlU3yzcmv"
status = client.fine_tuning.jobs.retrieve(job_id)

print("\n", status)
print("\nfinetune status is: ", status.status)
print("\nfinetune model id is: ", status.fine_tuned_model)
