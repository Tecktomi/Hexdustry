function draw_boton_text_list(xpos, ypos, variable = 0, array_name = array_create(0, ""), array = array_create(0, 0), max_height = 25){
	with control{
		if draw_boton(xpos, ypos, array_name[variable],,,, false){
			get_keyboard_string = draw_boton_text_counter
			input_layer = 1
			deslizante[draw_boton_text_counter] = 0
		}
		if get_keyboard_string = draw_boton_text_counter++{
			var max_width = 0, size = array_length(array_name), a = text_x, des_index = draw_boton_text_counter - 1
			if array_length(array) = 0{
				array = array_create(size)
				for(var i = 0; i < array_length(array_name); i++)
					array[i] = i
			}
			editor_xpos = xpos
			editor_ypos = ypos
			editor_array = array
			editor_array_name = array_name
			editor_max_height = max_height
			editor_list = true
			for(var b = 0; b < min(max_height, size); b++)
				max_width = max(max_width, string_width(array_name[deslizante[des_index] + b]))
			draw_set_color(c_ltgray)
			draw_rectangle(xpos, ypos + 20, xpos + max_width + 20, ypos + 20 * (min(max_height, size) + 1), false)
			draw_set_color(c_black)
			draw_rectangle(xpos, ypos + 20, xpos + max_width + 20, ypos + 20 * (min(max_height, size) + 1), true)
			ypos += 20
			if size > max_height
				deslizante[des_index] = floor(draw_deslizante_vertical(xpos + 10, ypos, ypos + 20 * min(max_height, size), deslizante[des_index], 0, size - max_height, 0, 1))
			if deslizante[des_index] + max_height < size and mouse_wheel_down()
				deslizante[des_index]++
			if deslizante[des_index] > 0 and mouse_wheel_up()
				deslizante[des_index]--
			for(var i = deslizante[des_index]; i < min(deslizante[des_index] + max_height, size); i++){
				var j = array[i]
				if draw_boton(xpos + 20, ypos, array_name[j],,,, false, 1){
					get_keyboard_string = -1
					input_layer = 0
					text_x = a
					return j
				}
				ypos += text_y
			}
			text_x = a
			exit_keyboard_input()
		}
		return variable
	}
}