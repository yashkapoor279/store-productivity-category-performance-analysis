USE store_productivity;

/*
PROJECT: Store Productivity & Category Performance Analysis
DATA: Walmart Recruiting Store Sales Forecasting dataset

This script contains the nine business analyses performed for the project.
It assumes the following tables/view already exist:
  - stores(Store, Type, Size)
  - sales(Store, Dept, Date, Weekly_Sales, IsHoliday)
  - features(Store, Date, ...)
  - sales_analysis (sales joined with stores and features)

Run each numbered section separately if you prefer to inspect results one at a time.
*/

-- ============================================================
-- 1. STORE TYPE PERFORMANCE
-- Total sales and average sales per store-department-week record.
-- ============================================================
SELECT
    st.Type AS Store_Type,
    ROUND(SUM(sa.Weekly_Sales), 2) AS Total_Sales,
    ROUND(AVG(sa.Weekly_Sales), 2) AS Average_Sales_Per_Record
FROM sales AS sa
JOIN stores AS st
    ON sa.Store = st.Store
GROUP BY st.Type
ORDER BY Total_Sales DESC;


-- ============================================================
-- 2. STORE PRODUCTIVITY: PERIOD SALES PER SQUARE FOOT
-- This is total sales over the available period divided by store size.
-- It is not a weekly sales-per-square-foot measure.
-- ============================================================
SELECT
    st.Store,
    st.Type,
    st.Size,
    ROUND(SUM(sa.Weekly_Sales), 2) AS Total_Sales,
    ROUND(SUM(sa.Weekly_Sales) / NULLIF(st.Size, 0), 2) AS Period_Sales_Per_SqFt
FROM sales AS sa
JOIN stores AS st
    ON sa.Store = st.Store
GROUP BY st.Store, st.Type, st.Size
ORDER BY Period_Sales_Per_SqFt DESC
LIMIT 10;


-- ============================================================
-- 3. DEPARTMENT PERFORMANCE
-- Total and average sales by department.
-- Department names are not available in the supplied dataset.
-- ============================================================
SELECT
    Dept,
    ROUND(SUM(Weekly_Sales), 2) AS Total_Sales,
    ROUND(AVG(Weekly_Sales), 2) AS Average_Sales_Per_Record
FROM sales
GROUP BY Dept
ORDER BY Total_Sales DESC
LIMIT 10;


-- ============================================================
-- 4. ABC CLASSIFICATION OF DEPARTMENTS
-- A: cumulative sales share up to and including 80%
-- B: cumulative sales share above 80% and up to 95%
-- C: cumulative sales share above 95%
-- Classification is based on cumulative share after each department.
-- ============================================================
WITH department_sales AS (
    SELECT
        Dept,
        SUM(Weekly_Sales) AS Total_Sales
    FROM sales
    GROUP BY Dept
),
department_cumulative AS (
    SELECT
        Dept,
        Total_Sales,
        SUM(Total_Sales) OVER (ORDER BY Total_Sales DESC, Dept) AS Cumulative_Sales,
        SUM(Total_Sales) OVER () AS Grand_Total
    FROM department_sales
),
abc AS (
    SELECT
        Dept,
        Total_Sales,
        Cumulative_Sales,
        Grand_Total,
        Cumulative_Sales / NULLIF(Grand_Total, 0) AS Cumulative_Sales_Share,
        CASE
            WHEN Cumulative_Sales / NULLIF(Grand_Total, 0) <= 0.80 THEN 'A'
            WHEN Cumulative_Sales / NULLIF(Grand_Total, 0) <= 0.95 THEN 'B'
            ELSE 'C'
        END AS ABC_Category
    FROM department_cumulative
)
SELECT
    Dept,
    ROUND(Total_Sales, 2) AS Total_Sales,
    ROUND(Cumulative_Sales_Share * 100, 2) AS Cumulative_Sales_Percent,
    ABC_Category
FROM abc
ORDER BY Total_Sales DESC, Dept;


-- ============================================================
-- 5. HOLIDAY VS NON-HOLIDAY PERFORMANCE
-- Average is calculated per sales record, not per store or week.
-- ============================================================
SELECT
    IsHoliday,
    COUNT(*) AS Total_Records,
    ROUND(AVG(Weekly_Sales), 2) AS Average_Sales,
    ROUND(SUM(Weekly_Sales), 2) AS Total_Sales
FROM sales
GROUP BY IsHoliday
ORDER BY IsHoliday;


-- ============================================================
-- 6. WEEK-OVER-WEEK SALES TREND
-- Aggregates sales across all stores/departments for each date,
-- then compares each date with the previous available sales date.
-- ============================================================
WITH weekly_totals AS (
    SELECT
        Date,
        SUM(Weekly_Sales) AS Total_Sales
    FROM sales
    GROUP BY Date
),
weekly_comparison AS (
    SELECT
        Date,
        Total_Sales,
        LAG(Total_Sales) OVER (ORDER BY Date) AS Previous_Week_Sales
    FROM weekly_totals
)
SELECT
    Date,
    ROUND(Total_Sales, 2) AS Total_Sales,
    ROUND(Previous_Week_Sales, 2) AS Previous_Week_Sales,
    ROUND(
        (Total_Sales - Previous_Week_Sales) * 100.0
        / NULLIF(Previous_Week_Sales, 0),
        2
    ) AS WoW_Change_Percent
FROM weekly_comparison
ORDER BY Date;


-- ============================================================
-- 7. YEAR-OVER-YEAR APPROXIMATION
-- Compares each date with the row 52 weekly observations earlier.
-- This is a 52-row comparison (approximately 364 days), not an
-- exact calendar-date join for every possible week/calendar year.
-- ============================================================
WITH weekly_totals AS (
    SELECT
        Date,
        SUM(Weekly_Sales) AS Total_Sales
    FROM sales
    GROUP BY Date
),
yoy_comparison AS (
    SELECT
        Date,
        Total_Sales,
        LAG(Total_Sales, 52) OVER (ORDER BY Date) AS Sales_52_Weeks_Earlier
    FROM weekly_totals
)
SELECT
    Date,
    ROUND(Total_Sales, 2) AS Current_Sales,
    ROUND(Sales_52_Weeks_Earlier, 2) AS Sales_52_Weeks_Earlier,
    ROUND(
        (Total_Sales - Sales_52_Weeks_Earlier) * 100.0
        / NULLIF(Sales_52_Weeks_Earlier, 0),
        2
    ) AS YoY_Change_Percent
FROM yoy_comparison
WHERE Sales_52_Weeks_Earlier IS NOT NULL
ORDER BY Date;


-- ============================================================
-- 8. STORE RANKING WITHIN EACH STORE TYPE
-- Ranks stores by total sales within their own store type.
-- ============================================================
WITH store_sales AS (
    SELECT
        st.Store,
        st.Type,
        st.Size,
        SUM(sa.Weekly_Sales) AS Total_Sales
    FROM sales AS sa
    JOIN stores AS st
        ON sa.Store = st.Store
    GROUP BY st.Store, st.Type, st.Size
),
ranked_stores AS (
    SELECT
        Store,
        Type,
        Size,
        Total_Sales,
        RANK() OVER (PARTITION BY Type ORDER BY Total_Sales DESC) AS Store_Rank_Within_Type
    FROM store_sales
)
SELECT
    Store,
    Type,
    Size,
    ROUND(Total_Sales, 2) AS Total_Sales,
    Store_Rank_Within_Type
FROM ranked_stores
ORDER BY Type, Store_Rank_Within_Type;


-- ============================================================
-- 9. MARKDOWN VS NO-MARKDOWN SALES
-- Missing markdown values are treated as zero for this analysis,
-- consistent with the documented project cleaning assumption.
-- ============================================================
WITH markdown_by_record AS (
    SELECT
        sa.Store,
        sa.Dept,
        sa.Date,
        sa.Weekly_Sales,
        COALESCE(f.MarkDown1, 0) +
        COALESCE(f.MarkDown2, 0) +
        COALESCE(f.MarkDown3, 0) +
        COALESCE(f.MarkDown4, 0) +
        COALESCE(f.MarkDown5, 0) AS Total_Markdown
    FROM sales AS sa
    LEFT JOIN features AS f
        ON sa.Store = f.Store
       AND sa.Date = f.Date
)
SELECT
    CASE
        WHEN Total_Markdown > 0 THEN 'With Markdown'
        ELSE 'Without Markdown'
    END AS Markdown_Status,
    COUNT(*) AS Total_Records,
    ROUND(AVG(Weekly_Sales), 2) AS Average_Sales,
    ROUND(SUM(Weekly_Sales), 2) AS Total_Sales
FROM markdown_by_record
GROUP BY
    CASE
        WHEN Total_Markdown > 0 THEN 'With Markdown'
        ELSE 'Without Markdown'
    END
ORDER BY Markdown_Status;
