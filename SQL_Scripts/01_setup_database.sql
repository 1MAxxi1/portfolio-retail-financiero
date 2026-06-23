-- ==============================================================================
-- PROYECTO: RETAIL FINANCIERO & LOGÍSTICA
-- ARCHIVO: 01_setup_database.sql
-- OBJETIVO: Creación de la base de datos e integración de datos
-- ==============================================================================

CREATE DATABASE retail_financiero;
USE retail_financiero;

-- ==============================================================================
-- 1. TABLAS DE DIMENSIONES (Independientes)
-- ==============================================================================

CREATE TABLE locales (
    id_local INT PRIMARY KEY,
    nombre_local VARCHAR(100),
    region VARCHAR(100)
);

CREATE TABLE clientes_credito (
    id_cliente INT PRIMARY KEY,
    nombre_completo VARCHAR(150),
    fecha_nacimiento DATE,       
    limite_credito VARCHAR(100),
    deuda_actual DECIMAL(10,2),  
    estado_riesgo VARCHAR(50)
);

-- ==============================================================================
-- INYECCIÓN POR DEFECTO: CLIENTE ANÓNIMO (Metodología Kimball)
-- Evita nulos en la tabla de hechos para mantener la integridad financiera
-- ==============================================================================
INSERT INTO clientes_credito (id_cliente, nombre_completo, fecha_nacimiento, limite_credito, deuda_actual, estado_riesgo) 
VALUES (9999, 'CLIENTE ANONIMO', '1900-01-01', 0.00, 0.00, 'SIN RIESGO');

CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    categoria VARCHAR(100),
    nombre_producto VARCHAR(150),
    costo_compra DECIMAL(10,2),  
    precio_venta DECIMAL(10,2)   
);

-- ==============================================================================
-- 2. TABLAS DE HECHOS (Dependientes)
-- ==============================================================================

CREATE TABLE inventario (
    id_inventario INT PRIMARY KEY,
    id_local INT,
    id_producto INT,
    stock_disponible INT,
    FOREIGN KEY (id_local) REFERENCES locales(id_local),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

CREATE TABLE transacciones (
    id_transaccion INT PRIMARY KEY,
    id_local INT,
    id_cliente INT, 
    fecha_venta VARCHAR(50), 
    monto_total DECIMAL(10,2),
    tipo_pago VARCHAR(50),       -- 'Debito', 'Efectivo', 'Credito Tienda'
    cantidad_cuotas INT,         -- NUEVO: La genialidad que propusiste
    FOREIGN KEY (id_local) REFERENCES locales(id_local),
    FOREIGN KEY (id_cliente) REFERENCES clientes_credito(id_cliente)
);

CREATE TABLE detalle_transacciones (
    id_detalle INT PRIMARY KEY,
    id_transaccion INT,
    id_producto INT,
    cantidad INT,
    subtotal DECIMAL(10,2), 
    FOREIGN KEY (id_transaccion) REFERENCES transacciones(id_transaccion),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);
