function add_mision(){
	with control{
		mision = def_mision()
		var a = irandom(1)
		//Producir recursos
		if a = 0{
			mision.objetivo = 0
			do var b = irandom(rss_max - 1)
			until recurso_tier[b] <= floor((misiones_pasadas + 2) / 3) and not in(b, idr_piedra_sulfatada, idr_piedra_cuprica, idr_piedra_ferrica, idr_uranio_enriquecido, idr_uranio_empobrecido)
			mision.target_id = b
			mision.target_num = irandom_range(max(10, 100 * (1 + misiones_pasadas) / (2 + recurso_tier[b])), min(20, 200 * (1 + misiones_pasadas) / (2 + recurso_tier[b])))
		}
		//Construir
		else if a = 1{
			mision.objetivo = 2
			var c = irandom(min(array_length(tecnologia_nivel_edificios) - 1, floor((misiones_pasadas + 2) / 3)))
			do var b = tecnologia_nivel_edificios[c, irandom(array_length(tecnologia_nivel_edificios[c]) - 1)]
			until tag_edificio_construible[b]
			mision.target_id = b
			mision.target_num = irandom_range(max(1, 20 * (1 + misiones_pasadas) / edificio_precio[b]), min(1, 40 * (1 + misiones_pasadas) / edificio_precio[b]))
		}
		misiones = array_create(1, mision)
	}
}