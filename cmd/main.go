package main

import (
	"context"
	"log"
	"math/rand"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/mallett002/sql-playground/db"
	"github.com/mallett002/sql-playground/factories"
)

func main() {
	// Seed the random generator (do this once per program, not per call ideally)
	rand.Seed(time.Now().UnixNano())

	// Connect to DB
	pool, err := pgxpool.New(context.Background(), "postgres://movie:movie_ps@localhost:5432/moviedb")

	if err != nil {
		log.Fatalf("unable to connect to database: %v", err)
	}

	defer pool.Close()

	// Create directors
	var directors *[]factories.Director = factories.CreateRandomDirectors(20)

	if err := db.InsertDirectors(pool, directors); err != nil {
		log.Fatalf("failed to insert directors: %v", err)
	}

	log.Println("Inserted directors successfully!")

	// Create movies
	var movies *[]factories.Movie = factories.CreateRandomMovies(directors, 500)

	if err := db.InsertMovies(pool, movies); err != nil {
		log.Fatalf("failed to insert movies: %v", err)
	}

	log.Println("Inserted movies successfully!")

}
