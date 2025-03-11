
Select * 
from layoffs;

-- 1. Remove Duplicates
-- 2. Standardize data
-- 3. Null data or blank values
-- 4. Remove Any Columns



Create Table layoffs_staging
Like layoffs;

Insert layoffs_staging
Select * 
from layoffs;

Select * from layoffs_staging;

Select *,
ROW_NUMBER() OVER
(PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) as row_num
from layoffs_staging;

With duplicate_cte as
(
Select *,
ROW_NUMBER() OVER
(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
Select * 
from duplicate_cte
where row_num > 1;

Select * 
from layoffs_staging
where company = 'Casper'; 


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
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

Select * 
from layoffs_staging2;


INSERT INTO layoffs_staging2 
Select *,
ROW_NUMBER() OVER
(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging;


Delete
from layoffs_staging2
where row_num > 1;

Select * 
from layoffs_staging2;

-- Standardizing Data
-- Remove trailing and leading spaces

Select company, Trim(company)
from layoffs_staging2;

Update layoffs_staging2
set company = TRIM(company);

-- Redundant data
-- group them e.g. crypto, cryptocurrency to Crypto
Select distinct industry
from layoffs_staging2;

Update layoffs_staging2
Set industry = 'Crypto'
where industry like 'Crypto%';

Select distinct location
from layoffs_staging2
order by 1
;

-- Removing any characters 
-- from country that might group the countries into two categories

Select *
from layoffs_staging2
where country like 'United States%'
order by 1
;

Select distinct country, trim(trailing '.' from country)
from layoffs_staging2
order by 1
;

Update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'United States%';

-- Formatting date as datetime instead of text

Select `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
from layoffs_staging2;


Update layoffs_staging2
set `date` = STR_TO_DATE(`date`, '%m/%d/%Y');


Select `date`
from layoffs_staging2;

Alter table layoffs_staging2
modify column `date` DATE;

Select * from layoffs_staging2;

-- NULL/ Blank handling

Select * from layoffs_staging2
where total_laid_off IS NULL
AND percentage_laid_off IS NULL;

Select *
from layoffs_staging2
where industry IS NULL 
or industry = '';

Select * 
from layoffs_staging2
where company = 'Airbnb';

Select * 
from layoffs_staging2
where company = 'Carvana';

Select * 
from layoffs_staging2
where company = 'Juul';

Select * 
from layoffs_staging2 st1 
join layoffs_staging2 st2
	on st1.company = st2.company
	and st1.location = st2.location
where (st1.industry IS NULL or st1.industry = '') 
and st2.industry IS NOT NULL;

Select st1.industry, st2.industry
from layoffs_staging2 st1 
join layoffs_staging2 st2
	on st1.company = st2.company
	and st1.location = st2.location
where (st1.industry IS NULL or st1.industry = '') 
and st2.industry IS NOT NULL;

Update layoffs_staging2
Set industry = NULL
where industry = '';

Update layoffs_staging2 st1 
join layoffs_staging2 st2
	on st1.company = st2.company
Set st1.industry = st2.industry
where (st1.industry IS NULL) 
and st2.industry IS NOT NULL;

Select * 
from layoffs_staging2
where industry IS NULL;

Select * 
from layoffs_staging2
where company like 'Bally%';

Select * 
from layoffs_staging2
where total_laid_off IS NULL
and percentage_laid_off IS NULL;

Delete 
from layoffs_staging2
where total_laid_off IS NULL
and percentage_laid_off IS NULL;

Select * 
from layoffs_staging2;

Alter table layoffs_staging2
drop column row_num;



-- Exploratory Data Analysis

Select * from layoffs_staging2;


Select MAX(total_laid_off), Max(percentage_laid_off)
from layoffs_staging2;

-- Companies that completely went under
Select * 
from layoffs_staging2
where percentage_laid_off = 1;


Select * 
from layoffs_staging2
where percentage_laid_off = 1
ORDER BY total_laid_off desc;

Select * 
from layoffs_staging2
where percentage_laid_off = 1
ORDER BY funds_raised_millions desc;

-- layoffs by the companies affected most to least

Select company, SUM(total_laid_off) as company_total_laid_off
from layoffs_staging2
group by company 
order by 2 desc;

-- From all start to end years

Select MIN(date), MAX(date)
from layoffs_staging2;

-- Layoffs by industries most affected

Select industry, SUM(total_laid_off) as industry_total_laid_off
from layoffs_staging2
group by industry 
order by 2 desc;


Select *
from layoffs_staging2;

-- Layoffs by country

Select country, SUM(total_laid_off) as country_total_laid_off
from layoffs_staging2
group by country
order by 2 desc; 


-- Layoffs year by year from 2020-2023

Select YEAR(`date`), SUM(total_laid_off) as yearly_total_laid_off
from layoffs_staging2
group by YEAR(`date`)
order by 1 desc; 


-- Stagewise layoffs
Select stage, SUM(total_laid_off) as stagewise_total_laid_off
from layoffs_staging2
group by stage
order by 2 desc; 


-- Rolling total by month

Select SUBSTRING(`date`,1,7) as `MONTH`, 
SUM(total_laid_off) 
from layoffs_staging2
where SUBSTRING(`date`,1,7) IS NOT NULL
group by `MONTH`
order by 1 asc;

With Rolling_Total AS
(
Select SUBSTRING(`date`,1,7) as `MONTH`, 
SUM(total_laid_off) as total_off
from layoffs_staging2
where SUBSTRING(`date`,1,7) IS NOT NULL
group by `MONTH`
order by 1 asc
)
Select `MONTH`, total_off,
SUM(total_off) over(order by `MONTH`) as rolling_total
from Rolling_Total
;

-- 

Select company, SUM(total_laid_off) as company_total_laid_off
from layoffs_staging2
group by company 
order by 2 desc;


Select company, Year(`date`), SUM(total_laid_off)
From layoffs_staging2
Group by company, Year(`date`)
order by 3 desc;

With Company_Year(company, years, total_laid_off) AS
(
Select company, Year(`date`), SUM(total_laid_off)
From layoffs_staging2
Group by company, Year(`date`)
), Company_Year_Rank AS
(Select *, 
dense_rank() OVER (Partition by years order by total_laid_off desc) as Ranking
from Company_Year
where years is not null
)
Select * 
from Company_Year_Rank
where Ranking <= 5;





