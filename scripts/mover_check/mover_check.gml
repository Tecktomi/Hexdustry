function mover_check(rss, edificio = control.null_edificio, target = control.null_edificio){
	with control{
		var index = target.index
		return (array_contains(edificio.outputs, target) and
			(target.carga_total < edificio_carga_max[index] and target.carga[rss] < target.carga_max[rss]) or index = id_nucleo) and
			not (tag_edificio_uranio[index] and tag_recurso_uranio[rss] and target.carga[idr_uranio_bruto] >= target.carga_max[idr_uranio_bruto]) and
			not (tag_edificio_piedra[index] and tag_recurso_piedra[rss] and target.carga[idr_piedra] >= target.carga_max[idr_piedra])
	}
}