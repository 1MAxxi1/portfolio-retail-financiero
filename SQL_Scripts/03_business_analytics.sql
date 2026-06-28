==============================================================================================
PROYECTO: Retail y Finanzas
ARCHIVO: 03_business_analytics.sql
AUTOR: Maximiliano Muñoz Fuentes
OBJETIVO: 
  Extraer KPIs críticos de negocio con las vistas ya creadas.
  Focos de análisis: Rendimiento Comercial, Comportamiento de Pago y Riesgo Crediticio.
============================================================================================== 
-- ----------------------------------------------------------------------------------------------
-- KPI 1: Ranking de Facturación por Sucursal (Top Locales)
-- Pregunta de Negocio: ¿Cuáles son las sucursales que generan el mayor volumen de ingresos?
-- ----------------------------------------------------------------------------------------------
  SELECT
	l.id_local,
	l.nombre_local,
    COUNT(v.id_transaccion) AS total_transacciones,
    SUM(v.monto_total) AS suma_total_local
FROM locales AS l
JOIN vw_transacciones_limpias AS v ON l.id_local=v.id_local
GROUP BY l.id_local, l.nombre_local
ORDER BY suma_total_local DESC;

-- ----------------------------------------------------------------------------------------------
-- KPI 2: Distribución por Método de Pago
-- Pregunta de Negocio: ¿Qué métodos de pago generan el mayor volumen transaccional y financiero?
-- ----------------------------------------------------------------------------------------------
SELECT
	t.tipo_pago,
	COUNT(t.id_transaccion)AS total_transacciones,
    SUM(t.monto_total) AS suma_total
FROM vw_transacciones_limpias AS t
GROUP BY t.tipo_pago
ORDER BY suma_total DESC;
