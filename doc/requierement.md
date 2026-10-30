# Requerimientos y Descripción del Modelo de Datos (requirements.md)

**Sistema:** RENTAL_CARS — Gestión de Alquiler de Vehículos  
**Ubicación:** `doc/requirements.md`  

---

## 1. Descripción General del Modelo de Datos

El modelo de datos **RENTAL_CARS** está diseñado para gestionar de manera integral el ciclo de vida de una empresa dedicada al alquiler de vehículos. Permite administrar la flota automotriz distribuida en múltiples sucursales, controlar el registro de clientes, empleados, reservas y la transacción central de alquileres. Además, el esquema incorpora la gestión de mantenimientos, emisión de pólizas de seguros, cobro de pagos, inspecciones técnicas (`CHECK_ALQUILER`), la aplicación de multas y el registro automático de auditoría.

---

## 2. Descripción de Entidades y Relaciones

### Entidades Principales y Secundarias:

* **CATEGORIAS:** Clasifica los vehículos según su tipo (Económico, SUV, Sedán, Camioneta, Lujo), definiendo sus características.
* **SUCURSALES:** Puntos físicos de operación de la empresa con dirección y ciudad.
* **EMPLEADOS:** Personal asignado a una sucursal específica que gestiona las operaciones.
* **CLIENTES:** Usuarios registrados habilitados para reservar y alquilar vehículos mediante una licencia de conducir única.
* **VEHICULOS:** Flota disponible con marca, modelo, año, precio diario, kilometraje, estado de disponibilidad y asignación a una categoría y sucursal.
* **RESERVAS:** Solicitudes previas de alquiler vinculadas a un cliente y vehículo.
* **ALQUILERES:** Entidad transaccional central que registra el periodo de arrendamiento, empleado gestor, cliente, vehículo y sucursales de retiro y devolución.
* **CHECK_ALQUILER:** Inspecciones de estado (salida y entrada) con kilometraje y nivel de combustible.
* **PAGOS, SEGUROS y MULTAS:** Entidades satélite que registran los cobros realizados, pólizas contratadas y penalizaciones asociadas a cada alquiler.
* **AUDITORIA_ALQUILERES:** Tabla de trazabilidad que registra automáticamente el alta de nuevos alquileres.

---

### Relaciones e Inversas Destacadas:

1. **CATEGORIAS ↔ VEHICULOS (1:N):** Una categoría agrupa a muchos vehículos. Inversa: Un vehículo pertenece a una única categoría.
2. **SUCURSALES ↔ EMPLEADOS (1:N):** Una sucursal emplea a múltiples personas. Inversa: Un empleado está asignado a una sola sucursal.
3. **SUCURSALES ↔ VEHICULOS (1:N):** Una sucursal alberga una flota de vehículos. Inversa: Un vehículo reside temporalmente en una sucursal.
4. **SUCURSALES ↔ ALQUILERES (1:N doble):** Una sucursal puede ser el punto de retiro (`id_sucursal_retiro`) y/o el punto de devolución (`id_sucursal_devolucion`) de múltiples alquileres.
5. **CLIENTES ↔ ALQUILERES (1:N):** Un cliente puede realizar varios alquileres a lo largo del tiempo. Inversa: Un alquiler pertenece a un único cliente.
6. **VEHICULOS ↔ ALQUILERES (1:N):** Un vehículo puede ser alquilado en diferentes periodos. Inversa: Un alquiler está asociado a un único vehículo.
7. **ALQUILERES ↔ CHECK_ALQUILER (1:N):** Un alquiler posee registros de inspección de tipo 'salida' y 'entrada'.

---

## 3. Requerimientos Funcionales (RF)

* **RF1 - Gestión de Flota y Categorías:** El sistema debe permitir registrar, categorizar y trasladar vehículos entre sucursales, actualizando su kilometraje y estado de disponibilidad.
* **RF2 - Registro de Clientes y Licencias:** Se debe registrar a los clientes asegurando que posean una licencia de conducir única en el sistema.
* **RF3 - Gestión Transaccional de Alquileres:** Permitir el registro de un alquiler calculando automáticamente el monto total en base a los días arrendados y la tarifa diaria del vehículo.
* **RF4 - Control de Disponibilidad:** No se debe permitir alquilar un vehículo cuyo estado figure como no disponible (`estado = FALSE`).
* **RF5 - Cambio Automático de Estado por Trigger:** Al registrar un alquiler en estado 'activo', el sistema debe cambiar automáticamente la disponibilidad del vehículo a `FALSE`.
* **RF6 - Registro Automático de Auditoría:** Toda inserción de un nuevo alquiler debe generar un evento automático en la tabla `AUDITORIA_ALQUILERES` indicando fecha, usuario/acción y referencias.
* **RF7 - Gestión de Multas y Cobros:** Permitir asociar multas e ingresar pagos vinculados a un alquiler en curso o finalizado.
* **RF8 - Inspección de Vehículos (Check-in / Check-out):** Registrar el kilometraje y nivel de combustible tanto en la salida como en la entrega del vehículo.
* **RF9 - Vistas de Consulta Operativa y Gerencial:**
  * Vista detallada de alquileres con nombres de clientes, vehículos, empleados y sucursales.
  * Vista del total de flota por sucursal para evaluación de inventario.
  * Vista de ingresos acumulados por categoría considerando solo alquileres finalizados.

---

## 4. Requerimientos No Funcionales (RNF)

* **RNF1 - Integridad Referencial y Restricciones:** Mantener la consistencia del modelo mediante claves primarias, foráneas, restricciones de unicidad (`UNIQUE` en licencias y patentes) y reglas de borrado restringido (`RESTRICT`).
* **RNF2 - Seguridad y Control de Acceso Granular:**
  * Rol Vendedor (`vendedor_user`): Acceso de lectura sobre catálogo y acceso de lectura/escritura en operaciones transaccionales, sin permisos de borrado (`DELETE`).
  * Rol Administrador (`admin_user`): Privilegios totales sobre la estructura y datos del sistema.
* **RNF3 - Modularidad y Encapsulamiento:** Toda lógica de negocio compleja debe estar encapsulada en procedimientos almacenados (`PL/pgSQL`) e invocada mediante parámetros.
* **RNF4 - Portabilidad y Contenerización:** La base de datos debe ejecutarse dentro de un entorno aislado de **Docker** mediante `docker-compose.yml`, configurado por medio de un archivo de variables de entorno `.env`.
* **RNF5 - Trazabilidad y Mantenibilidad:** La estructura del repositorio debe respetar la separación entre scripts SQL (`sql/`) y documentación técnica (`doc/`).