function cargar_escenario(){
	with control{
		var file = get_open_filename("*.txt", game_save_id + "save.txt")
		if file != ""{
			ini_open(file)
			var prev_xsize = xsize
			xsize = ini_read_real("Global", "xsize", xsize)
			if xsize > prev_xsize
				resize_grid(prev_xsize, 0)
			var prev_ysize = ysize
			ysize = ini_read_real("Global", "ysize", ysize)
			if ysize > prev_ysize
				resize_grid(0, prev_ysize)
			spawn_x = ini_read_real("Global", "spawn_x", 0)
			spawn_y = ini_read_real("Global", "spawn_y", 0)
			for(var a = 0; a < rss_max; a++)
				carga_inicial[a] = ini_read_real("Carga inicial", a, 0)
			delete_edificio(nucleo.a, nucleo.b, false)
			var temp_nucleo = add_edificio(0, 0, ini_read_real("Global", "nucleo_x", floor(xsize / 2)), ini_read_real("Global", "nucleo_y", floor(ysize / 2)))
			nucleo = temp_nucleo
			array_copy(nucleo.carga, 0, carga_inicial, 0, rss_max)
			oleadas = bool(ini_read_real("Global", "oleadas", real(oleadas)))
			oleadas_tiempo_primera = ini_read_real("Global", "tiempo primera oleada", oleadas_tiempo_primera)
			oleadas_tiempo = ini_read_real("Global", "tiempo entre oleadas", oleadas_tiempo)
			var objetivos_max = ini_read_real("Global", "objetivos", 0)
			array_resize(mision_nombre, objetivos_max)
			array_resize(mision_objetivo, objetivos_max)
			array_resize(mision_target_id, objetivos_max)
			array_resize(mision_target_num, objetivos_max)
			for(var a = 0; a < objetivos_max; a++){
				mision_nombre[a] = ini_read_string($"Objetivo {a}", "nombre", $"objetivo {a}")
				mision_objetivo[a] = ini_read_real($"Objetivo {a}", "objetivo", 0)
				mision_target_id[a] = ini_read_real($"Objetivo {a}", "target_id", 0)
				mision_target_num[a] = ini_read_real($"Objetivo {a}", "target_num", 0)
			}
			ds_grid_clear(terreno, 0)
			ds_grid_clear(ore, -1)
			ds_grid_clear(ore_amount, 0)
			for(var a = 0; a < xsize; a++)
				for(var b = 0; b < ysize; b++){
					ds_grid_set(terreno, a, b, ini_read_real("Terreno", $"{a},{b}", 1))
					ds_grid_set(ore, a, b, ini_read_real("Ore", $"{a},{b}", -1))
					ds_grid_set(ore_amount, a, b, ini_read_real("Ore amount", $"{a},{b}", 0))
				}
			ini_close()
			for(var a = 0; a < xsize / chunk_width; a++)
				for(var b = 0; b < ysize / chunk_height; b++)
					update_background(chunk_width * a, chunk_height * b)
		}
		return file
	}
}