# SQL

SQL scripts from my data analyst / business analyst skill-building — views, queries, and warehouse-style reporting logic.

## Contents

- `scripts/gold/report_customers.sql` — a customer reporting view over a star-schema warehouse (`fact_sales` + `dim_customers`). Joins fact and dimension tables, aggregates order/sales history per customer, then derives segments (VIP / Regular / New), age groups, recency, average order value, and average monthly spend using CTEs and window-style date logic.
- `scripts/netflix_imdb/analysis.sql` — an exploratory analysis joining three separate datasets (Netflix titles, IMDB ratings, and weekly Netflix Top 10 charts) to test whether IMDB ratings actually predict popularity, and to compare content strategy by country. Written as data exploration ahead of a Power BI dashboard.

## What I learned building the Netflix/IMDB analysis

This one moved past single-table reporting into working with several independently-sourced datasets and chasing an actual question instead of just describing the data:

- Writing SELECT queries from scratch with joins, GROUP BY/aggregation, and CASE-based segmentation
- Creating a VIEW so a recurring metric (English vs. non-English viewership trend) can be queried directly by a BI tool instead of re-deriving the logic every time
- Joining tables that weren't designed to go together — matching on cleaned/trimmed title text plus a year parsed out of a messy text field (`PATINDEX` + `SUBSTRING` + `TRY_CAST`), since there was no shared key to join on
- Cleaning data before trusting it: stripping formatting characters out of numbers before casting (`REPLACE` + `TRY_CAST`), and switching a plain `=` filter to `LIKE` / `STRING_SPLIT` once I noticed the country field stores co-productions as a single comma-separated string
- Structuring a query with CTEs to build an actual analytical framework (a quadrant model classifying titles as Proven Hit / Hidden Gem / Popular but Mediocre / Low Priority), not just a flat report
- Testing an assumption instead of taking it for granted — comparing the top-10-rated list against the top-10-most-voted list to check whether a high rating means anything without volume behind it
- Doing the data exploration and cleaning in SQL first, before touching Power BI, so the dashboard consumes an already-cleaned, aggregated dataset instead of raw tables

That last point is the one that matters most to an employer: it shows the SQL isn't just an exercise, it's the first stage of a real analytics pipeline — source data → SQL cleaning/joining/aggregation → BI visualization — which is how this work actually gets done on an analyst team.
