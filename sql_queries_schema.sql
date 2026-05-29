-- ============================================================
--  GLOBAL E-COMMERCE ANALYTICS — SQL SCHEMA & QUERY LIBRARY
--  Project: Global E-Commerce & Retail Analytics (2015-2024)
--  Author: [Your Name]
--  Database: PostgreSQL / MySQL / SQL Server compatible
-- ============================================================

-- ─────────────────────────────────────────────────
--  SECTION 1: DDL — CREATE TABLES
-- ─────────────────────────────────────────────────

CREATE TABLE dim_country (
    country_id      SERIAL PRIMARY KEY,
    country_name    VARCHAR(100) NOT NULL,
    region          VARCHAR(100),
    currency_code   VARCHAR(10),
    population_m    INT
);

CREATE TABLE dim_category (
    category_id   SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    base_price    DECIMAL(10,2)
);

CREATE TABLE dim_platform (
    platform_id   SERIAL PRIMARY KEY,
    platform_name VARCHAR(100) NOT NULL
);

CREATE TABLE dim_date (
    date_id     DATE PRIMARY KEY,
    year        INT,
    quarter     VARCHAR(5),
    month_name  VARCHAR(20),
    month_num   INT,
    day_of_week VARCHAR(20)
);

CREATE TABLE fact_transactions (
    transaction_id     VARCHAR(20) PRIMARY KEY,
    customer_id        VARCHAR(20),
    date_id            DATE REFERENCES dim_date(date_id),
    country_id         INT REFERENCES dim_country(country_id),
    category_id        INT REFERENCES dim_category(category_id),
    platform_id        INT REFERENCES dim_platform(platform_id),
    business_segment   VARCHAR(50),
    payment_method     VARCHAR(50),
    device_type        VARCHAR(20),
    units_sold         INT,
    gross_revenue_usd  DECIMAL(12,2),
    discount_amount    DECIMAL(12,2),
    net_revenue_usd    DECIMAL(12,2),
    shipping_cost      DECIMAL(10,2),
    profit_margin_pct  DECIMAL(5,4),
    profit_usd         DECIMAL(12,2),
    customer_rating    DECIMAL(3,1),
    is_returned        BOOLEAN,
    return_reason      VARCHAR(100),
    india_city         VARCHAR(100)
);

CREATE TABLE india_transactions (
    transaction_id  VARCHAR(20) PRIMARY KEY,
    date_id         DATE,
    year            INT,
    quarter         VARCHAR(5),
    city            VARCHAR(100),
    city_tier       VARCHAR(20),
    state           VARCHAR(100),
    category        VARCHAR(100),
    platform        VARCHAR(100),
    payment_method  VARCHAR(50),
    revenue_usd     DECIMAL(12,2),
    revenue_inr     DECIMAL(15,2),
    gst_rate_pct    DECIMAL(5,2),
    customer_rating DECIMAL(3,1),
    is_returned     BOOLEAN,
    device_type     VARCHAR(20),
    internet_type   VARCHAR(20)
);

-- ─────────────────────────────────────────────────
--  SECTION 2: ANALYTICAL QUERIES
-- ─────────────────────────────────────────────────

-- Q1: YoY Revenue Growth by Country
WITH yearly_rev AS (
    SELECT
        dc.country_name,
        dd.year,
        SUM(f.net_revenue_usd) AS total_revenue
    FROM fact_transactions f
    JOIN dim_country dc ON f.country_id = dc.country_id
    JOIN dim_date dd    ON f.date_id    = dd.date_id
    GROUP BY dc.country_name, dd.year
),
with_lag AS (
    SELECT *,
           LAG(total_revenue) OVER (PARTITION BY country_name ORDER BY year) AS prev_year_rev
    FROM yearly_rev
)
SELECT
    country_name,
    year,
    ROUND(total_revenue, 2)                                              AS revenue_usd,
    ROUND(prev_year_rev, 2)                                             AS prev_rev,
    ROUND((total_revenue - prev_year_rev) / NULLIF(prev_year_rev,0) * 100, 2) AS yoy_growth_pct
FROM with_lag
ORDER BY country_name, year;


-- Q2: Top 5 Categories by Profit Margin (Global)
SELECT
    dc2.category_name,
    COUNT(f.transaction_id)              AS total_orders,
    SUM(f.units_sold)                    AS total_units,
    ROUND(SUM(f.net_revenue_usd),2)      AS total_revenue,
    ROUND(SUM(f.profit_usd),2)           AS total_profit,
    ROUND(AVG(f.profit_margin_pct)*100,2)AS avg_margin_pct
FROM fact_transactions f
JOIN dim_category dc2 ON f.category_id = dc2.category_id
GROUP BY dc2.category_name
ORDER BY avg_margin_pct DESC
LIMIT 5;


-- Q3: India — Revenue Split by City Tier (Yearly)
SELECT
    year,
    city_tier,
    COUNT(transaction_id)           AS orders,
    ROUND(SUM(revenue_usd),2)       AS revenue_usd,
    ROUND(SUM(revenue_inr)/1e6,2)   AS revenue_inr_mn,
    ROUND(AVG(customer_rating),2)   AS avg_rating
FROM india_transactions
GROUP BY year, city_tier
ORDER BY year, city_tier;


-- Q4: Return Rate Analysis — Country × Category
SELECT
    dc.country_name,
    dc2.category_name,
    COUNT(f.transaction_id)                            AS total_txns,
    SUM(CASE WHEN f.is_returned THEN 1 ELSE 0 END)    AS returns,
    ROUND(SUM(CASE WHEN f.is_returned THEN 1 ELSE 0 END)
          * 100.0 / COUNT(f.transaction_id), 2)        AS return_rate_pct
FROM fact_transactions f
JOIN dim_country  dc  ON f.country_id  = dc.country_id
JOIN dim_category dc2 ON f.category_id = dc2.category_id
GROUP BY dc.country_name, dc2.category_name
ORDER BY return_rate_pct DESC;


-- Q5: Platform Market Share by Region (Net Revenue)
SELECT
    dc.region,
    dp.platform_name,
    ROUND(SUM(f.net_revenue_usd),2)                            AS revenue,
    ROUND(SUM(f.net_revenue_usd)*100.0
          / SUM(SUM(f.net_revenue_usd)) OVER (PARTITION BY dc.region),2) AS share_pct
FROM fact_transactions f
JOIN dim_country  dc ON f.country_id  = dc.country_id
JOIN dim_platform dp ON f.platform_id = dp.platform_id
GROUP BY dc.region, dp.platform_name
ORDER BY dc.region, share_pct DESC;


-- Q6: Payment Method Preference — India UPI vs Others
SELECT
    year,
    payment_method,
    COUNT(*)                              AS transactions,
    ROUND(SUM(revenue_usd),2)            AS revenue_usd,
    ROUND(COUNT(*)*100.0
          / SUM(COUNT(*)) OVER (PARTITION BY year), 2) AS share_pct
FROM india_transactions
GROUP BY year, payment_method
ORDER BY year, share_pct DESC;


-- Q7: Rolling 3-Quarter Revenue (India)
WITH qtr AS (
    SELECT
        year,
        quarter,
        SUM(revenue_usd) AS qtr_rev
    FROM india_transactions
    GROUP BY year, quarter
)
SELECT
    year, quarter, qtr_rev,
    ROUND(AVG(qtr_rev) OVER (
        ORDER BY year, quarter
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS rolling_3q_avg
FROM qtr;


-- Q8: Customer Rating vs Return Rate (Correlation Proxy)
SELECT
    FLOOR(customer_rating) AS rating_floor,
    COUNT(*)               AS orders,
    SUM(CASE WHEN is_returned THEN 1 ELSE 0 END) AS returns,
    ROUND(SUM(CASE WHEN is_returned THEN 1 ELSE 0 END)*100.0/COUNT(*),2) AS return_pct
FROM fact_transactions
GROUP BY rating_floor
ORDER BY rating_floor;


-- Q9: Device Type Revenue Share by Year (Mobile vs Desktop)
SELECT
    dd.year,
    f.device_type,
    COUNT(*)                     AS orders,
    ROUND(SUM(f.net_revenue_usd),2) AS revenue,
    ROUND(SUM(f.net_revenue_usd)*100.0
          / SUM(SUM(f.net_revenue_usd)) OVER (PARTITION BY dd.year),2) AS pct_share
FROM fact_transactions f
JOIN dim_date dd ON f.date_id = dd.date_id
GROUP BY dd.year, f.device_type
ORDER BY dd.year, pct_share DESC;


-- Q10: Top Customers by Lifetime Value (LTV)
SELECT
    customer_id,
    COUNT(DISTINCT transaction_id) AS orders,
    SUM(units_sold)                AS total_units,
    ROUND(SUM(net_revenue_usd),2)  AS total_spend,
    ROUND(SUM(profit_usd),2)       AS total_profit,
    ROUND(AVG(customer_rating),2)  AS avg_rating
FROM fact_transactions
GROUP BY customer_id
ORDER BY total_spend DESC
LIMIT 20;


-- Q11: Seasonal Revenue Heatmap (Month × Year — India)
SELECT
    year,
    EXTRACT(MONTH FROM date_id::DATE) AS month_num,
    TO_CHAR(date_id::DATE, 'Mon')     AS month_name,
    ROUND(SUM(revenue_usd),2)         AS revenue
FROM india_transactions
GROUP BY year, month_num, month_name
ORDER BY year, month_num;


-- Q12: RFM Segmentation (Global)
WITH rfm_base AS (
    SELECT
        customer_id,
        MAX(date_id::DATE)                  AS last_purchase,
        COUNT(DISTINCT transaction_id)      AS frequency,
        SUM(net_revenue_usd)                AS monetary
    FROM fact_transactions
    GROUP BY customer_id
),
scored AS (
    SELECT *,
        NTILE(4) OVER (ORDER BY last_purchase DESC) AS r_score,
        NTILE(4) OVER (ORDER BY frequency ASC)      AS f_score,
        NTILE(4) OVER (ORDER BY monetary ASC)        AS m_score,
        CURRENT_DATE - last_purchase                 AS recency_days
    FROM rfm_base
)
SELECT
    customer_id, recency_days, frequency, ROUND(monetary,2) AS monetary,
    r_score, f_score, m_score,
    r_score + f_score + m_score AS rfm_total,
    CASE
        WHEN r_score + f_score + m_score >= 10 THEN 'Champions'
        WHEN r_score + f_score + m_score >= 7  THEN 'Loyal'
        WHEN r_score + f_score + m_score >= 4  THEN 'At Risk'
        ELSE 'Lost'
    END AS segment
FROM scored
ORDER BY rfm_total DESC;
