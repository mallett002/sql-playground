package factories

import (
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

func CreateRandomDirectors(count int) []Director {
	var directors []Director = make([]Director, 0, count)

	for i := 0; i < count; i++ {
		dir := createRandomDirector()

		directors = append(directors, dir)
	}

	return directors
}
