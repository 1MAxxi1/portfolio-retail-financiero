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

-- ----------------------------------------------------------------------------------------------
-- KPI 3: Exposición de Deuda por Nivel de Riesgo
-- Pregunta de Negocio: ¿Cuánto capital tenemos en riesgo según el estado de nuestros deudores?
-- ----------------------------------------------------------------------------------------------
SELECT
	V.estado_riesgo,
    COUNT(V.id_cliente) AS volumen_deudores,
    SUM(v.deuda_actual) AS deuda_total
FROM vw_clientes_credito_limpios AS V
GROUP BY v.estado_riesgo
ORDER BY deuda_total DESC; 

-- ----------------------------------------------------------------------------------------------
-- KPI 4: Tasa de Utilización de Crédito
-- Pregunta de Negocio: ¿Qué porcentaje de su límite de crédito están utilizando los clientes según su riesgo?
-- ----------------------------------------------------------------------------------------------
SELECT
    v.estado_riesgo,
    SUM(v.limite_credito) AS suma_limite_credito,
    SUM(v.deuda_actual) AS deuda_total,
    CONCAT(ROUND((SUM(v.deuda_actual) / NULLIF(SUM(v.limite_credito), 0)) * 100, 1), '%') AS utilizacion
FROM vw_clientes_credito_limpios AS v
GROUP BY v.estado_riesgo
ORDER BY (SUM(v.deuda_actual) / NULLIF(SUM(v.limite_credito), 0)) DESC;

-- ==============================================================================================
-- BLOQUE 3: GESTIÓN DE PRODUCTOS E INVENTARIO 
-- Objetivo: Identificar quiebres de stock y optimizar la distribución del almacén.
-- ==============================================================================================
-- ----------------------------------------------------------------------------------------------
-- KPI 5: Alerta de Quiebre de Stock (Stock Crítico)
-- Pregunta de Negocio: ¿Qué productos están a punto de agotarse y cuánto capital representan?
-- ----------------------------------------------------------------------------------------------
SELECT
	l.nombre_local,
    i.stock_disponible,
    p.nombre_producto,
    p.costo_compra,
    (i.stock_disponible * p.costo_compra) AS capital_inmovilizado
FROM inventario AS i 
JOIN locales AS l ON l.id_local = i.id_local
JOIN productos AS p ON i.id_producto = p.id_producto
WHERE i.stock_disponible < 15
ORDER BY i.stock_disponible ASC;

-- ----------------------------------------------------------------------------------------------
-- KPI 6: Rentabilidad y Margen por Producto
-- Pregunta de Negocio: ¿Cuáles son nuestros productos estrella que dejan el mayor margen de utilidad?
-- ----------------------------------------------------------------------------------------------
SELECT
	p.nombre_producto,
    p.costo_compra,
    p.precio_venta,
    (p.precio_venta - p.costo_compra) AS ganancia_neta,
    ROUND(((p.precio_venta - p.costo_compra) / NULLIF(p.costo_compra, 0) * 100), 1) AS margen_porcentual_ganancia
FROM productos AS p
ORDER BY ganancia_neta DESC;

-- ==============================================================================================
-- BLOQUE 4: COMPORTAMIENTO Y SEGMENTACIÓN DE CLIENTES
-- Objetivo: Identificar a los consumidores de alto valor para estrategias de fidelización.
-- ==============================================================================================
-- ----------------------------------------------------------------------------------------------
-- KPI 7: Ranking de Clientes VIP (Top Compradores)
-- Pregunta de Negocio: ¿Quiénes son los 10 clientes que más ingresos generan y cuál es su frecuencia?
-- ----------------------------------------------------------------------------------------------
SELECT
	c.id_cliente,
    c.nombre_completo,
    COUNT(t.id_transaccion) AS frecuencia_compra,
    SUM(t.monto_total) AS volumen_gastado
FROM vw_clientes_credito_limpios AS c 
JOIN vw_transacciones_limpias AS t ON c.id_cliente = t.id_cliente
GROUP BY c.id_cliente, c.nombre_completo
ORDER BY volumen_gastado DESC
LIMIT 10;

-- ----------------------------------------------------------------------------------------------
-- KPI 8: Segmentación de Clientes por Valor (Tiers)
-- Pregunta de Negocio: ¿Cómo se distribuye nuestra cartera de clientes según su nivel de gasto histórico?
-- ----------------------------------------------------------------------------------------------
SELECT 
    tipo_cliente,
    COUNT(id_cliente) AS cantidad_clientes,
    SUM(total_gastado) AS ingresos_por_segmento
FROM (
    SELECT 
        c.id_cliente,
        SUM(t.monto_total) AS total_gastado,
        CASE 
            WHEN SUM(t.monto_total) >= 900000 THEN 'VIP'
            WHEN SUM(t.monto_total) >= 500000 THEN 'Regular'
            ELSE 'Esporádico'
        END AS tipo_cliente
    FROM vw_clientes_credito_limpios AS c
    JOIN vw_transacciones_limpias AS t ON c.id_cliente = t.id_cliente
    GROUP BY c.id_cliente
) AS subconsulta_segmentacion 
GROUP BY tipo_cliente
ORDER BY tipo_cliente DESC;

-- ==============================================================================================
-- BLOQUE 5: SQL AVANZADO (WINDOW FUNCTIONS Y CTEs)
-- Objetivo: Demostrar dominio en funciones de ventana y expresiones de tabla comunes para análisis complejos.
-- ==============================================================================================
-- ----------------------------------------------------------------------------------------------
-- KPI 9: Top 3 Clientes por Sucursal (Ranking Regional)
-- Pregunta de Negocio: ¿Quiénes son los 3 clientes más valiosos en cada uno de nuestros locales?
-- ----------------------------------------------------------------------------------------------
WITH GastoPorClienteLocal AS(
    SELECT
    	l.nombre_local,
    	c.nombre_completo,
    	SUM(t.monto_total) AS gastado_total_cliente,
    	DENSE_RANK() OVER (PARTITION BY l.nombre_local ORDER BY SUM(T.monto_total) DESC) AS ranking_local
    FROM vw_clientes_credito_limpios AS c 
    JOIN vw_transacciones_limpias AS t ON c.id_cliente = t.id_cliente
    JOIN locales AS l ON t.id_local = l.id_local
    GROUP BY c.nombre_completo, l.nombre_local
)
SELECT *
FROM GastoPorClienteLocal
WHERE ranking_local <= 3
ORDER BY nombre_local ASC, ranking_local ASC;

-- ----------------------------------------------------------------------------------------------
-- KPI 10: Crecimiento Mes a Mes (Inteligencia de Tiempo)
-- Pregunta de Negocio: ¿Cuál es la tendencia de nuestros ingresos mensuales y nuestro % de crecimiento?
-- ----------------------------------------------------------------------------------------------
WITH VentasMensuales AS (
    SELECT 
        DATE_FORMAT(fecha_venta, '%Y-%m') AS mes_venta,
        SUM(monto_total) AS ingresos_del_mes
    FROM vw_transacciones_limpias
    WHERE fecha_venta IS NOT NULL 
    GROUP BY DATE_FORMAT(fecha_venta, '%Y-%m')
)
SELECT 
    mes_venta,
    ingresos_del_mes,
    LAG(ingresos_del_mes, 1) OVER (ORDER BY mes_venta) AS ingresos_mes_anterior,
    ROUND(
        ((ingresos_del_mes - LAG(ingresos_del_mes, 1) OVER (ORDER BY mes_venta)) 
        / NULLIF(LAG(ingresos_del_mes, 1) OVER (ORDER BY mes_venta), 0)) * 100,1) AS porcentaje_crecimiento
FROM VentasMensuales
ORDER BY mes_venta ASC;




