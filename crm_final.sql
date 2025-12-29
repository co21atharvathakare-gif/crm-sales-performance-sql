--DATA INSPECTION
SELECT * FROM sales_pipeline LIMIT 20;

SELECT * FROM accounts;

SELECT * FROM products;

SELECT * FROM sales_teams;

SELECT * FROM data_dictionary;

--DATA CLEANING

UPDATE accounts
SET sector = 'Unknown'
WHERE sector IS NULL;

UPDATE sales_pipeline
SET product = 'GTX Pro'
WHERE product = 'GTXPro';

--DATA ANALYSIS ( BASIC LEVEL )

--1. Top products wrt Total revenue
SELECT product , COUNT(product) AS units_sold, SUM(close_value) AS total_revenue
FROM sales_pipeline
GROUP BY product
ORDER BY total_revenue DESC;

--2. Top performing sales agent
SELECT sales_agent AS agent, SUM(close_value) AS total_sales
FROM sales_pipeline
WHERE deal_stage = 'Won'
GROUP BY agent
ORDER BY total_sales;

--3. Which account is top clients
SELECT account, COUNT(opportunity_id) AS total_deals, SUM(close_value) AS total_sales
FROM sales_pipeline
GROUP BY account
ORDER BY total_sales DESC;

--DATA ANALYSIS ( ADVANCE LEVEL )

--1. Sales teams wise total deals, won deals & win ratio

WITH team_performance AS (
    SELECT 
        t.manager,
        COUNT(p.opportunity_id) AS total_deals,
        COUNT(CASE WHEN p.deal_stage = 'Won' THEN 1 END) AS won_deals
    FROM sales_pipeline p
    JOIN sales_teams t ON p.sales_agent = t.sales_agent
    GROUP BY t.manager
)
SELECT 
    manager,
    total_deals,
    won_deals,
    ROUND((won_deals::numeric / total_deals) * 100, 2) AS win_rate
FROM team_performance
ORDER BY win_rate DESC;

--2. Average time between engaging and closing deal wrt Teams

WITH cte AS (
  SELECT t.manager ,
    AVG(p.close_date - p.engage_date) AS avg_close_time
  FROM sales_pipeline p
  JOIN sales_teams t
  ON p.sales_agent = t.sales_agent
  WHERE p.close_date IS NOT NULL
  GROUP BY t.manager
)
SELECT manager, ROUND(avg_close_time, 2) AS avg_days_to_close
FROM cte
ORDER BY avg_days_to_close;

--3. Which agent have the highest average discount.
SELECT 
  s.sales_agent,
  ROUND(AVG(p.sales_price - s.close_value),2) AS avg_discount
FROM sales_pipeline s
JOIN products p
ON s.product = p.product
WHERE s.deal_stage = 'Won'
GROUP BY s.sales_agent
ORDER BY avg_discount DESC;

--4. Quarter-Over-Quarter (QoQ) Revenue Growth
WITH quarterly_revenue AS (
  SELECT
    DATE_TRUNC('quarter',close_date) AS quarter,
	SUM(close_value) AS current_revenue
  FROM sales_pipeline
  WHERE deal_stage = 'Won' AND close_value IS NOT NULL
  GROUP BY quarter
),
revenue_comparison AS (
  SELECT
    quarter,
	current_revenue,
	LAG(current_revenue) OVER(ORDER BY quarter) AS previous_revenue
  FROM quarterly_revenue
)
SELECT 
    quarter,
    current_revenue,
    previous_revenue,
    ROUND(current_revenue - previous_revenue, 2) AS revenue_change,
	ROUND(((current_revenue - previous_revenue) / NULLIF(previous_revenue, 0)) * 100,2) AS qoq_growth_percentage
FROM revenue_comparison
ORDER BY quarter;

--5. Sector Wise Average Deal Value
SELECT a.sector , ROUND(AVG(s.close_value),2) AS total_rev
FROM sales_pipeline s
JOIN accounts a
ON s.account = a.account
WHERE s.deal_stage = 'Won' 
GROUP BY a.sector
ORDER BY total_rev DESC;
