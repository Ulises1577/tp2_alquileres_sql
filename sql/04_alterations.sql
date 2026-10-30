-- =============================================================================
-- TRABAJO PRÁCTICO N° 2 SQL | BASE DE DATOS: RENTAL_CARS
-- Archivo: sql/04_alterations.sql
-- Motor: PostgreSQL
-- Descripción: Operaciones DML (Sección 3 del Trabajo Práctico).
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. NUEVO CLIENTE (Punto 1)
-- Inserta un cliente con licencia única y ciudad existente en la base de datos.
-- -----------------------------------------------------------------------------

INSERT INTO clientes (
    nombre,
    email,
    telefono,
    ciudad,
    fecha_registro,
    licencia_conducir
) VALUES (
    'Mariana Ruiz',
    'mariana.ruiz@gmail.com',
    '0115556677',
    'Buenos Aires',
    CURRENT_DATE,
    'ARG-998877'
);

-- -----------------------------------------------------------------------------
-- 2. ACTUALIZAR SALARIO (Punto 2)
-- Actualiza el salario a 200000.00 para los vendedores que ingresaron antes del 2021.
-- -----------------------------------------------------------------------------

UPDATE empleados
SET salario = 200000.00
WHERE cargo IN ('Vendedor', 'Vendedora')
  AND fecha_ingreso < '2021-01-01';

-- -----------------------------------------------------------------------------
-- 3. BORRAR VEHÍCULO (Punto 3)
-- Elimina un vehículo específico sin relaciones activas para mantener la integridad referencial.
-- En nuestros datos de prueba, el vehículo id = 8 (Fiat Cronos) no tiene alquileres ni reservas.
-- -----------------------------------------------------------------------------

DELETE FROM vehiculos
WHERE id = 8;

-- -----------------------------------------------------------------------------
-- 4. CAMBIO DE SUCURSAL (Punto 4)
-- Traslada un vehículo específico (id = 5, Toyota Hilux) a la Sucursal Aeroparque (id = 2).
-- -----------------------------------------------------------------------------

UPDATE vehiculos
SET id_sucursal = 2
WHERE id = 5;