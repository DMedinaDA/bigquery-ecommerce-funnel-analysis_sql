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
   
## Key Findings
- Checkout: 80% conversion (don't touch it)
- Social ads: 30% traffic, poor conversion → shift to retargeting
- Email: 13% conversion → prioritize capture popups
- AOV $108 → keep CAC under $30-40


### Funnel Performance
| Stage | Users | Conversion Rate |
|-------|-------|-----------------|
| Page Views | **2,173** | - |
| Add to Cart | 688 | **32.0%** ↓ |
| Checkout Start | 474 | **69.0%** ↓ |
| Payment Info | 378 | **80.0%** ↓ |
| Purchase | **353** | **93.0%** ↓ |

**Overall conversion**: **16.0%** (2,173 views → 353 purchases)

### Traffic Source Performance
| Source | Views | Purchases | View→Purchase |
|--------|-------|-----------|---------------|
| **email** | 233 | **75** | **32.2%** 🥇 |
| **paid_ads** | 401 | 83 | **21.0%** 🥈 |
| organic | 884 | 153 | **17.0%** |
| social | 655 | 42 | **6.0%** 🥉 |

**Email = 5x better than social.**

### Journey Timing
**Average time for 353 converted users:**
- View → Cart: **10.99 minutes**
- Cart → Purchase: **13.04 minutes** 
- **Total journey**: **24.03 minutes**

### Revenue Metrics
| Metric | Value |
|--------|-------|
| Total Revenue | **$38,181**
| Orders | 353 |
| **Avg Order Value** | **$108.16**
| Revenue per Visitor | **$17.57**

**Takeaway**: Email drives highest ROI; 68% drop-off occurs at cart→checkout stage.

## Skills Demonstrated

- Writing analytical SQL with CTEs and conditional aggregation.
- Funnel and conversion analysis.
- Time‑to‑event calculations with `TIMESTAMP_DIFF`.
- Revenue and monetization metrics (AOV, revenue per visitor/buyer).
- Clear, documented SQL suitable for analytics and stakeholder reporting.
