
-- Funnel analysis for last 30 days of user events (BigQuery, web analytics dataset)

SELECT *  FROM `sql-projects-medina.sql_practice.userevents` 


   -- 1) Define the sales funnel and count unique users at each stage, CTE setup to show what will be used. 

WITH funnel_stages AS ( 

SELECT 
  COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS stage_1_views,-- Users who viewed at least one page
  COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS stage_2_cart, -- Users who added at least one item to cart
  COUNT(DISTINCT CASE WHEN event_type = 'checkout_start' THEN user_id END) AS stage_3_checkout, -- Users who started checkout
  COUNT(DISTINCT CASE WHEN event_type = 'payment_info' THEN user_id END) AS stage_4_payment,   -- Users who submitted payment info
  COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS stage_5_purchase     -- Users who completed a purchase    

FROM `sql-projects-medina.sql_practice.userevents` 

WHERE event_date >= TIMESTAMP(DATE_SUB(CURRENT_DATE(),INTERVAL 30 DAY))

)

SELECT * FROM funnel_stages;

  -- 2) Compute step-by-step and overall conversion rates -- conversion rates through the funnel 

WITH funnel_stages AS ( 

SELECT 
  COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS stage_1_views,
  COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS stage_2_cart,
  COUNT(DISTINCT CASE WHEN event_type = 'checkout_start' THEN user_id END) AS stage_3_checkout,
  COUNT(DISTINCT CASE WHEN event_type = 'payment_info' THEN user_id END) AS stage_4_payment,
  COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS stage_5_purchase

FROM `sql-projects-medina.sql_practice.userevents` 

WHERE event_date >= TIMESTAMP(DATE_SUB(CURRENT_DATE(),INTERVAL 30 DAY))
)

SELECT 
-- Raw counts at each funnel stage
 stage_1_views,
 stage_2_cart,
 ROUND(stage_2_cart * 100 / stage_1_views) AS view_to_cart_rate, -- % of viewers who added to cart

 stage_3_checkout,
 ROUND(stage_3_checkout * 100 / stage_2_cart) AS cart_to_checkout_rate, -- % of cart users who started checkout
 
 stage_4_payment,
 ROUND(stage_4_payment * 100 / stage_3_checkout) AS checkout_to_payment_rate,   -- % of checkout users who submitted payment details
 
stage_5_purchase,
 ROUND(stage_5_purchase * 100 / stage_4_payment) AS payment_to_purchase,    -- % of users with payment info who completed purchase

 ROUND(stage_5_purchase * 100 / stage_1_views) AS overall_conversion_rate    -- Overall conversion from first page view to purchase
 
FROM funnel_stages



-- 3) Funnel performance by traffic source

WITH source_funnel AS (
 SELECT
 traffic_source, 
  COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS views,  -- Users per source who saw at least one page
  COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS cart, -- Users per source who added at least one item to cart
  COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS purchases -- Users per source who completed at least one purchase

FROM `sql-projects-medina.sql_practice.userevents` 

WHERE event_date >= TIMESTAMP(DATE_SUB(CURRENT_DATE(),INTERVAL 30 DAY))
group by traffic_source

)

SELECT
traffic_source,
views,
cart,
purchases,
 ROUND(cart * 100 / views) AS cart_to_conversion_rate, -- % of visitors per source who added to cart
 ROUND(purchases * 100 / views) AS purchases_conversion_rate,  -- % of visitors per source who purchased
 ROUND(purchases * 100 / cart) AS cart_to_purchase_conversion_rate, -- % of cart users per source who purchased

FROM source_funnel
ORDER by purchases DESC -- Show top-converting sources by absolute purchase count



-- 4) Time to conversion analysis: how long users take to move through the funnel -- This assumes a linear journey (view → cart → purchase). Users who skip steps may have NULL intermediate times.

WITH user_journey AS (
 SELECT
 user_id, 
  MIN(CASE WHEN event_type = 'page_view' THEN event_date END) AS view_time, -- First time the user viewed any page
  MIN(CASE WHEN event_type = 'add_to_cart' THEN event_date END) AS cart_time,    -- First time the user added an item to cart
  MIN(CASE WHEN event_type = 'purchase' THEN event_date END) AS purchase_time   -- First time the user completed a purchase

FROM `sql-projects-medina.sql_practice.userevents` 

WHERE event_date >= TIMESTAMP(DATE_SUB(CURRENT_DATE(),INTERVAL 30 DAY))
group by user_id
HAVING MIN(CASE WHEN event_type = 'purchase' THEN event_date END) IS NOT NULL    -- Only include users who eventually purchased (completed funnel)

)

SELECT 
 COUNT(*) AS converted_users,
 ROUND(AVG(TIMESTAMP_DIFF(cart_time,view_time, MINUTE)),2) AS avg_view_to_cart_minutes,  -- Average minutes from first view to first cart event
 ROUND(AVG(TIMESTAMP_DIFF(purchase_time,cart_time, MINUTE)),2) AS avg_cart_to_purchase_minutes,  -- Average minutes from first cart event to purchase
 ROUND(AVG(TIMESTAMP_DIFF(purchase_time,view_time, MINUTE)),2) AS avg_total_journey_minutes,    -- Average total journey time from first view to purchase

FROM user_journey

-- 5) Revenue funnel: link funnel behavior to revenue

WITH funnel_revenue AS (
SELECT
  COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS total_visitors,  -- Total unique visitors in the last 30 days
  COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS total_buyers,   -- Unique buyers who completed at least one purchase
  SUM(CASE WHEN event_type = 'purchase' THEN amount END) AS total_revenue,     -- Total revenue from purchase events (assumes 'amount' is per order)
  COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) AS total_orders,    -- Total number of purchase events (treating each as an order)

FROM `sql-projects-medina.sql_practice.userevents`

WHERE event_date >= TIMESTAMP(DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY))
)


SELECT
 total_visitors,
 total_buyers,
 total_orders,
 total_revenue,
 total_revenue / total_orders AS avg_order_value,  -- Average revenue per order
 total_revenue / total_buyers AS revenue_per_buyer,   -- Average revenue per unique buyer
 total_revenue / total_visitors AS revenue_per_visitor  -- Average revenue generated per unique visitor

FROM funnel_revenue 





