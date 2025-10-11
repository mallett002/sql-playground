-- create the main database (only if it doesn't already exist)
do
$$
begin
    if not exists (select from pg_database where datname = 'moviedb') then
        create database moviedb owner movie;
    end if;
end
$$;

-- enable useful extensions
create extension if not exists pgcrypto;

-- create sample tables (in the default 'public' schema)
create table directors (
    id uuid default gen_random_uuid() primary key,
    first_name varchar(30),
    last_name varchar(30) not null,
    date_of_birth date,
    nationality varchar(20)
);

create table actors (
    id uuid default gen_random_uuid() primary key,
    first_name varchar(30),
    last_name varchar(30),
    gender char(1),
    date_of_birth timestamptz
);

create table movies (
    id uuid default gen_random_uuid() primary key,
    movie_name varchar(50) not null,
    movie_length int,
    movie_lang varchar(20),
    release_date date,
    age_certificate varchar(5),
    director_id uuid references directors (id)
);

create table movie_revenues (
    id uuid default gen_random_uuid() primary key,
    movie_id uuid references movies (id),
    domestic_takings numeric(10,2),
    international_takings numeric(10,2)
);

create table movies_actors (
    movie_id uuid references movies (id),
    actor_id uuid references actors (id),
    primary key (movie_id, actor_id)
);

create table critics (
    id uuid default gen_random_uuid() primary key,
    first text,
    last text
);

create table movie_reviews (
    id uuid default gen_random_uuid() primary key,
    movie_id uuid references movies (id),
    user_id uuid references critics (id),
    stars int check (stars > 0 and stars < 6),
    review text
);

-- Seeding data ------------------------------------------------------------------
-- Directors
INSERT INTO directors (first_name, last_name, date_of_birth, nationality)
VALUES
  ('Christopher', 'Nolan', '1970-07-30', 'British-American'),
  ('Steven', 'Spielberg', '1946-12-18', 'American'),
  ('Quentin', 'Tarantino', '1963-03-27', 'American'),
  ('James', 'Cameron', '1954-08-16', 'Canadian'),
  ('Martin', 'Scorsese', '1942-11-17', 'American'),
  ('Ridley', 'Scott', '1937-11-30', 'British'),
  ('Peter', 'Jackson', '1961-10-31', 'New Zealander'),
  ('Denis', 'Villeneuve', '1967-10-03', 'Canadian'),
  ('Greta', 'Gerwig', '1983-08-04', 'American'),
  ('Patty', 'Jenkins', '1971-07-24', 'American');

-- Actors
INSERT INTO actors (first_name, last_name, gender, date_of_birth)
VALUES
  ('Leonardo', 'DiCaprio', 'M', '1974-11-11'),
  ('Brad', 'Pitt', 'M', '1963-12-18'),
  ('Uma', 'Thurman', 'F', '1970-04-29'),
  ('Tom', 'Hanks', 'M', '1956-07-09'),
  ('Natalie', 'Portman', 'F', '1981-06-09'),
  ('Morgan', 'Freeman', 'M', '1937-06-01'),
  ('Matt', 'Damon', 'M', '1970-10-08'),
  ('Cate', 'Blanchett', 'F', '1969-05-14'),
  ('Denzel', 'Washington', 'M', '1954-12-28'),
  ('Anne', 'Hathaway', 'F', '1982-11-12'),
  ('Samuel', 'Jackson', 'M', '1948-12-21'),
  ('Ryan', 'Gosling', 'M', '1980-11-12'),
  ('Emma', 'Stone', 'F', '1988-11-06'),
  ('Christian', 'Bale', 'M', '1974-01-30'),
  ('Scarlett', 'Johansson', 'F', '1984-11-22'),
  ('Timothée', 'Chalamet', 'M', '1995-12-27'),
  ('Rebecca', 'Ferguson', 'F', '1983-10-19');

-- Movies
INSERT INTO movies (movie_name, movie_length, movie_lang, release_date, age_certificate, director_id)
VALUES
  ('Inception', 148, 'English', '2010-07-16', 'PG-13', (SELECT id FROM directors WHERE last_name='Nolan')),
  ('Interstellar', 169, 'English', '2014-11-07', 'PG-13', (SELECT id FROM directors WHERE last_name='Nolan')),
  ('Jurassic Park', 127, 'English', '1993-06-11', 'PG-13', (SELECT id FROM directors WHERE last_name='Spielberg')),
  ('Pulp Fiction', 154, 'English', '1994-10-14', 'R', (SELECT id FROM directors WHERE last_name='Tarantino')),
  ('Titanic', 195, 'English', '1997-12-19', 'PG-13', (SELECT id FROM directors WHERE last_name='Cameron')),
  ('The Wolf of Wall Street', 180, 'English', '2013-12-25', 'R', (SELECT id FROM directors WHERE last_name='Scorsese')),
  ('The Martian', 144, 'English', '2015-10-02', 'PG-13', (SELECT id FROM directors WHERE last_name='Scott')),
  ('The Lord of the Rings: The Fellowship of the Ring', 178, 'English', '2001-12-19', 'PG-13', (SELECT id FROM directors WHERE last_name='Jackson')),
  ('Dune', 155, 'English', '2021-10-22', 'PG-13', (SELECT id FROM directors WHERE last_name='Villeneuve')),
  ('Barbie', 114, 'English', '2023-07-21', 'PG-13', (SELECT id FROM directors WHERE last_name='Gerwig')),
  ('Wonder Woman', 141, 'English', '2017-06-02', 'PG-13', (SELECT id FROM directors WHERE last_name='Jenkins'));

-- Movie revenues
INSERT INTO movie_revenues (movie_id, domestic_takings, international_takings)
VALUES
  ((SELECT id FROM movies WHERE movie_name='Inception'), 292.6, 535.7),
  ((SELECT id FROM movies WHERE movie_name='Interstellar'), 188.0, 489.4),
  ((SELECT id FROM movies WHERE movie_name='Jurassic Park'), 402.5, 620.1),
  ((SELECT id FROM movies WHERE movie_name='Pulp Fiction'), 107.9, 213.9),
  ((SELECT id FROM movies WHERE movie_name='Titanic'), 659.4, 1542.0),
  ((SELECT id FROM movies WHERE movie_name='The Wolf of Wall Street'), 116.9, 275.1),
  ((SELECT id FROM movies WHERE movie_name='The Martian'), 228.4, 403.7),
  ((SELECT id FROM movies WHERE movie_name='The Lord of the Rings: The Fellowship of the Ring'), 316.1, 883.0),
  ((SELECT id FROM movies WHERE movie_name='Dune'), 108.3, 309.2),
  ((SELECT id FROM movies WHERE movie_name='Barbie'), 636.2, 816.6),
  ((SELECT id FROM movies WHERE movie_name='Wonder Woman'), 412.6, 409.3);

-- Movies-actors relationships
INSERT INTO movies_actors (movie_id, actor_id)
VALUES
  ((SELECT id FROM movies WHERE movie_name='Inception'), (SELECT id FROM actors WHERE last_name='DiCaprio')),
  ((SELECT id FROM movies WHERE movie_name='Inception'), (SELECT id FROM actors WHERE last_name='Hathaway')),
  ((SELECT id FROM movies WHERE movie_name='Interstellar'), (SELECT id FROM actors WHERE last_name='Hathaway')),
  ((SELECT id FROM movies WHERE movie_name='Interstellar'), (SELECT id FROM actors WHERE last_name='Damon')),
  ((SELECT id FROM movies WHERE movie_name='Jurassic Park'), (SELECT id FROM actors WHERE last_name='Portman')),
  ((SELECT id FROM movies WHERE movie_name='Pulp Fiction'), (SELECT id FROM actors WHERE last_name='Thurman')),
  ((SELECT id FROM movies WHERE movie_name='Pulp Fiction'), (SELECT id FROM actors WHERE last_name='Jackson')),
  ((SELECT id FROM movies WHERE movie_name='Titanic'), (SELECT id FROM actors WHERE last_name='DiCaprio')),
  ((SELECT id FROM movies WHERE movie_name='Titanic'), (SELECT id FROM actors WHERE last_name='Johansson')),
  ((SELECT id FROM movies WHERE movie_name='The Wolf of Wall Street'), (SELECT id FROM actors WHERE last_name='DiCaprio')),
  ((SELECT id FROM movies WHERE movie_name='The Martian'), (SELECT id FROM actors WHERE last_name='Damon')),
  ((SELECT id FROM movies WHERE movie_name='The Lord of the Rings: The Fellowship of the Ring'), (SELECT id FROM actors WHERE last_name='Blanchett')),
  ((SELECT id FROM movies WHERE movie_name='Dune'), (SELECT id FROM actors WHERE last_name='Chalamet')),
  ((SELECT id FROM movies WHERE movie_name='Dune'), (SELECT id FROM actors WHERE last_name='Ferguson')),
  ((SELECT id FROM movies WHERE movie_name='Barbie'), (SELECT id FROM actors WHERE last_name='Gosling')),
  ((SELECT id FROM movies WHERE movie_name='Barbie'), (SELECT id FROM actors WHERE last_name='Stone')),
  ((SELECT id FROM movies WHERE movie_name='Wonder Woman'), (SELECT id FROM actors WHERE last_name='Johansson')),
  ((SELECT id FROM movies WHERE movie_name='Wonder Woman'), (SELECT id FROM actors WHERE last_name='Portman'));


INSERT INTO critics (first, last)
VALUES
  ('Roger', 'Ebert'),
  ('Peter', 'Travers'),
  ('Manohla', 'Dargis'),
  ('A. O.', 'Scott'),
  ('Richard', 'Roeper');


INSERT INTO movie_reviews (movie_id, user_id, stars, review)
VALUES
  ((SELECT id FROM movies WHERE movie_name='Inception'), (SELECT id FROM critics WHERE last='Ebert'), 5, 'A mind-bending masterpiece.'),
  ((SELECT id FROM movies WHERE movie_name='Titanic'), (SELECT id FROM critics WHERE last='Travers'), 4, 'A classic love story with groundbreaking visuals.'),
  ((SELECT id FROM movies WHERE movie_name='Dune'), (SELECT id FROM critics WHERE last='Scott'), 5, 'Epic in every sense of the word.'),
  ((SELECT id FROM movies WHERE movie_name='Barbie'), (SELECT id FROM critics WHERE last='Dargis'), 4, 'Smart, funny, and surprisingly deep.'),
  ((SELECT id FROM movies WHERE movie_name='Pulp Fiction'), (SELECT id FROM critics WHERE last='Roeper'), 5, 'Iconic and endlessly rewatchable.');

