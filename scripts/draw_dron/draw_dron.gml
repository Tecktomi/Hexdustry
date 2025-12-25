function draw_dron(dron = control.null_enemigo, enemigo = true){
	with control{
		var aa = dron.a, bb = dron.b, index = dron.index
		if index = 4{
			draw_sprite_off(dron_sprite[index], image_index / 2, aa, bb,,, dron.dir_move)
			draw_sprite_off(dron_sprite_color[index], 0, aa, bb,,, dron.dir)
		}
		else if index = 5{
			draw_sprite_off(dron_sprite[index], image_index / 2, aa, bb,,, dron.dir)
			draw_sprite_off(dron_sprite_color[index], 0, aa, bb,,, image_index * 15, enemigo ? c_red : c_blue)
		}
		else if index = 6{
			draw_sprite_off(dron_sprite_color[index], 0, aa, bb,,, dron.dir + 20 * sin(image_index / 20 + dron.random_int * 90))
			draw_sprite_off(dron_sprite_color[index], 0, aa, bb,,, dron.dir + 90 - 20 * sin(image_index / 20 + dron.random_int * 90))
			draw_sprite_off(dron_sprite_color[index], 0, aa, bb,,, dron.dir + 180 - 20 * sin(image_index / 20 + dron.random_int * 90))
			draw_sprite_off(dron_sprite_color[index], 0, aa, bb,,, dron.dir + 270 + 20 * sin(image_index / 20 + dron.random_int * 90))
			draw_sprite_off(dron_sprite[index], image_index / 2, aa, bb,,, dron.dir_move)
		}
		else{
			draw_sprite_off(dron_sprite[index], image_index / 2, aa, bb,,, dron.dir)
			draw_sprite_off(dron_sprite_color[index], 0, aa, bb,,, dron.dir, enemigo ? c_red : c_blue)
		}
	}
}