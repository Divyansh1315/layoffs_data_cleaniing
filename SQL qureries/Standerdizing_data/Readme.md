## 1. Problem Statement

Raw layoff dataset contained inconsistent text values.
Issues included:
- Extra spaces in company names
- Multiple variations of the same industry (e.g., Crypto, CryptoCurrency)
- Country names with trailing punctuation

## 2. Objective
- Clean and standardize categorical text fields.
- Ensure consistent values for accurate analysis and reporting.

## 3. Approach & Logic
- Identified inconsistencies using exploratory queries.
- Applied trimming functions to remove unwanted spaces and characters.
- Standardized categorical labels using pattern matching.
- Updated records directly in the staging table.

## 4. SQL Query Used
<pre>
SELECT * FROM layoffs_staging2;

-- Trim company names
UPDATE layoffs_staging2
SET company = TRIM(company);

-- Standardize industry names
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Remove trailing dot from country names
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States.';
</pre>

## 5. How the Query Works
- `TRIM()` removes leading/trailing spaces.
- `LIKE 'Crypto%'` identifies all variations starting with “Crypto”.
- `TRIM(TRAILING '.')` removes unwanted punctuation.
- `UPDATE` modifies records directly in the dataset.

## 6. Outcomes
Eliminated inconsistent text formatting.
Unified industry naming conventions.
Standardized country values.
Improved data quality for analysis.

## 7. Key Skills Demonstrated
- Data Cleaning in SQL
- Data Standardization Techniques
- Pattern Matching using LIKE
- Text Functions (TRIM)
- Data Quality Improvement

## 8. Why This Matters
- Clean data ensures accurate insights.
- Prevents duplicate categories in dashboards.
- Improves reliability of business reporting.\
- Essential step before any analysis or visualization.
