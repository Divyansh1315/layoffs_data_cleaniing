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
