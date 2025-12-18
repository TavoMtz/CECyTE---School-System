# Sistema de Gestión Escolar - CECyTE

> **Estado actual:** 🚧 Fase de Diseño y Modelado de Datos *(En progreso)*

Sistema para la administración de expedientes académicos, control escolar y procesos de admisión de las preparatorias CECyTE. Este proyecto tiene como objetivo centralizar la información estudiantil y eliminar la redundancia de datos.

## Estructura del Repositorio

Este repositorio contiene la arquitectura de datos y la documentación técnica del sistema:

* `/base de datos`:
    * **Scripts SQL:** Código DDL para la creación de tablas y relaciones.
    * **Diagramas:** Documento de MySQL Workbench, que es el Modelo Entidad-Relación (ERD).
    * **Datos Semilla:** Scripts para poblar catálogos iniciales.
* `/docs`:
    * Diccionario de Datos.
    * Listado de requerimientos y reglas de negocio (markdown)
    * Manual de procesos del CECyTE (PDF)
    * Diagrama de Casos de Uso (PDF).

> **Nota:** El manual detalla por secciones los procesos llevados a cabo para un mejor entenidmiento de los mismos.

## Tecnologías

* **Motor de Base de Datos:** MySQL

## Despliegue de la Base de Datos

1.  Clonar el repositorio.
2.  Crear una base de datos vacía en tu gestor local.
3.  Ejecutar el script principal ubicado en `base de datos/script_ddl.sql`.
4.  (Opcional) Cargar datos de prueba con `base de datos/seed_data.sql`.

## Autores
**Gustavo Enrique Martínez**\
**Lucio Emiliano Ruiz Sepulveda**