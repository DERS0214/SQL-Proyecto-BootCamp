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
(3, '2025-09-03', 'Centro Histórico de Quito'),
(4, '2025-09-04', 'Cuenca Oeste - Totoracocha'),
(5, '2025-09-05', 'Zona industrial de Guayaquil'),
(6, '2025-09-06', 'Quito - Chillogallo'),
(1, '2025-09-07', 'Nueva jornada en Norte - Urdesa'),
(2, '2025-09-08', 'Recolección Sur - Guasmo'),
(3, '2025-09-09', 'Centro Quito - Plaza Grande'),
(4, '2025-09-10', 'Cuenca Oeste - Baños'),
(5, '2025-09-11', 'Zona industrial - Vía Daule'),
(6, '2025-09-12', 'Chillogallo - Barrio La Mena'),
(1, '2025-09-13', 'Norte - Alborada'),
(2, '2025-09-14', 'Sur - Fertisa');


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
-- 2025-09-01 (Norte)
(1, 1, (SELECT id_proceso_disposicion FROM proceso_disposicion WHERE nombre='Compostaje'), 180.00),
(1, 2, (SELECT id_proceso_disposicion FROM proceso_disposicion WHERE nombre='Reciclaje'),   45.00),
-- 2025-09-02 (Sur)
(2, 2, (SELECT id_proceso_disposicion FROM proceso_disposicion WHERE nombre='Reciclaje'),   80.00),
-- 2025-09-03 (Centro Quito)
(3, 3, (SELECT id_proceso_disposicion FROM proceso_disposicion WHERE nombre='Reciclaje'),   60.00),
(3, 1, (SELECT id_proceso_disposicion FROM proceso_disposicion WHERE nombre='Compostaje'), 110.00),
-- 2025-09-04 (Cuenca Oeste)
(4, 4, (SELECT id_proceso_disposicion FROM proceso_disposicion WHERE nombre='Incineración'), 12.00),
(4, 2, (SELECT id_proceso_disposicion FROM proceso_disposicion WHERE nombre='Reciclaje'),    55.00),
-- 2025-09-05 (Zona industrial)
(5, 5, (SELECT id_proceso_disposicion FROM proceso_disposicion WHERE nombre='Vertedero'),  300.00),
(5, 6, (SELECT id_proceso_disposicion FROM proceso_disposicion WHERE nombre='Reutilización'), 50.00),
-- 2025-09-06 (Chillogallo)
(6, 1, (SELECT id_proceso_disposicion FROM proceso_disposicion WHERE nombre='Compostaje'), 140.00),
-- 2025-09-07 (Norte)
(7, 2, (SELECT id_proceso_disposicion FROM proceso_disposicion WHERE nombre='Reciclaje'),   65.00),
(7, 3, (SELECT id_proceso_disposicion FROM proceso_disposicion WHERE nombre='Reciclaje'),   40.00),
-- 2025-09-08 (Sur)
(8, 1, (SELECT id_proceso_disposicion FROM proceso_disposicion WHERE nombre='Compostaje'), 120.00),
-- 2025-09-09 (Centro Quito)
(9, 5, (SELECT id_proceso_disposicion FROM proceso_disposicion WHERE nombre='Vertedero'),  200.00),
(9, 6, (SELECT id_proceso_disposicion FROM proceso_disposicion WHERE nombre='Reutilización'), 70.00),
-- 2025-09-10 (Cuenca Oeste)
(10, 2, (SELECT id_proceso_disposicion FROM proceso_disposicion WHERE nombre='Reciclaje'),  90.00),
-- 2025-09-11 (Zona industrial)
(11, 4, (SELECT id_proceso_disposicion FROM proceso_disposicion WHERE nombre='Incineración'), 20.00),
(11, 6, (SELECT id_proceso_disposicion FROM proceso_disposicion WHERE nombre='Reutilización'), 40.00),
-- 2025-09-12 (Chillogallo)
(12, 1, (SELECT id_proceso_disposicion FROM proceso_disposicion WHERE nombre='Compostaje'), 160.00),
(12, 2, (SELECT id_proceso_disposicion FROM proceso_disposicion WHERE nombre='Reciclaje'),   55.00),
-- 2025-09-13 (Norte)
(13, 3, (SELECT id_proceso_disposicion FROM proceso_disposicion WHERE nombre='Reciclaje'),   70.00),
-- 2025-09-14 (Sur)
(14, 5, (SELECT id_proceso_disposicion FROM proceso_disposicion WHERE nombre='Vertedero'),  250.00),
(14, 1, (SELECT id_proceso_disposicion FROM proceso_disposicion WHERE nombre='Compostaje'), 100.00);





select * from proceso_disposicion;
select * from recoleccion;
select * from recoleccion_detalle;
select * from tipo_residuo;
select * from ubicacion;
use proyecto;

-- Consultas
-- 1) ¿Qué tipo de residuo se genera con mayor frecuencia en cada ubicación?
SELECT
	-- Seleccionar Ubicación, residuo, total 
    ubicacion,
    residuo,
    Total
FROM (
	-- Primero hacemos un query para mostrar por cada Ubicación un ranking con el tipo de residuo
    SELECT
        CONCAT(u.nombre, ' ', u.ciudad) AS Ubicacion,
        tr.nombre AS residuo,
        SUM(rd.cantidad_kg) AS Total,
        ROW_NUMBER() OVER(PARTITION BY u.id_ubicacion ORDER BY SUM(rd.cantidad_kg) DESC) AS ranking
    FROM
        recoleccion AS r
    INNER JOIN recoleccion_detalle AS rd ON r.id_recoleccion = rd.id_recoleccion
    INNER JOIN ubicacion AS u ON u.id_ubicacion = r.id_ubicacion
    INNER JOIN tipo_residuo AS tr ON tr.id_tipo_residuo = rd.id_tipo_residuo
    GROUP BY
        u.id_ubicacion, tr.nombre
) AS T1
WHERE
	-- Filtramos solo el primer ranking de cada Ubicación
    T1.ranking = 1
ORDER BY
    T1.Total DESC;
    
    
/*
-- Optimizacion de datos con index
  CREATE INDEX ix_detalle_recol_tipo
  ON recoleccion_detalle (id_recoleccion, id_tipo_residuo, cantidad_kg);
  
  -- 
  EXPLAIN
WITH tot AS (
  SELECT r.id_ubicacion, rd.id_tipo_residuo, SUM(rd.cantidad_kg) AS TotalKg
  FROM recoleccion r
  JOIN recoleccion_detalle rd ON rd.id_recoleccion = r.id_recoleccion
  GROUP BY r.id_ubicacion, rd.id_tipo_residuo
)
SELECT u.nombre, u.ciudad, tr.nombre, tot.TotalKg
FROM tot
JOIN ubicacion u     ON u.id_ubicacion = tot.id_ubicacion
JOIN tipo_residuo tr ON tr.id_tipo_residuo = tot.id_tipo_residuo
ORDER BY tot.TotalKg DESC;
*/
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
-- 2) ¿Qué días de la semana tienen mayor volumen de recolección? 
SELECT 
  UPPER(DATE_FORMAT(r.fecha, '%W')) AS Dia, 
  SUM(rd.cantidad_kg) AS TotalRecolectado
FROM recoleccion AS r
INNER JOIN recoleccion_detalle AS rd
  ON r.id_recoleccion = rd.id_recoleccion
GROUP BY Dia
ORDER BY TotalRecolectado DESC;

/*
-- Optimizacion de datos con index
CREATE INDEX ix_recoleccion_fecha_recol
  ON recoleccion (fecha, id_recoleccion); 

CREATE INDEX ix_detalle_recol_cant
  ON recoleccion_detalle (id_recoleccion, cantidad_kg);
  
  -- 
  EXPLAIN
SELECT 
  DATE_FORMAT(r.fecha, '%W') AS Dia, 
  SUM(rd.cantidad_kg) AS TotalRecolectado
FROM recoleccion AS r
JOIN recoleccion_detalle AS rd
  ON r.id_recoleccion = rd.id_recoleccion
GROUP BY Dia
ORDER BY TotalRecolectado DESC;
*/
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
-- 3) ¿Qué ubicaciones tienen mayor eficiencia en la separación de residuos reciclables?
-- Ubicaciones con más kilos reciclables
 SELECT
  Ubicacion,
ROUND(
  SUM(CASE WHEN Clasificacion = 'Reciclable' THEN Cantidad ELSE 0 END)
  / SUM(Cantidad) * 100, 2) AS Tasa_Eficiencia -- round
FROM
  (
	SELECT CONCAT(u.nombre, ' ', u.ciudad) AS Ubicacion,
      tr.clasificacion AS Clasificacion,
      SUM(rd.cantidad_kg) AS Cantidad
    FROM
      recoleccion AS r
      INNER JOIN recoleccion_detalle AS rd ON r.id_recoleccion = rd.id_recoleccion
      INNER JOIN ubicacion AS u ON u.id_ubicacion = r.id_ubicacion
      INNER JOIN tipo_residuo AS tr ON tr.id_tipo_residuo = rd.id_tipo_residuo
    GROUP BY
      Ubicacion,
      Clasificacion
  ) AS Totales
GROUP BY
  Ubicacion
ORDER BY
  Tasa_Eficiencia DESC;

/*
-- Optimizacion de datos con index
CREATE INDEX ix_recoleccion_fecha_recol
  ON recoleccion (fecha, id_recoleccion);    

CREATE INDEX ix_detalle_recol
  ON recoleccion_detalle (id_recoleccion, id_tipo_residuo, cantidad_kg);  
  
-- 
EXPLAIN
SELECT
  u.nombre  AS Ubicacion,
  u.ciudad  AS Ciudad,
  SUM(CASE WHEN tr.clasificacion = 'Reciclable'
           THEN rd.cantidad_kg ELSE 0 END) AS KgReciclables
FROM recoleccion r
JOIN recoleccion_detalle rd ON rd.id_recoleccion  = r.id_recoleccion
JOIN ubicacion u            ON u.id_ubicacion     = r.id_ubicacion
JOIN tipo_residuo tr        ON tr.id_tipo_residuo = rd.id_tipo_residuo
GROUP BY u.id_ubicacion
ORDER BY KgReciclables DESC;
*/