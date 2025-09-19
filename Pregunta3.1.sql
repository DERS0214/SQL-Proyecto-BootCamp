SELECT
   concat(u.nombre, '-', u.ciudad) as Ubicacion,
    COUNT(rd.id_tipo_residuo) AS total_recolecciones,
    (round(SUM(CASE WHEN tr.nombre = 'Orgánico' THEN 1 ELSE 0 END) * 100.0 / COUNT(rd.id_tipo_residuo),0)) AS Porcentaje_Organico,
    (round(SUM(CASE WHEN tr.nombre = 'Plástico' THEN 1 ELSE 0 END) * 100.0 / COUNT(rd.id_tipo_residuo),0)) AS Porcentaje_Plastico,
    (round(SUM(CASE WHEN tr.nombre = 'Vidrio' THEN 1 ELSE 0 END) * 100.0 / COUNT(rd.id_tipo_residuo),0)) AS Porcentaje_Vidrio,
    (round(SUM(CASE WHEN tr.nombre = 'Baterías' THEN 1 ELSE 0 END) * 100.0 / COUNT(rd.id_tipo_residuo),0)) AS Porcentaje_Baterias,
    (round(SUM(CASE WHEN tr.nombre= 'Escombros' THEN 1 ELSE 0 END) * 100.0 / COUNT(rd.id_tipo_residuo),0)) AS Porcentaje_Escombros,
    (round(SUM(CASE WHEN tr.nombre = 'Metales' THEN 1 ELSE 0 END) * 100.0 / COUNT(rd.id_tipo_residuo),0)) AS Porcentaje_Metales
FROM recoleccion r
JOIN ubicacion u 
	ON r.id_ubicacion = u.id_ubicacion
JOIN recoleccion_detalle rd 
	ON r.id_recoleccion = rd.id_recoleccion
JOIN tipo_residuo tr 
	ON rd.id_tipo_residuo = tr.id_tipo_residuo
GROUP BY Ubicacion
ORDER BY Ubicacion;