# Bakery Business Analytics — SQL + Python

## Project Overview
End-to-end analysis of a synthetic bakery transaction dataset using SQL and Python, focused on revenue, profitability, promotions, discounting, waste, expiry risk, customer behavior, stores and operating patterns.

## Dataset
- Records / transactions: 16,569
- Date range: 2023-01-01 to 2024-12-31
- Customers: 2,173
- Products: 35
- Categories: 10
- Stores: 3
- Employees: 20
- Columns: 47

## Executive KPI Snapshot
| KPI | Value |
|---|---:|
| Revenue | 3,444,112.95 |
| Profit | -230,339.25 |
| Overall margin | -6.69% |
| Units produced | 126,710 |
| Units sold | 81,184 |
| Unsold units | 45,526 |
| Unsold rate | 35.93% |
| Waste cost | 1,388,812.80 |

## Key Business Insights

### 1. Revenue is not translating into profitability
The dataset produces approximately **3,444,113 of revenue but -230,339 of profit**, giving an overall margin of **-6.69%**. Revenue growth alone should therefore not be the primary management KPI.

### 2. Promotions are associated with significant margin pressure
Promoted transactions contribute approximately **-232,292 profit**, while non-promoted transactions contribute approximately **1,953**. Promotion transactions also have a lower average bill. This is an observational relationship, not proof of causality; product mix and inventory conditions may influence which transactions receive promotions.

### 3. Deeper discounts are associated with weaker profitability
Profit declines materially as discount depth increases. The 20%+ discount band is especially loss-making. Discounting should therefore be controlled by product economics and inventory risk rather than used as a blanket volume lever.

### 4. Expiry risk is a major operational signal
High expiry-risk transactions have higher unsold rates and weaker profitability. Shelf-life-aware production planning and earlier markdown decisions are strong areas for further optimization.

### 5. Cakes generate large revenue but weak economics
Cakes are the largest revenue category but are loss-making in aggregate. Chocolate Cake and Black Forest Cake are among the largest negative profit contributors. Management should examine pricing, production quantities, waste, discounts and unit economics for these products.

### 6. Beverages are a positive contribution area
Beverages generate substantial revenue with positive aggregate profitability. They can be evaluated for cross-sell and bundle opportunities while protecting contribution margin.

### 7. Weekend sales require margin analysis
Weekend revenue is substantial, but weekend profitability is materially weaker than weekday profitability. Product mix, discounting, production volume and waste should be decomposed before increasing weekend promotions.

### 8. Store performance suggests a systemic issue
The three stores have broadly similar revenue levels and all are loss-making. This suggests the core issue may be pricing, discounting, waste or product economics rather than a single weak location.

## Senior Analyst Recommendations
1. Build a contribution-margin KPI that includes revenue, discount, product profit and waste cost.
2. Establish product/category-specific discount guardrails.
3. Forecast demand using weekday, season, shelf life, store and promotion signals.
4. Prioritize products that combine high revenue, negative profit and high waste.
5. Use controlled promotion experiments to measure incremental contribution.
6. Optimize weekend production and promotion based on profitable demand.
7. Track loyalty using frequency, basket size, retention and incremental contribution—not membership count alone.

## SQL
`bakery_analysis.sql` contains queries for:
- KPI reporting
- Monthly trends
- Category/product profitability
- Store comparison
- Promotion and discount analysis
- Expiry/waste analysis
- Weekend/day-of-week analysis
- Customer segments and loyalty
- Payment and weather
- Product recommendations
- Repeat frequency
- Loss-making product detection
- Data-quality checks

## Python
`bakery_analysis.py` covers:
- EDA and schema inspection
- Missing values and duplicate checks
- Descriptive statistics
- KPI calculations
- Category/product/store analysis
- Promotion/discount analysis
- Waste and expiry analysis
- Customer/loyalty analysis
- Time analysis
- 12 business visualizations

## Visualizations
See the `visualizations/` folder for:
1. Monthly revenue and profit
2. Revenue by category
3. Profit by category
4. Bottom products by profit
5. Promotion vs no-promotion profit
6. Waste by expiry risk
7. Revenue by day
8. Store performance
9. Profit by discount band
10. Revenue by customer segment
11. Payment methods
12. Discount vs transaction profit

## Data Quality
No duplicate rows or duplicate transaction IDs were found. `Festival` and `Promotion_Type` are sparse because they are conditional fields. Small monetary formula differences can occur because of decimal/rounding precision in the source.

## Major business insights
1. Revenue is not translating into profitability.
The business has significant sales volume but negative overall profitability, so revenue alone is not an adequate performance KPI.
2. Promotions are a major margin-risk area.
Promoted transactions generated approximately -232K profit, while non-promoted transactions generated approximately +2K.
3. Deep discounting is strongly associated with poor profitability.
The 20%+ discount group has approximately -54% margin, compared with positive margins for transactions with little/no discount.
4. Expiry risk is strongly associated with waste.
High-risk inventory has an unsold rate of approximately 43.9%, versus approximately 29.6% for low-risk inventory.
5. Cakes are a major revenue driver but a profitability problem.
Cakes generated approximately 1.29M revenue but around -108K profit.
6. Chocolate Cake and Black Forest Cake require investigation.
They are among the largest revenue-generating products while also being among the largest negative contributors to profit.
7. Beverages are an important positive contribution category.
Beverages generated approximately 21% aggregate margin in the supplied data.
8. Weekend sales need profitability optimization.
Weekend revenue is high, but weekend margin is approximately -11.6%, considerably weaker than weekday performance.
9. All three stores are loss-making.
This suggests the profitability issue is likely systemic—pricing, discounting, waste, or product economics—rather than isolated to one store.
10.The next step should be demand + profitability optimization.
A production forecasting model using product, store, weekday, season, shelf life, promotion and historical demand would be a strong next-stage project.

## Conclusion
The central business issue is **profitability and inventory efficiency, not simply sales volume**. The supplied data shows meaningful revenue but negative aggregate profit, with the strongest signals around discount depth, promotion usage, expiry risk, waste and high-revenue loss-making products.
The next analytical stage should be a **demand forecasting and profitability optimization model** that recommends production quantities by product/store/day, applies product-specific discount guardrails, and evaluates promotions on incremental contribution. This would help the business pursue growth while protecting margin and reducing waste.
