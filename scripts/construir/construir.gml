function construir(index, dir, mx, my){
	with control{
		var flag = true, flag_2 = false, build_list = get_size(mx, my, dir, edificio_size[index]), edificio, temp_complex = abtoxy(mx, my)
		for(var a = ds_list_size(build_list) - 1; a >= 0; a--){
			var temp_complex_2 = build_list[|a], aa = temp_complex_2.a, bb = temp_complex_2.b
			//Asegurarse de que esté dentro del mundo
			if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize{
				flag = false
				break
			}
			var temp_terreno_terreno = terreno[# aa, bb]
			if in(terreno_nombre[temp_terreno_terreno], "Pared de Piedra", "Pared de Arena", "Pared de Nieve", "Pared de Pasto"){
				flag = false
				break
			}
			//Checkear coliciones
			if edificio_bool[# aa, bb] and not ((edificio_camino[index] or in(index, id_tunel, id_tunel_salida)) and edificio_camino[edificio_id[# aa, bb].index]){
				flag = false
				break
			}
			//Checkear agua
			if not in(index, id_bomba_de_evaporacion, id_bomba_hidraulica, id_tuberia, id_generador_geotermico) and terreno_liquido[temp_terreno_terreno]{
				flag = false
				break
			}
			//Reemplazar caminos
			if edificio_bool[# aa, bb]{
				var temp_edificio = edificio_id[# aa, bb]
				if (edificio_camino[index] or (in(index, id_tunel, id_tunel_salida))) and edificio_camino[temp_edificio.index]{
					if index = temp_edificio.index{
						temp_edificio.dir = dir
						calculate_in_out_2(temp_edificio)
						mover(aa, bb)
						var d = temp_edificio.dir * pi / 3 + pi / 6
						temp_edificio.array_real[0] = cos(d)
						temp_edificio.array_real[1] = -sin(d)
						flag = false
						if in(index, id_enrutador, id_cinta_magnetica){
							if (dir mod 3) = 1
								temp_edificio.yscale = power(-1, dir > 1)
							else{
								temp_edificio.xscale = power(-1, ((dir + 1) mod 6) > 1)
								temp_edificio.yscale = power(-1, dir > 2)
							}
						}
						else
							temp_edificio.draw_rot = (dir - 1) * 60
						break
					}
					else
						delete_edificio(aa, bb)
				}
			}
			//Checkear minerales
			if in(index, id_taladro, id_taladro_electrico) and ore[# aa, bb] >= 0
				flag_2 = true
			//Checkear minerales
			if in(index, id_taladro_electrico) and terreno_recurso_bool[temp_terreno_terreno]
				flag_2 = true
			//Checkear agua
			if in(index, id_bomba_hidraulica) and not terreno_liquido[temp_terreno_terreno]
				flag = false
			if in(index, id_bomba_de_evaporacion) and not in(terreno_nombre[temp_terreno_terreno], "Agua", "Agua Profunda")
				flag = false
		}
		//Detectar enemigos cerca
		if flag and not cheat{
			var size_2 = array_length(enemigos)
			for(var a = 0; a < size_2; a++){
				var enemigo = enemigos[a]
				if (sqr(enemigo.a - temp_complex.a) + sqr(enemigo.b - temp_complex.b)) < 10_000{//100^2
					flag = false
					break
				}
			}
		}
		if flag and in(index, id_taladro, id_taladro_electrico) and not flag_2
			flag = false
		if not flag
			return
		if in(index, id_tunel, id_tunel_salida) and build_able and build_target.index = 6
			index = 16
		edificio = add_edificio(index, dir, mx, my)
		//Algoritmo link de tuneles
		if in(index, id_tunel, id_tunel_salida){
			build_able = false
			var a = mx, b = my
			repeat(10){
				var temp_complex_2 = next_to(a, b, dir)
				a = temp_complex_2.a
				b = temp_complex_2.b
				if a < 0 or b < 0 or a >= xsize or b >= ysize
					break
				if edificio_bool[# a, b]{
					var edificio_2 = edificio_id[# a, b]
					if in(edificio_2.index, id_tunel, id_tunel_salida) and edificio_2.dir = (dir + 3) mod 6{
						build_target = edificio_2
						build_able = true
						break
					}
				}
			}
			build_dir = (dir + 3) mod 6
			edificio.idle = not build_able
			if build_able{
				if not build_target.idle{
					build_target.link.idle = true
					if build_target.index = 16{
						array_remove(build_target.inputs, build_target.link)
						array_remove(build_target.link.outputs, build_target)
					}
					else{
						array_remove(build_target.outputs, build_target.link)
						array_remove(build_target.link.inputs, build_target)
					}
				}
				build_target.idle = false
				if index = 16{
					array_push(edificio.inputs, build_target)
					array_push(build_target.outputs, edificio)
				}
				else{
					array_push(edificio.outputs, build_target)
					array_push(build_target.inputs, edificio)
				}
				edificio.link = build_target
				build_target.link = edificio
				if build_target.waiting
					mover(build_target.a, build_target.b)
			}
		}
		//Actualizar recursos
		if not cheat
			for(var a = 0; a < array_length(edificio_precio_id[index]); a++){
				nucleo.carga[edificio_precio_id[index, a]] -= edificio_precio_num[index, a]
				nucleo.carga_total -= edificio_precio_num[index, a]
			}
		if in(index, id_planta_quimica, id_fabrica_de_drones){
			show_menu = true
			show_menu_build = edificio
			build_index = 0
		}
	}
}