Data Analytics: Retail, Riesgo Financiero y Operaciones Logísticas
Un proyecto integral de Análisis de Datos diseñado para responder a preguntas críticas 
de negocio en la industria del retail, conectando el comportamiento del consumidor, el riesgo crediticio y la eficiencia de la cadena de suministro.

OBJETIVO DEL PROYECTO:
El propósito de este repositorio es demostrar la capacidad de extraer, limpiar y analizar datos transaccionales, financieros y de inventario utilizando SQL Avanzado. 
El enfoque principal está en proporcionar insights accionables que permitan a la gerencia optimizar el control de 
almacenes, mitigar la exposición de deuda y focalizar estrategias de retención de clientes de alto valor.

Stack Tecnológico y Habilidades.
Lenguaje: SQL
Técnicas Aplicadas:
Limpieza y estandarización de datos (Data Wrangling).
Creación de Vistas (Views) para arquitecturas de Capa Plata/Bronce.
Funciones de Ventana (Window Functions: DENSE_RANK, LAG).
Expresiones de Tabla Comunes (CTEs).
Lógica condicional para segmentación (CASE WHEN).
Cálculos financieros preventivos (Manejo de NULLIF para evitar errores de división por cero).

Estructura del Repositorio:
El flujo de trabajo está dividido en tres fases lógicas, emulando un entorno corporativo real:

1. 01_schema_and_mock_data.sql (Capa Bronce)
Diseño del modelo relacional de la base de datos. Incluye la creación de las tablas principales (clientes, transacciones, inventario, productos, locales) y la ingesta de datos crudos iniciales.

2. 02_data_wrangling.sql (Capa Plata)
Proceso de limpieza y estandarización. Se crearon vistas seguras para tratar inconsistencias en la data, corregir formatos de texto (UPPER, TRIM), castear tipos de datos y unificar categorías (ej. estados de riesgo y métodos de pago).

3. 03_business_analytics.sql (Capa Oro - KPIs)
El núcleo analítico del proyecto. Un script estructurado que responde a 10 requerimientos directos del negocio divididos en cuatro bloques estratégicos:

Rendimiento Comercial: Top sucursales y métodos de pago preferidos.

Riesgo Crediticio: Capital inmovilizado en clientes morosos y tasas de utilización de crédito.

Logística e Inventario: Detección de quiebres de stock críticos y cálculo de márgenes de rentabilidad neta por producto.

Segmentación de Clientes: Creación de Tiers de clientes, ranking regional de compradores VIP y análisis de series de tiempo (crecimiento Mes a Mes).
