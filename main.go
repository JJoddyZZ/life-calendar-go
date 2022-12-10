package main

import (
	"github.com/JJoddyZZ/life-calendar-go/config"
	"github.com/JJoddyZZ/life-calendar-go/internal/app"
)

func main() {
	c := config.Load()
	app.ServeAPI(c)
}
