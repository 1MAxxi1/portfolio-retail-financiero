## Data Analytics: Retail, Riesgo Financiero y Operaciones Logísticas

Un proyecto integral de Análisis de Datos diseñado para responder a preguntas críticas de negocio en la industria del retail, conectando el comportamiento del consumidor, el riesgo crediticio y la eficiencia de la cadena de suministro.

## Objetivo del Proyecto
El propósito de este repositorio es demostrar la capacidad de extraer, limpiar y analizar datos transaccionales, financieros y de inventario utilizando **SQL Avanzado** y la automatización de procesos. El enfoque principal está en proporcionar insights accionables que permitan a la gerencia optimizar el control de almacenes, mitigar la exposición de deuda y focalizar estrategias de retención de clientes de alto valor.

## Stack Tecnológico y Habilidades
Lenguajes:SQL, Python
Técnicas Aplicadas:
-Generación automatizada de datos sintéticos con Python.
-Limpieza y estandarización de datos (Data Wrangling).
-Creación de Vistas (Views) para arquitecturas de datos en capas.
-Funciones de Ventana (Window Functions: `DENSE_RANK`, `LAG`).
-Expresiones de Tabla Comunes (CTEs).
-Lógica condicional para segmentación de carteras (`CASE WHEN`).
-Subconsultas avanzadas (Tablas Derivadas).
-Cálculos financieros preventivos (Manejo de `NULLIF` para evitar errores de división por cero).

## Estructura del Repositorio
El flujo de trabajo está estructurado de manera secuencial dentro de la carpeta principal, reflejando las etapas reales de un pipeline de datos en un entorno corporativo:

1 `00_data_generator.py`
Script desarrollado en Python encargado de la simulación y creación automatizada de los conjuntos de datos de prueba (mock data) de clientes, transacciones e inventarios para asegurar el volumen y la variabilidad requerida para el análisis.

2 `01_setup_database.sql` 
Diseño e implementación del modelo relacional de la base de datos. Este script estructura las tablas principales (`clientes`, `transacciones`, `inventario`, `productos`, `locales`) y ejecuta la ingesta de los datos crudos iniciales generados en el paso previo.

3 `02_data_wrangling.sql` 
Proceso intensivo de limpieza y transformación de datos. Se establecen vistas seguras para corregir formatos inconsistentes (`UPPER`, `TRIM`), tratar registros nulos, y unificar criterios de negocio (como normalizar las variaciones en las cadenas de estados de riesgo y métodos de pago).

4 `03_business_analytics.sql` (KPIS)
El motor analítico del proyecto. Un compendio de consultas optimizadas para responder a 10 requerimientos críticos de negocio divididos en bloques estratégicos:
Rendimiento Comercial: Top sucursales e ingresos por métodos de pago.
Riesgo Crediticio: Capital comprometido en categorías críticas y tasas de utilización de crédito.
Logística e Inventario: Alertas de quiebre de stock con cálculo de capital inmovilizado y márgenes de rentabilidad neta por producto.
Segmentación de Clientes: Clasificación de carteras mediante subconsultas por valor, ranking regional de compradores VIP (Window Functions) y análisis temporal de ingresos Mes a Mes (MoM).

## Principales Hallazgos (Insights Destacados)
Inteligencia de Tiempo: Implementación de análisis secuencial para detectar variaciones porcentuales en la facturación mensual, aislando registros inconsistentes.
Gestión de Almacén: Visibilidad completa de productos críticos con inventario menor a 15 unidades, permitiendo programar despachos de manera prioritaria según el costo inmovilizado.
Protección Financiera: Monitoreo estricto del porcentaje de uso de líneas de crédito según categorías de deudores para mitigar pérdidas operacionales.

## Próximos Pasos
* Conexión de la base de datos a Power BI
* Diseño de un Dashboard interactivo para la visualización dinámica de los 10 KPIs analíticos.

---
Autor: Maximiliano Muñoz Fuentes  
Perfil: Analista de Datos orientado a resultados comerciales y eficiencia operativa.
