# Store Productivity & Category Performance Analysis

![Python](https://img.shields.io/badge/Python-Data%20Analysis-blue)
![SQL](https://img.shields.io/badge/MySQL-Database-orange)
![Pandas](https://img.shields.io/badge/Pandas-EDA-purple)
![Status](https://img.shields.io/badge/Project-Completed-brightgreen)

## 1. Project Overview

This project focuses on analyzing retail sales data to evaluate store productivity, department-level performance, holiday sales patterns and seasonal trends.

The objective is to transform raw retail data into meaningful business insights that can help retail businesses understand sales performance, identify high-performing stores and departments, and make informed operational decisions.

The analysis uses the Walmart Recruiting Store Sales Forecasting dataset and combines SQL-based business analysis with Python-based Exploratory Data Analysis (EDA).

## 2. Business Objectives

- Evaluate sales performance across different store types.
- Identify high-performing stores based on total sales and store size.
- Analyze department-wise sales contribution.
- Perform ABC classification to categorize departments based on sales contribution.
- Compare holiday and non-holiday sales performance.
- Identify weekly and monthly sales trends.
- Examine the relationship between promotional markdowns and sales.
- Identify data-quality issues before performing analysis.

## 3. Tools & Technologies

| Technology | Purpose |
|---|---|
| Python | Data analysis |
| Pandas & NumPy | Data manipulation and cleaning |
| Matplotlib | Data visualization |
| Seaborn | Statistical visualization |
| MySQL | Database management and SQL analysis |
| Jupyter Notebook | Interactive analysis |
| Git & GitHub | Version control and project documentation |

## 4. Dataset Description

**Dataset Source:** [Walmart Recruiting - Store Sales Forecasting (Kaggle)](https://www.kaggle.com/competitions/walmart-recruiting-store-sales-forecasting/data)

The project uses three datasets:

| Dataset | Records | Description |
|---|---:|---|
| train.csv | 421,570 | Weekly sales by store and department |
| stores.csv | 45 | Store information, type and size |
| features.csv | 8,190 | Store-date information including temperature, fuel price, markdowns, CPI and unemployment |

The sales dataset contains records from 45 stores across 143 unique dates, covering February 2010 to October 2012.

**Note:** Dataset CSV files are excluded from this GitHub repository. Download them separately from Kaggle and place them in the `data/raw/` directory.

## 5. Project Workflow

### Phase 1: Data Understanding

- Inspected dataset dimensions, columns and data types.
- Examined date ranges and unique store and department counts.
- Identified missing values and duplicate records.
- Investigated negative and zero sales records.
- Checked date coverage between sales and features datasets.

### Phase 2: Data Cleaning

The following data-quality checks and decisions were performed:

- Converted date columns into proper datetime format.
- Checked complete duplicate records and duplicate business keys.
- Identified 1,285 negative sales records.
- Identified 73 zero-sales records.
- Preserved negative and zero sales because their business meaning was not confirmed.
- Replaced missing values in MarkDown1–MarkDown5 with zero as an analytical assumption.
- Retained missing CPI and Unemployment values because the affected records fall outside the sales analysis period.

**Data Quality Summary**

| Data Quality Check | Result |
|---|---:|
| Negative sales records | 1,285 |
| Zero sales records | 73 |
| Duplicate sales records | 0 |
| Duplicate store-date feature records | 0 |
| Missing CPI values | 585 |
| Missing Unemployment values | 585 |

The missing CPI and Unemployment values occur across 13 dates between May and July 2013, after the sales dataset ends on October 26, 2012.

### Phase 3: MySQL Database Development

- Created a MySQL database named `store_productivity`.
- Created relational tables for stores, sales and features.
- Defined primary and foreign key constraints.
- Imported the cleaned CSV datasets.
- Created a joined analysis view combining sales, store information and external features.
- Verified the joined view contained 421,570 records.

SQL techniques used:

- SELECT, WHERE and ORDER BY
- GROUP BY and aggregate functions
- JOIN operations
- Subqueries and CTEs
- Window functions such as LAG() and RANK()
- CASE statements
- ABC classification
- Week-over-week and year-over-year comparisons

### Phase 4: Python Exploratory Data Analysis

Used Pandas, Matplotlib and Seaborn to analyze:

- Weekly sales trends.
- Holiday versus non-holiday performance.
- Store-type sales comparison.
- Average sales per store by type.
- Department-wise sales contribution.
- Monthly sales trends.
- Store size versus total sales.
- Sales distribution.
- Markdown versus non-markdown sales.
- Correlation analysis.

## 6. Key Business Findings

The following findings are based on the actual analysis performed on the dataset.

### 6.1 Store Type Performance

| Store Type | Total Sales | Average Sales per Record |
|---|---:|---:|
| A | 4,331,014,722.75 | 20,099.57 |
| B | 2,000,700,736.82 | 12,237.08 |
| C | 405,503,527.54 | 9,519.53 |

**Insight:** Store Type A generated the highest total sales and average sales per store-department-week record.

### 6.2 Store Productivity Analysis

Calculated period sales per square foot using:

`Period Sales per Sq Ft = Total Sales / Store Size`

Top-performing stores:

| Store | Type | Period Sales per Sq Ft |
|---|---|---:|
| 43 | C | 2,205.58 |
| 10 | B | 2,146.97 |
| 42 | C | 2,004.68 |
| 37 | C | 1,859.25 |
| 23 | B | 1,735.31 |

**Insight:** Store 43 recorded the highest period sales per square foot, demonstrating that store size alone does not determine sales productivity.

### 6.3 Department Performance

Top five departments by total sales:

| Department | Total Sales |
|---|---:|
| 92 | 483,943,341.87 |
| 95 | 449,320,162.52 |
| 38 | 393,118,136.92 |
| 72 | 305,725,152.21 |
| 90 | 291,068,463.68 |

**Insight:** Departments 92, 95 and 38 were the three largest contributors to total sales.

### 6.4 ABC Analysis

Categorized 79 departments based on cumulative sales contribution.

| Category | Number of Departments | Sales Contribution |
|---|---:|---:|
| A | 28 | 79.33% |
| B | 21 | 15.53% |
| C | 30 | 5.14% |

**Insight:** Category A contained 28 departments contributing approximately 79.33% of total sales. These departments can receive higher priority for inventory planning and performance monitoring.

### 6.5 Holiday vs Non-Holiday Performance

| Sales Period | Average Sales per Record |
|---|---:|
| Non-Holiday | 15,901.45 |
| Holiday | 17,035.82 |

**Insight:** Average sales per record were approximately 7.13% higher during holiday weeks.

This indicates an association between holiday periods and higher average sales, not proof that holidays alone caused the increase.

### 6.6 Weekly Sales Trends

The analysis identified significant sales increases around major holiday periods.

| Date | Week-over-Week Change |
|---|---:|
| 26 Nov 2010 | +45.86% |
| 24 Dec 2010 | +30.91% |
| 31 Dec 2010 | -50.04% |
| 25 Nov 2011 | +43.40% |
| 23 Dec 2011 | +28.15% |
| 30 Dec 2011 | -40.20% |

**Insight:** Sales showed noticeable seasonal spikes around Thanksgiving and Christmas, followed by sharp declines in subsequent weeks.

### 6.7 Markdown Analysis

| Markdown Status | Records | Average Sales per Record |
|---|---:|---:|
| With Markdown | 151,432 | 16,177.02 |
| Without Markdown | 270,138 | 15,871.52 |

**Insight:** Records with markdown information showed approximately 1.92% higher average sales.

This is an observed association and does not establish a causal relationship between markdowns and sales.

### 6.8 Store Size and Sales Relationship

The correlation between store size and total sales across stores was approximately **0.846**.

**Insight:** There is a strong positive relationship between store size and total sales. However, correlation does not establish causation.

## 7. Business Recommendations

Based on the findings:

1. **Prioritize high-contributing departments:** Focus inventory availability and performance monitoring on Category A departments.
2. **Monitor store productivity:** Compare sales relative to store size instead of relying only on total sales.
3. **Prepare for seasonal demand:** Plan inventory and staffing ahead of major holiday periods.
4. **Evaluate promotional effectiveness:** Investigate markdown performance further using comparable stores, departments and time periods.
5. **Monitor lower-performing categories:** Review Category C departments for possible assortment and inventory optimization.

These are analytical recommendations based on observed patterns, not tested business interventions.

## 8. Project Limitations

- The sales dataset covers February 2010 to October 2012.
- The analysis is based on historical data and does not establish future performance.
- Department names are not provided, so departments are identified by numerical IDs.
- Negative sales records were retained because their meaning was not confirmed by the dataset documentation.
- Missing markdown values were treated as zero; this is an assumption.
- Holiday and markdown comparisons show associations, not causal effects.
- The analysis does not include detailed costs, profit margins or inventory quantities.

## 9. Repository Structure

```text
Store-Productivity-Analysis/
│
├── data/
│   ├── raw/
│   └── cleaned/
│
├── notebooks/
│   └── 01_data_understanding.ipynb
│
├── sql/
│   ├── sql1.sql
│   ├── sql2.sql
│   ├── sql3.sql
│   └── business_analysis.sql
│
├── visualizations/
│   ├── weekly_sales_trend.png
│   ├── holiday_vs_nonholiday.png
│   ├── store_type_sales.png
│   ├── average_store_sales_by_type.png
│   ├── top_10_departments.png
│   ├── monthly_sales_trend.png
│   ├── store_size_vs_sales.png
│   ├── sales_distribution.png
│   ├── markdown_vs_sales.png
│   └── correlation_heatmap.png
│
├── reports/
├── powerbi/
├── .gitignore
└── Readme.md
```

## 10. How to Run the Project

### Step 1: Clone the Repository

```bash
git clone https://github.com/yashkapoor279/store-productivity-category-performance-analysis.git
```

### Step 2: Navigate to the Project Folder

```bash
cd store-productivity-category-performance-analysis
```

### Step 3: Create a Virtual Environment

```bash
python -m venv .venv
```

Activate it on Windows PowerShell:

```powershell
.\.venv\Scripts\Activate.ps1
```

### Step 4: Install Required Libraries

```bash
pip install pandas numpy matplotlib seaborn jupyter ipykernel
```

### Step 5: Download the Dataset

Download the three CSV files from the Kaggle competition and place them inside `data/raw/`.

### Step 6: Run the Notebook

```bash
jupyter notebook
```

Open `notebooks/01_data_understanding.ipynb` and execute the cells sequentially.

### Step 7: MySQL Analysis

Import the cleaned datasets into MySQL, create the required tables and view, and execute the SQL analysis scripts.

## 11. Author

**Yash Kapoor**

B.Tech – Computer Science and Engineering

GitHub: [yashkapoor279](https://github.com/yashkapoor279)

**Project Focus:** Data Analytics | SQL | Python | Business Intelligence

---

*Developed as a practical data analytics project to demonstrate data cleaning, SQL querying, exploratory data analysis, visualization and business insight generation.*
