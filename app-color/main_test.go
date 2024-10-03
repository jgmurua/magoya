package main

import (
	"net/http"
	"net/http/httptest"
	"os"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

func TestMainRoute(t *testing.T) {
	gin.SetMode(gin.TestMode)

	router := gin.Default()

	// Usar la función definida en el mismo paquete
	router.GET("/", func(c *gin.Context) {
		color := os.Getenv("BACKGROUND_COLOR")
		RenderTemplate(c, color)
	})

	// Crear una nueva petición HTTP
	req, _ := http.NewRequest("GET", "/", nil)

	// Crear un ResponseRecorder para obtener la respuesta
	w := httptest.NewRecorder()

	// Establecer una variable de entorno
	os.Setenv("BACKGROUND_COLOR", "#FF5733")

	// Ejecutar la petición
	router.ServeHTTP(w, req)

	// Verificar que la respuesta sea 200 OK
	assert.Equal(t, http.StatusOK, w.Code)

	// Verificar que el body contenga el color correcto
	assert.Contains(t, w.Body.String(), "#FF5733")
}
