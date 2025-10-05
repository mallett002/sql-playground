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

-- Seed:
-- Directors
INSERT INTO directors (first_name, last_name, date_of_birth, nationality)
VALUES
  ('Christopher', 'Nolan', '1970-07-30', 'British-American'),
  ('Steven', 'Spielberg', '1946-12-18', 'American'),
  ('Quentin', 'Tarantino', '1963-03-27', 'American');

-- Actors
INSERT INTO actors (first_name, last_name, gender, date_of_birth)
VALUES
  ('Leonardo', 'DiCaprio', 'M', '1974-11-11'),
  ('Brad', 'Pitt', 'M', '1963-12-18'),
  ('Uma', 'Thurman', 'F', '1970-04-29');

-- Movies
INSERT INTO movies (movie_name, movie_length, movie_lang, release_date, age_certificate, director_id)
VALUES
  ('Inception', 148, 'English', '2010-07-16', 'PG-13', (SELECT id FROM directors WHERE last_name='Nolan')),
  ('Pulp Fiction', 154, 'English', '1994-10-14', 'R', (SELECT id FROM directors WHERE last_name='Tarantino')),
  ('Jurassic Park', 127, 'English', '1993-06-11', 'PG-13', (SELECT id FROM directors WHERE last_name='Spielberg'));

-- Movie revenues
INSERT INTO movie_revenues (movie_id, domestic_takings, international_takings)
VALUES
  ((SELECT id FROM movies WHERE movie_name='Inception'), 292.6, 535.7),
  ((SELECT id FROM movies WHERE movie_name='Pulp Fiction'), 107.9, 213.9),
  ((SELECT id FROM movies WHERE movie_name='Jurassic Park'), 402.5, 620.1);

-- Movies-actors relationships
INSERT INTO movies_actors (movie_id, actor_id)
VALUES
  ((SELECT id FROM movies WHERE movie_name='Inception'), (SELECT id FROM actors WHERE last_name='DiCaprio')),
  ((SELECT id FROM movies WHERE movie_name='Pulp Fiction'), (SELECT id FROM actors WHERE last_name='Pitt')),
  ((SELECT id FROM movies WHERE movie_name='Pulp Fiction'), (SELECT id FROM actors WHERE last_name='Thurman'));







