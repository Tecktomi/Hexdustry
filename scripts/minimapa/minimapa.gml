function minimapa(terreno = control.terreno){
	var width = ds_grid_width(terreno), height = ds_grid_height(terreno), temp_surf = surface_create(width, height)
	surface_set_target(temp_surf)
	for(var a = width - 1; a >= 0; a--)
		for(var b = height - 1; b >= 0; b--){
			draw_set_color(control.terreno_color[terreno[# a, b]])
			draw_point(a, b)
			var c = ore[# a, b]
			if c >= 0{
				draw_set_color(control.recurso_color[ore_recurso[c]])
				draw_set_alpha(0.8)
				draw_point(a, b)
				draw_set_alpha(1)
			}
		}
	var minimap = sprite_create_from_surface(temp_surf, 0, 0, width, height, false, false, 0, 0)
	surface_reset_target()
	surface_free(temp_surf)
	return minimap
}