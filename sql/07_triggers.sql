-- =============================================================================
-- TRABAJO PRÁCTICO N° 2 SQL | BASE DE DATOS: RENTAL_CARS
-- Archivo: sql/07_triggers.sql
-- Motor: PostgreSQL
-- Descripción: Creación de Triggers / Disparadores (Sección 5 del Trabajo Práctico).
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. TABLA DE AUDITORÍA (Requisito previo Punto 1)
-- -----------------------------------------------------------------------------

DROP TABLE IF EXISTS auditoria_alquileres CASCADE;

CREATE TABLE auditoria_alquileres (
    id_auditoria SERIAL PRIMARY KEY,
    id_alquiler INT NOT NULL,
    id_cliente INT NOT NULL,
    id_vehiculo INT NOT NULL,
    fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    accion VARCHAR(50) NOT NULL
);

-- -----------------------------------------------------------------------------
-- 2. TRIGGER 1: tr_auditar_alquiler (Punto 1)
-- Se dispara después de insertar un nuevo alquiler e inserta un registro de auditoría.
-- -----------------------------------------------------------------------------

-- Función asociada al Trigger de Auditoría
CREATE OR REPLACE FUNCTION fn_tr_auditar_alquiler()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO auditoria_alquileres (
        id_alquiler,
        id_cliente,
        id_vehiculo,
        fecha_registro,
        accion
    ) VALUES (
        NEW.id_alquiler,
        NEW.id_cliente,
        NEW.id_vehiculo,
        CURRENT_TIMESTAMP,
        'NUEVO ALQUILER'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Definición del Trigger
DROP TRIGGER IF EXISTS tr_auditar_alquiler ON alquileres;

CREATE TRIGGER tr_auditar_alquiler
AFTER INSERT ON alquileres
FOR EACH ROW
EXECUTE FUNCTION fn_tr_auditar_alquiler();

-- -----------------------------------------------------------------------------
-- 3. TRIGGER 2: tr_actualizar_estado_vehiculo (Punto 2)
-- Se dispara después de insertar un alquiler. Si el estado es 'activo',
-- cambia el campo estado del vehículo alquilado a FALSE (no disponible).
-- -----------------------------------------------------------------------------

-- Función asociada al Trigger de Estado de Vehículo
CREATE OR REPLACE FUNCTION fn_tr_actualizar_estado_vehiculo()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.estado = 'activo' THEN
        UPDATE vehiculos
        SET estado = FALSE
        WHERE id = NEW.id_vehiculo;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Definición del Trigger
DROP TRIGGER IF EXISTS tr_actualizar_estado_vehiculo ON alquileres;

CREATE TRIGGER tr_actualizar_estado_vehiculo
AFTER INSERT ON alquileres
FOR EACH ROW
EXECUTE FUNCTION fn_tr_actualizar_estado_vehiculo();