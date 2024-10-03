package main

import (
	"os"

	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()

	// Ruta para la página principal
	router.GET("/", func(c *gin.Context) {
		color := os.Getenv("BACKGROUND_COLOR")
		RenderTemplate(c, color)  // Usa la función definida en handlers.go
	})

	router.Run(":80")
}
