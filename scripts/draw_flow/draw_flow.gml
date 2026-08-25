function draw_flow(){
	with control{
		var h = draw_get_halign(), v = draw_get_valign(), a, b, temp_complex, aa, bb, temp_priority, edificio, dir, temp_array_dron, temp_array_dron_2, temp_array_1
		var temp_array_2, temp_array_3, len, len_2, color, temp_terreno, temp_beta
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		if flow = 1{
			for(a = mina; a < maxa; a++) for(b = minb; b < maxb; b++) if terreno_caminable[terreno[# a, b]]{
				temp_complex = abtoxy(a, b)
				draw_text_off(temp_complex[0], temp_complex[1], ".")
			}
		}
		else if flow = 2{
			for(a = mina; a < maxa; a++) for(b = minb; b < maxb; b++) if terreno_caminable[terreno[# a, b]]{
				temp_complex = abtoxy(a, b)
				draw_text_off(temp_complex[0], temp_complex[1], edificio_cercano_dis[# a, b])
			}
		}
		else if flow = 3{
			for(a = mina; a < maxa; a++) for(b = minb; b < maxb; b++) if terreno_caminable[terreno[# a, b]]{
				temp_complex = abtoxy(a, b)
				temp_priority = ds_grid_get(edificio_cercano_priority, a, b)
				draw_text_off(temp_complex[0], temp_complex[1], ds_priority_size(temp_priority))
			}
		}
		else if flow = 4{
			for(a = mina; a < maxa; a++) for(b = minb; b < maxb; b++) if terreno_caminable[terreno[# a, b]]{
				temp_complex = abtoxy(a, b)
				temp_priority = ds_grid_get(edificio_cercano_priority, a, b)
				edificio = ds_priority_find_min(temp_priority)
				if edificio != undefined
					draw_text_off(temp_complex[0], temp_complex[1], edificio.index)
			}
		}
		else if flow = 5{
			for(a = mina; a < maxa; a++) for(b = minb; b < maxb; b++) if terreno_caminable[terreno[# a, b]]{
				dir = edificio_cercano_dir[# a, b]
				if dir != -1{
					temp_complex = abtoxy(a, b)
					aa = temp_complex[0]
					bb = temp_complex[1]
					draw_arrow_off(aa, bb, aa + 10 * COS_ANGLE_DIR[dir], bb - 10 * SIN_ANGLE_DIR[dir], 4)
				}
			}
		}
		else if flow = 6{
			for(a = min_chunka; a < max_chunka; a++) for(b = min_chunkb; b < max_chunkb; b++){
				temp_complex = abtoxy(a * CHUNK_WIDTH, b * CHUNK_HEIGHT)
				temp_array_dron = chunk_dron[# a, b]
				draw_text_off(temp_complex[0], temp_complex[1], $"{array_length(temp_array_dron)}")
			}
		}
		else if flow = 7{
			for(a = min_chunka; a < max_chunka; a++) for(b = min_chunkb; b < max_chunkb; b++){
				temp_complex = abtoxy(a * CHUNK_WIDTH, b * CHUNK_HEIGHT)
				temp_array_1 = chunk_edificios_estatico[# a, b]
				temp_array_2 = chunk_edificios_dinamico[# a, b]
				temp_array_3 = chunk_edificios_draw[# a, b]
				draw_text_off(temp_complex[0], temp_complex[1], $"{array_length(temp_array_1)}\n{array_length(temp_array_2)}\n{array_length(temp_array_3)}")
			}
		}
		else if flow = 8{
			len = array_length(betas)
			for(a = 0; a < len; a++){
				temp_beta = betas[a]
				len_2 = array_length(temp_beta.terrenos)
				color = make_color_hsv(255 * a / len, 127, 127)
				for(b = 0; b < len_2; b++){
					temp_terreno = temp_beta.terrenos[b]
					temp_complex = abtoxy(temp_terreno[0], temp_terreno[1])
					draw_sprite_off(spr_hexagono, 0, temp_complex[0], temp_complex[1],,,, color, 0.5)
				}
				draw_set_color(c_white)
				temp_complex = abtoxy(temp_beta.center_x, temp_beta.center_y)
				draw_text_off(temp_complex[0], temp_complex[1], a)
			}
		}
		else if flow = 9{
			for(a = mina; a < maxa; a++) for(b = minb; b < maxb; b++) if tag_agua[terreno[# a, b]]{
				temp_complex = abtoxy(a, b)
				draw_text_off(temp_complex[0], temp_complex[1], grid_water_distance[# a, b])
			}
		}
		else if flow = 10{
			for(a = mina; a < maxa; a++) for(b = minb; b < maxb; b++){
				temp_complex = abtoxy(a, b)
				draw_text_off(temp_complex[0], temp_complex[1], temperatura[# a, b])
			}
		}
		draw_set_halign(h)
		draw_set_valign(v)
	}
}