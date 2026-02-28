# 🗑️ Sistema de Gestión de Recolección de Residuos

## 📌 Descripción

Este proyecto consiste en el diseño e implementación de una base de
datos relacional para gestionar procesos de **recolección y disposición
de residuos**.\
Incluye el modelado de entidades, creación de tablas, restricciones de
integridad, carga de datos y consultas orientadas al análisis operativo.

El objetivo es simular un sistema real que permita registrar: -
Ubicaciones donde se recolectan residuos - Tipos de residuos y su
clasificación - Eventos de recolección - Procesos de disposición final -
Cantidades recolectadas por tipo de residuo

Además, el proyecto incorpora documentación técnica, modelo
entidad‑relación y análisis de optimización de consultas.

------------------------------------------------------------------------

## 🎯 Objetivos del Proyecto

-   Diseñar un modelo de base de datos relacional normalizado.
-   Implementar tablas con claves primarias y foráneas.
-   Aplicar restricciones de integridad (CHECK, UNIQUE, FK).
-   Registrar eventos de recolección de residuos.
-   Analizar datos mediante consultas SQL.
-   Evaluar optimización de consultas.

------------------------------------------------------------------------

## 🛠️ Tecnologías Utilizadas

-   MySQL / SQL
-   MySQL Workbench (.mwb)
-   Excel (dataset de apoyo)
-   Documentación PDF
-   Git & GitHub

------------------------------------------------------------------------

## 🗂️ Estructura del Repositorio

    SQL-Proyecto-BootCamp/
    │
    ├── SQL PROYECTO.sql                # Script principal de creación de base de datos
    ├── SQL PROYECTO.mwb                # Modelo en MySQL Workbench
    ├── Proyecto Grupo 3.xlsx           # Datos de apoyo
    ├── Modelo de base de datos.png     # Diagrama entidad‑relación
    ├── Informe de optimización de consultas.pdf
    ├── ModeloProyecto6.pdf
    └── README.md

------------------------------------------------------------------------

## 🧱 Modelo de Datos

El sistema está compuesto por las siguientes entidades principales:

-   **ubicacion** → Lugares donde se realiza la recolección
-   **tipo_residuo** → Clasificación de residuos
-   **recoleccion** → Eventos de recolección por fecha y ubicación
-   **proceso_disposicion** → Destino final del residuo
-   **recoleccion_detalle** → Cantidad recolectada por tipo

El diseño asegura integridad referencial mediante claves foráneas y
restricciones.

------------------------------------------------------------------------

## 🚀 Cómo Ejecutar el Proyecto

1.  Abrir MySQL Workbench o tu gestor SQL.
2.  Ejecutar el archivo:

```{=html}
<!-- -->
```
    SQL PROYECTO.sql

3.  La base de datos `proyecto` se creará automáticamente con sus tablas
    y relaciones.

------------------------------------------------------------------------

## 📊 Funcionalidades Implementadas

-   Creación de base de datos desde cero
-   Relaciones entre entidades
-   Restricciones de validación geográfica (latitud/longitud)
-   Registro de eventos de recolección
-   Control de procesos de disposición
-   Consultas para análisis de cantidades recolectadas

------------------------------------------------------------------------

## 📚 Aprendizajes Clave

-   Modelado relacional aplicado a un caso real
-   Uso de claves primarias y foráneas
-   Normalización de datos
-   Implementación de restricciones SQL
-   Análisis y optimización de consultas

------------------------------------------------------------------------

## 👥 Autoría

Proyecto desarrollado como parte de un Bootcamp de SQL / Data Analytics.
