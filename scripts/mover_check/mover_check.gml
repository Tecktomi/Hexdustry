function mover_check(rss, edificio = control.null_edificio, target = control.null_edificio){
	with control{
		var index = target.index
		return (array_contains(edificio.outputs, target) and
			(target.carga_total < edificio_carga_max[index] and target.carga[rss] < target.carga_max[rss]) or index = id_nucleo) and
			not (in(index, id_rifle, id_mortero) and in(rss, id_uranio_enriquecido, id_uranio_empobrecido) and target.carga[id_uranio_bruto] >= target.carga_max[id_uranio_bruto]) and
			not (in(index, id_triturador, id_fabrica_de_concreto) and in(rss, id_piedra_cuprica, id_piedra_ferrica, id_piedra_sulfatada) and target.carga[id_piedra] >= target.carga_max[id_piedra])
	}
}