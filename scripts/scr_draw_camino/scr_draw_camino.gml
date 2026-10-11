function scr_draw_camino(edificio = control.null_edificio, offset_x = 0, offset_y = 0){
	draw_sprite_off(control.edificio_sprite[edificio.index], image_index << 2, edificio.x + offset_x, edificio.y + offset_y,,, edificio.draw_rot)
}