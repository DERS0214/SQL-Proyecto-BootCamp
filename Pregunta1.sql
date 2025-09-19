USE proyecto;
select U.nombre as Ubicacion, Tr.nombre as Tipo_Residuo
from recoleccion as R
join ubicacion as U
on R.id_ubicacion = U.id_ubicacion
join recoleccion_detalle as RD
on R.id_recoleccion = RD.id_recoleccion
join tipo_residuo as Tr
on RD.id_tipo_residuo = Tr.id_tipo_residuo
group by U.nombre, Tr.nombre
Having count(*) =
(select count(*) from recoleccion as r2
join recoleccion_detalle as RD2 
on r2.id_recoleccion = RD2.id_recoleccion
where id_ubicacion = r2.id_ubicacion
group by RD2.id_tipo_residuo
order by count(*) desc
limit 1);