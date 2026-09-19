function build_rueda_flujos(_change){
	with control{
		if _change{
			var _temp_array_liquidos = array_create(liquido_max, false)
			var len = array_length(build_list_arround), aa, bb
			for(var a = 0; a < len;){
				aa = build_list_arround[a++]
				bb = build_list_arround[a++]
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
					continue
				if edificio_bool[# aa, bb]{
					var temp_edificio = edificio_id[# aa, bb]
					if edificio_flujo[temp_edificio.index]{
						if temp_edificio.flujo != null_flujo and temp_edificio.flujo.liquido != -1
							_temp_array_liquidos[temp_edificio.flujo.liquido] = true
						if temp_edificio.flujo_2 != null_flujo and temp_edificio.flujo_2.liquido != -1
							_temp_array_liquidos[temp_edificio.flujo_2.liquido] = true
					}
				}
			}
			array_resize(liquido_choose_array, 0)
			for(var a = 0; a < liquido_max; a++)
				if _temp_array_liquidos[a]
					array_push(liquido_choose_array, a)
		}
		var _len = array_length(liquido_choose_array)
		if _len > 1{
			var temp_complex = abtoxy(temp_mx, temp_my)
			var aa = temp_complex[0]
			var bb = temp_complex[1]
			var b = 2 * pi / _len
			draw_set_color(c_white)
			draw_set_alpha(0.5)
			draw_circle_off(aa, bb, 60, false)
			for(var a = -5; a < 5; a++)
				draw_triangle_off(aa, bb, aa + 60 * cos((liquido_choose + 0.1 * a) * b), bb + 60 * sin((liquido_choose + 0.1 * a) * b), aa + 60 * cos((liquido_choose + 0.1 * (a + 1)) * b), bb + 60 * sin((liquido_choose + 0.1 * (a + 1)) * b), false)
			draw_set_alpha(1)
			for(var a = 0; a < _len; a++)
				draw_sprite_off(liquido_sprite[liquido_choose_array[a]], 0, aa + 50 * cos(a * b), bb + 50 * sin(a * b))
			if mouse_wheel_up()
				liquido_choose = (liquido_choose + 1) mod _len
			if mouse_wheel_down()
				liquido_choose = (liquido_choose + _len - 1) mod _len
		}
	}
}