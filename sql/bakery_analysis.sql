-- PostgreSQL-compatible Bakery Business Analytics
-- Source table: bakery_transactions

SELECT COUNT(*) transactions, SUM(total_bill) revenue, SUM(profit) profit,
       ROUND(100.0*SUM(profit)/NULLIF(SUM(total_bill),0),2) margin_pct,
       SUM(units_produced) units_produced, SUM(units_sold) units_sold,
       SUM(unsold_units) unsold_units, SUM(waste_cost) waste_cost
FROM bakery_transactions;

SELECT DATE_TRUNC('month', date) month, COUNT(*) transactions,
       SUM(total_bill) revenue, SUM(profit) profit,
       ROUND(100.0*SUM(profit)/NULLIF(SUM(total_bill),0),2) margin_pct
FROM bakery_transactions GROUP BY 1 ORDER BY 1;

SELECT category, COUNT(*) transactions, SUM(total_bill) revenue,
       SUM(profit) profit,
       ROUND(100.0*SUM(profit)/NULLIF(SUM(total_bill),0),2) margin_pct,
       SUM(units_sold) units_sold, SUM(unsold_units) unsold_units,
       SUM(waste_cost) waste_cost
FROM bakery_transactions GROUP BY category ORDER BY revenue DESC;

SELECT product, COUNT(*) transactions, SUM(total_bill) revenue,
       SUM(profit) profit,
       ROUND(100.0*SUM(profit)/NULLIF(SUM(total_bill),0),2) margin_pct,
       SUM(unsold_units) unsold_units, SUM(waste_cost) waste_cost
FROM bakery_transactions GROUP BY product ORDER BY profit ASC;

SELECT product, SUM(total_bill) revenue
FROM bakery_transactions GROUP BY product ORDER BY revenue DESC LIMIT 10;

SELECT store_id, COUNT(*) transactions, SUM(total_bill) revenue,
       SUM(profit) profit,
       ROUND(100.0*SUM(profit)/NULLIF(SUM(total_bill),0),2) margin_pct,
       SUM(waste_cost) waste_cost
FROM bakery_transactions GROUP BY store_id ORDER BY revenue DESC;

SELECT promotion_applied, COUNT(*) transactions, SUM(total_bill) revenue,
       SUM(profit) profit,
       ROUND(100.0*SUM(profit)/NULLIF(SUM(total_bill),0),2) margin_pct,
       AVG(total_bill) avg_bill
FROM bakery_transactions GROUP BY promotion_applied;

SELECT COALESCE(promotion_type,'No Promotion') promotion_type,
       COUNT(*) transactions, SUM(total_bill) revenue, SUM(profit) profit,
       ROUND(100.0*SUM(profit)/NULLIF(SUM(total_bill),0),2) margin_pct
FROM bakery_transactions
GROUP BY COALESCE(promotion_type,'No Promotion') ORDER BY profit ASC;

SELECT CASE
         WHEN discount_percentage=0 THEN '0%'
         WHEN discount_percentage<=5 THEN '0-5%'
         WHEN discount_percentage<=10 THEN '5-10%'
         WHEN discount_percentage<=15 THEN '10-15%'
         WHEN discount_percentage<=20 THEN '15-20%'
         ELSE '20%+'
       END discount_band,
       COUNT(*) transactions, SUM(total_bill) revenue, SUM(profit) profit,
       ROUND(100.0*SUM(profit)/NULLIF(SUM(total_bill),0),2) margin_pct
FROM bakery_transactions GROUP BY 1 ORDER BY 1;

SELECT expiry_risk, SUM(units_produced) produced, SUM(units_sold) sold,
       SUM(unsold_units) unsold,
       ROUND(100.0*SUM(unsold_units)/NULLIF(SUM(units_produced),0),2) unsold_rate_pct,
       SUM(waste_cost) waste_cost, SUM(profit) profit
FROM bakery_transactions GROUP BY expiry_risk ORDER BY unsold_rate_pct DESC;

SELECT weekend, COUNT(*) transactions, SUM(total_bill) revenue,
       SUM(profit) profit, AVG(total_bill) avg_bill
FROM bakery_transactions GROUP BY weekend;

SELECT day_of_week, COUNT(*) transactions, SUM(total_bill) revenue,
       SUM(profit) profit, AVG(total_bill) avg_bill
FROM bakery_transactions GROUP BY day_of_week ORDER BY revenue DESC;

SELECT customer_segment, COUNT(*) transactions,
       COUNT(DISTINCT customer_id) customers, SUM(total_bill) revenue,
       SUM(profit) profit, AVG(total_bill) avg_bill
FROM bakery_transactions GROUP BY customer_segment ORDER BY revenue DESC;

SELECT loyalty_member, COUNT(*) transactions, COUNT(DISTINCT customer_id) customers,
       SUM(total_bill) revenue, SUM(profit) profit, AVG(total_bill) avg_bill
FROM bakery_transactions GROUP BY loyalty_member;

SELECT payment_method, COUNT(*) transactions, SUM(total_bill) revenue,
       AVG(total_bill) avg_bill
FROM bakery_transactions GROUP BY payment_method ORDER BY revenue DESC;

SELECT weather, COUNT(*) transactions, SUM(total_bill) revenue,
       SUM(profit) profit, AVG(total_bill) avg_bill
FROM bakery_transactions GROUP BY weather ORDER BY revenue DESC;

SELECT product, recommended_product, COUNT(*) recommendation_count
FROM bakery_transactions
GROUP BY product,recommended_product
ORDER BY recommendation_count DESC;

WITH c AS (
 SELECT customer_id, COUNT(*) orders, SUM(total_bill) revenue, SUM(profit) profit
 FROM bakery_transactions GROUP BY customer_id
)
SELECT CASE WHEN orders=1 THEN '1 order'
            WHEN orders BETWEEN 2 AND 5 THEN '2-5 orders'
            WHEN orders BETWEEN 6 AND 10 THEN '6-10 orders'
            ELSE '11+ orders' END frequency_band,
       COUNT(*) customers, SUM(revenue) revenue, SUM(profit) profit
FROM c GROUP BY 1 ORDER BY 1;

SELECT product, SUM(total_bill) revenue, SUM(profit) profit,
       ROUND(100.0*SUM(profit)/NULLIF(SUM(total_bill),0),2) margin_pct,
       SUM(unsold_units) unsold_units, SUM(waste_cost) waste_cost
FROM bakery_transactions
GROUP BY product HAVING SUM(profit)<0 ORDER BY waste_cost DESC;

SELECT COUNT(*) rows, COUNT(DISTINCT transaction_id) distinct_transactions,
       SUM(CASE WHEN total_bill IS NULL THEN 1 ELSE 0 END) missing_bills,
       SUM(CASE WHEN profit IS NULL THEN 1 ELSE 0 END) missing_profit,
       SUM(CASE WHEN units_produced-units_sold<>unsold_units THEN 1 ELSE 0 END) unit_balance_errors
FROM bakery_transactions;
