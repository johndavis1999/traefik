# 🌐 Entorno Dockerizado con Traefik + Nginx + Let's Encrypt (Cloudflare)

Este proyecto proporciona un entorno dockerizado para desplegar fácilmente sitios web con soporte para HTTPS automático utilizando **Traefik** como reverse proxy y **Cloudflare** como proveedor DNS para la emisión automática de certificados SSL.

## 📁 Estructura del Proyecto

project-root/
├── init.sh
├── docker-compose.yml
├── traefik/
│ ├── traefik.yml
│ ├── config.yml
│ └── data/
│ └── acme.json
├── landing/
│ ├── docker-compose.yml
│ └── html/
│ └── index.html
└── sub/
├── docker-compose.yml
└── html/
└── index.html

---

## ⚙️ Requisitos Previos

- Linux (no compatible con macOS ni para ejecutar dentro de un contenedor)
- Docker y Docker Compose
- Un dominio real en [Cloudflare](https://dash.cloudflare.com/)
- Un token de API de Cloudflare con permisos DNS completos para interactuar con el dominio a usar

---

## 🔐 Variables importantes

Edita los siguientes archivos para personalizar el entorno:

- `network/init.sh`:
  - Asegúrate de que el dominio, correo y token de Cloudflare estén correctos.
- `traefik.yml`:
  - Reemplaza `domain.com` y `mail@domain.com` con tu dominio real y correo.

---

## 🚀 Despliegue Paso a Paso

### 1. Ejecutar el script de inicialización

bash
cd network
chmod +x init.sh
sudo ./init.sh

Este script:

- Verifica que el sistema no sea macOS ni un contenedor Docker.

- Instala Docker, Python3 y Composer si no están presentes.

- Crea la red externa vpn_net.

- Levanta Traefik con docker-compose up -d.

2. Levantar la landing page (dominio principal)

cd ../landing
docker compose up -d

- Servirá el contenido desde landing/html/ en https://domain.com.

3. Levantar un subdominio (ej. sub.domain.com)

cd ../sub
docker compose up -d

- Servirá el contenido desde sub/html/ en https://sub.domain.com.

## 🌐 Certificados SSL Automáticos
- Traefik se encarga automáticamente de:

- Solicitar certificados SSL Let's Encrypt usando DNS Challenge vía Cloudflare

- Renovarlos automáticamente

- Servir cada dominio/subdominio con HTTPS

## 📌 Notas Adicionales
- El archivo acme.json debe tener permisos chmod 600 para que Traefik lo utilice correctamente.

- Puedes crear múltiples servicios en subdominios replicando el contenido de sub/.

## 🧼 Detener y limpiar

cd network
docker compose down --remove-orphans

🛠️ En desarrollo...
Posibilidad de integrar aplicaciones Laravel, React o Node.js en subdominios.

Uso de variables de entorno para parametrizar automáticamente dominios.

Automatización con scripts de CI/CD.

## 🧑‍💻 Autor

**John Davis**  
Full Stack Developer

- 🌐 [github.com/johndavis1999](https://github.com/johndavis1999)
- 💼 [linkedin.com/in/john-davis-cedeño-9ab611207](https://www.linkedin.com/in/john-davis-cede%C3%B1o-9ab611207)