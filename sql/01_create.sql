-- =============================================================================
-- TRABAJO PRÁCTICO N° 2 SQL | BASE DE DATOS: RENTAL_CARS
-- Archivo: sql/01_create.sql
-- Motor: PostgreSQL
-- Descripción: Creación de la base de datos y esquemas de tablas con sus PK/FK.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. CREACIÓN DE LA BASE DE DATOS (Punto 1)
-- -----------------------------------------------------------------------------
-- Nota: En PostgreSQL, la sentencia CREATE DATABASE se ejecuta de forma independiente
-- o mediante la inicialización del contenedor en Docker.

CREATE DATABASE rental_cars;

-- Conectarse a la base de datos en psql (opcional según el cliente SQL utilizado):
-- \c rental_cars;

-- -----------------------------------------------------------------------------
-- 2. ELIMINACIÓN PREVIA DE TABLAS (Limpia el esquema en orden inverso de FK)
-- -----------------------------------------------------------------------------

DROP TABLE IF EXISTS multas CASCADE;
DROP TABLE IF EXISTS check_alquiler CASCADE;
DROP TABLE IF EXISTS pagos CASCADE;
DROP TABLE IF EXISTS seguros CASCADE;
DROP TABLE IF EXISTS alquileres CASCADE;
DROP TABLE IF EXISTS mantenimientos CASCADE;
DROP TABLE IF EXISTS reservas CASCADE;
DROP TABLE IF EXISTS vehiculos CASCADE;
DROP TABLE IF EXISTS empleados CASCADE;
DROP TABLE IF EXISTS clientes CASCADE;
DROP TABLE IF EXISTS sucursales CASCADE;
DROP TABLE IF EXISTS categorias CASCADE;

-- -----------------------------------------------------------------------------
-- 3. CREACIÓN DE TABLAS - NIVEL 0 (Sin Claves Foráneas)
-- -----------------------------------------------------------------------------

-- Tabla: CATEGORIAS
CREATE TABLE categorias (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(120)
);

-- Tabla: SUCURSALES
CREATE TABLE sucursales (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    direccion VARCHAR(120) NOT NULL,
    ciudad VARCHAR(50) NOT NULL,
    telefono VARCHAR(30)
);

-- Tabla: CLIENTES
CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    telefono VARCHAR(50),
    ciudad VARCHAR(50) NOT NULL,
    fecha_registro DATE NOT NULL DEFAULT CURRENT_DATE,
    licencia_conducir VARCHAR(30) NOT NULL UNIQUE
);

-- -----------------------------------------------------------------------------
-- 4. CREACIÓN DE TABLAS - NIVEL 1 (Dependen del Nivel 0)
-- -----------------------------------------------------------------------------

-- Tabla: EMPLEADOS
CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    cargo VARCHAR(50) NOT NULL,
    id_sucursal INT NOT NULL,
    fecha_ingreso DATE NOT NULL,
    salario DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_empleados_sucursal FOREIGN KEY (id_sucursal) REFERENCES sucursales(id)
);

-- Tabla: VEHICULOS
CREATE TABLE vehiculos (
    id SERIAL PRIMARY KEY,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    anio INT NOT NULL,
    precio_dia DECIMAL(9,2) NOT NULL,
    estado BOOLEAN NOT NULL DEFAULT TRUE, -- TRUE: disponible, FALSE: no disponible / alquilado
    id_categoria INT NOT NULL,
    id_sucursal INT NOT NULL,
    patente VARCHAR(15) NOT NULL UNIQUE,
    km_actual INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_vehiculos_categoria FOREIGN KEY (id_categoria) REFERENCES categorias(id),
    CONSTRAINT fk_vehiculos_sucursal FOREIGN KEY (id_sucursal) REFERENCES sucursales(id)
);

-- -----------------------------------------------------------------------------
-- 5. CREACIÓN DE TABLAS - NIVEL 2 (Dependen de Vehículos, Clientes y Empleados)
-- -----------------------------------------------------------------------------

-- Tabla: RESERVAS
CREATE TABLE reservas (
    id SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_vehiculo INT NOT NULL,
    fecha_reserva DATE NOT NULL DEFAULT CURRENT_DATE,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'pendiente',
    CONSTRAINT fk_reservas_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id),
    CONSTRAINT fk_reservas_vehiculo FOREIGN KEY (id_vehiculo) REFERENCES vehiculos(id)
);

-- Tabla: MANTENIMIENTOS
CREATE TABLE mantenimientos (
    id SERIAL PRIMARY KEY,
    id_vehiculo INT NOT NULL,
    fecha DATE NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    costo DECIMAL(9,2) NOT NULL,
    observaciones VARCHAR(200),
    CONSTRAINT fk_mantenimientos_vehiculo FOREIGN KEY (id_vehiculo) REFERENCES vehiculos(id)
);

-- Tabla: ALQUILERES
CREATE TABLE alquileres (
    id_alquiler SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_vehiculo INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    total DECIMAL(9,2) NOT NULL,
    id_empleado INT NOT NULL,
    id_sucursal_retiro INT NOT NULL,
    id_sucursal_devolucion INT NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'activo',
    CONSTRAINT fk_alquileres_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id),
    CONSTRAINT fk_alquileres_vehiculo FOREIGN KEY (id_vehiculo) REFERENCES vehiculos(id),
    CONSTRAINT fk_alquileres_empleado FOREIGN KEY (id_empleado) REFERENCES empleados(id),
    CONSTRAINT fk_alquileres_sucursal_retiro FOREIGN KEY (id_sucursal_retiro) REFERENCES sucursales(id),
    CONSTRAINT fk_alquileres_sucursal_devolucion FOREIGN KEY (id_sucursal_devolucion) REFERENCES sucursales(id)
);

-- -----------------------------------------------------------------------------
-- 6. CREACIÓN DE TABLAS - NIVEL 3 (Dependen de ALQUILERES)
-- -----------------------------------------------------------------------------

-- Tabla: SEGUROS
CREATE TABLE seguros (
    id SERIAL PRIMARY KEY,
    id_alquiler INT NOT NULL,
    compania VARCHAR(80) NOT NULL,
    numero_poliza VARCHAR(50) NOT NULL,
    cobertura VARCHAR(100) NOT NULL,
    costo DECIMAL(9,2) NOT NULL,
    CONSTRAINT fk_seguros_alquiler FOREIGN KEY (id_alquiler) REFERENCES alquileres(id_alquiler)
);

-- Tabla: PAGOS
CREATE TABLE pagos (
    id SERIAL PRIMARY KEY,
    id_alquiler INT NOT NULL,
    fecha_pago DATE NOT NULL DEFAULT CURRENT_DATE,
    monto DECIMAL(9,2) NOT NULL,
    CONSTRAINT fk_pagos_alquiler FOREIGN KEY (id_alquiler) REFERENCES alquileres(id_alquiler)
);

-- Tabla: CHECK_ALQUILER
CREATE TABLE check_alquiler (
    id SERIAL PRIMARY KEY,
    id_alquiler INT NOT NULL,
    tipo VARCHAR(10) NOT NULL, -- 'salida' o 'entrada'
    fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    km INT NOT NULL,
    nivel_combustible INT NOT NULL,
    CONSTRAINT fk_check_alquiler FOREIGN KEY (id_alquiler) REFERENCES alquileres(id_alquiler)
);

-- Tabla: MULTAS
CREATE TABLE multas (
    id SERIAL PRIMARY KEY,
    id_alquiler INT NOT NULL,
    fecha DATE NOT NULL DEFAULT CURRENT_DATE,
    motivo VARCHAR(120) NOT NULL,
    monto DECIMAL(9,2) NOT NULL,
    pagada BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT fk_multas_alquiler FOREIGN KEY (id_alquiler) REFERENCES alquileres(id_alquiler)
);