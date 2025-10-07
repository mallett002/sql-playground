package main

import (
	"context"
	"log"
	"math/rand"
	"time"

	random "github.com/Pallinder/go-randomdata"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
)

type Director struct {
	ID          uuid.UUID `db:"id"`
	FirstName   string    `db:"first_name"`
	LastName    string    `db:"last_name"`
	DateOfBirth time.Time `db:"date_of_birth"`
	Nationality string    `db:"nationality"`
}

func randomDateOfBirth() time.Time {
	// define a date range
	start := time.Date(1940, 1, 1, 0, 0, 0, 0, time.UTC)
	end := time.Date(2005, 12, 31, 0, 0, 0, 0, time.UTC)

	// pick a random number of seconds between start and end
	delta := end.Unix() - start.Unix()
	randSec := rand.Int63n(delta)

	return time.Unix(start.Unix()+randSec, 0)
}

func pickRandomNationality() string {
	nationalities := []string{
		"American",
		"British",
		"Canadian",
		"French",
		"German",
		"Italian",
		"Japanese",
		"Korean",
		"Australian",
		"Mexican",
		"Indian",
		"Spanish",
		"Brazilian",
		"Swedish",
		"Norwegian",
	}

	// Pick a random index
	return nationalities[rand.Intn(len(nationalities))]
}

func createRandomDirector() Director {
	return Director{
		ID:          uuid.New(),
		FirstName:   random.FirstName(rand.Intn(2)),
		LastName:    random.LastName(),
		DateOfBirth: randomDateOfBirth(),
		Nationality: pickRandomNationality(),
	}
}

func createRandomDirectors(count int) []Director {
	var directors []Director = make([]Director, 0, count)

	for i := 0; i < count; i++ {
		dir := createRandomDirector()

		directors = append(directors, dir)
	}

	return directors
}

// DB updates -----------------------------------------------------------------------
func insertDirectors(pool *pgxpool.Pool, dirs []Director) error {
	// Prepare the SQL insert statement
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

func main() {
	// Seed the random generator (do this once per program, not per call ideally)
	rand.Seed(time.Now().UnixNano())

	// Connect to DB
	pool, err := pgxpool.New(context.Background(), "postgres://movie:movie_ps@localhost:5432/moviedb")

	if err != nil {
		log.Fatalf("unable to connect to database: %v", err)
	}

	defer pool.Close()

	var directors []Director = createRandomDirectors(20)

	// Insert them into the DB
	if err := insertDirectors(pool, directors); err != nil {
		log.Fatalf("failed to insert directors: %v", err)
	}

	log.Println("Inserted directors successfully!")

}
