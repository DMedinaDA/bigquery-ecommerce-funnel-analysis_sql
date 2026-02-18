# BigQuery E‑commerce Funnel Analysis (SQL)

E‑commerce sales funnel analysis using SQL in Google BigQuery (conversion rates, time‑to‑purchase, revenue metrics)

This project analyzes an e‑commerce sales funnel using SQL in Google BigQuery. It measures how users move from first page view to completed purchase, compares performance by traffic source, and quantifies revenue and time‑to‑conversion.

## Repository Structure

- `sql/`
  - `01_funnel_stages.sql` – counts unique users at each funnel stage (views, cart, checkout, payment, purchase).
  - `02_funnel_conversion_rates.sql` – calculates step‑to‑step and overall conversion rates.
  - `03_funnel_by_source.sql` – compares funnel performance by `traffic_source`.
  - `04_time_to_conversion.sql` – measures average time from view → cart → purchase.
  - `05_revenue_funnel.sql` – computes total revenue, average order value, revenue per buyer, and revenue per visitor.

## Dataset

- Table: `sql-projects-medina.sql_practice.userevents`
- Key fields:
  - `user_id` – unique user identifier
  - `event_type` – user action (`page_view`, `add_to_cart`, `checkout_start`, `payment_info`, `purchase`)
  - `event_date` – event timestamp
  - `traffic_source` – where the user came from (e.g. paid, organic, email)
  - `amount` – purchase amount for `purchase` events

All analyses use the last 30 days of data.

## Business Questions Answered

1. How many users reach each step of the funnel?
2. What are the conversion rates between each step and overall?
3. Which traffic sources drive the best conversion and purchase rates?
4. How long does it take users to move from first view to purchase?
5. How much revenue does the funnel generate per order, per buyer, and per visitor?

## How to Run

1. Open Google BigQuery and connect to your dataset.
2. Update the table name in the scripts if needed.
3. Run the SQL files in the `sql/` folder in numeric order.
4. Optionally, export results to a BI tool (e.g. Looker Studio) to visualize the funnel.

## Skills Demonstrated

- Writing analytical SQL with CTEs and conditional aggregation.
- Funnel and conversion analysis.
- Time‑to‑event calculations with `TIMESTAMP_DIFF`.
- Revenue and monetization metrics (AOV, revenue per visitor/buyer).
- Clear, documented SQL suitable for analytics and stakeholder reporting.
