SELECT
   concat(u.nombre, '-', u.ciudad) as Ubicacion,
    COUNT(rd.id_tipo_residuo) AS Total_Recolecciones,
    SUM(CASE 
		WHEN tr.nombre = 'Plástico' THEN 1 ELSE 0 
    END) AS Recolecciones_Plastico,
    (round(SUM(CASE
		WHEN tr.nombre = 'Plástico' THEN 1 ELSE 0 
    END) * 100.0 / 
    COUNT(rd.id_tipo_residuo),2)) AS Porcentaje_Eficiencia
FROM recoleccion r
JOIN ubicacion u 
	ON r.id_ubicacion = u.id_ubicacion
JOIN recoleccion_detalle rd 
	ON r.id_recoleccion = rd.id_recoleccion
JOIN tipo_residuo tr 
    ON rd.id_tipo_residuo = tr.id_tipo_residuo
GROUP BY Ubicacion
ORDER BY porcentaje_eficiencia DESC;