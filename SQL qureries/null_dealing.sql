-- DEALING WITH NULL/BLANK VALUES

SELECT * FROM layoffs_staging2;

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';


SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';


SELECT t1.company, t1.industry,t2.company, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
WHERE (t1.industry IS NULL OR TRIM(t1.industry) = '')
AND t2.industry IS NOT NULL
AND TRIM(t2.industry) <> '';

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR TRIM(t1.industry) = '')
AND t2.industry IS NOT NULL
AND TRIM(t2.industry) <> '';


SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT Count(*) 
FROM layoffs_staging2;

-- Earlier there were 2339 rows
-- After deleting, now there are 1991 rows

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
