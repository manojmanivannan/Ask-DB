import os
import streamlit as st
from langchain_community.llms import OpenAI, Ollama

from langchain_community.utilities import SQLDatabase
from langchain_experimental.sql import SQLDatabaseChain
from openai._exceptions import AuthenticationError
from psycopg2.errors import SyntaxError, OperationalError
import pandas as pd
from sqlalchemy import create_engine
# from markdown_content import *
import base64
from pathlib import Path

def img_to_bytes(img_path):
    img_bytes = Path(img_path).read_bytes()
    encoded = base64.b64encode(img_bytes).decode()
    return encoded

st.set_page_config(
    page_title="Ask DB", 
    page_icon='etc/logo.png', 
    layout='wide', 
    initial_sidebar_state='auto')


# st.components.v1.html(f"""
# <html>
# <head><title>Top NavBar</title></head>
# <body bgcolor='#FAFBFC'>
# <table border=0 width="20%">
# <tr><td align=left><img src="data:image/png;base64,{img_to_bytes('./etc/logo.png')}"/></td></tr>
# </table>
# </body>
# </html>
# """)

st.title("Ask DB")


@st.cache_data
def load_postgres_data():
    
    connection_url = os.getenv("DB_URI")
    print(f'Loading postgres data using: {connection_url}')
    engine = create_engine(connection_url)
    df = pd.read_sql_query("SELECT * FROM crime_data limit 100", engine)
    return df

# st.markdown(markdown_main_content, unsafe_allow_html=True)

with st.sidebar:
    # st.markdown(markdown_sidebar_content, unsafe_allow_html=True)
    st.sidebar.image('etc/logo.png')
    # st.sidebar.image('etc/toolbar.png', width=80)


if st.toggle("View dataset"):
    st.dataframe(load_postgres_data())

if "messages" not in st.session_state:
    st.session_state["messages"] = [{"role": "assistant", "content": "How can I help you?"}]

for msg in st.session_state.messages:
    st.chat_message(msg["role"]).write(msg["content"])

if prompt := st.chat_input():

    # Eastablish connection to the clickhouse database
    db = SQLDatabase.from_uri(os.getenv("DB_URI"))

    # Initialize the LLM
    # llm = OpenAI(model_name='gpt-3.5-turbo-instruct',temperature=0, verbose=True)
    llm = Ollama(model=os.getenv("OLLAMA_MODEL"))
    llm.base_url=os.getenv("OLLAMA_URI")

    # Initialize the chain
    db_chain = SQLDatabaseChain.from_llm(llm, db, verbose=True,use_query_checker=True, top_k=3)

    # Get user input
    st.session_state.messages.append({"role": "user", "content": prompt})
    st.chat_message("user").write(prompt)
    

    try:
        # Run the chain
        response = db_chain.run(prompt)

        # write the models output
        st.session_state.messages.append({"role": "assistant", "content": response})
        st.chat_message("assistant").write(response)

    except AuthenticationError:
        st.error("Invalid API key. Please try again.")
        st.stop()

    except SyntaxError:
        st.error("Can not understand your question. Please try again.")
        st.stop()

    except OperationalError:
        st.error("Unable to connect to database. Fix your database and try again.")
        st.stop()
        
    except Exception as e:
        st.error(f"Unknown error. Please try again: {e}")
        st.stop()