function scr_draw_mina(edificio = control.null_edificio, offset_x = 0, offset_y = 0){
	with control
		draw_sprite_off(tag_agua_profunda[terreno[# edificio.a, edificio.b]] ? edificio_sprite_2[id_mina] : edificio_sprite[id_mina], 0, edificio.x, edificio.y,,,,, 0.5)
}