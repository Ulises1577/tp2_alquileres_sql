-- =============================================================================
-- TRABAJO PRÁCTICO N° 2 SQL | BASE DE DATOS: RENTAL_CARS
-- Archivo: sql/03_queries.sql
-- Motor: PostgreSQL
-- Descripción: Resolución de las 20 consultas de selección (Sección 2).
-- =============================================================================

-- 1. Marca, modelo y año de todos los vehículos, ordenados del más antiguo al más nuevo.
SELECT
    marca,
    modelo,
    anio
FROM vehiculos
ORDER BY anio ASC;

-- 2. Nombre, email y ciudad de todos los clientes registrados el mes anterior.
-- Nota: Utiliza las funciones de fecha de PostgreSQL para calcular el mes anterior dinámicamente.
SELECT
    nombre,
    email,
    ciudad
FROM clientes
WHERE fecha_registro >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
  AND fecha_registro <  DATE_TRUNC('month', CURRENT_DATE);

-- 3. Marca, modelo y precio por día de los vehículos de la categoría con id = 2.
SELECT
    marca,
    modelo,
    precio_dia
FROM vehiculos
WHERE id_categoria = 2;

-- 4. Todos los datos de los empleados cuyo nombre comience con la letra "L".
SELECT
    id,
    nombre,
    cargo,
    id_sucursal,
    fecha_ingreso,
    salario
FROM empleados
WHERE nombre LIKE 'L%';

-- 5. Nombre y cargo de los empleados cuyo salario sea distinto a 180000.00.
SELECT
    nombre,
    cargo
FROM empleados
WHERE salario <> 180000.00;

-- 6. Marca y modelo del vehículo junto con el nombre de su categoría.
SELECT
    v.marca,
    v.modelo,
    c.nombre AS categoria
FROM vehiculos v
INNER JOIN categorias c ON v.id_categoria = c.id;

-- 7. Consulta combinada con fecha de inicio, cliente, vehículo y empleado que atendió.
SELECT
    a.fecha_inicio,
    cli.nombre AS nombre_cliente,
    CONCAT(v.marca, ' ', v.modelo) AS vehiculo,
    e.nombre AS nombre_empleado
FROM alquileres a
INNER JOIN clientes cli ON a.id_cliente = cli.id
INNER JOIN vehiculos v ON a.id_vehiculo = v.id
INNER JOIN empleados e ON a.id_empleado = e.id;

-- 8. Nombre del cliente, su ciudad y fecha de registro.
SELECT
    nombre,
    ciudad,
    fecha_registro
FROM clientes;

-- 9. Marca y modelo del vehículo junto con el nombre de la sucursal y la ciudad donde se encuentra.
SELECT
    v.marca,
    v.modelo,
    s.nombre AS sucursal,
    s.ciudad
FROM vehiculos v
INNER JOIN sucursales s ON v.id_sucursal = s.id;

-- 10. Alquileres indicando el nombre de la sucursal de retiro y la de devolución.
SELECT
    a.id_alquiler,
    sr.nombre AS sucursal_retiro,
    sd.nombre AS sucursal_devolucion
FROM alquileres a
INNER JOIN sucursales sr ON a.id_sucursal_retiro = sr.id
INNER JOIN sucursales sd ON a.id_sucursal_devolucion = sd.id;

-- 11. Cantidad de vehículos registrados por cada categoría (incluyendo categorías sin vehículos).
SELECT
    c.nombre AS categoria,
    COUNT(v.id) AS cantidad_vehiculos
FROM categorias c
LEFT JOIN vehiculos v ON c.id = v.id_categoria
GROUP BY c.id, c.nombre;

-- 12. Precio promedio por día de los vehículos agrupados por categoría.
SELECT
    c.nombre AS categoria,
    ROUND(AVG(v.precio_dia), 2) AS precio_promedio_dia
FROM categorias c
INNER JOIN vehiculos v ON c.id = v.id_categoria
GROUP BY c.id, c.nombre;

-- 13. Nombre del empleado y cuántos alquileres ha gestionado en total (orden de mayor a menor).
SELECT
    e.nombre AS empleado,
    COUNT(a.id_alquiler) AS total_alquileres
FROM empleados e
LEFT JOIN alquileres a ON e.id = a.id_empleado
GROUP BY e.id, e.nombre
ORDER BY total_alquileres DESC;

-- 14. Clientes que tienen más de 1 alquiler registrado en el sistema.
SELECT
    c.id,
    c.nombre,
    COUNT(a.id_alquiler) AS cantidad_alquileres
FROM clientes c
INNER JOIN alquileres a ON c.id = a.id_cliente
GROUP BY c.id, c.nombre
HAVING COUNT(a.id_alquiler) > 1;

-- 15. Nombre de la ciudad y la cantidad de sucursales que hay en cada una.
SELECT
    ciudad,
    COUNT(id) AS cantidad_sucursales
FROM sucursales
GROUP BY ciudad;

-- 16. Marca, modelo y año del vehículo más antiguo de la flota.
SELECT
    marca,
    modelo,
    anio
FROM vehiculos
WHERE anio = (
    SELECT MIN(anio)
    FROM vehiculos
);

-- 17. Vehículos que nunca han sido alquilados.
SELECT
    v.id,
    v.marca,
    v.modelo,
    v.patente
FROM vehiculos v
LEFT JOIN alquileres a ON v.id = a.id_vehiculo
WHERE a.id_alquiler IS NULL;

-- 18. Alquileres activos que hayan comenzado en octubre de 2024.
SELECT
    id_alquiler,
    id_cliente,
    id_vehiculo,
    fecha_inicio,
    fecha_fin,
    total,
    id_empleado,
    id_sucursal_retiro,
    id_sucursal_devolucion,
    estado
FROM alquileres
WHERE estado = 'activo'
  AND fecha_inicio >= '2024-10-01'
  AND fecha_inicio <= '2024-10-31';

-- 19. Los 3 vehículos con el precio por día más alto.
SELECT
    marca,
    modelo,
    precio_dia
FROM vehiculos
ORDER BY precio_dia DESC
LIMIT 3;

-- 20. Cantidad total de multas pagadas y monto total recaudado por las mismas.
SELECT
    COUNT(*) AS total_multas_pagadas,
    COALESCE(SUM(monto), 0) AS monto_total_recaudado
FROM multas
WHERE pagada = TRUE;