# 📊 SQL Data Cleaning Project — Layoffs Dataset

## 🧩 Problem Statement

* The raw layoffs dataset contained multiple data quality issues that could distort analysis:

  * **Duplicate records** due to repeated data entries.
  * **Missing / blank industry values** for companies appearing multiple times.
  * **Inconsistent text formatting** such as extra spaces, varied labels, and trailing punctuation.
* These issues could lead to inaccurate reporting, incorrect aggregations, and unreliable insights.

---

## 🎯 Objective

* Prepare a **clean, analysis-ready dataset** by:

  * Removing duplicate records.
  * Filling missing industry values logically.
  * Standardizing text fields across columns.
* Ensure data integrity without modifying the raw source table.

---

## 🛠️ Approach & Logic

### **1️⃣ Removing Duplicate Records**

* Created staging tables to protect raw data.
* Used **ROW_NUMBER() window function** to identify duplicates.
* Deleted rows where row number > 1 to keep only unique records.

---

### **2️⃣ Handling Missing Industry Values**

* Performed a **self-join** on the company column.
* Identified rows with NULL or blank industries.
* Updated them using valid industry values from other records of the same company.

---

### **3️⃣ Standardizing Data**

* Trimmed extra spaces in company names.
* Unified industry labels (e.g., Crypto variations → Crypto).
* Removed trailing punctuation from country names.

---

## 🧠 SQL Queries Used

### **Duplicate Removal**

```sql
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off,
percentage_laid_off, date, stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging;

DELETE FROM layoffs_staging2
WHERE row_num > 1;
```

---

### **Fix Missing Industry Values**

```sql
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR TRIM(t1.industry) = '')
AND t2.industry IS NOT NULL;
```

---

### **Standardizing Text Data**

```sql
UPDATE layoffs_staging2
SET company = TRIM(company);

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country);
```

---

## 🔍 How the Queries Work

* **ROW_NUMBER()** assigns unique sequence numbers to identical rows to detect duplicates.
* **Self JOIN** allows copying valid values within the same table.
* **TRIM() & LIKE** functions clean and standardize text fields.
* **DELETE & UPDATE** ensure permanent data correction in staging tables.

---

## ✅ Outcomes

* Removed all duplicate records.
* Filled missing industry values accurately.
* Standardized categorical text data.
* Produced a clean dataset ready for analysis and dashboards.

---

## 📌 Key Skills Demonstrated

* SQL Data Cleaning Techniques
* Window Functions (ROW_NUMBER)
* Self Joins for Data Imputation
* Handling NULL & Blank Values
* Text Standardization using SQL Functions
* ETL Staging Best Practices

---

## 🚀 Why This Matters

* Clean data ensures **accurate insights and reporting**.
* Prevents double counting and category fragmentation.
* Improves reliability of business intelligence dashboards.
* Reflects real-world data preparation — a core skill for data analysts.

---

⭐ *This project demonstrates an end-to-end SQL data cleaning workflow — from raw messy data to a fully analysis-ready dataset.*
