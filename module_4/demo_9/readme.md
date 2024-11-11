docker run -d -v /root/ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama

docker exec -it ollama ollama run llama3.2:1b


https://github.com/ollama/ollama?tab=readme-ov-file
https://hub.docker.com/r/ollama/ollama
https://ollama.com/library/llama3.2:1b

curl http://localhost:11434/api/chat -d '{
  "model": "llama3.2:1b",
  "messages": [
    { "role": "user", "content": "why is the sky blue?" }
  ]
}'