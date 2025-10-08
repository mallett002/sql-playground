package db

import (
	"context"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/mallett002/sql-playground/factories"
)

func InsertDirectors(pool *pgxpool.Pool, dirs []factories.Director) error {
	sql := `
		INSERT INTO directors (id, first_name, last_name, date_of_birth, nationality)
		VALUES ($1, $2, $3, $4, $5)
	`

	for _, d := range dirs {
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
