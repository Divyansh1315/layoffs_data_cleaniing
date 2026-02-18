## 1. Problem Statement
Raw datasets often contain redundant or duplicate records due to data entry errors or system glitches. In this layoffs dataset, multiple identical rows for the same company leading to distort analytical accuracy and inflated reporting.


## 2. Objective
The primary goal is to clean the dataset by identifying and removing duplicate records while maintaining data integrity through a staged environment.


## 3. Approach & Logic
- **Staging**: Create a duplicate table (layoffs_staging) to avoid modifying the raw source data directly.
- **Partitioning**: Use Window Functions to group identical columns and assign a unique row number to each occurrence.
- **Filtering**: Identify duplicates where the assigned row number is greater than 1.
- **Deletion**: Since MySQL does not allow direct DELETE on CTEs, create a second staging table (layoffs_staging2) with an explicit row_num column to facilitate permanent removal.


## 4. SQL Query Used
<pre>
-- 1. Created a staging table with an extra column for row numbers
-- This allowed me to physically store the row_num and delete based on it

  CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
);

-- 2. Inserted data while generating a unique row number for identical records
-- If all columns match, the second occurrence gets row_num = 2

  INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
    PARTITION BY company, 
                 location, 
                 industry, 
                 total_laid_off, 
                 percentage_laid_off, 
                 `date`, 
                 stage, 
                 country, 
                 funds_raised_millions
) AS row_num
FROM layoffs_staging;

-- 3. Identified and deleted the duplicate records
-- Kept only the rows where row_num is 1

DELETE FROM layoffs_staging2
WHERE row_num > 1;

-- 4. Verify the clean data
SELECT * FROM layoffs_staging2;
</pre>


## 5. How the Query Works
**CREATE TABLE ... LIKE:** Copies the schema of the original table to ensure data types remain consistent.

**ROW_NUMBER():** This Window Function scans the specified columns (PARTITION BY). If it finds multiple rows where all these values match, it assigns 1 to the first and 2, 3... to the repeats.

**INSERT INTO ... SELECT:** Transfers the data into a new table that includes a physical row_num column.

**DELETE:** Targets any row where row_num > 1, effectively keeping only the unique "first" occurrence of every record.


## 6. Outcomes
- **Data Integrity:** A clean, "golden" dataset (layoffs_staging2) with zero duplicate entries.
- **Accuracy:** Improved reliability for downstream metrics like "Total Laid Off by Industry."
- **Performance:** Reduced table size by removing redundant noise.


## 7. Key Skills Demonstrated
- **Data Architecture:** Designing multi-stage ETL (Extract, Transform, Load) workflows.
- **Advanced SQL:** Expertise in Window Functions `(OVER, PARTITION BY)` and Common Table Expressions `(CTEs)`.
- **DBA Best Practices:** Implementing staging tables to protect raw data and managing session variables `(SQL_SAFE_UPDATES)`.


## 8. Why This Matters
Data cleaning is 80% of a data analyst's job. Removing duplicates is a critical first step because if the data is wrong, the insights will be wrong. Ensuring a unique record for every layoff event prevents business leaders from making decisions based on "double-counted" numbers.
