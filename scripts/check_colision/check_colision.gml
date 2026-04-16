function check_colision(a, b, index, dir){
	with control{
		var size = get_size(a, b, dir, edificio_size[index]), flag = true
		var temp_es_camino = (grafic_array_camino_o_tunel[index] or index = id_cruce)
		var temp_sobre_hielo = (edificio_size[index] > 1 and index != id_extractor_atmosferico)
		var temp_sobre_liquido = (not grafic_array_construible_en_liquido[index])
		var es_taladro_pesado = in(index, id_taladro_electrico, id_taladro_de_explosion)
		var es_taladro = ((index = id_taladro) or es_taladro_pesado)
		if es_taladro or in(index, id_bomba_hidraulica, id_bomba_de_evaporacion, id_generador_geotermico)
			flag = false
		for(var i = 0; i < array_length(size); i++){
			var aa = size[i, 0], bb = size[i, 1]
			if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
				return false
			if edificio_bool[# aa, bb]{
				if temp_es_camino{
					var edificio = edificio_id[# aa, bb]
					if not ((edificio_camino[edificio.index] or edificio.index = id_cruce))
						return false
				}
				else
					return false
			}
			var temp_terreno = terreno[# aa, bb]
			if terreno_pared[temp_terreno]
				return false
			if temp_terreno = idt_hielo and not temp_sobre_hielo
				return false
			if terreno_liquido[temp_terreno] and not temp_sobre_liquido
				return false
			if not flag{
				if es_taladro and (ore[# aa, bb] >= 0 or (es_taladro_pesado and terreno_recurso_bool[temp_terreno]))
					flag = true
				else if index = id_bomba_hidraulica and terreno_liquido[temp_terreno]
					flag = true
				else if index = id_bomba_de_evaporacion and grafic_array_agua_baja[temp_terreno]
					flag = true
				else if index = id_generador_geotermico and temp_terreno = idt_lava
					flag = true
			}
		}
		if es_taladro or in(index, id_bomba_hidraulica, id_bomba_de_evaporacion, id_generador_geotermico)
			return flag
		return true
	}
}