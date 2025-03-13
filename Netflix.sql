--count the number of movies and tv shows
SELECT type,
count(*) as total_content
FROM netflix
GROUP BY type;


--find the most common rating for movies and tv shows
SELECT type,
rating,
total
FROM
(SELECT count(*) as total,
rating,
type,
 rank() over (partition by type order by count(*) desc) as rank
FROM netflix
GROUP BY type , rating) as ranked
WHERE rank = 1
GROUP BY type, rating, total;


--list all movies released in 2020
SELECT *
FROM netflix
WHERE type = 'Movie' AND release_year = 2020;


--find the top 5 countries with the most movies and tv shows
SELECT unnest(STRING_to_array(country,',')) as new_country,
count(show_id) as total_content
FROM netflix
GROUP BY new_country
ORDER BY total_content DESC
LIMIT 5;


--identify the longest movie

SELECT title,
split_part(duration,'m',1)::numeric as new_duration
FROM netflix
WHERE type = 'Movie' and duration IS NOT NULL
ORDER BY new_duration DESC


--find content added in the last 5 years
SELECT *
FROM netflix
WHERE to_date(date_added, 'Month DD, YYYY') >= current_date - interval '5 years';

--find all the movies and tv shows by the director 'Rajiv Chilaka'
SELECT *
FROM netflix
WHERE director like '%Rajiv Chilaka%';


--list all the movies and tv shows whith more than 5 seasons
SELECT *
FROM netflix
WHERE type = 'TV Show' AND duration like '%Season%' and split_part(duration,' ',1)::numeric > 5;


--count the number of content items in each genre
SELECT count(*) as total_content,
unnest(STRING_to_array(listed_in,',')) as genre
FROM netflix
GROUP BY genre
ORDER BY total_content DESC;

--  Find each year and the average numbers of content release by India on netflix. 
-- return top 5 year with highest avg content release !
SELECT release_year,
round(avg(total_content),1) as avg_content
FROM (SELECT release_year,
count(*) as total_content
FROM netflix
WHERE country like '%India%'
GROUP BY release_year
ORDER BY total_content DESC)
GROUP BY release_year
ORDER BY avg_content DESC
LIMIT 5;


-- List all movies that are documentaries
SELECT *
FROM netflix
WHERE type = 'Movie' AND listed_in like '%Documentaries%';


--Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT count(*) as total_movies
FROM netflix
WHERE casts like '%Salman Khan%' AND release_year >= extract(year from current_date) - 10;


--Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT unnest(STRING_to_array(casts,',')) as actor,
count(*) as total_movies
FROM netflix
WHERE country like '%India%'
GROUP BY actor
ORDER BY total_movies DESC
LIMIT 10;


/*Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.*/

SELECT 
    CASE 
        WHEN description LIKE '%Kill%' OR description LIKE '%Violence%' THEN 'Bad'
        ELSE 'Good'
    END AS category,
    COUNT(*) AS total_content
FROM 
    netflix
GROUP BY 
    category;