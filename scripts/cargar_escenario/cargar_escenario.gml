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
			var temp_nucleo = add_edificio(0, 0, ini_read_real("Global", "nucleo_x", floor(xsize / 2)), ini_read_real("Global", "nucleo_y", floor(ysize / 2)))
			delete_edificio(nucleo.a, nucleo.b, false)
			nucleo = temp_nucleo
			for(var a = 0; a < xsize; a++)
				for(var b = 0; b < ysize; b++){
					ds_grid_set(terreno, a, b, ini_read_real("Terreno", $"{a},{b}", 1))
					ds_grid_set(ore, a, b, ini_read_real("Ore", $"{a},{b}", -1))
					ds_grid_set(ore_amount, a, b, ini_read_real("Ore amount", $"{a},{b}", 0))
				}
			ini_close()
		}
		return file
	}
}