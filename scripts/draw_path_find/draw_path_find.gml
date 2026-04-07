function draw_path_find(){
	with control{
		var h = draw_get_halign(), v = draw_get_valign()
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		switch flow{
			case 1:{
				for(var a = mina; a < maxa; a++) for(var b = minb; b < maxb; b++) if terreno_caminable[terreno[# a, b]]{
					var temp_complex = abtoxy(a, b), aa = temp_complex[0], bb = temp_complex[1]
					draw_text_off(aa, bb, ".")
				}
				break
			}
			case 2:{
				for(var a = mina; a < maxa; a++) for(var b = minb; b < maxb; b++) if terreno_caminable[terreno[# a, b]]{
					var temp_complex = abtoxy(a, b), aa = temp_complex[0], bb = temp_complex[1]
					draw_text_off(aa, bb, edificio_cercano_dis[# a, b])
				}
				break
			}
			case 3:{
				for(var a = mina; a < maxa; a++) for(var b = minb; b < maxb; b++) if terreno_caminable[terreno[# a, b]]{
					var temp_complex = abtoxy(a, b), aa = temp_complex[0], bb = temp_complex[1], temp_priority = ds_grid_get(edificio_cercano_priority, a, b)
					draw_text_off(aa, bb, ds_priority_size(temp_priority))
				}
				break
			}
			case 4:{
				for(var a = mina; a < maxa; a++) for(var b = minb; b < maxb; b++) if terreno_caminable[terreno[# a, b]]{
					var temp_complex = abtoxy(a, b), aa = temp_complex[0], bb = temp_complex[1], temp_priority = ds_grid_get(edificio_cercano_priority, a, b), temp_edificio = ds_priority_find_min(temp_priority)
					if temp_edificio != undefined
						draw_text_off(aa, bb, temp_edificio.index)
				}
				break
			}
			case 5:{
				for(var a = mina; a < maxa; a++) for(var b = minb; b < maxb; b++) if terreno_caminable[terreno[# a, b]]{
					var dir = edificio_cercano_dir[# a, b]
					if dir != -1{
						var temp_complex = abtoxy(a, b), aa = temp_complex[0], bb = temp_complex[1]
						draw_arrow_off(aa, bb, aa + 10 * cos_angle_dir[dir], bb - 10 * sin_angle_dir[dir], 4)
					}
				}
				break
			}
			case 6:{
				for(var a = min_chunka; a < max_chunka; a++) for(var b = min_chunkb; b < max_chunkb; b++){
					var temp_complex = abtoxy(a * chunk_width, b * chunk_height)
					var temp_array_dron = chunk_dron_enemigo[# a, b], temp_array_dron_2 = chunk_dron_aliado[# a, b]
					draw_text_off(temp_complex[0], temp_complex[1], $"{array_length(temp_array_dron)}\n{array_length(temp_array_dron_2)}")
				}
				break
			}
			case 7:{
				for(var a = min_chunka; a < max_chunka; a++) for(var b = min_chunkb; b < max_chunkb; b++){
					var temp_complex = abtoxy(a * chunk_width, b * chunk_height)
					var temp_array_1 = chunk_edificios_estatico[# a, b], temp_array_2 = chunk_edificios_dinamico[# a, b], temp_array_3 = chunk_edificios_draw[# a, b]
					draw_text_off(temp_complex[0], temp_complex[1], $"{array_length(temp_array_1)}\n{array_length(temp_array_2)}\n{array_length(temp_array_3)}")
				}
				break
			}
			case 8:{
				var len = array_length(betas)
				for(var a = 0; a < len; a++){
					var temp_beta = betas[a], len_2 = array_length(temp_beta.terrenos), color = make_color_hsv(255 * a / len, 127, 127)
					for(var b = 0; b < len_2; b++){
						var temp_terreno = temp_beta.terrenos[b], temp_complex = abtoxy(temp_terreno[0], temp_terreno[1])
						draw_sprite_off(spr_hexagono, 0, temp_complex[0], temp_complex[1],,,, color, 0.5)
					}
					draw_set_color(c_white)
					var temp_complex = abtoxy(temp_beta.center_x, temp_beta.center_y)
					draw_text_off(temp_complex[0], temp_complex[1], a)
				}
				break
			}
		}
		draw_set_halign(h)
		draw_set_valign(v)
	}
}