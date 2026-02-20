function scr_draw_bomba_par(edificio = control.null_edificio, offset_x = 0, offset_y = 0){
	with control{
		var index = edificio.index, dir = edificio.dir, aa = edificio.x + offset_x, bb = edificio.y + offset_y
		draw_sprite_off(edificio_sprite[index], 0, aa, bb, edificio.xscale)
		if edificio.flujo.liquido = -1
			draw_sprite_off(spr_bomba_color, 0, edificio.center_x, edificio.center_y)
		else
			draw_sprite_off(spr_bomba_color, 0, edificio.center_x, edificio.center_y,,,, liquido_color[edificio.flujo.liquido], edificio.flujo.almacen / edificio.flujo.almacen_max)
		draw_sprite_off(spr_bomba_rotor, 1, edificio.center_x, edificio.center_y,,, edificio.draw_rot)
		draw_sprite_off(spr_bomba_cupula, 1, edificio.center_x, edificio.center_y)
	}
}