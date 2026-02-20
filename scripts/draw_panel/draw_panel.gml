function draw_panel(x, y, w, h, deslizante_x = 0, deslizante_y = 0, this_input_data = 0, funcion = function(xpos = 0, ypos = 0, data = {}){}, data = {}){
	with control{
		gpu_set_scissor(x + 1, y + 1, w - 2, h - 2)
		var temp_complex = funcion(x - deslizante[deslizante_x], y - deslizante[deslizante_y], data)
		var ancho = temp_complex.a - (x - deslizante[deslizante_x])
		var alto = temp_complex.b - (y - deslizante[deslizante_y])
		gpu_set_scissor(0, 0, room_width, room_height)
		if ancho > w{
			draw_rectangle(x, y, x + w, y + h, true)
			deslizante[deslizante_x] = draw_deslizante(x, x + w, y + h + 5, deslizante[deslizante_x], 0, ancho - w, deslizante_x, this_input_data)
			if mouse_x > x and mouse_y > y and mouse_x < x + w and mouse_y < y + h{
				if mouse_wheel_up()
					deslizante[deslizante_x] = max(0, deslizante[deslizante_x] - 10)
				if mouse_wheel_down()
					deslizante[deslizante_x] = min(ancho - w, deslizante[deslizante_x] + 10)
			}
		}
		if alto > h{
			draw_rectangle(x, y, x + w, y + h, true)
			deslizante[deslizante_y] = draw_deslizante_vertical(x - 5, y, y + h, deslizante[deslizante_y], 0, alto - h, deslizante_y, this_input_data)
			if mouse_x > x and mouse_y > y and mouse_x < x + w and mouse_y < y + h{
				if mouse_wheel_up()
					deslizante[deslizante_y] = max(0, deslizante[deslizante_y] - 10)
				if mouse_wheel_down()
					deslizante[deslizante_y] = min(alto - h, deslizante[deslizante_y] + 10)
			}
		}
	}
}