-- Top 10 Rows
Select top 10 * from Netflix

-- Create a new table for age ratings
SELECT DISTINCT category, show_id
INTO Dim_Categories
FROM netflix


-- Create a new table containing country names, in addition to splitting rows containing multiple countries into multiple rows
SELECT show_id, TRIM(value) AS CountryName
INTO Dim_Countries
FROM netflix
CROSS APPLY STRING_SPLIT(country, ',')
WHERE country IS NOT NULL 
  AND TRIM(value) <> ''; -- This condition prevents empty spaces from becoming rows.

-- Create a table of genres (Movie, TV Show)
SELECT distinct type, show_id
INTO Dim_Type
From Netflix

-- Create a table containing directors' names, in addition to splitting rows containing multiple directors
SELECT show_id, TRIM(value) AS DirectorName
INTO Dim_Directors
FROM netflix
CROSS APPLY STRING_SPLIT(director, ',')
WHERE director IS NOT NULL and director <> 'Not Specified';

-- Create a table containing actors' names, in addition to splitting rows containing multiple actors
SELECT show_id, TRIM(value) AS ActorName
INTO Dim_Actors
FROM netflix
CROSS APPLY STRING_SPLIT(cast, ',')
WHERE cast IS NOT NULL and cast <> 'Not Specified';

-- Create a table containing show genres (Comedy, Drama, Action, etc.), in addition to splitting rows containing multiple genres.
SELECT show_id, TRIM(value) AS MovieClassification
INTO Dim_MovieClassification
FROM netflix
CROSS APPLY STRING_SPLIT(listed_in, ',')
WHERE listed_in IS NOT NULL and listed_in <> 'Not Specified';

-- Create two columns for the duration of the movie or TV show.
-- ALTER TABLE netflix ADD movie_min INT, tv_seasons INT;
-- UPDATE netflix SET movie_min = duration_value WHERE type = 'Movie';
-- UPDATE netflix SET tv_seasons = duration_value WHERE type = 'TV Show';

-- Discover the top 10 most popular categories in the Netflix library
select top 10 MovieClassification, count(*) as Total_Content
from Dim_MovieClassification
group by MovieClassification
order by Total_Content
Desc

-- Track the evolution of content additions on Netflix over the years
select added_year, type, count(*) as Total_Content
from dbo.netflix
group by type, added_year
order by added_year
Desc

-- The 10 movies that took the longest to reach Netflix
select top 10 title, release_year, added_year, diff_of_year
from dbo.netflix
where type = 'Movie'
order by diff_of_year Desc

-- Average film length in minutes & TV Show in seasons
select avg(movie_min) Avg_Movie_Min, avg(tv_seasons) as Avg_TV_Season
from dbo.netflix


-- Countries that produce the most films vs TV Show
select top 10 CountryName, type, count(*) as Total_Content
from dbo.netflix n join Dim_Countries DC on n.show_id = DC.show_id
group by type, CountryName
order by Total_Content Desc

-- The film schedule is combined with country and genre classifications to provide a detailed list of film frequency for each country and genre it belongs to.
select n.show_id, CountryName, MovieClassification
from dbo.netflix n join Dim_Countries DC on n.show_id = DC.show_id
join Dim_MovieClassification MC on DC.show_id = MC.show_id
group by CountryName, n.show_id,  MovieClassification


-- Creating a view to prepare data for export
CREATE VIEW VW_Netflix AS
SELECT 
    n.show_id, 
    n.type,
    n.title,
    n.release_year,
    n.added_year,
    n.duration_value,
    n.movie_min,
    n.tv_seasons,
    DC.CountryName, 
    MC.MovieClassification
FROM dbo.netflix n 
INNER JOIN Dim_Countries DC ON n.show_id = DC.show_id
INNER JOIN Dim_MovieClassification MC ON n.show_id = MC.show_id
WHERE DC.CountryName <> '' 
  AND DC.CountryName IS NOT NULL
  AND MC.MovieClassification <> ''
  AND MC.MovieClassification IS NOT NULL;

select * from VW_Netflix