-- ==============================================================================
-- PROYECTO: RETAIL FINANCIERO & RIESGO CREDITICIO
-- ARCHIVO: 02_data_wrangling.sql
-- OBJETIVO: Limpieza, estandarización y preparación de datos crudos (ETL)
-- ==============================================================================

USE retail_financiero;

-- ------------------------------------------------------------------------------
-- TICKET 1: Estandarización de Cartera de Clientes
-- Regla de Negocio: Nombres estandarizados sin espacios, mayúsculas uniformes 
-- y control de valores nulos en el límite de crédito (forzados a 0.00)
-- Estado de Riesgo sin espacios y con mayúsculas.
-- ------------------------------------------------------------------------------

CREATE VIEW vw_clientes_limpios AS
SELECT 
    id_cliente, 
    UPPER(TRIM(nombre_completo)) AS nombre_completo_corregido, 
    IFNULL(limite_credito, 0) AS limite_credito_corregido, 
    UPPER(TRIM(estado_riesgo)) AS estado_riesgo_corregido 
FROM clientes_credito;
