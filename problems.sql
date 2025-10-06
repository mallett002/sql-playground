select * from directors;
select * from actors;
select * from movies;
select * from movie_revenues;
select * from movies_actors;

-- ### Basic SELECT and filtering
-- List all actors’ full names (first + last).
select concat(first_name, ' ',  last_name) from actors;
select concat_ws(' ', first_name, last_name) from actors; -- concat with separator

-- Find all movies released after the year 2000.
select * from movies where release_date > '12/31/2000';

-- List all actors born before 1975.
select * from actors where date_of_birth < '1975-01-01';

-- Show all movies sorted by release date, newest first.
select * from movies order by release_date desc;

-- ### Aggregations
-- Count the total number of movies.
select count(*) from movies;

-- Count how many actors are in the database.
select count(*) from movies;

-- Find the average domestic takings of all movies.
select round(AVG(domestic_takings), 2) from movie_revenues;

-- Find the total international takings for all movies.
select sum(international_takings) from movie_revenues;

-- Find the number of movies directed by each director. 
select 
	d.last_name,
	count(*) as total_movies
from movies m
join directors d on m.director_id = d.id
group by d.id, d.last_name;

-- (this one's better)
-- get directors first since we're getting total movies for directors
select 
	d.last_name,
	count(*) as total_movies
from directors d
join movies m on d.id = m.director_id
group by d.id, d.last_name;

-- ### Joins
-- List all movies along with the director’s full name.
select movie_name, concat_ws(' ', first_name, last_name) from movies m
join directors d on m.director_id = d.id;

-- List all actors in a specific movie (e.g., “Inception”).
SELECT 
	concat_ws(' ', first_name, last_name),
	movie_name
FROM actors a
JOIN movies_actors ma 
	ON a.id = ma.actor_id
JOIN movies m 
	ON ma.movie_id = m.id
WHERE movie_name = 'Inception';


-- List all movies an actor has starred in (choose any actor).
select movie_name
from movies m
join movies_actors ma
	on m.id = ma.movie_id
join actors a
	on a.id = ma.actor_id
where a.first_name = 'Leonardo'
and a.last_name = 'DiCaprio';
select * from actors;

-- List all movies along with their total revenue (domestic + international).
-- List all actors and the movies they appeared in.

/*
### Filtering with joins
Find all movies directed by “Christopher Nolan.”
Find all actors who starred in movies with a PG-13 rating.
Find all movies where domestic takings exceeded 300 million.
Find all directors who have directed more than one movie.
List movies where at least one actor’s first name is “Leonardo.”

### Subqueries and advanced queries
Find actors who appeared in movies directed by “Quentin Tarantino.”
Find the movie with the highest total revenue.
List all directors whose movies have collectively earned more than 500 million domestically.
List actors who have appeared in more than one movie.
For each movie, show a comma-separated list of actors in it.

### Optional / creative challenges
Find movies where the director and an actor share the same last name.
List movies that have no revenue records.
Find all actors born in the 1960s who appeared in movies released after 2000.
Show the average revenue per director.
List all movies along with the number of actors in each.

*/
