function explosion(_x = 0, _y = 0, edificio = control.null_edificio, radio = 120, dmg = 1000, incendiario = false, _jugador = jugador, _target_dron = control.null_dron){
	with control{
		sound_play(snd_explosion, _x, _y)
		array_push(efectos, add_efecto(spr_explosion, 0, _x, _y, 24, 1 / 3))
		var temp_complex = xytoab(_x, _y), chunk_x, chunk_y, mina, minb, maxa, maxb, temp_array_edificios, temp_array_dron, dmg_total, a, b, c, i, dis, dron, flag = false
		if temp_complex[0] < 0 or temp_complex[1] < 0 or temp_complex[0] >= xsize or temp_complex[1] >= ysize
			exit
		chunk_x = floor(temp_complex[0] / CHUNK_WIDTH)
		chunk_y = floor(temp_complex[1] / CHUNK_HEIGHT)
		mina = max(chunk_x - 1, 0)
		minb = max(chunk_y - 1, 0)
		maxa = min(chunk_x + 1, chunk_xsize - 1)
		maxb = min(chunk_y + 1, chunk_ysize - 1)
		array_push(chunk_explosion[# chunk_x, chunk_y], {x : _x, y : _y, rot : sim_random(360)})
		dmg_total = 0
		if incendiario{
			for(a = mina; a <= maxa; a++)
				for(b = minb; b <= maxb; b++){
					//Herir edificios
					for(c = 0; c < EQUIPOS; c++) if not aliados[# _jugador, c]{
						temp_array_edificios = ds_grid_get(chunk_edificios_jugador[c], a, b)
						for(i = array_length(temp_array_edificios) - 1; i >= 0; i--){
							edificio = temp_array_edificios[i]
							dis = point_distance(_x, _y, edificio.center_x, edificio.center_y)
							if dis < radio
								if herir_edificio(dmg / (10 + dis), edificio)
									flag = true
								else{
									if edificio.fuego = 0
										array_disorder_push(edificios_fuego, edificio, ptre_fuego)
									edificio.fuego = 300
								}
						}
						//Herir drones
						temp_array_dron = ds_grid_get(chunk_dron_jugador[c], a, b)
						for(i = array_length(temp_array_dron) - 1; i >= 0; i--){
							dron = temp_array_dron[i]
							dis = point_distance(_x, _y, dron.x, dron.y)
							if dis < radio{
								if herir_dron(dmg / (10 + dis), dron) and dron = _target_dron
									flag = true
								else
									aplicar_efecto(1, 120, dron)
							}
						}
					}
				}
		}
		else{
			for(a = mina; a <= maxa; a++)
				for(b = minb; b <= maxb; b++){
					for(c = 0; c < EQUIPOS; c++) if not aliados[# _jugador, c]{
						temp_array_edificios = ds_grid_get(chunk_edificios_jugador[c], a, b)
						for(i = array_length(temp_array_edificios) - 1; i >= 0; i--){
							edificio = temp_array_edificios[i]
							dis = point_distance(_x, _y, edificio.center_x, edificio.center_y)
							if dis < radio and herir_edificio(dmg / (10 + dis), edificio)
								flag = true
						}
						//Herir drones
						temp_array_dron = ds_grid_get(chunk_dron_jugador[c], a, b)
						for(i = array_length(temp_array_dron) - 1; i >= 0; i--){
							dron = temp_array_dron[i]
							dis = point_distance(_x, _y, dron.x, dron.y)
							if dis < radio and herir_dron(dmg / (10 + dis), dron) and dron = _target_dron
								flag = true
						}
					}
				}
		}
		return flag
	}
}