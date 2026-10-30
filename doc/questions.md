# Respuestas a las Preguntas Teóricas (Sección 8)

**Archivo:** `doc/questions.md`  
**Proyecto:** RENTAL_CARS  

---

### 1. ¿Por qué la tabla ALQUILERES tiene claves foráneas hacia SUCURSALES dos veces (id_sucursal_retiro e id_sucursal_devolucion)? ¿Qué tipo de relación representa esto?

* **Justificación:** Representa dos **relaciones independientes de Uno a Muchos (1:N)** entre `SUCURSALES` y `ALQUILERES`. Una sucursal puede ser la sede donde se retira el vehículo y, al mismo tiempo, una sucursal distinta (o la misma) puede ser el punto donde se efectúa la devolución.
* **Motivo de diseño:** Almacenar ambos campos permite modelar la dinámica real del negocio de alquiler de autos, donde un cliente puede retirar el coche en una ciudad/sucursal (ej. Aeroparque) y devolverlo en otra diferente (ej. Centro). Definir dos claves foráneas separadas vincula ambas entidades de forma clara sin duplicar registros ni recurrir a tablas intermedias innecesarias.

---

### 2. Si intentamos borrar una CATEGORIA que tiene vehículos asociados, ¿qué debería hacer la base de datos? ¿Por qué? Menciona al menos dos opciones (RESTRICT, CASCADE, SET NULL) y justifica cuál sería la más adecuada para este modelo.

* **Opciones del motor de base de datos:**
  * **`RESTRICT` / `NO ACTION` (Opción recomendada):** Impide la eliminación de la categoría si existen vehículos asociados a ella, lanzando un error de restricción de integridad referencial.
  * **`CASCADE`:** Elimina automáticamente la categoría y **todos** los vehículos pertenecientes a ella (así como sus registros asociados en cascada).
  * **`SET NULL`:** Asigna valor nulo (`NULL`) a la columna `id_categoria` en los vehículos asociados.
* **Justificación de la mejor opción:** La alternativa adecuada para este modelo es **`RESTRICT`**. Eliminar una categoría en cascada (`CASCADE`) causaría la pérdida accidental de información crítica de la flota y de su historial. Por otro lado, un vehículo no debería quedar huérfano de categoría (`SET NULL`) ya que esta define la tarifa y características del auto. Por ende, la base de datos debe restringir el borrado solicitando la reasignación previa de los vehículos.

---

### 3. Observando la tabla VEHICULOS, ¿por qué la categoría está en una tabla separada (CATEGORIAS) y no directamente como un campo de texto en VEHICULOS?

* **Normalización y Reglas de Diseño:** Separar la categoría responde a los principios de normalización para evitar la **redundancia de datos** y **anomalías de modificación**.
* **Ventajas clave:**
  1. **Consistencia de datos:** Evita inconsistencias tipográficas (ej. registrar `"Económico"`, `"economico"`, `"Econ"`).
  2. **Eficiencia en almacenamiento:** Guardar un entero (`INT`) como clave foránea consume mucho menos espacio en disco que repetir cadenas de texto largas en cada vehículo.
  3. **Mantenibilidad:** Si se necesita modificar el nombre o descripción de una categoría, solo se actualiza una fila en la tabla `CATEGORIAS`, en lugar de actualizar múltiples registros en la tabla `VEHICULOS`.

---

### 4. ¿Qué tipo de relación existe entre SUCURSALES y EMPLEADOS? (Uno a Muchos, Muchos a Muchos, etc.). Justifica.

* **Tipo de relación:** **Uno a Muchos (1:N)**.
* **Justificación:**
  * Una **sucursal** puede contar con **muchos empleados** contratados o asignados a su nómina.
  * Un **empleado** pertenece y trabaja en **una sola sucursal** a la vez.
  * Por esta razón, la clave primaria de `SUCURSALES` (`id`) se incluye como clave foránea (`id_sucursal`) en la tabla `EMPLEADOS`.

---

### 5. ¿Por qué la tabla CHECK_ALQUILER tiene un campo tipo con valores 'salida' o 'entrada' en lugar de tener dos tablas separadas? ¿Qué ventaja aporta este diseño?

* **Justificación de diseño:** Las revisiones de entrega y devolución comparten exactamente la misma estructura de atributos: ambas registran el alquiler correspondiente (`id_alquiler`), la fecha/hora, el kilometraje (`km`) y el nivel de combustible (`nivel_combustible`).
* **Ventajas principales:**
  1. **Estructura limpia:** Evita la duplicación de tablas con idénticos campos (`CHECK_SALIDA` y `CHECK_ENTRADA`).
  2. **Consultas simplificadas:** Permite consultar o comparar el estado del vehículo al salir y al entrar mediante consultas sencillas sobre una única tabla (`WHERE tipo = 'salida'`).
  3. **Escalabilidad:** Si en el futuro se requiriera registrar un chequeo adicional (ej. `'intermedio'`), solo se necesitaría añadir ese valor a la columna `tipo` sin modificar el esquema ni crear nuevas tablas.