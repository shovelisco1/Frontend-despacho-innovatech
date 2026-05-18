# ==========================================
# ETAPA 1: Construcción (Build Stage)
# ==========================================
# Usamos Node para compilar el proyecto Vite
FROM node:18-alpine AS builder

WORKDIR /app

# Copiamos los archivos de dependencias
COPY package*.json ./

# Instalamos las dependencias
RUN npm install

# Copiamos el resto del código del frontend
COPY . .

# Compilamos React (Vite generará la carpeta "dist")
RUN npm run build

# ==========================================
# ETAPA 2: Producción (Production Stage)
# ==========================================
# Usamos una imagen de Nginx "unprivileged" (usuario no root) por seguridad
FROM nginxinc/nginx-unprivileged:alpine AS production

# Copiamos la carpeta "dist" generada en la etapa 1 a Nginx
COPY --from=builder /app/dist /usr/share/nginx/html

# Exponemos el puerto (Nginx unprivileged usa el 8080 por defecto)
EXPOSE 8080

# Comando para iniciar el servidor web
CMD ["nginx", "-g", "daemon off;"]
