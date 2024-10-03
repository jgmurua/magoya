# App-color

Esta aplicación en Go muestra un color en una página web, el mismo es definido por la variable de entorno `BACKGROUND_COLOR`.

## Construir binario localmente
    
```bash
go mod init app-color
go mod tidy
go build -o main
```
# Construir imagen docker localmente

```bash
docker build -t app-color .
docker run -p 80:80 -e BACKGROUND_COLOR="#FF0099" app-color
```

## Ejecutar la aplicación localmente
```bash
BACKGROUND_COLOR="#FF5733" go run main.go
```

## Ejecutar pruebas unitarias localmente

```bash
go clean -cache -testcache -modcache
go test -v ./...
```

# Se incluye el manifiesto de kubernetes para desplegar la aplicacion en un cluster EKS y de esa manera alternar entre los colores de fondo de la aplicacion al dirigirse a green o red

```bash
kubectl create namespace app-color --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f app-color.yaml -n app-color
```