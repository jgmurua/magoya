# Stage de construcción
FROM golang:1.20 AS build-stage

# Establecer el directorio de trabajo
WORKDIR /app

# Crear go.mod automáticamente
RUN go mod init app-color

# Copiar los archivos de código fuente al contenedor
COPY *.go ./

# Ejecutar go mod tidy para descargar dependencias y generar go.mod y go.sum
RUN go mod tidy

# Compilar la aplicación con optimizaciones
RUN CGO_ENABLED=0 GOOS=linux go build -o main

# Etapa intermedia para compresión del binario
FROM alpine:3.18 AS compression-stage

# Instalar upx para comprimir el binario
RUN apk --no-cache add upx

# Copiar el binario desde la etapa de construcción
COPY --from=build-stage /app/main /main

# Comprimir el binario usando upx
RUN upx --best /main

# Stage de producción
FROM alpine:3.18 AS production-stage

# Instalar certificados necesarios (si se requiere para conexiones HTTPS)
RUN apk --no-cache add ca-certificates

# Copiar el binario comprimido de la etapa de compresión
COPY --from=compression-stage /main /

# Establecer variables de entorno
ENV GIN_MODE=release
ENV BACKGROUND_COLOR='#64FE2E'

# Puerto expuesto por la aplicación
EXPOSE 80

# Comando para ejecutar la aplicación
CMD ["/main"]
