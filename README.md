# SQL

SQL scripts from my data analyst / business analyst skill-building, mostly views, queries, and warehouse-style reporting logic.

## Contents

- `scripts/gold/report_customers.sql`, a customer reporting view over a star-schema warehouse (`fact_sales` + `dim_customers`). Joins fact and dimension tables, aggregates order/sales history per customer, then derives segments (VIP / Regular / New), age groups, recency, average order value, and average monthly spend using CTEs and window-style date logic.
- `scripts/netflix_imdb/analysis.sql`, an exploratory analysis joining three separate datasets (Netflix titles, IMDB ratings, and weekly Netflix Top 10 charts) to test whether IMDB ratings actually predict popularity, and to compare content strategy by country. Written as data exploration ahead of a Power BI dashboard.

## What I learned building the Netflix/IMDB analysis

This one pushed me past single-table reporting into working with a few datasets that weren't built to go together, and actually trying to answer a question instead of just describing the data.

I got more comfortable writing SELECT queries with joins, GROUP BY and aggregation, and CASE based segmentation from scratch. I created a VIEW so a metric I kept coming back to (English vs non-English viewership) could just be queried directly instead of rebuilding the logic every time. I joined tables that had no shared key by matching on cleaned, trimmed title text plus a year I had to pull out of a messy text field using PATINDEX, SUBSTRING, and TRY_CAST. I also learned to clean data before trusting it, stripping formatting characters out of numbers before casting them, and switching a plain equals filter to LIKE and STRING_SPLIT once I noticed the country field was storing co-productions as one long comma-separated string.

I used CTEs to build an actual framework instead of just a flat report, a quadrant model that classifies titles as Proven Hit, Hidden Gem, Popular but Mediocre, or Low Priority. And I tested an assumption instead of just accepting it, comparing the top-rated list against the top-voted list to see if a high rating actually means anything without votes behind it.

The biggest thing though was doing the exploration and cleaning in SQL first, before touching Power BI, so the dashboard was working off something already clean instead of raw tables. That's the part that matters most to an employer, it shows the SQL isn't just practice, it's the first step of an actual pipeline: source data, then SQL for cleaning, joining, and aggregating, then Power BI for the visual layer.
