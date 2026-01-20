function mover_check(rss, edificio = control.null_edificio, target = control.null_edificio){
	with control{
		var index = target.index
		return (array_contains(edificio.outputs, target) and
			(target.carga_total < edificio_carga_max[index] and target.carga[rss] < target.carga_max[rss]) or index = id_nucleo) and
			not (in(index, id_rifle, id_mortero, id_fabrica_de_drones) and in(rss, idr_uranio_enriquecido, idr_uranio_empobrecido) and target.carga[idr_uranio_bruto] >= target.carga_max[idr_uranio_bruto]) and
			not (in(index, id_triturador, id_fabrica_de_concreto) and in(rss, idr_piedra_cuprica, idr_piedra_ferrica, idr_piedra_sulfatada) and target.carga[idr_piedra] >= target.carga_max[idr_piedra])
	}
}