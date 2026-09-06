# SQL

SQL scripts from my data analyst / business analyst skill-building — views, queries, and warehouse-style reporting logic.

## Contents

- `scripts/gold/report_customers.sql` — a customer reporting view over a star-schema warehouse (`fact_sales` + `dim_customers`). Joins fact and dimension tables, aggregates order/sales history per customer, then derives segments (VIP / Regular / New), age groups, recency, average order value, and average monthly spend using CTEs and window-style date logic.
