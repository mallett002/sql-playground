package db

import (
	"context"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/mallett002/sql-playground/factories"
)

func InsertDirectors(pool *pgxpool.Pool, dirs *[]factories.Director) error {
	sql := `
		INSERT INTO directors (id, first_name, last_name, date_of_birth, nationality)
		VALUES ($1, $2, $3, $4, $5)
	`

	for _, d := range *dirs {
		_, err := pool.Exec(context.Background(), sql,
			d.ID,
			d.FirstName,
			d.LastName,
			d.DateOfBirth,
			d.Nationality,
		)

		if err != nil {
			return err
		}
	}

	return nil
}

func InsertMovies(pool *pgxpool.Pool, movies *[]factories.Movie) error {
	sql := `
		INSERT INTO movies (id, movie_name, movie_length, movie_lang, release_date, age_certificate, director_id)
		VALUES ($1, $2, $3, $4, $5, $6, $7)
	`

	for _, m := range *movies {
		_, err := pool.Exec(context.Background(), sql,
			m.ID,
			m.MovieName,
			m.MovieLength,
			m.MovieLang,
			m.ReleaseDate,
			m.AgeCertificate,
			m.DirectorID,
		)

		if err != nil {
			return err
		}
	}

	return nil
}
