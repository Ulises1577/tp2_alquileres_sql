-- =============================================================================
-- TRABAJO PRÁCTICO N° 2 SQL | BASE DE DATOS: RENTAL_CARS
-- Archivo: sql/09_users_grants.sql
-- Motor: PostgreSQL
-- Descripción: Gestión de usuarios, roles y asignación de permisos (Sección 7).
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. CREACIÓN DE USUARIOS
-- -----------------------------------------------------------------------------

-- Eliminar usuarios si existen previamente (limpieza)
DROP USER IF EXISTS vendedor_user;
DROP USER IF EXISTS admin_user;

-- Crear usuario Vendedor (acceso operativo limitado)
CREATE USER vendedor_user WITH PASSWORD 'VendedorPass2024!';

-- Crear usuario Administrador (acceso total)
CREATE USER admin_user WITH PASSWORD 'AdminSecurePass2024!';

-- -----------------------------------------------------------------------------
-- 2. OTORGAMIENTO DE PERMISOS (GRANT)
-- -----------------------------------------------------------------------------

-- Permisos básicos de conexión
GRANT CONNECT ON DATABASE rental_cars TO vendedor_user;
GRANT USAGE ON SCHEMA public TO vendedor_user;

-- Permisos operativos para el VENDEDOR:
-- Consulta de tablas maestras
GRANT SELECT ON categorias, sucursales, vehiculos TO vendedor_user;

-- Lectura e inserción en tablas de gestión comercial
GRANT SELECT, INSERT, UPDATE ON clientes, reservas, alquileres, pagos, check_alquiler TO vendedor_user;

-- Permiso de ejecución sobre los procedimientos almacenados
GRANT EXECUTE ON PROCEDURE sp_registrar_alquiler TO vendedor_user;
GRANT EXECUTE ON PROCEDURE sp_calcular_multa TO vendedor_user;

-- Permiso de uso sobre las secuencias autoincrementales (SERIAL)
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO vendedor_user;

-- Permisos para el ADMINISTRADOR (Acceso total al esquema y tablas)
GRANT ALL PRIVILEGES ON DATABASE rental_cars TO admin_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin_user;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO admin_user;
GRANT ALL PRIVILEGES ON ALL PROCEDURES IN SCHEMA public TO admin_user;

-- -----------------------------------------------------------------------------
-- 3. REVOCACIÓN DE PERMISOS (REVOKE)
-- -----------------------------------------------------------------------------

-- Se restringe explícitamente al Vendedor eliminar registros transaccionales críticos
REVOKE DELETE ON alquileres, pagos, vehiculos, clientes FROM vendedor_user;

-- Se restringe al Vendedor modificar el esquema estructural
REVOKE CREATE ON SCHEMA public FROM vendedor_user;