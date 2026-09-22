function menu_first_time(){
	with control{
		dibujar_fondo(1)
		var text_array = ["English", "Español", "Русский"], ypos = 200
		draw_set_halign(fa_center)
		draw_set_font(font_titulo)
		for(var a = 0; a < IDIOMAS; a++){
			if draw_boton(room_width / 2, ypos, text_array[a], ui_verde){
				FIRST_TIME = false
				idioma = a
				set_idioma()
				load_escenario_buffer("mision_1.txt")
				game_start()
				tutorial = 1
				tecnologia = true
				cheat = false
			}
			ypos += text_y * 1.2
		}
		draw_text(room_width / 2, 40, L.menu_hexdustry)
		draw_set_halign(fa_left)
		draw_set_font(font_normal)
	}
}