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



-- Find actors who appeared in movies directed by “Quentin Tarantino.”
select 
	concat_ws(' ', first_name, last_name),
	m.movie_name
from actors a
join movies_actors ma
	on a.id = ma.actor_id
join movies m
	on m.id = ma.movie_id
where m.director_id = (
	select id from directors where first_name = 'Quentin' and last_name = 'Tarantino'
)


-- ### Filtering with joins

-- Find all movies directed by “Christopher Nolan.”
select * from movies m
join directors d 
	on m.director_id = d.id
where d.first_name = 'Christopher' and d.last_name = 'Nolan';

-- Find all actors who starred in movies with a PG-13 rating.
select * from actors a
join movies_actors ma
	on a.id = ma.actor_id
join movies m on ma.movie_id = m.id
where age_certificate = 'PG-13';

-- Find all movies where domestic takings exceeded 300 million.
select * from movies m
join movie_revenues mr on m.id = mr.movie_id
where mr.domestic_takings > 300000000.00;


-- Find all directors who have directed more than one movie.
SELECT 
	concat_ws(' ', d.first_name, d.last_name) as director_name,
	count(m.id) as total_movies
FROM directors d
JOIN movies m ON d.id = m.director_id
GROUP BY director_name
HAVING count(m.id) > 1;

-- OR this
SELECT 
    d.id,
    concat_ws(' ', d.first_name, d.last_name) AS director_name,
    count(m.id) AS total_movies
FROM directors d
JOIN movies m ON d.id = m.director_id
-- safer to group by the id as well:
GROUP BY d.id, d.first_name, d.last_name
HAVING count(m.id) > 1;


-- List movies where at least one actor’s first name is “Leonardo.”
select distinct movie_name from movies m -- distinct in case there are 2 leonardos in a movie
join movies_actors ma on m.id = ma.movie_id
join actors a on ma.actor_id = a.id
where a.first_name = 'Leonardo'


-- ### Subqueries and advanced queries

-- Find actors who appeared in movies directed by “Quentin Tarantino.”
select 
	concat_ws(' ', first_name, last_name),
	m.movie_name
from actors a
join movies_actors ma
	on a.id = ma.actor_id
join movies m
	on m.id = ma.movie_id
where m.director_id = (
	select id from directors where first_name = 'Quentin' and last_name = 'Tarantino'
)


-- Find the movie with the highest total revenue.
with highest_rev as (
	select 
		movie_id,
		sum(domestic_takings) + sum(international_takings) as total_rev
	from movie_revenues
	group by movie_id
	order by total_rev desc
	-- limit 1
)
select 
	m.movie_name,
	hr.total_rev
from movies m
join highest_rev hr on m.id = hr.movie_id
WHERE hr.total_rev = (SELECT MAX(total_rev) FROM highest_rev); -- added this in case of ties. Was doing the limit 1 in cte


-- List all directors whose movies have collectively earned more than 500 million domestically & internationally.
-- get grouping of directors with total earnings:
with dir_earnings as (
	select 
		d.id,
		sum(mr.domestic_takings + mr.international_takings) as total_earnings
	from directors d
	join movies m on d.id = m.director_id
	join movie_revenues mr on m.id = mr.movie_id
	group by d.id
)
-- select the directors from that grouping where total_earnings > x
select 
	concat_ws(' ', d.first_name, d.last_name) as director_name,
	de.total_earnings
from directors d
join dir_earnings de
	on d.id = de.id
where de.total_earnings > 1000.00; -- 1000 here bc none have 500 mil in my data



-- List actors who have appeared in more than one movie.
select 
	concat_ws(' ', first_name, last_name) as actor,
	count(*) as movie_count
from actors a
join movies_actors ma
	on a.id = ma.actor_id
-- group by actor (technically not sql standard. should group by first_name, last_name)
group by first_name, last_name
having count(*) > 1;




-- For each movie, show a comma-separated list of actors in it.
select 
	m.movie_name,
	string_agg(concat_ws(' ', a.first_name, a.last_name), ', ') as actors
from movies m
join movies_actors ma
	on m.id = ma.movie_id
join actors a 
	on ma.actor_id = a.id
group by m.movie_name;

-- ### Optional / creative challenges
-- Find movies where the director and an actor share the same last name.
-- List movies that have no revenue records.
-- Find all actors born in the 1960s who appeared in movies released after 2000.
-- Show the average revenue per director.
-- List all movies along with the number of actors in each.
