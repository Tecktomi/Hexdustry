function mover_check(rss, edificio = control.null_edificio, target = control.null_edificio){
	with control{
		return (array_contains(edificio.outputs, target) and
			(target.carga_total < edificio_carga_max[target.index] and target.carga[rss] < target.carga_max[rss]) or target.index = id_nucleo) and
			not (in(target.index, id_rifle, id_mortero) and in(rss, id_uranio_enriquecido, id_uranio_empobrecido) and target.carga[id_uranio_bruto] >= target.carga_max[id_uranio_bruto])
	}
}