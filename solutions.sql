-- NETFLIX PROJECT

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix(
	show_id	VARCHAR(6),
	type VARCHAR(10),
	title VARCHAR(150),
	director VARCHAR(250),
	casts VARCHAR(1000),
	country	VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(10),
	duration VARCHAR(15),
	listed_in VARCHAR(100),
	description VARCHAR(260)
);

select * from netflix;

select count(*) as Total_Content from netflix;

SELECT DISTINCT type from netflix;


-- 15 Business Problems & Solutions --

-- 1. Count the number of Movies vs TV Shows

SELECT 
type, count(*) as Total_Content
from netflix
GROUP BY type;



-- 2. Find the most common rating for movies and TV shows

SELECT
	type,
	rating
FROM
	(
	SELECT 
		type, 
		rating, 
		count(*),
		RANK() OVER(Partition by type order by count(*) desc) as ranking
	from netflix
	group by type,2
	)
where ranking=1
;


-- 3. List all movies released in a specific year (e.g., 2020)


select * from netflix
where
	type = 'Movie'
	AND
	release_year = 2020
;


-- 4. Find the top 5 countries with the most content on Netflix

select 
	UNNEST (string_to_array(country, ',')) as new_country,
	count(show_id) as total_content
from netflix
group by 1
order by 2 desc
limit 5;



-- 5. Identify the longest movie

select title, release_year, duration from netflix 
where
	type = 'Movie'
	AND
	duration = (SELECT  max(duration) from netflix);



-- 6. Find content added in the last 5 years


select * from netflix
WHERE
	TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';


-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select * from netflix
where director ilike '%Rajiv Chilaka%';



-- 8. List all TV shows with more than 5 seasons


select title, duration
from netflix
where
type = 'TV Show'
AND
split_part(duration, ' ',1)::numeric > 5
;



-- 9. Count the number of content items in each genre


select 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(show_id) as total_content
from netflix
group by 1
;


-- 10.Find each year and the average numbers of content release in India on netflix. 
-- return top 5 year with highest avg content release!

select
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
	COUNT(*) as yearly_content,
	ROUND(count(*) * 100.0 /(
	select count(*) from netflix where country = 'India'),2
	) as avg_content_per_year
from netflix
where country='India'
GROUP BY 1
order by 3 desc;



-- 11. List all movies that are documentaries


select * from netflix
where listed_in ILIKE '%documentaries%';


-- 12. Find all content without a director

select * from netflix
where director is null;

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select * from netflix
where 
	casts ilike '%Salman Khan%'
	and
	release_year > extract(year from current_date) - 10;


-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select 
UNNEST(string_to_array(casts, ',')) as actors,
count(*) as total_content
from netflix
where country ilike '%India'
group by 1
order by 2 desc
limit 10;


15.
-- Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.


SELECT
    CASE
        WHEN description ILIKE '%kill%' 
          OR description ILIKE '%violence%' THEN 'Bad'
        ELSE 'Good'
    END AS category,
    COUNT(*) AS total_count
FROM netflix
GROUP BY category
ORDER BY category;





















