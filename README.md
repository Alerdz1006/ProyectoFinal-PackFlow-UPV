# PackFlow UPV - Sistema de Microservicios para Paquetería

PackFlow UPV es una plataforma robusta de gestión y cotización de envíos de paquetería, construida bajo una arquitectura **Cloud-Native**. El sistema está diseñado para ofrecer escalabilidad y alta disponibilidad, operando íntegramente sobre la infraestructura administrada de **DigitalOcean**.

## Características Principales

- **Arquitectura de Microservicios:** Servicios independientes y desacoplados para una gestión eficiente.
- **Cotización en Tiempo Real:** Lógica avanzada de peso volumétrico y zonas de destino.
- **Seguridad:** Autenticación mediante JWT y gestión de credenciales a través de Kubernetes Secrets.
- **Infraestructura como Código:** Despliegue estandarizado utilizando Helm Charts.
- **Escalabilidad Automática:** Configuración de HPA (Horizontal Pod Autoscaler) para responder a la demanda.

## Stack Tecnológico

| Componente | Tecnología |
| :--- | :--- |
| **Backend** | PHP 8.2 |
| **Framework** | Lumen (Micro-framework de Laravel) |
| **Base de Datos** | PostgreSQL 15 (Managed) |
| **Orquestación** | Kubernetes (DOKS) |
| **Contenedores** | Docker |
| **Gestión de Paquetes K8s** | Helm |
| **Ingreso de Tráfico** | Nginx Ingress Controller |
| **CI/CD** | GitHub Actions |

## Arquitectura de Red y Despliegue

El proyecto utiliza un pipeline automatizado de CI/CD que se activa con cada `push` a la rama `main`, construyendo las imágenes y almacenándolas en el **DigitalOcean Container Registry (DOCR)**.



### Componentes de Infraestructura:
1. **DOKS (DigitalOcean Kubernetes Service):** Nodo central de orquestación.
2. **Managed PostgreSQL:** Garantiza la durabilidad y alta disponibilidad de los datos sin carga operativa.
3. **GitHub Actions:** Automatiza las pruebas y el despliegue hacia el cluster.

## Instalación y Despliegue

Para desplegar este sistema en un entorno de Kubernetes, se utilizan Helm Charts:

# Añadir configuración de entorno
cp values.example.yaml values.production.yaml

# Desplegar con Helm
helm install packflow-upv ./charts/packflow -f values.production.yaml
## Seguridad y Autenticación
El sistema implementa:

JWT (JSON Web Tokens): Para la comunicación segura entre el cliente y los servicios.

Kubernetes Secrets: Para el manejo de variables de entorno y llaves sensibles de la base de datos.

Encriptación: Comunicación interna cifrada para proteger los datos en tránsito.

## Contexto Académico
Este proyecto fue desarrollado por Manuel Alejandro Rodriguez Resendiz como parte de la asignatura de Tecnologías de Virtualización (2025) en la Universidad Politécnica de Victoria.

PackFlow UPV - v1.0.0 - Producción
