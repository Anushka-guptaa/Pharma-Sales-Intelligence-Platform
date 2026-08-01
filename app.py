import streamlit as st
import pandas as pd
from groq import Groq
from dotenv import load_dotenv
import os
load_dotenv()

client = Groq(
    api_key=os.getenv("GROQ_API_KEY")
)
st.set_page_config(page_title="Pharmaceutical Sales Analytics")

st.title("💊 Pharmaceutical Sales Analytics Assistant")
uploaded_file = st.file_uploader(
    "Upload Pharmaceutical Sales Dataset",
    type=["csv"]
)

if uploaded_file is not None:

    df = pd.read_csv(uploaded_file)

    st.success("Dataset Uploaded Successfully!")

    st.dataframe(df.head())


st.subheader("📊 Key Metrics")

col1, col2, col3, col4 = st.columns(4)

col1.metric(
    "💰 Total Sales",
    f"${df['Sales'].sum():,.0f}"
)

col2.metric(
    "📦 Total Orders",
    len(df)
)

col3.metric(
    "🌍 Countries",
    df["Country"].nunique()
)

col4.metric(
    "💊 Products",
    df["Product Name"].nunique()
)
st.subheader("🏆 Top 10 Products by Sales")

top_products = (
    df.groupby("Product Name")["Sales"]
      .sum()
      .sort_values(ascending=False)
      .head(10)
)

st.bar_chart(top_products)
st.subheader("🌍 Sales by Country")

country_sales = (
    df.groupby("Country")["Sales"]
      .sum()
)

st.bar_chart(country_sales)

st.subheader("📈 Sales by Year")

year_sales = (
    df.groupby("Year")["Sales"]
      .sum()
)

st.line_chart(year_sales)

st.subheader("👨‍💼 Top Sales Representatives")

top_reps = (
    df.groupby("Name of Sales Rep")["Sales"]
      .sum()
      .sort_values(ascending=False)
      .head(10)
)

st.bar_chart(top_reps)

st.download_button(
    label="📥 Download Dataset",
    data=df.to_csv(index=False),
    file_name="clean_sales_dataset.csv",
    mime="text/csv"
)
st.divider()

st.subheader("🤖 AI Executive Summary")

if st.button("Generate Executive Summary"):

    sample = df.head(100).to_csv(index=False)

    prompt = f"""
You are a Business Analyst.

Generate:
1. Executive Summary
2. Key Insights
3. Business Risks
4. Growth Opportunities
5. Recommendations

Dataset:
{sample}
"""

    with st.spinner("Generating Summary..."):

        response = client.chat.completions.create(

            model="llama-3.3-70b-versatile",

            messages=[
                {
                    "role": "user",
                    "content": prompt
                }
            ]
        )

    st.success("Summary Generated!")

    with st.expander("📄 Executive Report", expanded=True):

        st.markdown(response.choices[0].message.content)