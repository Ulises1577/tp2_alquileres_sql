-- Active: 1793381682276@@127.0.0.1@5432@rental_cars
-- =============================================================================
-- TRABAJO PRÁCTICO N° 2 SQL | BASE DE DATOS: RENTAL_CARS
-- Archivo: sql/02_inserts.sql
-- Motor: PostgreSQL
-- Descripción: Inserción de datos de prueba en todas las tablas del esquema.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. INSERCIÓN EN TABLAS MAESTRAS (Nivel 0)
-- -----------------------------------------------------------------------------

-- Tabla: CATEGORIAS
INSERT INTO categorias (nombre, descripcion) 
VALUES 
    ('Económico', 'Autos compactos de bajo consumo de combustible'),
    ('SUV', 'Vehículos utilitarios deportivos de gran capacidad y confort'),
    ('Sedán', 'Autos medianos ideales para viajes ejecutivos o familiares'),
    ('Camioneta', 'Vehículos de carga y terreno mixto para trabajo pesado'),
    ('Lujo', 'Autos de alta gama, deportivos e híbridos');

-- Tabla: SUCURSALES
INSERT INTO sucursales (nombre, direccion, ciudad, telefono) 
VALUES 
    ('Sucursal Centro', 'Av. Corrientes 1234', 'Buenos Aires', '011-4321-0001'),
    ('Sucursal Aeroparque', 'Av. Costanera Rafael Obligado s/n', 'Buenos Aires', '011-4321-0002'),
    ('Sucursal Córdoba Norte', 'Av. Colón 500', 'Córdoba', '0351-420-0001'),
    ('Sucursal Mendoza Centro', 'Av. San Martín 800', 'Mendoza', '0261-410-0001');

-- Tabla: CLIENTES
INSERT INTO clientes (nombre, email, telefono, ciudad, fecha_registro, licencia_conducir) 
VALUES 
    ('Lucas Gómez', 'lucas.gomez@gmail.com', '1155551111', 'Buenos Aires', '2024-09-15', 'ARG-112233'),
    ('Laura Fernández', 'laura.f@hotmail.com', '1155552222', 'Buenos Aires', '2024-09-20', 'ARG-445566'),
    ('Carlos Rodríguez', 'carlos.rod@yahoo.com', '0351555333', 'Córdoba', '2024-01-10', 'ARG-778899'),
    ('María López', 'mlopez@gmail.com', '0261555444', 'Mendoza', '2023-11-05', 'ARG-990011'),
    ('Juan Pérez', 'juan.perez@gmail.com', '1155555555', 'Buenos Aires', '2024-08-01', 'ARG-223344');

-- -----------------------------------------------------------------------------
-- 2. INSERCIÓN EN TABLAS DE NIVEL 1
-- -----------------------------------------------------------------------------

-- Tabla: EMPLEADOS
INSERT INTO empleados (nombre, cargo, id_sucursal, fecha_ingreso, salario) 
VALUES 
    ('Lucas Martínez', 'Vendedor', 1, '2020-05-10', 180000.00),
    ('Laura Benítez', 'Vendedora', 2, '2019-03-15', 175000.00),
    ('Leonardo Silva', 'Gerente', 1, '2018-01-01', 350000.00),
    ('Martín Rossi', 'Vendedor', 3, '2022-06-01', 180000.00),
    ('Sofía Castro', 'Atención al Cliente', 4, '2023-02-15', 190000.00);

-- Tabla: VEHICULOS
INSERT INTO vehiculos (marca, modelo, anio, precio_dia, estado, id_categoria, id_sucursal, patente, km_actual) 
VALUES 
    ('Chevrolet', 'Corsa', 2012, 25000.00, TRUE, 1, 1, 'AA123BB', 120000), -- Más antiguo
    ('Toyota', 'RAV4', 2022, 65000.00, FALSE, 2, 1, 'AF456CD', 35000),  -- Categoría 2 (SUV)
    ('Jeep', 'Cherokee', 2023, 75000.00, FALSE, 2, 2, 'AG789EF', 20000), -- Categoría 2 (SUV)
    ('Ford', 'Focus', 2020, 38000.00, TRUE, 3, 3, 'AD012GH', 60000),
    ('Toyota', 'Hilux', 2024, 95000.00, TRUE, 4, 4, 'AG345IJ', 10000),
    ('BMW', 'Serie 3', 2024, 120000.00, FALSE, 5, 1, 'AG678KL', 5000),  -- Precio más alto #1
    ('Audi', 'Q5', 2023, 110000.00, TRUE, 5, 2, 'AG901MN', 8000),       -- Precio más alto #2
    ('Fiat', 'Cronos', 2021, 28000.00, TRUE, 1, 1, 'AE234OP', 45000);   -- Nunca alquilado

-- -----------------------------------------------------------------------------
-- 3. INSERCIÓN EN TABLAS TRANSACCIONALES (Nivel 2)
-- -----------------------------------------------------------------------------

-- Tabla: RESERVAS
INSERT INTO reservas (id_cliente, id_vehiculo, fecha_reserva, fecha_inicio, fecha_fin, estado) 
VALUES 
    (1, 2, '2024-10-01', '2024-10-10', '2024-10-15', 'confirmada'),
    (3, 4, '2024-10-05', '2024-10-20', '2024-10-25', 'pendiente');

-- Tabla: MANTENIMIENTOS
INSERT INTO mantenimientos (id_vehiculo, fecha, tipo, costo, observaciones) 
VALUES 
    (1, '2024-05-10', 'Cambio de Aceite', 25000.00, 'Filtro y aceite sintético reemplazados'),
    (3, '2024-08-15', 'Alineación y Balanceo', 18000.00, 'Rotación completa de neumáticos');

-- Tabla: ALQUILERES
INSERT INTO alquileres (id_cliente, id_vehiculo, fecha_inicio, fecha_fin, total, id_empleado, id_sucursal_retiro, id_sucursal_devolucion, estado) 
VALUES 
    (1, 2, '2024-10-01', '2024-10-05', 260000.00, 1, 1, 1, 'activo'),     -- Octubre 2024 / Activo
    (1, 3, '2024-10-10', '2024-10-15', 375000.00, 1, 1, 2, 'activo'),     -- Retiro != Devolución, Cliente 1 con >1 alquiler
    (2, 1, '2024-09-01', '2024-09-05', 100000.00, 2, 2, 2, 'finalizado'), -- Finalizado (para vistas)
    (3, 5, '2024-09-10', '2024-09-15', 475000.00, 3, 3, 3, 'finalizado'),
    (4, 6, '2024-10-02', '2024-10-06', 480000.00, 2, 1, 1, 'activo');     -- Octubre 2024 / Activo

-- -----------------------------------------------------------------------------
-- 4. INSERCIÓN EN TABLAS SATÉLITE DE ALQUILERES (Nivel 3)
-- -----------------------------------------------------------------------------

-- Tabla: SEGUROS
INSERT INTO seguros (id_alquiler, compania, numero_poliza, cobertura, costo) 
VALUES 
    (1, 'La Segunda', 'POL-1001', 'Cobertura Total contra Todo Riesgo', 15000.00),
    (2, 'Sancor Seguros', 'POL-1002', 'Terceros Completo', 10000.00),
    (3, 'Federación Patronal', 'POL-1003', 'Básica', 8000.00);

-- Tabla: PAGOS
INSERT INTO pagos (id_alquiler, fecha_pago, monto) 
VALUES 
    (1, '2024-10-01', 130000.00),
    (2, '2024-10-10', 375000.00),
    (3, '2024-09-01', 100000.00);

-- Tabla: CHECK_ALQUILER
INSERT INTO check_alquiler (id_alquiler, tipo, fecha, km, nivel_combustible) 
VALUES 
    (1, 'salida', '2024-10-01 09:00:00', 35000, 100),
    (1, 'entrada', '2024-10-05 18:00:00', 35600, 90),
    (3, 'salida', '2024-09-01 10:00:00', 120000, 100),
    (3, 'entrada', '2024-09-05 17:00:00', 120450, 100);

-- Tabla: MULTAS
INSERT INTO multas (id_alquiler, fecha, motivo, monto, pagada) 
VALUES 
    (1, '2024-10-03', 'Exceso de velocidad en Ruta 2', 15000.00, TRUE),
    (2, '2024-10-12', 'Estacionamiento en zona prohibida', 8000.00, TRUE),
    (3, '2024-09-04', 'Devolución fuera de horario pactado', 5000.00, FALSE);