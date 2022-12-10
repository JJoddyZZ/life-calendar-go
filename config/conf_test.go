package config

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func Test_Load(t *testing.T) {
	c := Load()
	assert.NotNil(t, c)
}
