# 📊Fixing Missing Industry Values Using SQL

## 🧩 Problem Statement

In the `layoffs_staging2` table, the same company appears multiple times with inconsistent or missing `industry` values.

### Issue

<img width="947" height="92" alt="image" src="https://github.com/user-attachments/assets/4f831454-8606-462c-8cf7-db15a5c2500e" />


For the company **Airbnb**:
- One record has `industry = 'Travel'`
- Another record has `industry = NULL`

This creates data inconsistency, which can lead to incorrect analysis and reporting.

---

## 🎯 Objective

To populate missing or blank `industry` values by leveraging existing valid industry information from other rows belonging to the same company.

---

## 🛠️ Approach & Logic

- Perform a **self JOIN** on the table using the `company` column.
- Identify rows where:
  - `industry` is `NULL` or empty.
- Update those rows using:
  - A non-null, non-empty industry value from another row of the same company.

### This ensures:
- Data consistency  
- No hardcoding  
- Scalable logic for large datasets  

---

## 🧠 SQL Query Used

```sql
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
  ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR TRIM(t1.industry) = '')
  AND t2.industry IS NOT NULL
  AND TRIM(t2.industry) <> '';
```

## 🔍 How the Query Works

### 1. Self JOIN (`t1` & `t2`)
- Matches rows from the same table based on the `company` column.

### 2. Target Rows (`t1`)
- Rows where `industry` is missing (`NULL` or empty).

### 3. Source Rows (`t2`)
- Rows where `industry` has a valid value.

### 4. Update Action
- Copies the valid `industry` value from `t2` into the missing value in `t1`.

---

## ✅ Outcome

<img width="1086" height="75" alt="image" src="https://github.com/user-attachments/assets/0f71fd87-9189-4582-a50e-9bbbff7d71da" />

- Missing `industry` values are successfully filled.
- Data becomes consistent across records for the same company.
- Dataset is now analysis-ready for downstream reporting and visualization.

---

## 📌 Key Skills Demonstrated

- SQL Data Cleaning  
- Self JOINs  
- Handling `NULL` and empty values  
- Writing safe and scalable `UPDATE` queries  
- Data quality improvement  

---

## 🚀 Why This Matters

Accurate categorical data like `industry` is critical for:
- Trend analysis  
- Sector-wise layoffs reporting  
- Business intelligence dashboards  

This task demonstrates real-world data cleaning logic commonly used in analytics projects.


