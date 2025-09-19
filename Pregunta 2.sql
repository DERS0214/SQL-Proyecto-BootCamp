SELECT
    DATE_FORMAT(fecha, '%W') AS Dia_semana,
    COUNT(*) AS Total_recolecciones
FROM recoleccion
GROUP BY Dia_semana
ORDER BY total_recolecciones DESC
LIMIT 1;