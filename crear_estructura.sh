#!/bin/bash
# ============================================================
# Sistema de Paquetería - Generador de Estructura del Proyecto
# Ejecutar desde: ~/proyectos/ (o donde quieras el proyecto)
# Uso: chmod +x crear_estructura.sh && ./crear_estructura.sh
# ============================================================

set -e
mkfile() { mkdir -p "$(dirname "$1")" && touch "$1"; }

PROJECT="sistema-paqueteria"
echo ""
echo "📦 Creando estructura del proyecto: $PROJECT"
echo "================================================"

mkdir -p $PROJECT && cd $PROJECT

# ── RAÍZ ────────────────────────────────────────────────────
touch .env.example .gitignore README.md docker-compose.yml docker-compose.prod.yml

# ── .github/workflows ────────────────────────────────────────
mkfile .github/workflows/ci-cd.yml
mkfile .github/workflows/tests.yml

# ── HELM CHARTS ──────────────────────────────────────────────
for svc in usuarios paquetes notificaciones; do
  mkfile helm/$svc/Chart.yaml
  mkfile helm/$svc/values.yaml
  mkfile helm/$svc/values.production.yaml
  mkfile helm/$svc/templates/deployment.yaml
  mkfile helm/$svc/templates/service.yaml
  mkfile helm/$svc/templates/ingress.yaml
  mkfile helm/$svc/templates/configmap.yaml
  mkfile helm/$svc/templates/hpa.yaml
done
mkfile helm/ingress-nginx/values.yaml

# ── KUBERNETES CONFIGS ────────────────────────────────────────
mkfile k8s/namespaces/paqueteria.yaml
mkfile k8s/secrets/db-secrets.yaml
mkfile k8s/secrets/jwt-secrets.yaml
mkfile k8s/storage/postgres-pvc.yaml

# ══════════════════════════════════════════════════════════════
# MICROSERVICIO 1: USUARIOS (PHP 8.2 + Slim)
# ══════════════════════════════════════════════════════════════
mkfile servicios/usuarios/public/index.php
mkfile servicios/usuarios/bootstrap/app.php
mkfile servicios/usuarios/routes/api.php
mkfile servicios/usuarios/composer.json
mkfile servicios/usuarios/.env.example
mkfile servicios/usuarios/.dockerignore
for f in AuthController UsuarioController PerfilController; do
  mkfile servicios/usuarios/src/Controllers/$f.php; done
for f in AuthMiddleware CorsMiddleware RateLimitMiddleware; do
  mkfile servicios/usuarios/src/Middleware/$f.php; done
for f in Usuario Sesion Token; do
  mkfile servicios/usuarios/src/Models/$f.php; done
for f in AuthService JwtService HashService EmailService; do
  mkfile servicios/usuarios/src/Services/$f.php; done
for f in RegistroValidator LoginValidator; do
  mkfile servicios/usuarios/src/Validators/$f.php; done
for f in app database jwt; do
  mkfile servicios/usuarios/config/$f.php; done
for f in 001_crear_tabla_usuarios 002_crear_tabla_sesiones 003_crear_tabla_tokens; do
  mkfile servicios/usuarios/database/migrations/$f.sql; done
mkfile servicios/usuarios/database/seeds/UsuarioSeeder.php
mkfile servicios/usuarios/tests/Unit/AuthServiceTest.php
mkfile servicios/usuarios/tests/Unit/JwtServiceTest.php
mkfile servicios/usuarios/tests/Integration/AuthControllerTest.php
for f in Dockerfile Dockerfile.dev nginx.conf php.ini entrypoint.sh; do
  mkfile servicios/usuarios/docker/$f; done

# ══════════════════════════════════════════════════════════════
# MICROSERVICIO 2: PAQUETES (PHP 8.2 + Slim)
# Incluye: calculadora de precios por peso/dimensiones
# ══════════════════════════════════════════════════════════════
mkfile servicios/paquetes/public/index.php
mkfile servicios/paquetes/bootstrap/app.php
mkfile servicios/paquetes/routes/api.php
mkfile servicios/paquetes/composer.json
mkfile servicios/paquetes/.env.example
mkfile servicios/paquetes/.dockerignore
for f in PaqueteController EnvioController RastreoController PrecioController ReporteController; do
  mkfile servicios/paquetes/src/Controllers/$f.php; done
for f in AuthMiddleware CorsMiddleware; do
  mkfile servicios/paquetes/src/Middleware/$f.php; done
for f in Paquete Envio EstadoEnvio Ruta Zona TarifaZona; do
  mkfile servicios/paquetes/src/Models/$f.php; done
for f in EnvioService RastreoService PaqueteService NotificacionPublisher; do
  mkfile servicios/paquetes/src/Services/$f.php; done
# -- Calculadora de precios (núcleo del negocio) --
for f in CalculadoraPrecio PesoCalculator DimensionesCalculator ZonaCalculator TarifaRepository DescuentoService; do
  mkfile servicios/paquetes/src/Calculadora/$f.php; done
for f in PaqueteValidator EnvioValidator PrecioValidator; do
  mkfile servicios/paquetes/src/Validators/$f.php; done
for f in PaqueteCreado EstadoCambiado EnvioEntregado; do
  mkfile servicios/paquetes/src/Events/$f.php; done
for f in app database tarifas zonas; do
  mkfile servicios/paquetes/config/$f.php; done
for f in 001_crear_tabla_paquetes 002_crear_tabla_envios 003_crear_tabla_estados 004_crear_tabla_zonas 005_crear_tabla_tarifas 006_crear_tabla_rutas; do
  mkfile servicios/paquetes/database/migrations/$f.sql; done
mkfile servicios/paquetes/database/seeds/ZonaSeeder.php
mkfile servicios/paquetes/database/seeds/TarifaSeeder.php
for f in CalculadoraPrecioTest PesoCalculatorTest ZonaCalculatorTest EnvioServiceTest; do
  mkfile servicios/paquetes/tests/Unit/$f.php; done
for f in PaqueteControllerTest PrecioControllerTest; do
  mkfile servicios/paquetes/tests/Integration/$f.php; done
for f in Dockerfile Dockerfile.dev nginx.conf php.ini entrypoint.sh; do
  mkfile servicios/paquetes/docker/$f; done

# ══════════════════════════════════════════════════════════════
# MICROSERVICIO 3: NOTIFICACIONES (Node.js + Express)
# ══════════════════════════════════════════════════════════════
mkfile servicios/notificaciones/app.js
mkfile servicios/notificaciones/package.json
mkfile servicios/notificaciones/.env.example
mkfile servicios/notificaciones/.dockerignore
for f in NotificacionController WebhookController; do
  mkfile servicios/notificaciones/src/controllers/$f.js; done
for f in EmailService SmsService PushService TemplateService; do
  mkfile servicios/notificaciones/src/services/$f.js; done
for f in consumer producer handlers; do
  mkfile servicios/notificaciones/src/queues/$f.js; done
for f in paquete-creado estado-actualizado entregado; do
  mkfile servicios/notificaciones/src/templates/email/$f.html; done
for f in estado-sms entrega-sms; do
  mkfile servicios/notificaciones/src/templates/sms/$f.txt; done
for f in app redis mail; do
  mkfile servicios/notificaciones/config/$f.js; done
for f in Dockerfile Dockerfile.dev entrypoint.sh; do
  mkfile servicios/notificaciones/docker/$f; done

# ══════════════════════════════════════════════════════════════
# FRONTEND (PHP/JS - Mobile First, PWA)
# ══════════════════════════════════════════════════════════════
for f in login registro dashboard rastrear nuevo-envio mis-envios calculadora perfil; do
  mkfile frontend/src/pages/$f.php; done
# -- Componentes calculadora --
for f in CalculadoraForm ResultadoPrecio SelectorZona DimensionesInput ResumenCotizacion; do
  mkfile frontend/src/components/calculadora/$f.php; done
# -- Componentes rastreo --
for f in TimelineEstados MapaRuta DetalleEnvio; do
  mkfile frontend/src/components/rastreo/$f.php; done
# -- Componentes compartidos --
for f in Header Footer Nav Alert Modal Loading; do
  mkfile frontend/src/components/shared/$f.php; done
for f in api auth format validacion; do
  mkfile frontend/src/utils/$f.js; done
for f in app calculadora rastreo sw; do
  mkfile frontend/public/js/$f.js; done
for f in main calculadora components; do
  mkfile frontend/public/css/$f.css; done
mkfile frontend/public/manifest.json
mkfile frontend/public/offline.html
for d in img icons; do mkdir -p frontend/public/$d; done
for f in base auth app; do mkfile frontend/templates/$f.php; done
for f in Dockerfile Dockerfile.dev nginx.conf; do
  mkfile frontend/docker/$f; done
mkfile frontend/.dockerignore

# ── SCRIPTS DE UTILIDAD ───────────────────────────────────────
for f in migrate seed backup restore; do mkfile scripts/db/$f.sh; done
for f in build-images push-images deploy-staging deploy-production rollback; do
  mkfile scripts/deploy/$f.sh; done
for f in setup reset-db logs; do mkfile scripts/dev/$f.sh; done

# ── DOCUMENTACIÓN ─────────────────────────────────────────────
for f in usuarios-api paquetes-api precios-api notificaciones-api; do
  mkfile docs/api/$f.md; done
for f in overview microservicios base-de-datos calculadora-precios; do
  mkfile docs/arquitectura/$f.md; done
for f in digital-ocean kubernetes ci-cd secrets; do
  mkfile docs/deployment/$f.md; done
mkfile docs/README.md

echo ""
echo "✅ Estructura creada exitosamente"
echo ""
echo "📁 Resumen:"
find . -type f | wc -l | xargs echo "   Archivos totales:"
find . -type d | wc -l | xargs echo "   Directorios totales:"
echo ""

# Mostrar árbol completo
if command -v tree &>/dev/null; then
  tree -a --dirsfirst -I ".git"
else
  find . | sort | sed 's|[^/]*/|  |g'
fi

echo ""
echo "📌 Próximos pasos:"
echo "   1. cd $PROJECT"
echo "   2. git init && git add . && git commit -m 'chore: estructura inicial del proyecto'"
echo "   3. Continuar con: Dockerfiles, GitHub Actions, código base"
echo ""
