-- ==============================================================================
-- PROYECTO: RETAIL FINANCIERO & RIESGO CREDITICIO
-- ARCHIVO: 01_setup_database.sql
-- OBJETIVO: Creación de la base de datos, cracion de las tablas y integración de datos "sucios"
-- ==============================================================================
-- CREACION DE LA BASE DE DATOS
CREATE DATABASE retail_financiero;

-- USAMOS LA BASE DE DATOS
USE retail_financiero;
  
-- 1. CREACIÓN DE TABLAS (Arquitectura)
CREATE TABLE locales (
    id_local INT PRIMARY KEY,
    nombre_local VARCHAR(100),
    region VARCHAR(100)
);

CREATE TABLE clientes_credito (
    id_cliente INT PRIMARY KEY,
    nombre_completo VARCHAR(150),
    limite_credito DECIMAL(10,2),
    estado_riesgo VARCHAR(50)
);

CREATE TABLE transacciones_pos (
    id_transaccion INT PRIMARY KEY,
    id_local INT,
    id_cliente INT, -- Puede ser NULL si el cliente compró en efectivo
    fecha_venta VARCHAR(50), -- Guardado como texto intencionalmente
    monto_total DECIMAL(10,2),
    tipo_pago VARCHAR(50)
);

-- 2. INYECCIÓN DE DATOS (Con basura intencional para posterior Data Wrangling)

-- Locales (Datos Relativamente limpios)
INSERT INTO locales (id_local, nombre_local, region) VALUES
(1, 'Sucursal Valparaiso Centro', 'Valparaiso'),
(2, 'Sucursal Vina del Mar Norte', 'Valparaiso'),
(3, 'Sucursal Rancagua Sur', 'O Higgins'),
(4, 'Bodega Central Stgo', 'Metropolitana');

-- Clientes (Datos sucios)
INSERT INTO clientes_credito (id_cliente, nombre_completo, limite_credito, estado_riesgo) VALUES
(101, '  JUAN PEREZ  ', 500000.00, 'Al dia'),
(102, 'maria gonzalez', 150000.00, 'MOROSO'),
(103, 'Carlos tapia', NULL, ' al dia '), -- Límite nulo, espacios extra
(104, 'ANDREA Silva', 800000.00, 'Castigado'),
(105, '   luis Morales', 250000.00, 'MOROSO');

-- Transacciones (Fechas rotas, nulos y errores de tipeo)
INSERT INTO transacciones_pos (id_transaccion, id_local, id_cliente, fecha_venta, monto_total, tipo_pago) VALUES
(1001, 1, 101, '15/05/2025', 45000.50, 'Credito Tienda'),
(1002, 3, NULL, '16-05-2025', 12500.00, 'Efectivo '), -- Cliente anónimo
(1003, 2, 102, '2025-05-17', 200000.00, 'Credito Tienda'), -- Monto supera el límite del cliente 102
(1004, 1, 104, '18 mayo 25', 15000.00, '  EFECTIVO'), -- Fecha inservible
(1005, 4, 105, '19/05/2025', NULL, 'Credito Tienda'); -- Fuga de información (Monto nulo)
