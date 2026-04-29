function minimapa(terreno = control.terreno){
	with control{
		var width = ds_grid_width(terreno), height = ds_grid_height(terreno), temp_surf = surface_create(width * 2, height), temp_array_color = array_create(0, c_black)
		for(var a = 0; a < ore_max; a++)
			array_push(temp_array_color, recurso_color[ore_recurso[a]])
		surface_set_target(temp_surf)
		for(var b = height - 1; b >= 0; b--){
			var c = b & 1
			for(var a = width - 1; a >= 0; a--){
				draw_set_color(terreno_color[terreno[# a, b]])
				draw_rectangle(2 * a + c, b, 2 * a + c + 1, b, false)
				if edificio_bool[# a, b]{
					var edificio = edificio_id[# a, b]
					draw_set_color(equipo_color[edificio.jugador])
					draw_rectangle(2 * a + c, b, 2 * a + c + 1, b, false)
				}
				else{
					var d = ore[# a, b]
					if d >= 0{
						draw_set_color(temp_array_color[d])
						draw_set_alpha(0.8)
						draw_rectangle(2 * a + c, b, 2 * a + c + 1, b, false)
						draw_set_alpha(1)
					}
				}
			}
		}
		var minimap = sprite_create_from_surface(temp_surf, 0, 0, width * 2, height, false, false, 0, 0)
		surface_reset_target()
		surface_free(temp_surf)
		return minimap
	}
}