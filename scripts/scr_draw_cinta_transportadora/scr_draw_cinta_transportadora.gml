function scr_draw_cinta_transportadora(edificio = control.null_edificio, offset_x = 0, offset_y = 0){
	draw_sprite_off(control.camino_general[edificio.dir, edificio.array_real[4]], image_index >> 1, edificio.x + offset_x, edificio.y + offset_y)
}