package factories

import (
	"math/rand"
	"time"
)

func randomDateOfBirth() time.Time {
	// define a date range
	start := time.Date(1940, 1, 1, 0, 0, 0, 0, time.UTC)
	end := time.Date(2005, 12, 31, 0, 0, 0, 0, time.UTC)

	// pick a random number of seconds between start and end
	delta := end.Unix() - start.Unix()
	randSec := rand.Int63n(delta)

	return time.Unix(start.Unix()+randSec, 0)
}
