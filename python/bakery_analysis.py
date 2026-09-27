import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

INPUT_FILE = "bakery_synthetic_dataset.csv (1).xlsx"
OUTPUT_DIR = "visualizations"
os.makedirs(OUTPUT_DIR, exist_ok=True)

df = pd.read_excel(INPUT_FILE)

print("Shape:", df.shape)
print("\nData types:\n", df.dtypes)
print("\nMissing values:\n", df.isna().sum())
print("\nDuplicate rows:", df.duplicated().sum())
print("Duplicate Transaction_ID:", df["Transaction_ID"].duplicated().sum())
print("\nDescriptive statistics:\n", df.describe(include="all").T)

df["Revenue"] = df["Total_Bill"]
df["Year"] = pd.to_datetime(df["Date"]).dt.year
df["Month"] = pd.to_datetime(df["Date"]).dt.to_period("M").astype(str)
df["Hour"] = pd.to_datetime(df["Time"].astype(str)).dt.hour
df["Margin_Pct"] = df["Profit"] / df["Revenue"] * 100
df["Discount_Band"] = pd.cut(
    df["Discount_Percentage"], [-.01,0,5,10,15,20,100],
    labels=["0%","0-5%","5-10%","10-15%","15-20%","20%+"]
)

print("\n=== CORE KPIs ===")
print("Revenue:", round(df["Revenue"].sum(),2))
print("Profit:", round(df["Profit"].sum(),2))
print("Margin %:", round(df["Profit"].sum()/df["Revenue"].sum()*100,2))
print("Units produced:", int(df["Units_Produced"].sum()))
print("Units sold:", int(df["Units_Sold"].sum()))
print("Unsold units:", int(df["Unsold_Units"].sum()))
print("Unsold rate %:", round(df["Unsold_Units"].sum()/df["Units_Produced"].sum()*100,2))
print("Waste cost:", round(df["Waste_Cost"].sum(),2))

def summary(col):
    x=df.groupby(col).agg(
        Transactions=("Transaction_ID","count"),
        Revenue=("Revenue","sum"),
        Profit=("Profit","sum"),
        Units_Sold=("Units_Sold","sum"),
        Unsold_Units=("Unsold_Units","sum"),
        Waste_Cost=("Waste_Cost","sum"),
        Avg_Bill=("Revenue","mean")
    )
    x["Margin_Pct"]=x["Profit"]/x["Revenue"]*100
    return x.sort_values("Revenue",ascending=False)

for col in ["Category","Product","Store_ID","Season","Day_of_Week",
            "Promotion_Applied","Promotion_Type","Customer_Segment",
            "Loyalty_Member","Payment_Method","Expiry_Risk","Weather"]:
    print(f"\n=== {col} ===")
    print(summary(col).round(2).to_string())

sns.set_theme(style="whitegrid")
def save(name):
    plt.tight_layout()
    plt.savefig(os.path.join(OUTPUT_DIR,name),dpi=160,bbox_inches="tight")
    plt.close()

df.groupby("Month")[["Revenue","Profit"]].sum().plot(marker="o")
plt.title("Monthly Revenue and Profit"); plt.ylabel("Amount"); plt.xticks(rotation=60); save("01_monthly_revenue_profit.png")

df.groupby("Category")["Revenue"].sum().sort_values().plot(kind="barh")
plt.title("Revenue by Category"); plt.xlabel("Revenue"); save("02_revenue_by_category.png")

df.groupby("Category")["Profit"].sum().sort_values().plot(kind="barh")
plt.title("Profit by Category"); plt.xlabel("Profit"); save("03_profit_by_category.png")

df.groupby("Product")["Profit"].sum().sort_values().head(10).plot(kind="barh")
plt.title("Bottom 10 Products by Profit"); plt.xlabel("Profit"); save("04_bottom_products_profit.png")

df.groupby("Promotion_Applied")["Profit"].sum().plot(kind="bar")
plt.title("Profit: Promotion vs No Promotion"); plt.ylabel("Profit"); save("05_promotion_profit.png")

df.groupby("Expiry_Risk")["Waste_Cost"].sum().plot(kind="bar")
plt.title("Waste Cost by Expiry Risk"); plt.ylabel("Waste Cost"); save("06_waste_by_expiry_risk.png")

df.groupby("Day_of_Week")["Revenue"].sum().reindex(
    ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
).plot(kind="bar")
plt.title("Revenue by Day of Week"); plt.ylabel("Revenue"); save("07_revenue_by_day.png")

df.groupby("Store_ID")[["Revenue","Profit"]].sum().plot(kind="bar")
plt.title("Store Revenue and Profit"); plt.ylabel("Amount"); save("08_store_performance.png")

df.groupby("Discount_Band")["Profit"].sum().plot(kind="bar")
plt.title("Profit by Discount Band"); plt.ylabel("Profit"); save("09_profit_by_discount.png")

df.groupby("Customer_Segment")["Revenue"].sum().sort_values().plot(kind="barh")
plt.title("Revenue by Customer Segment"); plt.xlabel("Revenue"); save("10_revenue_by_segment.png")

df["Payment_Method"].value_counts().plot(kind="bar")
plt.title("Transactions by Payment Method"); plt.ylabel("Transactions"); save("11_payment_methods.png")

plt.figure(figsize=(10,6))
plt.scatter(df["Discount_Percentage"],df["Profit"],alpha=.15,s=10)
plt.title("Discount Percentage vs Transaction Profit")
plt.xlabel("Discount Percentage"); plt.ylabel("Transaction Profit"); save("12_discount_vs_profit.png")
print("Analysis complete. Charts saved to", OUTPUT_DIR)
