package main

import (
	"html/template"
	"net/http"

	"github.com/gin-gonic/gin"
)

// RenderTemplate es la función que renderiza la plantilla
func RenderTemplate(c *gin.Context, color string) {
	htmlTemplate := `
		<!DOCTYPE html>
		<html>
			<head>
				<title>Web App con Color Personalizado</title>
			</head>
			<body style="background-color: {{ .Color }};">
				<h1>Página con color personalizado</h1>
			</body>
		</html>
	`

	tmpl := template.Must(template.New("index.html").Parse(htmlTemplate))

	data := struct {
		Color string
	}{
		Color: color,
	}

	err := tmpl.Execute(c.Writer, data)
	if err != nil {
		c.String(http.StatusInternalServerError, "Error al renderizar el template")
		return
	}
}
