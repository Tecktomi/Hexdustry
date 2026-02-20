function scr_draw_pantalla(edificio = control.null_edificio, offset_x = 0, offset_y = 0){
	with control{
		var index = edificio.index, dir = edificio.dir, aa = edificio.x + offset_x, bb = edificio.y + offset_y
		draw_sprite_off(edificio_sprite[index], 0, aa, bb)
		if edificio.mode{
			var d = array_create(0, array_create(1, 0)), color = draw_get_color()
			draw_set_font(ft_mini)
			var temp_surf = surface_create(60, 50), size = array_length(edificio.instruccion)
			surface_set_target(temp_surf)
			for(var c = 0; c < size; c++){
				d = edificio.instruccion[c]
				var e = d[0]
				if e = 0
					draw_set_color(make_color_rgb(d[1], d[2], d[3]))
				else if e = 1
					draw_set_color(make_color_hsv(d[1], d[2], d[3]))
				else if e = 2
					draw_rectangle(d[1], d[2], d[1] + d[3], d[2] + d[4], false)
				else if e = 3
					draw_line(d[1], d[2], d[3], d[4])
				else if e = 4
					draw_triangle(d[1], d[2], d[3], d[4], d[5], d[6], false)
				else if e = 5
					draw_circle(d[1], d[2], d[3], false)
				else if e = 6
					draw_text(d[1], d[2], d[3])
			}
			edificio.imagen = sprite_create_from_surface(temp_surf, 0, 0, 60, 50, false, false, 0, 0)
			edificio.modo = false
			surface_reset_target()
			surface_free(temp_surf)
			draw_set_font(font_normal)
			draw_set_color(color)
		}
		if edificio.imagen != spr_hexagono
			draw_sprite_off(edificio.imagen, 0, aa - 30, bb - 25)
	}
}