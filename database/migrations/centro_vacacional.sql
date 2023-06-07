CREATE DATABASE IF NOT EXISTS `centro_vacacional(the_leaky_cauldron)`; 
USE `centro_vacacional(the_leaky_cauldron)`;

-- Tabla CLIENTES
CREATE TABLE IF NOT EXISTS `clientes` (
 `id_cliente` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `nom_cliente` VARCHAR(40) NOT NULL,
 `ape_cliente` VARCHAR(40) NOT NULL,
 `correo_cliente` VARCHAR(255) NOT NULL,
 `codigo_tlf_cliente` VARCHAR(4) NOT NULL,
 `num_tlf_cliente` VARCHAR(7) NOT NULL,
 `contrasena_cliente` VARCHAR(255) NOT NULL,

 UNIQUE (correo_cliente)
);

-- Tabla RECEPCIONISTAS
CREATE TABLE IF NOT EXISTS `recepcionistas` (
 `id_recepcionista` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `nom_recepcionista` VARCHAR(40) NOT NULL,
 `ape_recepcionista` VARCHAR(40) NOT NULL,
 `correo_recepcionista` VARCHAR(255) NOT NULL,
 `cod_tlf_recepcionista` VARCHAR(4) NOT NULL,
 `num_tlf_recepcionista` VARCHAR(7) NOT NULL,
 `contrasena_recepcionista` VARCHAR(255) NOT NULL,

 UNIQUE (correo_recepcionista)
);

-- Tabla RESERVACIONES
CREATE TABLE IF NOT EXISTS `reservaciones` (
 `id_reservacion` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `personas_reservacion` INT NOT NULL,
 `fecha_reservacion` DATE NOT NULL,
 `estado` ENUM('Pendiente', 'Finalizado', 'En curso') NOT NULL,
 `motivo` ENUM('Viaje', 'Negocio', 'Recreacion') NOT NULL,

 `cliente_id` BIGINT NOT NULL, FOREIGN KEY (cliente_id) REFERENCES clientes (id_cliente) ON
DELETE CASCADE ON UPDATE CASCADE,
 `recepcionista_id` BIGINT NOT NULL, FOREIGN KEY (recepcionista_id) REFERENCES recepcionistas (id_recepcionista) ON
DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla HABITACIONES
CREATE TABLE IF NOT EXISTS `habitaciones` (
 `id_habitacion` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `tipo_habitacion` ENUM('Individual', 'Doble') NOT NULL,
 `desc_habitacion` VARCHAR(255) NOT NULL,
 `capacidad_habitacion` INT NOT NULL,
 `numero` INT NOT NULL,
 `piso` INT NOT NULL,
 `estado` ENUM('Ocupado', 'Disponible') NOT NULL
);

-- Tabla relacion HABITACION - RESERVACION
CREATE TABLE IF NOT EXISTS `habitaciones_reservaciones` (
 `habitacion_id` BIGINT NOT NULL, FOREIGN KEY (habitacion_id) REFERENCES habitaciones (id_habitacion) ON
DELETE CASCADE ON UPDATE CASCADE,
`reservacion_id` BIGINT NOT NULL, FOREIGN KEY (reservacion_id) REFERENCES reservaciones (id_reservacion) ON
DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla IMAGENES
CREATE TABLE IF NOT EXISTS `imagenes` (
 `id_imagen` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `ruta_imagen` VARCHAR(255) NOT NULL,

  UNIQUE (ruta_imagen),

 `habitacion_id` BIGINT NOT NULL, FOREIGN KEY (habitacion_id) REFERENCES `habitaciones` (id_habitacion) ON
DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla HUESPEDES
CREATE TABLE IF NOT EXISTS `huespedes` (
 `id_huesped` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `fecha_llegada` DATE NOT NULL,
 `fecha_salida` DATE NOT NULL,

 `habitacion_id` BIGINT NOT NULL, FOREIGN KEY (habitacion_id) REFERENCES `habitaciones` (id_habitacion) ON
DELETE CASCADE ON UPDATE CASCADE,
 `cliente_id` BIGINT NOT NULL, FOREIGN KEY (cliente_id) REFERENCES `clientes` (id_cliente) ON
DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla RESENAS
CREATE TABLE IF NOT EXISTS `resenas` (
 `id_resena` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `experiencia_resena` VARCHAR(255) NOT NULL,
 `puntuacion_resena` INT NOT NULL,

 `huesped_id` BIGINT NOT NULL, FOREIGN KEY (huesped_id) REFERENCES `huespedes` (id_huesped) ON
DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla PLANES
CREATE TABLE IF NOT EXISTS `planes` (
 `id_plan` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `nom_plan` VARCHAR(70) NOT NULL,
 `detalles_plan` VARCHAR(255) NOT NULL,
 `dias_plan` INT NOT NULL,
 `noches_plan` INT NOT NULL,

 UNIQUE (nom_plan),

 `recepcionista_id` BIGINT NOT NULL, FOREIGN KEY (recepcionista_id) REFERENCES `recepcionistas` (id_recepcionista) ON
DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla SERVICIOS
CREATE TABLE IF NOT EXISTS `servicios` (
 `id_servicio` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `nom_servicio` VARCHAR(70) NOT NULL,
 `desc_servicio` VARCHAR(255) NOT NULL,
 `precio_servicio` INT NOT NULL,

 UNIQUE (nom_servicio)
);

-- Tabla relacion SERVICIOS - PLANES
CREATE TABLE IF NOT EXISTS `servicios_planes` (
 `servicio_id` BIGINT NOT NULL,
 FOREIGN KEY (servicio_id) REFERENCES `servicios` (id_servicio) ON DELETE CASCADE ON UPDATE CASCADE,
 `plan_id` BIGINT NOT NULL,
 FOREIGN KEY (plan_id) REFERENCES `planes` (id_plan) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla ALIMENTOS
CREATE TABLE IF NOT EXISTS `alimentos` (
 `id_alimento` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `nom_alimento` VARCHAR(50) NOT NULL,
 `cantidad_alimento` INT NOT NULL,

 UNIQUE (nom_alimento)
);

-- Tabla relacion ALIMENTOS - SERVICIOS
CREATE TABLE IF NOT EXISTS `alimentos_servicios` (
 `alimento_id` BIGINT NOT NULL, FOREIGN KEY (alimento_id) REFERENCES alimentos (id_alimento) ON
DELETE CASCADE ON UPDATE CASCADE,
`servicio_id` BIGINT NOT NULL, FOREIGN KEY (servicio_id) REFERENCES servicios (id_servicio) ON
DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla PAGOS
CREATE TABLE IF NOT EXISTS `pagos` (
 `id_pago` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `monto_total_pago` INT NOT NULL,
 `metodo_pago` ENUM('Efectivo', 'Tarjeta') NOT NULL,
 `fecha_pago` DATE NOT NULL,
 `descuento_pago` INT NOT NULL,
 `estado_pago` ENUM('Finalizado', 'Pendiente') NOT NULL
);

-- Tabla relacion PAGOS - SERVICIOS
CREATE TABLE IF NOT EXISTS `pagos_servicios` (
 `pago_id` BIGINT NOT NULL, FOREIGN KEY (pago_id) REFERENCES pagos (id_pago) ON
DELETE CASCADE ON UPDATE CASCADE,
`servicio_id` BIGINT NOT NULL, FOREIGN KEY (servicio_id) REFERENCES servicios (id_servicio) ON
DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla ESPACIOS
CREATE TABLE IF NOT EXISTS `espacios` (
 `id_espacio` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `nom_espacio` VARCHAR(40) NOT NULL,
 `capacidad_espacio` INT NOT NULL,
 `ubicacion_espacio` ENUM('A', 'B', 'C', 'D', 'E') NOT NULL,
 `estado_espacio` ENUM('Ocupado', 'Disponible') NOT NULL,

 UNIQUE (nom_espacio)
);

-- Tabla relacion ESPACIOS - RESERVACIONES
CREATE TABLE IF NOT EXISTS `espacios_reservaciones` (
 `reservacion_id` BIGINT NOT NULL, FOREIGN KEY (reservacion_id) REFERENCES reservaciones (id_reservacion) ON
DELETE CASCADE ON UPDATE CASCADE,
`espacio_id` BIGINT NOT NULL, FOREIGN KEY (espacio_id) REFERENCES espacios (id_espacio) ON
DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla HORARIOS
CREATE TABLE IF NOT EXISTS `horarios` (
 `id_horario` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `hora_inicio` TIME NOT NULL,
 `hora_fin` TIME NOT NULL
);

-- Tabla relacion HORARIOS - ESPACIOS
CREATE TABLE IF NOT EXISTS `horarios_espacios` (
 `horario_id` BIGINT NOT NULL, FOREIGN KEY (horario_id) REFERENCES horarios (id_horario) ON
DELETE CASCADE ON UPDATE CASCADE,
`espacio_id` BIGINT NOT NULL, FOREIGN KEY (espacio_id) REFERENCES espacios (id_espacio) ON
DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla CARGOS
CREATE TABLE IF NOT EXISTS `cargos` (
 `id_cargo` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `nom_cargo` VARCHAR(50) NOT NULL,
 `desc_cargo` VARCHAR(255) NOT NULL,
 `sueldo_cargo` int NOT NULL,

 UNIQUE (nom_cargo)
);

-- Tabla EMPLEADOS
CREATE TABLE IF NOT EXISTS `empleados` (
 `id_empleado` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `nom_empleado` VARCHAR(40) NOT NULL,
 `ape_empleado` VARCHAR(40) NOT NULL,
 `correo_empleado` VARCHAR(255) NOT NULL,
 `cod_tlf_empleado` VARCHAR(4) NOT NULL,
 `num_tlf_empleado` VARCHAR(7) NOT NULL,
 `contrasena_empleado` VARCHAR(255) NOT NULL,

 UNIQUE (correo_empleado),

 `cargo_id` BIGINT NOT NULL, FOREIGN KEY (cargo_id) REFERENCES cargos (id_cargo) ON
DELETE CASCADE ON UPDATE CASCADE
);


-- Tabla ACTIVIDADES
CREATE TABLE IF NOT EXISTS `actividades` (
 `id_actividad` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `nom_actividad` VARCHAR(40) NOT NULL,
 `desc_actividad` VARCHAR(255) NOT NULL,
 `estado_actividad` ENUM('Finalizado', 'Progreso', 'Espera') NOT NULL,

 UNIQUE (nom_actividad),
 
`empleado_id` BIGINT NOT NULL, FOREIGN KEY (empleado_id) REFERENCES empleados (id_empleado) ON
DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla relacion ESPACIOS - ACTIVIDADES
CREATE TABLE IF NOT EXISTS `espacios_actividades` ( 
`espacio_id` BIGINT NOT NULL, FOREIGN KEY (espacio_id) REFERENCES espacios (id_espacio) ON
DELETE CASCADE ON UPDATE CASCADE,
`actividad_id` BIGINT NOT NULL, FOREIGN KEY (actividad_id) REFERENCES actividades (id_actividad) ON
DELETE CASCADE ON UPDATE CASCADE
);