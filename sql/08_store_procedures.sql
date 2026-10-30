-- =============================================================================
-- TRABAJO PRÁCTICO N° 2 SQL | BASE DE DATOS: RENTAL_CARS
-- Archivo: sql/08_store_procedures.sql
-- Motor: PostgreSQL
-- Descripción: Procedimientos Almacenados (Sección 6 del Trabajo Práctico).
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. sp_registrar_alquiler (Punto 1)
-- Registra un alquiler verificando la disponibilidad del vehículo y calculando
-- el total en función de los días reservados y el precio diario.
-- -----------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE sp_registrar_alquiler(
    p_id_cliente INT,
    p_id_vehiculo INT,
    p_id_empleado INT,
    p_id_sucursal_retiro INT,
    p_id_sucursal_devolucion INT,
    p_fecha_inicio DATE,
    p_fecha_fin DATE
)
LANGUAGE plpgsql AS $$
DECLARE
    v_disponible BOOLEAN;
    v_precio_dia DECIMAL(9,2);
    v_dias INT;
    v_total DECIMAL(9,2);
BEGIN
    -- a. Verificar si el vehículo está disponible (estado = TRUE)
    SELECT estado, precio_dia 
    INTO v_disponible, v_precio_dia
    FROM vehiculos 
    WHERE id = p_id_vehiculo;

    IF v_disponible IS NULL THEN
        RAISE EXCEPTION 'El vehículo con ID % no existe.', p_id_vehiculo;
    END IF;

    IF v_disponible = FALSE THEN
        RAISE EXCEPTION 'El vehículo con ID % no está disponible para alquiler.', p_id_vehiculo;
    END IF;

    -- Validar coherencia de fechas
    IF p_fecha_fin <= p_fecha_inicio THEN
        RAISE EXCEPTION 'La fecha de fin debe ser posterior a la fecha de inicio.';
    END IF;

    -- b. Calcular días y total multiplicando por precio_dia
    v_dias := (p_fecha_fin - p_fecha_inicio);
    v_total := v_dias * v_precio_dia;

    -- c. Insertar el nuevo registro en ALQUILERES con estado 'activo'
    INSERT INTO alquileres (
        id_cliente,
        id_vehiculo,
        fecha_inicio,
        fecha_fin,
        total,
        id_empleado,
        id_sucursal_retiro,
        id_sucursal_devolucion,
        estado
    ) VALUES (
        p_id_cliente,
        p_id_vehiculo,
        p_fecha_inicio,
        p_fecha_fin,
        v_total,
        p_id_empleado,
        p_id_sucursal_retiro,
        p_id_sucursal_devolucion,
        'activo'
    );

    -- d. Mensaje de éxito
    RAISE NOTICE 'Alquiler registrado correctamente. Total a cobrar: $%', v_total;
END;
$$;

-- -----------------------------------------------------------------------------
-- 2. sp_calcular_multa (Punto 2)
-- Registra una multa asociada a un alquiler previa validación de su existencia.
-- -----------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE sp_calcular_multa(
    p_id_alquiler INT,
    p_motivo VARCHAR(120),
    p_monto DECIMAL(9,2)
)
LANGUAGE plpgsql AS $$
DECLARE
    v_existe INT;
BEGIN
    -- a. Verificar que el alquiler exista
    SELECT COUNT(*) 
    INTO v_existe
    FROM alquileres 
    WHERE id_alquiler = p_id_alquiler;

    IF v_existe = 0 THEN
        RAISE EXCEPTION 'El alquiler con ID % no existe en el sistema.', p_id_alquiler;
    END IF;

    -- b. Insertar la multa en la tabla MULTAS con pagada = FALSE y fecha actual
    INSERT INTO multas (
        id_alquiler,
        fecha,
        motivo,
        monto,
        pagada
    ) VALUES (
        p_id_alquiler,
        CURRENT_DATE,
        p_motivo,
        p_monto,
        FALSE
    );

    -- c. Mensaje de éxito
    RAISE NOTICE 'Multa registrada correctamente.';
END;
$$;

--PRUEBAAA

-- Probar sp_registrar_alquiler con el vehículo id = 4 (Ford Focus disponible)
CALL sp_registrar_alquiler(
    1,            -- id_cliente
    4,            -- id_vehiculo
    1,            -- id_empleado
    1,            -- id_sucursal_retiro
    1,            -- id_sucursal_devolucion
    '2024-11-01', -- fecha_inicio
    '2024-11-05'  -- fecha_fin (4 días)
);

-- Probar sp_calcular_multa para el alquiler id = 1
CALL sp_calcular_multa(
    1,                                -- id_alquiler
    'Retorno con tanque incompleto', -- motivo
    12000.00                          -- monto
);