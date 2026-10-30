-- =============================================================================
-- TRABAJO PRÁCTICO N° 2 SQL | BASE DE DATOS: RENTAL_CARS
-- Archivo: sql/06_views.sql
-- Motor: PostgreSQL
-- Descripción: Definición de Vistas (Sección 4 del Trabajo Práctico).
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. VISTA: vw_alquileres_detalle (Punto 1)
-- Muestra la información de los alquileres de forma legible reemplazando los IDs
-- numéricos por nombres de clientes, empleados, vehículos y sucursales.
-- -----------------------------------------------------------------------------

CREATE OR REPLACE VIEW vw_alquileres_detalle AS
SELECT
    a.id_alquiler,
    a.fecha_inicio,
    a.fecha_fin,
    c.nombre AS cliente,
    CONCAT(v.marca, ' ', v.modelo) AS vehiculo,
    e.nombre AS empleado_gestor,
    sr.nombre AS sucursal_retiro,
    sd.nombre AS sucursal_devolucion,
    a.total
FROM alquileres a
INNER JOIN clientes c ON a.id_cliente = c.id
INNER JOIN vehiculos v ON a.id_vehiculo = v.id
INNER JOIN empleados e ON a.id_empleado = e.id
INNER JOIN sucursales sr ON a.id_sucursal_retiro = sr.id
INNER JOIN sucursales sd ON a.id_sucursal_devolucion = sd.id;

-- -----------------------------------------------------------------------------
-- 2. VISTA: vw_vehiculos_por_sucursal (Punto 2)
-- Muestra el nombre de la sucursal, la ciudad y la cantidad total de vehículos.
-- Incluye sucursales sin flota asignada mediante LEFT JOIN.
-- -----------------------------------------------------------------------------

CREATE OR REPLACE VIEW vw_vehiculos_por_sucursal AS
SELECT
    s.nombre AS sucursal,
    s.ciudad,
    COUNT(v.id) AS total_vehiculos
FROM sucursales s
LEFT JOIN vehiculos v ON s.id = v.id_sucursal
GROUP BY s.id, s.nombre, s.ciudad;

-- -----------------------------------------------------------------------------
-- 3. VISTA: vw_ingresos_por_categoria (Punto 3)
-- Muestra la categoría, cantidad de alquileres finalizados y el monto total
-- facturado. Se consideran únicamente alquileres en estado 'finalizado'.
-- -----------------------------------------------------------------------------

CREATE OR REPLACE VIEW vw_ingresos_por_categoria AS
SELECT
    cat.nombre AS categoria,
    COUNT(a.id_alquiler) AS cantidad_alquileres_finalizados,
    COALESCE(SUM(a.total), 0.00) AS total_facturado
FROM categorias cat
LEFT JOIN vehiculos v ON cat.id = v.id_categoria
LEFT JOIN alquileres a ON v.id = a.id_vehiculo AND a.estado = 'finalizado'
GROUP BY cat.id, cat.nombre;