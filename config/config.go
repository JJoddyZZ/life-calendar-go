package config

import "github.com/kelseyhightower/envconfig"

type Config struct {
	AppName    string `envconfig:"NAME" default:"APP"`
	AppVersion string `envconfig:"VERSION" default:"x.x.x"`
	ServerPort string `envconfig:"PORT" default:"8080"`
}

func Load() *Config {
	c := new(Config)
	envconfig.MustProcess("", c)
	return c
}
