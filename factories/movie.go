package factories

import (
	"math/rand"
	"time"

	random "github.com/Pallinder/go-randomdata"
	"github.com/google/uuid"
)

type Movie struct {
	ID             uuid.UUID `db:"id"`
	MovieName      string    `db:"movie_name"`
	MovieLength    int       `db:"movie_length"`
	MovieLang      string    `db:"movie_lang"`
	ReleaseDate    time.Time `db:"release_date"`
	AgeCertificate string    `db:"age_certificate"`
	DirectorID     uuid.UUID `db:"director_id"`
}

func createRandomMovie(director *Director) Movie {
	return Movie{
		ID:             uuid.New(),
		MovieName:      random.SillyName(),
		MovieLength:    random.Number(100, 200),
		MovieLang:      pickRandomLang(),
		ReleaseDate:    randomDate(),
		AgeCertificate: pickRandomAgeCert(),
		DirectorID:     director.ID,
	}
}

func pickRandomLang() string {
	languages := []string{
		"English",
		"English",
		"English",
		"English",
		"English",
		"French",
		"Portuguese",
		"German",
		"Italian",
		"Japanese",
		"Korean",
		"Spanish",
	}

	// Pick a random index
	return languages[rand.Intn(len(languages))]
}

func pickRandomAgeCert() string {
	certs := []string{
		"PG-13",
		"R",
		"PG",
	}

	return certs[rand.Intn(len(certs))]
}

func CreateRandomMovies(directors *[]Director, movieCount int) *[]Movie {
	var movies []Movie = make([]Movie, 0, movieCount)

	for i := 0; i < movieCount; i++ {
		d := *directors
		randomDirector := d[rand.Intn(len(d))]

		movie := createRandomMovie(&randomDirector)

		movies = append(movies, movie)
	}

	return &movies
}
