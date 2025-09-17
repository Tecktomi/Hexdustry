function draw_path_find(){
	with control{
		var h = draw_get_halign(), v = draw_get_valign()
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		var mina = max(floor(camx / zoom / 48), 0), minb = max(floor(camy / zoom / 14), 0), maxa = ceil((camx + room_width) / zoom / 48), maxb = ceil((camy + room_height) / zoom / 14)
		switch flow{
			case 1:{
				for(var a = mina; a < maxa; a++) for(var b = minb; b < maxb; b++) if terreno_caminable[terreno[# a, b]]{
					var temp_complex = abtoxy(a, b), aa = temp_complex.a, bb = temp_complex.b
					draw_text_off(aa, bb, ".")
				}
				break
			}
			case 2:{
				for(var a = mina; a < maxa; a++) for(var b = minb; b < maxb; b++) if terreno_caminable[terreno[# a, b]]{
					var temp_complex = abtoxy(a, b), aa = temp_complex.a, bb = temp_complex.b
					draw_text_off(aa, bb, edificio_cercano_dis[# a, b])
				}
				break
			}
			case 3:{
				for(var a = mina; a < maxa; a++) for(var b = minb; b < maxb; b++) if terreno_caminable[terreno[# a, b]]{
					var temp_complex = abtoxy(a, b), aa = temp_complex.a, bb = temp_complex.b, temp_priority = ds_grid_get(edificio_cercano_priority, a, b)
					draw_text_off(aa, bb, ds_priority_size(temp_priority))
				}
				break
			}
			case 4:{
				for(var a = mina; a < maxa; a++) for(var b = minb; b < maxb; b++) if terreno_caminable[terreno[# a, b]]{
					var temp_complex = abtoxy(a, b), aa = temp_complex.a, bb = temp_complex.b, temp_priority = ds_grid_get(edificio_cercano_priority, a, b), temp_edificio = ds_priority_find_min(temp_priority)
					if temp_edificio != undefined
						draw_text_off(aa, bb, temp_edificio.index)
				}
				break
			}
			case 5:{
				for(var a = mina; a < maxa; a++) for(var b = minb; b < maxb; b++) if terreno_caminable[terreno[# a, b]]{
					var dir = edificio_cercano_dir[# a, b]
					if dir != -1{
						var temp_complex = abtoxy(a, b), aa = temp_complex.a, bb = temp_complex.b
						draw_arrow_off(aa, bb, aa + 10 * cos_angle_dir[dir], bb - 10 * sin_angle_dir[dir], 4)
					}
				}
				break
			}
		}
		draw_set_halign(h)
		draw_set_valign(v)
	}
}