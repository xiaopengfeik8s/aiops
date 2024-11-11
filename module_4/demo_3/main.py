# pip install openai==0.28.1
# pip install langchain==0.0.330

from langchain.chat_models import ChatOpenAI
from langchain.chains import ConversationChain
from langchain.memory import ConversationBufferMemory

llm = ChatOpenAI(
    model="gpt-4o",

    openai_api_base="https://api.apiyi.com/v1",
    max_tokens=None,
    timeout=None,
)
memory = ConversationBufferMemory()
conversation = ConversationChain(
    llm=llm,
    memory=memory,
    verbose=False,
)

while True:
    user_input = input("输入问题：")
    reply = conversation.predict(input=user_input)
    print("当前聊天上下文：", conversation.memory)
    print(f"\n\n运维专家: {reply}")
