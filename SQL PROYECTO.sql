DROP DATABASE IF EXISTS proyecto;
CREATE DATABASE proyecto;
USE proyecto;

-- 1) Tabla de ubicaciones (dónde se recoge la basura)
--    + latitud / longitud para precisión geográfica
CREATE TABLE ubicacion (
  id_ubicacion INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(80) NOT NULL,
  ciudad VARCHAR(60) NOT NULL,
  latitud DECIMAL(9,6)  NULL,
  longitud DECIMAL(9,6)  NULL,
  CONSTRAINT chk_latitud  CHECK (latitud  IS NULL OR (latitud  BETWEEN -90.000000 AND  90.000000)),
  CONSTRAINT chk_longitud CHECK (longitud IS NULL OR (longitud BETWEEN -180.000000 AND 180.000000)),
  UNIQUE KEY uq_ubicacion (nombre, ciudad)
);

-- 2) Tabla de tipos de residuo (qué se recoge)
CREATE TABLE tipo_residuo (
  id_tipo_residuo INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(150) NOT NULL,
  clasificacion ENUM('Organico','Reciclable','Peligroso','No Reciclable') NOT NULL,
  UNIQUE KEY uq_tipo_residuo (nombre)
);

-- 3) Evento de recolección (una visita/fecha por ubicación)
CREATE TABLE recoleccion (
  id_recoleccion INT PRIMARY KEY AUTO_INCREMENT,
  id_ubicacion INT NOT NULL,
  fecha DATE NOT NULL,
  observacion VARCHAR(255),
  FOREIGN KEY (id_ubicacion) REFERENCES ubicacion(id_ubicacion)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  UNIQUE KEY uq_ubic_fecha (id_ubicacion, fecha)
);

-- 4) Catálogo de procesos de disposición (destino final)
--    (Reciclaje, Compostaje, Vertedero, Otro, etc.)
CREATE TABLE proceso_disposicion (
  id_proceso_disposicion INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(80) NOT NULL,
  descripcion VARCHAR(255),
  UNIQUE KEY uq_proceso_disposicion (nombre)
);

-- 5) Detalle de la recolección (cuánto de cada residuo)
--    + referencia al proceso de disposición (el destino final)
CREATE TABLE recoleccion_detalle (
  id_detalle INT PRIMARY KEY AUTO_INCREMENT,
  id_recoleccion INT NOT NULL,
  id_tipo_residuo INT NOT NULL,
  id_proceso_disposicion INT NOT NULL,
  cantidad_kg DECIMAL(10,2) NOT NULL,  -- volumen/masa
  FOREIGN KEY (id_recoleccion) REFERENCES recoleccion(id_recoleccion)
    ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (id_tipo_residuo) REFERENCES tipo_residuo(id_tipo_residuo)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (id_proceso_disposicion)  REFERENCES proceso_disposicion(id_proceso_disposicion)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  UNIQUE KEY uq_detalle (id_recoleccion, id_tipo_residuo),
  CONSTRAINT chk_cantidad_positiva CHECK (cantidad_kg > 0)
);

-- DATOS DE EJEMPLO / CARGA INICIAL
-- 1) Ubicaciones 
INSERT INTO ubicacion (nombre, ciudad, latitud, longitud) VALUES
('Norte',   'Guayaquil',  -2.134500, -79.900300),
('Sur',     'Guayaquil',  -2.230000, -79.900000),
('Centro',  'Quito',      -0.220000, -78.510000),
('Oeste',   'Cuenca',     -2.905000, -79.010000),
('Industrial','Guayaquil',-2.180000, -79.870000),
('Chillogallo','Quito',   -0.320000, -78.570000);

-- 2) Tipos de residuo 
INSERT INTO tipo_residuo (nombre, clasificacion) VALUES
('Orgánico',     'Organico'),
('Plástico',     'Reciclable'),
('Vidrio',       'Reciclable'),
('Baterías',     'Peligroso'),
('Escombros',    'No Reciclable'),
('Metales',      'Reciclable');

-- 3) Recolecciones 
INSERT INTO recoleccion (id_ubicacion, fecha, observacion) VALUES
(1, '2025-09-01', 'Recolección en Norte - sector Kennedy'),
(2, '2025-09-02', 'Recolección en Sur - Febres Cordero'),
(3, '2025-09-03', 'Centro Historico de Quito'),
(4, '2025-09-04', 'Cuenca Oeste - Totoracocha'),
(5, '2025-09-05', 'Zona industrial de Guayaquil'),
(6, '2025-09-06', 'Quito - Chillogallo');

-- 4) Procesos de disposición 
INSERT INTO proceso_disposicion (nombre, descripcion) VALUES
('Reciclaje',   'Clasificación y recuperación de materiales reciclables'),
('Compostaje',  'Tratamiento biológico de residuos orgánicos'),
('Vertedero',   'Disposición final en relleno sanitario'),
('Incineración','Eliminación mediante combustión controlada'),
('Reutilización','Uso directo de los residuos en otro contexto'),
('Otro',        'Otro destino no especificado');

-- 5) Recolección Detalles 
INSERT INTO recoleccion_detalle (id_recoleccion, id_tipo_residuo, id_proceso_disposicion, cantidad_kg) VALUES
(1, 1, (SELECT id_proceso_disposicion FROM proceso_disposicion WHERE nombre='Compostaje'), 180.00), -- Orgánico
(2, 2, (SELECT id_proceso_disposicion FROM proceso_disposicion WHERE nombre='Reciclaje'),   75.00), -- Plástico
(3, 3, (SELECT id_proceso_disposicion FROM proceso_disposicion WHERE nombre='Reciclaje'),   50.00), -- Vidrio
(4, 4, (SELECT id_proceso_disposicion FROM proceso_disposicion WHERE nombre='Incineración'),15.00), -- Baterías
(5, 5, (SELECT id_proceso_disposicion FROM proceso_disposicion WHERE nombre='Vertedero'),  320.00), -- Escombros
(6, 6, (SELECT id_proceso_disposicion FROM proceso_disposicion WHERE nombre='Reutilización'),60.00); -- Metales



select * from proceso_disposicion;
select * from recoleccion;
select * from recoleccion_detalle;
select * from tipo_residuo;
select * from ubicacion;

