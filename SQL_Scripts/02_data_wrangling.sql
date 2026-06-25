-- ==============================================================================
-- FASE 1: DIAGNÓSTICO Y PERFILAMIENTO DE DATOS (DATA PROFILING)
-- Objetivo: Auditar las 6 tablas de la Capa Bronce para detectar anomalías,
-- nulos, textos vacíos y validar rangos lógicos antes de la transformación.
-- ==============================================================================

USE retail_financiero;

-- 1. Auditoría: TABLA LOCALES
SELECT 
    'locales' AS tabla,
    COUNT(*) AS total_registros,
    SUM(CASE WHEN id_local IS NULL THEN 1 ELSE 0 END) AS nulos_id,
    SUM(CASE WHEN nombre_local IS NULL THEN 1 ELSE 0 END) AS nulos_nombre,
    SUM(CASE WHEN region IS NULL THEN 1 ELSE 0 END) AS nulos_region,
    SUM(CASE WHEN nombre_local LIKE ' %' OR nombre_local LIKE '% ' THEN 1 ELSE 0 END) AS espacios_nombre,
    SUM(CASE WHEN region LIKE ' %' OR region LIKE '% ' THEN 1 ELSE 0 END) AS espacios_region
FROM locales;

-- 2. Auditoría: TABLA PRODUCTOS
SELECT 
    'productos' AS tabla,
    COUNT(*) AS total_registros,
    SUM(CASE WHEN id_producto IS NULL THEN 1 ELSE 0 END) AS nulos_id,
    SUM(CASE WHEN costo_compra IS NULL THEN 1 ELSE 0 END) AS nulos_costo,
    SUM(CASE WHEN precio_venta IS NULL THEN 1 ELSE 0 END) AS nulos_precio_venta,
    SUM(CASE WHEN categoria IS NULL THEN 1 ELSE 0 END) AS nulos_categoria,
    SUM(CASE WHEN nombre_producto IS NULL THEN 1 ELSE 0 END) AS nulos_nombre,
    SUM(CASE WHEN categoria LIKE ' %' OR categoria LIKE '% ' THEN 1 ELSE 0 END) AS espacios_categoria,
    SUM(CASE WHEN nombre_producto LIKE ' %' OR nombre_producto LIKE '% ' THEN 1 ELSE 0 END) AS espacios_nombre,
    MIN(costo_compra) AS costo_min_detectado, 
    MIN(precio_venta) AS precio_venta_min_detectado,
    MAX(costo_compra) AS costo_max_detectado,
    MAX(precio_venta) AS precio_venta_max_detectado
FROM productos;

-- 3. Auditoría: TABLA INVENTARIO
SELECT 
    'inventario' AS tabla,
    COUNT(*) AS total_registros,
    SUM(CASE WHEN id_inventario IS NULL THEN 1 ELSE 0 END) AS nulos_id_inven,
    SUM(CASE WHEN id_local IS NULL THEN 1 ELSE 0 END) AS nulos_id_local,
    SUM(CASE WHEN id_producto IS NULL THEN 1 ELSE 0 END) AS nulos_id_produc,
    SUM(CASE WHEN stock_disponible IS NULL THEN 1 ELSE 0 END) AS nulos_stock,
    MIN(stock_disponible) AS stock_min_detectado, 
    MAX(stock_disponible) AS stock_max_detectado  
FROM inventario;

-- 4. Auditoría: TABLA DETALLE_TRANSACCIONES
SELECT
	'detalle_transacciones' AS tabla,
    COUNT(*) AS total_registros,
	SUM(CASE WHEN id_detalle IS null THEN 1 ELSE 0 END) AS nulos_id_detalle,
    SUM(CASE WHEN id_transaccion IS null THEN 1 ELSE 0 END) AS nulos_id_transaccion,
    SUM(CASE WHEN id_producto IS null THEN 1 ELSE 0 END) AS nulos_id_producto,
    SUM(CASE WHEN cantidad IS null THEN 1 ELSE 0 END) AS nulos_cantidad,
    SUM(CASE WHEN subtotal IS null THEN 1 ELSE 0 END) AS nulos_subtotal,
    MIN(cantidad) AS min_cantidad,
    MAX(cantidad) AS max_cantidad,
    MIN(subtotal) AS min_subtotal,
    MAX(subtotal) AS max_subtotal
FROM detalle_transacciones;

-- 5. Auditoría: TABLA CLIENTES_CREDITO (Evidencia de datos sucios)
SELECT 
    'clientes_credito' AS tabla,
    COUNT(*) AS total_registros,
    SUM(CASE WHEN id_cliente IS null THEN 1 ELSE 0 END) AS nulos_id_cliente,
    SUM(CASE WHEN nombre_completo LIKE ' %' OR nombre_completo LIKE '% ' THEN 1 ELSE 0 END) AS nombres_con_espacios,
    SUM(CASE WHEN nombre_completo IS null THEN 1 ELSE 0 END) AS nulos_nombre_completo,
    SUM(CASE WHEN fecha_nacimiento IS null THEN 1 ELSE 0 END) AS nulos_fecha_nacimiento,
    SUM(CASE WHEN TRIM(limite_credito) = '' THEN 1 ELSE 0 END) AS limite_credito_vacios,
    SUM(CASE WHEN limite_credito LIKE ' %' OR limite_credito LIKE '% ' THEN 1 ELSE 0 END) AS limite_credito_con_espacios,
    SUM(CASE WHEN limite_credito IS null THEN 1 ELSE 0 END) AS nulos_limite_credito,
    SUM(CASE WHEN deuda_actual IS null THEN 1 ELSE 0 END) AS nulos_deuda_actual,
    SUM(CASE WHEN estado_riesgo LIKE ' %' OR estado_riesgo LIKE '% ' THEN 1 ELSE 0 END) AS estados_con_espacios,
    SUM(CASE WHEN estado_riesgo IS null THEN 1 ELSE 0 END) AS nulos_estado_riesgo,
    MIN(deuda_actual) AS min_deuda_actual,
    MAX(deuda_actual) AS max_deuda_actual,
    MIN(fecha_nacimiento) AS min_fecha_nace,
    MAX(fecha_nacimiento) AS max_fecha_nace
FROM clientes_credito;

-- 6. Auditoría: TABLA TRANSACCIONES (Evidencia de datos sucios)
SELECT 
    'transacciones' AS tabla,
    COUNT(*) AS total_registros,
    SUM(CASE WHEN fecha_venta NOT LIKE '2025-%' OR LENGTH(fecha_venta) != 10 THEN 1 ELSE 0 END) AS fechas_fuera_de_formato_estandar,
    SUM(CASE WHEN tipo_pago LIKE ' %' OR tipo_pago LIKE '% ' THEN 1 ELSE 0 END) AS pagos_con_espacios
FROM transacciones;
