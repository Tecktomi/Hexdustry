function menu_campanna(){
	with control{
		dibujar_fondo(1)
		draw_set_alpha(0.5)
		draw_set_color(c_black)
		draw_rectangle(0, 0, room_width, room_height, false)
		draw_set_alpha(1)
		draw_set_color(c_ltgray)
		draw_roundrect(100, 100, room_width - 100, room_height - 100, false)
		if draw_boton(110, 110, L.volver, ui_rojo) or keyboard_check_pressed(vk_escape){
			keyboard_clear(vk_escape)
			menu = 0
		}
		var total_width = WORLD_WIDTH * 96, total_height = WORLD_HEIGHT * TILE_WIDTH
		for(var a = 0; a < WORLD_WIDTH; a++)
			for(var b = 0; b < WORLD_HEIGHT; b++){
				var view = world_visible[# a, b]
				if view > 0{
					var temp_complex = abtoxy(a, b), aa =  2 * temp_complex[0] + (room_width - total_width) / 2, bb = 2 * temp_complex[1] + (room_height - total_height) / 2
					if draw_sprite_boton(world_sprite[# a, b],, aa, bb, 64, 56,, hover_sprite_boton_text({a : $"{a}, {b}, {view}"})) and view = 2{
						ini_open("settings.ini")
						if ini_key_exists("World mision", world_tutorial[# a, b]){
							var buffer = buffer_load($"Tutorial/mision{world_tutorial[# a, b]}.save")
							if load_game_buffer(buffer){
								game_start(, true)
								tutorial = world_tutorial[# a, b]
								tecnologia = true
								cheat = false
							}
						}
						else{
							var escenario = world_escenario[# a, b]
							if escenario != ""{
								var file = load_escenario_buffer(escenario)
								if file != ""
									game_start()
								tutorial = world_tutorial[# a, b]
								tecnologia = true
								cheat = false
							}
						}
						ini_close()
					}
					if view = 1
						draw_sprite_ext(spr_hexagono, 0, aa + 32, bb + TILE_WIDTH, 2, 2, 0, c_black, 0.5)
				}
			}
	}
}