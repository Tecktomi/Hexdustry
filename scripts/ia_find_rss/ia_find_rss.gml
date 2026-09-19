function ia_find_rss(_ore, _tiles_usados){
	with control{
		var len = array_length(ia_ores[_ore])
		if len = 0
			return {a : 0, b : 0, dir : 0, flag : false, dis : 0}
		var a, b, c, dir, dis, temp_complex, i, j, aa, bb, flag = false
		c = 0
		dis = infinity
		//Buscar ORE
		for(i = 0; i < len; i++){
			temp_complex = ia_ores[_ore, c++]
			a = temp_complex[0]
			b = temp_complex[1]
			dir = irandom(1)
			if check_colision(a, b, id_taladro, dir){
				flag = true
				break
			}
			dir = 1 - dir
			if check_colision(a, b, id_taladro, dir){
				flag = true
				break
			}
		}
		if not flag
			return {a : 0, b : 0, dir : 0, flag : false, dis : 0}
		array_push(ia_build_queue, [id_taladro, dir, a, b])
		//Limpiar terreno debajo
		var temp_list = get_size(a, b, dir, edificio_size[id_taladro]), angle
		len = array_length(temp_list)
		for(i = 0; i < len;){
			aa = temp_list[i++]
			bb = temp_list[i++]
			dis = min(dis, ia_grid_real[# aa, bb])
			for(j = 0; j < array_length(ia_ores[_ore]); j++)
				if aa = ia_ores[_ore, j][0] and bb = ia_ores[_ore, j][1]
					array_delete(ia_ores[_ore], j--, 1)
			_tiles_usados[# aa, bb] = true
		}
		//Buscar mejor salida
		temp_list = get_arround(a, b, dir, edificio_size[id_taladro])
		flag = false
		len = array_length(temp_list)
		for(i = 0; i < len;){
			a = temp_list[i++]
			b = temp_list[i++]
			if a < 0 or b < 0 or a >= xsize or b >= ysize
				continue
			if ia_grid_real[# a, b] < dis and (not edificio_bool[# a, b] or check_tile_usado(a, b, ia_tiles_nucleo)) and not _tiles_usados[# a, b]{
				dis = ia_grid_real[# a, b]
				aa = a
				bb = b
				flag = true
			}
		}
		return {a : aa, b : bb, dir : dir, flag : flag, dis : dis}
	}
}