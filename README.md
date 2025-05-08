# 💼 Layoff Trends Analysis (2020–2023)

## 📊 Overview

This project analyzes layoff trends across industries, countries, and funding stages from 2020 to 2023. The dataset was cleaned, transformed, and explored using SQL to uncover which companies and industries were most impacted. The goal is to provide insight into economic stress points, particularly in tech and startup ecosystems.

---

## 🛠️ Tools & Technologies

- **SQL (MySQL)** – Data cleaning, transformation, and aggregation
- **Layoff Data** – Sourced from public layoff databases (e.g., Layoffs.fyi)
- **Window Functions, CTEs, and String Manipulation** – For advanced querying

---

## 🧼 Data Cleaning Steps

- Removed duplicates using `ROW_NUMBER()` and `DELETE`
- Trimmed whitespace and standardized fields like `industry`, `company`, and `country`
- Fixed inconsistent formats in `date` and converted to proper `DATE` type
- Replaced blank industries via self-joins
- Dropped unnecessary columns (like `row_num`) and removed rows with no layoff data

---

## 🔍 Key Analysis & Insights

### 🔹 Total Layoffs by Company
- ✅ *Insight:* Companies like **Meta**, **Amazon**, and **Google** had the highest total layoffs during the period.

### 🔹 Industry Impact
- ✅ *Insight:* **Tech**, **Retail**, and **Crypto** were among the hardest-hit industries.

### 🔹 Yearly Trends (2020–2023)
- ✅ *Insight:* Layoffs peaked in **2022**, with over 150,000 job losses recorded across the dataset.

### 🔹 Country-wise Distribution
- ✅ *Insight:* The **United States** dominated layoff numbers, followed by **India** and **Canada**.

### 🔹 Stage of Company at Time of Layoff
- ✅ *Insight:* Startups in **post-IPO** and **late-stage** funding rounds saw disproportionately high layoffs.

### 🔹 Rolling Monthly Totals
- Used CTEs and `SUM() OVER` to show cumulative layoffs month-over-month.
- ✅ *Insight:* There was a sustained rise in layoffs starting mid-2022.

---
