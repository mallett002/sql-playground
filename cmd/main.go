package main

import (
	"fmt"
	"math/rand"
	"time"

	random "github.com/Pallinder/go-randomdata"
	"github.com/google/uuid"
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

func createDirectors() {
	dir := createRandomDirector()

	fmt.Println(dir)
}

func main() {
	// Seed the random generator (do this once per program, not per call ideally)
	rand.Seed(time.Now().UnixNano())

	createDirectors()
}
