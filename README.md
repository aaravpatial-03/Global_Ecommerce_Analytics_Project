# 🌐 Global E-Commerce & Retail Analytics (2015–2024)

<p align="center">
  <img src="https://img.shields.io/badge/SQL-PostgreSQL-4479A1?style=for-the-badge&logo=postgresql&logoColor=white"/>
  <img src="https://img.shields.io/badge/Python-NumPy%20%7C%20Pandas-3776AB?style=for-the-badge&logo=python&logoColor=white"/>
  <img src="https://img.shields.io/badge/Excel-Advanced-217346?style=for-the-badge&logo=microsoft-excel&logoColor=white"/>
  <img src="https://img.shields.io/badge/Power%20BI-Ready-F2C811?style=for-the-badge&logo=powerbi&logoColor=black"/>
  <img src="https://img.shields.io/badge/Records-60%2C000%2B-red?style=for-the-badge"/>
</p>

---

## 📌 Project Overview

A **full-stack data analytics project** analyzing global e-commerce transactions across **10 countries, 10 product categories, 10 platforms, and 10 years (2015–2024)**. The project features **60,000+ records** including a dedicated **India Deep Dive** dataset, and delivers business intelligence through SQL queries, Python statistical analysis, Excel dashboards, and Power BI visuals.

> **Objective:** Uncover revenue patterns, profitability drivers, customer behavior, and market trends across global and Indian e-commerce markets to support strategic decision-making.

---

## 🗂️ Repository Structure

```
global-ecommerce-analytics/
│
├── data/
│   ├── global_ecommerce_transactions.csv     # 50,000 rows — Global transactions
│   ├── india_ecommerce_detail.csv            # 10,000 rows — India deep dive
│   └── kpi_yearly_country.csv               # 100 rows — Pre-aggregated KPIs
│
├── sql/
│   └── sql_queries_schema.sql               # DDL schema + 12 analytical queries
│
├── python/
│   └── python_analysis.py                   # NumPy + Pandas analysis script
│
├── excel/
│   └── Global_Ecommerce_Analytics_Project.xlsx  # 7-sheet professional workbook
│
└── README.md
```

---

## 📊 Datasets

### 1. Global Transactions (`global_ecommerce_transactions.csv`)
| Field | Description |
|---|---|
| Transaction_ID | Unique transaction identifier |
| Customer_ID | Anonymized customer ID |
| Date / Year / Quarter / Month | Time dimensions |
| Country / Region | Geographic dimensions |
| India_City | City (India transactions only) |
| Category | Product category |
| Platform | E-commerce platform |
| Business_Segment | B2C / B2B / D2C / Marketplace |
| Payment_Method | Payment channel |
| Device_Type | Mobile / Desktop / Tablet |
| Units_Sold | Quantity |
| Gross_Revenue_USD | Pre-discount revenue |
| Discount_Amount_USD | Discount applied |
| Net_Revenue_USD | Post-discount revenue |
| Shipping_Cost_USD | Shipping fee |
| Profit_Margin_Pct | Profit margin percentage |
| Profit_USD | Absolute profit |
| Customer_Rating | 1.0–5.0 rating |
| Is_Returned | Boolean return flag |
| Return_Reason | Reason for return |

### 2. India Deep Dive (`india_ecommerce_detail.csv`)
Additional India-specific fields: City_Tier, State, Revenue_INR, GST_Rate_Pct, Internet_Type

### 3. KPI Summary (`kpi_yearly_country.csv`)
Pre-aggregated yearly KPIs by country — ideal for Power BI direct import.

---

## 🔢 Data Sources

This project uses **synthetically generated data** modeled after real-world patterns from the following authoritative public sources:

| Source | URL | Data Used |
|---|---|---|
| **World Bank — E-commerce Stats** | https://data.worldbank.org | Country GDP weights, population |
| **UNCTAD Digital Economy Report** | https://unctad.org/topic/ecommerce-and-digital-economy | Global e-commerce growth rates |
| **India DPIIT E-commerce Report** | https://dpiit.gov.in | India market share, city-tier data |
| **Statista — Global E-Commerce** | https://www.statista.com/topics/871/online-shopping | Category revenue benchmarks |
| **RBI Payment Systems Report** | https://rbi.org.in | India UPI/payment method share |
| **IBEF Retail Report** | https://www.ibef.org/industry/retail-india | India retail growth projections |
| **eMarketer Global Commerce** | https://www.emarketer.com | Platform market share data |
| **GSTN GST Rate Data** | https://www.gst.gov.in | Indian GST rate slabs per category |

---

## 🛠️ Tools & Technologies

| Tool | Purpose | Version |
|---|---|---|
| **Python** | Data generation, statistical analysis | 3.10+ |
| **NumPy** | Array operations, correlation matrix, percentiles | 1.24+ |
| **Pandas** | Data manipulation, group-by, aggregations | 2.0+ |
| **SQL (PostgreSQL)** | Schema design, 12 analytical queries, window functions | 14+ |
| **Excel (openpyxl)** | 7-sheet dashboard workbook | 365 / 2019+ |

---

## 🔍 Key Analytical Findings

### Global Market
- 📈 **Total Net Revenue (2015–2024):** $29.5M across 50,000 transactions
- 🇺🇸 **USA** leads with 25.0% revenue share, followed by **China** (22%) and **India** (18.1%)
- 📅 **Average YoY Growth Rate:** ~6.2% (2016–2024)
- ↩️ **Global Return Rate:** 12.0% — Fashion & Apparel highest at 12.8%

### India Market
- 🇮🇳 India contributes **18.1%** of global revenue — 3rd largest market
- 📱 **UPI dominates** with 35.5% of India payment transactions
- 🏙️ **Tier-1 cities** contribute ~65% of India revenue
- 📈 India e-commerce CAGR: ~12% (higher than global ~6%)

### Product Insights
- 💎 **Automotive** ($450 base) and **Electronics** ($280 base) have highest average order values
- 📚 **Books & Media** has lowest AOV ($30) but high frequency
- 💰 **All categories** show 23–24% average profit margin

### Technology Trends
- 📱 **Mobile commerce:** Consistently ~60% of all transactions (2015–2024)
- 🖥️ Desktop remains at ~30%, Tablet at ~10%
- 5G adoption in India boosting mobile conversion rates

---

## 🗄️ SQL Highlights

The SQL file contains **12 advanced queries** including:

1. YoY Revenue Growth by Country (LAG window function)
2. Top Categories by Profit Margin
3. India Revenue Split by City Tier
4. Return Rate Analysis — Country × Category
5. Platform Market Share by Region (Window functions)
6. India UPI vs Other Payment Methods
7. Rolling 3-Quarter Revenue Average
8. Customer Rating vs Return Rate Correlation
9. Device Type Revenue Share by Year
10. Top 20 Customers by Lifetime Value
11. Seasonal Revenue Heatmap
12. **RFM Customer Segmentation** (NTILE, multiple CTEs)

---

## 📈 Excel Workbook Structure

| Sheet | Content |
|---|---|
| 📊 Dashboard Overview | KPI cards, country summary table |
| 📋 Raw Data | 5,000-row sample with full 24 columns |
| 📈 Yearly KPI Analysis | 10-year trend with YoY growth + Line chart |
| 🇮🇳 India Deep Dive | City-wise & payment method analysis |
| 📦 Category Analysis | 10-category performance + Bar chart |
| 🐍 Python Analysis | Correlation matrix & descriptive stats |
| 🇮🇳 India Raw Data | 3,000-row India transaction sample |

---

## 🚀 How to Run

### Python Analysis
```bash
git clone https://github.com/aaravpatial-03/global-ecommerce-analytics.git
cd global-ecommerce-analytics
pip install pandas numpy openpyxl
python python/python_analysis.py
```

### SQL
```sql
-- 1. Create database
CREATE DATABASE ecommerce_analytics;

-- 2. Run schema
psql -d ecommerce_analytics -f sql/sql_queries_schema.sql

-- 3. Import CSV (PostgreSQL)
COPY fact_transactions FROM 'data/global_ecommerce_transactions.csv' 
DELIMITER ',' CSV HEADER;
```

---

## 📋 Business Questions Answered

1. Which countries are driving the highest revenue growth?
2. What is India's contribution vs global benchmarks?
3. Which product categories are most profitable?
4. How has mobile commerce share evolved over 10 years?
5. What drives high return rates by category?
6. Which payment methods are preferred in India?
7. Who are the top customers by Lifetime Value?
8. What is the seasonal revenue pattern in India?
9. How do platforms compare in market share by region?
10. What does customer RFM segmentation reveal?

---

## 👤 Author

**Aarav Patial**  
Data Analyst | SQL • Python • Power BI • Excel  
📧 aaravpatial108@gmail.com  
🔗 LinkedIn (https://www.linkedin.com/in/contactaaravpatial)  
🐙 GitHub (https://github.com/aaravpatial-03/Global_Ecommerce_Analytics_Project.git)

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---
