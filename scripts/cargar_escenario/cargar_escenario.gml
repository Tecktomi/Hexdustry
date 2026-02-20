function cargar_escenario(file = "", config = true){
	with control{
		if file = ""
			file = get_open_filename("*.txt", "save.txt")
		if file = ""
			exit
		ini_open(file)
		var prev_xsize = xsize
		xsize = ini_read_real("Global", "xsize", xsize)
		if xsize != prev_xsize
			resize_grid(prev_xsize, 0)
		var prev_ysize = ysize
		ysize = ini_read_real("Global", "ysize", ysize)
		if ysize != prev_ysize
			resize_grid(0, prev_ysize)
		spawn_x = ini_read_real("Global", "spawn_x", 0)
		spawn_y = ini_read_real("Global", "spawn_y", 0)
		if config{
			for(var a = 0; a < rss_max; a++)
				carga_inicial[a] = ini_read_real("Carga inicial", a, 0)
			oleadas = bool(ini_read_real("Global", "oleadas", real(oleadas)))
			oleadas_tiempo_primera = ini_read_real("Global", "tiempo primera oleada", oleadas_tiempo_primera)
			oleadas_tiempo = ini_read_real("Global", "tiempo entre oleadas", oleadas_tiempo)
			var objetivos_max = ini_read_real("Global", "objetivos", 0)
			if objetivos_max > 0
				mision_texto_victoria = ini_read_string("Global", "texto victoria", mision_texto_victoria)
			array_resize(mision_nombre, objetivos_max)
			array_resize(mision_objetivo, objetivos_max)
			array_resize(mision_target_id, objetivos_max)
			array_resize(mision_target_num, objetivos_max)
			array_resize(mision_tiempo, objetivos_max)
			array_resize(mision_tiempo_edit, objetivos_max)
			array_resize(mision_tiempo_victoria, objetivos_max)
			array_resize(mision_tiempo_show, objetivos_max)
			array_resize(mision_camara_move, objetivos_max)
			array_resize(mision_camara_x, objetivos_max)
			array_resize(mision_camara_y, objetivos_max)
			array_resize(mision_texto, objetivos_max)
			array_resize(mision_switch_oleadas, objetivos_max)
			for(var a = 0; a < objetivos_max; a++){
				if ini_key_exists($"Objetivo {a}", $"nombre_{idioma_name[idioma]}")
					mision_nombre[a] = ini_read_string($"Objetivo {a}", $"nombre_{idioma_name[idioma]}", $"objetivo {a}")
				else
					mision_nombre[a] = ini_read_string($"Objetivo {a}", "nombre", $"objetivo {a}")
				mision_objetivo[a] = ini_read_real($"Objetivo {a}", "objetivo", 0)
				mision_target_id[a] = ini_read_real($"Objetivo {a}", "target_id", 0)
				mision_target_num[a] = ini_read_real($"Objetivo {a}", "target_num", 0)
				mision_tiempo[a] = ini_read_real($"Objetivo {a}", "tiempo", 0)
				mision_tiempo_edit[a] = (mision_tiempo[a] > 0)
				mision_tiempo_victoria[a] = bool(ini_read_real($"Objetivo {a}", "tiempo victoria", 0))
				mision_tiempo_show[a] = bool(ini_read_real($"Objetivo {a}", "tiempo show", 1))
				mision_camara_move[a] = bool(ini_read_real($"Objetivo {a}", "camara move", 0))
				mision_camara_x[a] = ini_read_real($"Objetivo {a}", "camara x", 0)
				mision_camara_y[a] = ini_read_real($"Objetivo {a}", "camara y", 0)
				var objetivo_textos = ini_read_real($"Objetivo {a}", "textos", 0)
				array_set(mision_texto, a, [])
				array_resize(mision_texto[a], objetivo_textos)
				for(var b = 0; b < objetivo_textos; b++){
					if ini_key_exists($"Objetivo {a}", $"texto {b}_{idioma_name[idioma]}")
						var text = ini_read_string($"Objetivo {a}", $"texto {b}_{idioma_name[idioma]}", "")
					else
						text = ini_read_string($"Objetivo {a}", $"texto {b}", "")
					array_set(mision_texto[a], b, {
						x : ini_read_real($"Objetivo {a}", $"x {b}", 0),
						y : ini_read_real($"Objetivo {a}", $"y {b}", 0),
						texto : text
					})
				}
				mision_switch_oleadas[a] = bool(ini_read_real($"Objetivo {a}", "switch oleadas", 0))
			}
			//0 = no disponible, 1 = investigable, 2 = investigado
			for(var a = 0; a < edificio_max; a++){
				var b = ini_read_real("Edificios", a, 2)
				mision_edificios[a] = (b > 0)
				edificio_tecnologia[a] = (b = 2)
				edificio_tecnologia_desbloqueable[a] = (b = 1)
			}
			for(var a = 0; a < edificio_max; a++)
				if not edificio_tecnologia[a] and edificio_tecnologia_desbloqueable[a]{
					var flag = true
					for(var b = array_length(edificio_tecnologia_prev[a]) - 1; b >= 0; b--)
						if not edificio_tecnologia[edificio_tecnologia_prev[a, b]]{
							flag = false
							break
						}
					if not flag
						edificio_tecnologia_desbloqueable[a] = false
				}
			categoria_edificios_disponible = array_create(0, array_create(0, 0))
			categoria_nombre_disponible = array_create(0, "")
			categoria_index_disponible = array_create(0, 0)
			//Crear rueda de edificios
			for(var a = 0; a < array_length(categoria_nombre); a++){
				var temp_array = array_create(0, 0)
				for(var b = 0; b < array_length(categoria_edificios[a]); b++){
					var c = categoria_edificios[a, b]
					if mision_edificios[c]
						array_push(temp_array, c)
				}
				if array_length(temp_array) > 0{
					array_push(categoria_edificios_disponible, temp_array)
					array_push(categoria_nombre_disponible, categoria_nombre[a])
					array_push(categoria_index_disponible, a)
				}
			}
			multiplicador_vida_enemigos = ini_read_real("Global", "Multiplicador vida enemigos", 100)
		}
		ds_grid_clear(terreno, 0)
		ds_grid_clear(ore, -1)
		ds_grid_clear(ore_amount, 0)
		ds_grid_clear(edificio_cercano, null_edificio)
		ds_grid_clear(edificio_cercano_dis, infinity)
		ds_grid_clear(edificio_cercano_dir, -1)
		var max_index = ini_read_real("Terreno", "Fondo", 1)
		for(var a = 0; a < xsize; a++)
			for(var b = 0; b < ysize; b++){
				set_terreno(a, b, ini_read_real("Terreno", $"{a},{b}", max_index))
				ds_grid_set(ore, a, b, ini_read_real("Ore", $"{a},{b}", -1))
				ds_grid_set(ore_amount, a, b, ini_read_real("Ore amount", $"{a},{b}", 0))
			}
		delete_edificio(nucleo, false)
		for(var a = 0; a < xsize; a++)
			for(var b = 0; b < ysize; b++){
				var temp_priority = ds_grid_get(edificio_cercano_priority, a, b)
				ds_priority_clear(temp_priority)
			}
		ds_grid_clear(chunk_edificios_dirty, true)
		for(var a = 0; a < chunk_xsize; a++)
			for(var b = 0; b < chunk_ysize; b++){
				ds_grid_set(background, a, b, spr_hexagono)
				ds_grid_set(chunk_edificios_background, a, b, spr_hexagono)
				ds_grid_set(chunk_dron_enemigo, a, b, array_create(0, null_dron))
				ds_grid_set(chunk_dron_aliado, a, b, array_create(0, null_dron))
				var chunk = chunk_edificios[# a, b], len = array_length(chunk)
				for(var c = 0; c < len; c++)
					delete_edificio(chunk[c])
				ds_grid_set(chunk_edificios, a, b, array_create(0, null_edificio))
				chunk = chunk_edificios_enemigo[# a, b]
				len = array_length(chunk)
				for(var c = 0; c < len; c++)
					delete_edificio(chunk[c])
				ds_grid_set(chunk_edificios_enemigo, a, b, array_create(0, null_edificio))
				ds_grid_set(chunk_edificios_estatico, a, b, array_create(0, null_edificio))
				ds_grid_set(chunk_edificios_dinamico, a, b, array_create(0, null_edificio))
				ds_grid_set(chunk_edificios_draw, a, b, array_create(0, null_edificio))
			}
		nucleo = add_edificio(0, 0, ini_read_real("Global", "nucleo_x", floor(xsize / 2)), ini_read_real("Global", "nucleo_y", floor(ysize / 2)))
		array_copy(nucleo.carga, 0, carga_inicial, 0, rss_max)
		var edificios_enemigos_total = ini_read_real("Edificios enemigos", "total", 0)
		for(var i = edificios_enemigos_total - 1; i >= 0; i--){
			var a = ini_read_real("Edificios enemigos", $"{i}.a", 0)
			var b = ini_read_real("Edificios enemigos", $"{i}.b", 0)
			var index = ini_read_real("Edificios enemigos", $"{i}.index", 0)
			var dir = ini_read_real("Edificios enemigos", $"{i}.dir", 0)
			var edificio = construir(index, dir, a, b, true)
			if edificio_seteable[index]{
				var mode = bool(ini_read_real("Edificios enemigos", $"{i}.mode", 0))
				var select = ini_read_real("Edificios enemigos", $"{i}.select", 0)
				set_edificio(mode, select, edificio)
			}
		}
		ini_close()
		for(var a = 0; a < chunk_xsize; a++)
			for(var b = 0; b < chunk_ysize; b++)
				update_background(chunk_width * a, chunk_height * b)
		return file
	}
}