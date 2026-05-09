function draw_boton_text_list(xpos, ypos, variable = 0, array_name = array_create(0, ""), array = array_create(0, 0), max_height = devise ? 25 : 15){
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
			xpos = clamp(xpos, 0, room_width - max_width - 20)
			ypos = clamp(ypos, 0, room_height - 20 * (min(max_height, size) + 1))
			editor_xpos = xpos
			editor_ypos = ypos
			editor_array = array
			editor_array_name = array_name
			editor_max_height = max_height
			editor_list = true
			for(var b = 0; b < min(max_height, size); b++)
				max_width = max(max_width, string_width(array_name[deslizante[des_index] + b]))
			var color = draw_get_color(), item_height = devise ? 20 : 40
			draw_set_color(c_ltgray)
			draw_rectangle(xpos, ypos + item_height, xpos + max_width + item_height, ypos + item_height * (min(max_height, size) + 1), false)
			draw_set_color(c_black)
			draw_rectangle(xpos, ypos + item_height, xpos + max_width + item_height, ypos + item_height * (min(max_height, size) + 1), true)
			draw_set_color(color)
			ypos += item_height
			var out = scroll(xpos + 10, ypos, size, max_height, item_height, scroll_draw_boton_text_list, {xpos : xpos + item_height, ypos : ypos, array : array, array_name : array_name, a : a, color : color}, des_index)
			if out != -1
				return out
			text_x = real(a)
			exit_keyboard_input()
		}
		return variable
	}
}