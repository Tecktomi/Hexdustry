function draw_edificio_borde(edificio = control.null_edificio, col = c_white, alpha = 1){
	with control{
		var index = edificio.index, a = edificio.x, b = edificio.y, dir = edificio.dir
		if edificio_size[index] mod 2 = 0{
			var sprite = (edificio_size[index] = 2) ? spr_borde_2 : spr_borde_4
			draw_sprite_off(sprite, 0, a, b, -1 + 2 * (dir = 0),,, col, alpha)
		}
		else if edificio_size[index] = 2.5{
			if dir = 0
				draw_sprite_off(spr_borde_2_5, 0, a, b,,,, col, alpha)
			else if dir = 1
				draw_sprite_off(spr_borde_2_5, 0, a, b,, -1,, col, alpha)
			else if dir = 2
				draw_sprite_off(spr_borde_2_5_b, 0, a, b,,,, col, alpha)
			else if dir = 3
				draw_sprite_off(spr_borde_2_5, 0, a, b, -1, -1,, col, alpha)
			else if dir = 4
				draw_sprite_off(spr_borde_2_5, 0, a, b, -1,,, col, alpha)
			else if dir = 5
				draw_sprite_off(spr_borde_2_5_b, 0, a, b,, -1,, col, alpha)
		}
		else{
			var sprite = (edificio_size[index] = 1) ? spr_borde_1 : spr_borde_3
			draw_sprite_off(sprite, 0, a, b,,,, col, alpha)
		}
	}
}