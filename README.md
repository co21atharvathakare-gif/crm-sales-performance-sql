# B2B CRM Sales Pipeline Analysis (SQL)

## 📊 Project Objective
This project analyzes the sales pipeline of a fictitious computer hardware company to uncover key drivers of revenue, sales team efficiency, and market opportunities. The goal is to provide actionable insights for sales managers to optimize their regional performance and product strategies.

## 🛠️ Tools Used
- **Database:** PostgreSQL
- **Interface:** pgAdmin 4
- **Concepts:** CTEs, Window Functions (LAG), Joins, Data Type Casting, Date Arithmetic, Data Cleaning.

## 🧹 Data Cleaning & Integrity
- **Handling Nulls:** Identified and populated missing values in the `sector` column of the `accounts` table as 'Unknown'.
- **Standardization:** Resolved a critical data mismatch where product names were inconsistent (e.g., 'GTXPro' vs 'GTX Pro') ensuring 100% accuracy in product-level revenue reporting.
- **Validation:** Audited date sequences to ensure `close_date` occurred after `engage_date`.

## 📈 Key Analysis & Insights
- **Sales Velocity:** Calculated the average time to close deals per team to identify bottlenecks in the sales funnel.
- **Profitability Audit:** Analyzed discounting behavior by comparing `sales_price` vs. actual `close_value` per agent.
- **Growth Trends:** Implemented a Quarter-over-Quarter (QoQ) revenue growth report using window functions to track momentum.
- **Market Segmentation:** Identified high-value sectors by calculating average deal values, allowing for better lead prioritization.

## 💡 Business Recommendations
- **Double down on Entertainment Sector:** It has our highest average deal value.
- **Standardize Discounting:** High discounts on GTK 500 are hurting margins. 
