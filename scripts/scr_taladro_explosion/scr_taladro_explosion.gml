function scr_taladro_explosion(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if edificio.carga[13] > 0{
			if edificio.carga_total < edificio_carga_max[index] and ++edificio.proceso >= edificio_proceso[index]{
				sound_play(snd_explosion, edificio.x, edificio.y)
				edificio.carga[13]--
				edificio.carga_total--
				var temp_list = get_size(edificio.a, edificio.b, edificio.dir, edificio_size[index] + 2), flag = false
				for(var b = 0; b < ds_list_size(temp_list); b++){
					var temp_complex = temp_list[|b], aa = temp_complex.a, bb = temp_complex.b
					if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
						continue
					if ore[# aa, bb] >= 0{
						edificio.carga[ore_recurso[ore[# aa, bb]]]++
						edificio.carga_total++
						flag = true
					}
					else if in(terreno_nombre[terreno[# aa, bb]], "Piedra", "Arena", "Piedra Cúprica", "Piedra Férrica", "Basalto Sulfatado"){
						edificio.carga[terreno_recurso_id[terreno[# aa, bb]]]++
						edificio.carga_total++
						flag = true
					}
				}
				if flag
					edificio.waiting = not mover(edificio.a, edificio.b)
				else
					edificio.idle = true
				edificio.proceso -= edificio_proceso[index]
			}
		}
		if edificio.carga_total > edificio.carga[13]
			edificio.waiting = not mover(edificio.a, edificio.b)
	}
}