package app

import (
	"context"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/JJoddyZZ/life-calendar-go/config"
	"github.com/uptrace/bunrouter"
	"github.com/uptrace/bunrouter/extra/reqlog"
)

type app struct {
	router *bunrouter.Router
}

func ServeAPI(c *config.Config) {
	app := &app{
		router: bunrouter.New(bunrouter.Use(reqlog.NewMiddleware())),
	}
	app.addRoutes()
	app.start()
}

func (a *app) addRoutes() {
	a.router.GET("/health", func(w http.ResponseWriter, req bunrouter.Request) error {
		bunrouter.JSON(w, bunrouter.H{"status": "ok"})
		return nil
	})
}

func (a *app) start() {
	srv := &http.Server{
		Addr:    ":8080",
		Handler: a.router,
	}

	go func() {
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			log.Fatalf("error while listening: %s\n", err)
		}
	}()

	// Waits for interrupting signal
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit

	// 5 seconds of timeout for a graceful shutdown of the server
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	if err := srv.Shutdown(ctx); err != nil {
		log.Fatalf("error shutting down the server: %s\n", err)
	}

	log.Println("5 second timeout...")
	<-ctx.Done()
	log.Println("Server off")
}
