function scr_draw_selector(edificio = control.null_edificio, offset_x = 0, offset_y = 0){
	with control{
		var _x = edificio.x + offset_x, _y = edificio.y + offset_y
		draw_sprite_off(edificio_sprite[id_selector], real(edificio.mode), _x, _y,,, edificio.draw_rot)
		if edificio.select >= 0
			draw_sprite_off(edificio_sprite_2[id_selector], 0, _x, _y,,, edificio.draw_rot, recurso_color[edificio.select])
	}
}