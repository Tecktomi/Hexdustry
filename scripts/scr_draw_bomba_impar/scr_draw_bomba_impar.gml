function scr_draw_bomba_impar(edificio = control.null_edificio, offset_x = 0, offset_y = 0){
	with control{
		var index = edificio.index, dir = edificio.dir, aa = edificio.x + offset_x, bb = edificio.y + offset_y
		draw_sprite_off(edificio_sprite[index], 0, aa, bb)
		if edificio.flujo.liquido = -1
			draw_sprite_off(spr_bomba_color, 0, aa, bb)
		else
			draw_sprite_off(spr_bomba_color, 0, aa, bb,,,, liquido_color[edificio.flujo.liquido], edificio.flujo.almacen / edificio.flujo.almacen_max)
		draw_sprite_off(spr_bomba_rotor, 1, aa, bb,,, edificio.draw_rot)
		draw_sprite_off(spr_bomba_cupula, 1, aa, bb)
	}
}