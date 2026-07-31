import pandas as pd
from sqlalchemy import create_engine

# Read the CSV
df = pd.read_csv(
    r"C:\Users\HP\OneDrive\Desktop\Pharmaceutical-Sales-Analytics\pharma_sales_clean.csv"
)

# MySQL connection
engine = create_engine(
    "mysql+pymysql://root:Anu123$60@localhost:3306/pharma_sales_db"
)

# Import data into MySQL
df.to_sql(
    name="pharma_sales",
    con=engine,
    if_exists="append",
    index=False
)

print("✅ CSV imported successfully!")