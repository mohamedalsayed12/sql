SELECT country, title
FROM [IMDB analysis]..netflix_titles
WHERE country IS NOT NULL
ORDER BY country ASC;


--which country has the most tv shows
select TRIM(value) as country, count(*) as 'tv_shows'
FROM [IMDB analysis]..netflix_titles
CROSS APPLY STRING_SPLIT(country, ',')
where type='TV Show' and country is not null
group by TRIM(value)
order by tv_shows desc



--which country has the most movies
select TRIM(value) as country, count(*) as 'movie_count'
FROM [IMDB analysis]..netflix_titles
CROSS APPLY STRING_SPLIT(country, ',')
where type='movie' and country is not null
group by TRIM(value)
order by movie_count desc


--has netflix been leaning towards movies or series in recent times (since 2014)
SELECT type, COUNT(*) AS total_titles
FROM [IMDB analysis]..netflix_titles
WHERE TRY_CONVERT(date, date_added) >= '2014-01-01'
GROUP BY type
ORDER BY total_titles DESC;


--since 2020
SELECT type, COUNT(*) AS total_titles
FROM [IMDB analysis]..netflix_titles
WHERE TRY_CONVERT(date, date_added) >= '2020-01-01'
GROUP BY type
ORDER BY total_titles DESC;



--how many series and movies are released from the United States
SELECT type, COUNT(*) AS total_titles
FROM [IMDB analysis]..netflix_titles
WHERE TRY_CONVERT(date, date_added) >= '2014-01-01' and country LIKE '%United States%'
GROUP BY type
ORDER BY total_titles DESC;


--United Kingdom
SELECT type, COUNT(*) AS total_titles
FROM [IMDB analysis]..netflix_titles
WHERE TRY_CONVERT(date, date_added) >= '2014-01-01' and country LIKE '%United Kingdom%'
GROUP BY type
ORDER BY total_titles DESC;

--UK has more tv shows on netflix than movies even though in general there are a lot more movies than tv shows why is that?
--it is due to the culture hollywood in the U.S. has a more movie heavy culture while the UK has always had a tv and show heavy culture and also
--has to do with the licensing rights of both due to netflix being in the U.S. it makes it easier for it to access the right to U.S. movies while the UK
--has companies such as the bbc and itv who dominate in that field there


--thinking about adding imdb ratings and viewership because thats where the valuable info will be, Whatever was before this is descriptive

--I want to prove that ratings don't tell the full story and that the amount of votes matter
--top 10 rated movies/shows
SELECT TOP 10 title, rating
FROM [IMDB analysis]..imdb_ratings
ORDER BY rating desc;



--top 10 with the most votes
SELECT TOP 10 title, votes
FROM [IMDB analysis]..imdb_ratings
ORDER BY TRY_CAST(REPLACE(votes, ',', '') AS INT) DESC;
--none of the top 10 are in the top 10 of highest vote

SELECT DISTINCT n.title, n.release_year, n.type, i.Rating, i.Votes
FROM [IMDB analysis]..netflix_titles n
JOIN [IMDB analysis]..imdb_ratings i
  ON LOWER(TRIM(n.title)) = LOWER(TRIM(i.title))
  AND n.release_year = TRY_CAST(
        SUBSTRING(i.year, PATINDEX('%[0-9]%', i.year), 4)
      AS SMALLINT)
ORDER BY i.Rating DESC;
--I joined the tables from netflix and imdb to compare the amount of votes and ratings from each movie/show
SELECT DISTINCT n.title, n.release_year, n.type, i.Rating,
       TRY_CAST(REPLACE(i.Votes, ',', '') AS INT) AS Votes
FROM [IMDB analysis]..netflix_titles n
JOIN [IMDB analysis]..imdb_ratings i
  ON LOWER(TRIM(n.title)) = LOWER(TRIM(i.title))
  AND n.release_year = TRY_CAST(
        SUBSTRING(i.year, PATINDEX('%[0-9]%', i.year), 4)
      AS SMALLINT)
      order by votes desc


  SELECT type, COUNT(*) AS cnt
FROM [IMDB analysis]..netflix_titles
GROUP BY type;

--which movies/series have the highest max weeks in the top 10 and what are their imdb ratings
SELECT awg.show_title,
       MAX(awg.cumulative_weeks_in_top_10) AS max_weeks_in_top10,
       AVG(i.Rating) AS avg_rating
FROM [IMDB analysis]..allweeksglobal awg
JOIN [IMDB analysis]..imdb_ratings i
  ON LOWER(TRIM(awg.show_title)) = LOWER(TRIM(i.title))
GROUP BY awg.show_title
ORDER BY max_weeks_in_top10 DESC;


-- ============================================================
-- CTE: Quadrant analysis, shows popular but average tv shows and underrated tv shows
WITH cleaned AS (
    SELECT title, Rating,
           TRY_CAST(REPLACE(Votes, ',', '') AS INT) AS Votes
    FROM [IMDB analysis]..imdb_ratings
),
avg_stats AS (
    SELECT AVG(Rating) AS avg_rating,
           AVG(Votes) AS avg_votes
    FROM cleaned
),
classified AS (
    SELECT c.title, c.Rating, c.Votes,
           CASE
               WHEN c.Rating >= a.avg_rating AND c.Votes >= a.avg_votes THEN 'Proven Hit'
               WHEN c.Rating >= a.avg_rating THEN 'Hidden Gem'
               WHEN c.Votes >= a.avg_votes THEN 'Popular but Mediocre'
               ELSE 'Low Priority'
           END AS quadrant
    FROM cleaned c
    CROSS JOIN avg_stats a
)
SELECT title, Rating, Votes, quadrant
FROM classified
ORDER BY quadrant, Rating DESC;

-- ============================================================
-- VIEW: English vs. Non-English viewership trend over time, to show international investment
USE [IMDB analysis];
GO

CREATE OR ALTER VIEW vw_language_trend AS
SELECT
    week,
    CASE
        WHEN category LIKE '%Non-English%' THEN 'Non-English'
        ELSE 'English'
    END AS language_group,
    SUM(weekly_hours_viewed) AS total_hours_viewed,
    SUM(weekly_views) AS total_views
FROM [IMDB analysis]..allweeksglobal
GROUP BY
    week,
    CASE
        WHEN category LIKE '%Non-English%' THEN 'Non-English'
        ELSE 'English'
    END;
GO
