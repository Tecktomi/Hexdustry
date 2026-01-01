function add_mision(){
	with control{
		var a = irandom(1)
		//Producir recursos
		if a = 0{
			mision_objetivo = [0]
			do var b = irandom(rss_max - 1)
			until recurso_tier[b] <= floor((misiones_pasadas + 2) / 3)
			mision_target_id = [b]
			mision_target_num = [irandom_range(max(10, 100 * (1 + misiones_pasadas) / (2 + recurso_tier[b])), min(20, 200 * (1 + misiones_pasadas) / (2 + recurso_tier[b])))]
			if b = id_uranio_enriquecido
				mision_target_num[0] = ceil(mision_target_num[0] / 20)
		}
		//Construir
		else if a = 1{
			mision_objetivo = [2]
			var c = irandom(min(array_length(tecnologia_nivel_edificios) - 1, floor((misiones_pasadas + 2) / 3)))
			do var b = tecnologia_nivel_edificios[c, irandom(array_length(tecnologia_nivel_edificios[c]) - 1)]
			until edificio_construible[b]
			mision_target_id = [b]
			mision_target_num = [irandom_range(max(1, 20 * (1 + misiones_pasadas) / edificio_precio[b]), min(1, 40 * (1 + misiones_pasadas) / edificio_precio[b]))]
		}
		mision_nombre = [""]
		mision_tiempo = [0]
		mision_switch_oleadas = [false]
		mision_camara_move = [false]
		mision_texto = [[]]
	}
}