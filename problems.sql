select * from directors;
select * from actors;
select * from movies;
select * from movie_revenues;
select * from movies_actors;

-- ### Basic SELECT and filtering
-- List all actors’ full names (first + last).
-- Find all movies released after the year 2000.
-- List all actors born before 1975.
-- Show all movies sorted by release date, newest first.

-- ### Aggregations
-- Count the total number of movies.
-- Count how many actors are in the database.
-- Find the average domestic takings of all movies.
-- Find the total international takings for all movies.
-- Find the number of movies directed by each director. 
-- (this one's better)
-- get directors first since we're getting total movies for directors

-- ### Joins
-- List all movies along with the director’s full name.
-- List all actors in a specific movie (e.g., “Inception”).
-- List all movies an actor has starred in (choose any actor).
-- List all movies along with their total revenue (domestic + international).
-- List all actors and the movies they appeared in.
-- Find actors who appeared in movies directed by “Quentin Tarantino.”

-- ### Filtering with joins
-- Find all movies directed by “Christopher Nolan.”
-- Find all actors who starred in movies with a PG-13 rating.
-- Find all movies where domestic takings exceeded 300 million.
-- Find all directors who have directed more than one movie.
-- List movies where at least one actor’s first name is “Leonardo.”

-- ### Subqueries and advanced queries
-- Find actors who appeared in movies directed by “Quentin Tarantino.”
-- Find the movie with the highest total revenue.
-- List all directors whose movies have collectively earned more than 500 million domestically & internationally.
-- List actors who have appeared in more than one movie.
-- For each movie, show a comma-separated list of actors in it.

-- ### Optional / creative challenges
-- Find movies where the director and an actor share the same last name.
-- List movies that have no revenue records.
-- Find all actors born in the 1960s who appeared in movies released after 2000.
-- Show the average revenue per director.
-- List all movies along with the number of actors in each.

