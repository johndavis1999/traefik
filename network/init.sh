#!/bin/sh
set -e

echo "🚀 Iniciando setup del entorno..."

# Verifica que el usuario sea root
if [ "$(id -u)" != "0" ]; then
    echo "❌ Error: Debes ejecutar este script como root." >&2
    exit 1
fi

# Verifica si es macOS
if [ "$(uname)" = "Darwin" ]; then
    echo "❌ Error: Este script no es compatible con macOS." >&2
    exit 1
fi

# Verifica si está dentro de un contenedor
if [ -f /.dockerenv ]; then
    echo "❌ Error: Este script no puede ejecutarse dentro de un contenedor Docker." >&2
    exit 1
fi

# Función para comprobar si un comando existe
command_exists() {
    command -v "$@" > /dev/null 2>&1
}

# Instala Docker si no existe
if command_exists docker; then
    echo "🐳 Docker ya está instalado."
else
    echo "📦 Instalando Docker..."
    curl -fsSL https://get.docker.com | sh
fi

# Instala Python3 si no existe
if command_exists python3; then
    echo "🐍 Python3 ya está instalado."
else
    echo "📦 Instalando Python3..."
    apt-get update && apt-get install -y python3
fi

# Instala Composer si no existe
if command_exists composer; then
    echo "🎼 Composer ya está instalado."
else
    echo "📦 Instalando Composer..."
    apt-get update && apt-get install -y composer
fi

# Asegura permisos correctos para acme.json
ACME_FILE="$(pwd)/traefik/data/acme.json"
if [ -f "$ACME_FILE" ]; then
    echo "🔐 Asignando permisos a acme.json"
    chmod 600 "$ACME_FILE"
else
    echo "📝 Creando acme.json..."
    touch "$ACME_FILE"
    chmod 600 "$ACME_FILE"
fi

# Crea red externa si no existe
if ! docker network ls | grep -q "vpn_net"; then
    echo "🔧 Creando red 'vpn_net'..."
    docker network create vpn_net
else
    echo "🔗 Red 'vpn_net' ya existe."
fi

# Detiene contenedores existentes si los hay
echo "🛑 Deteniendo contenedores existentes (si aplica)..."
docker compose down --remove-orphans

# Levanta los servicios definidos en docker-compose.yml
echo "🚢 Levantando servicios..."
docker compose up -d

echo "✅ Proyecto desplegado exitosamente. Puedes revisar los logs con:"
echo "   docker logs -f traefik"
