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
  Select * from layoffs;



-- REMOVING DUPLICATES



CREATE TABLE layoffs_staging

LIKE layoffs;



INSERT INTO layoffs_staging

SELECT * FROM layoffs;



SELECT * FROM layoffs_staging;



Select *,

ROW_NUMBER()Over(PARTITION BY company, location,industry,total_laid_off,percentage_laid_off,'date',stage, country,funds_raised_millions) as row_num

FROM layoffs_staging;





With duplicate_CTE as (

Select *,

ROW_NUMBER()Over(PARTITION BY company, location,industry,total_laid_off,percentage_laid_off,'date',stage, country,funds_raised_millions) as row_num

FROM layoffs_staging

)



Select * from duplicate_CTE

where row_num>1;



Select * from layoffs_staging

where company = "Cazoo";





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

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



INSERT INTO layoffs_staging2

Select *,

ROW_NUMBER()Over(PARTITION BY company, location,industry,total_laid_off,percentage_laid_off,'date',stage, country,funds_raised_millions) as row_num

FROM layoffs_staging;



Select * from layoffs_staging2;



Select * from layoffs_staging2

where row_num > 1;



DELETE from layoffs_staging2

where row_num > 1;



SET SQL_SAFE_UPDATES = 0;
</pre>

## 5. How the Query Works
CREATE TABLE ... LIKE: Copies the schema of the original table to ensure data types remain consistent.

ROW_NUMBER(): This Window Function scans the specified columns (PARTITION BY). If it finds multiple rows where all these values match, it assigns 1 to the first and 2, 3... to the repeats.

INSERT INTO ... SELECT: Transfers the data into a new table that includes a physical row_num column.

DELETE: Targets any row where row_num > 1, effectively keeping only the unique "first" occurrence of every record.
