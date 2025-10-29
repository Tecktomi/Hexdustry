function draw_boton_text_list(xpos, ypos, variable = 0, array_name = array_create(0, ""), array = array_create(0, 0), max_height = 25){
	with control{
		if draw_boton(xpos, ypos, array_name[variable],,,, false){
			get_keyboard_string = draw_boton_text_counter
			input_layer = 1
		}
		if get_keyboard_string = draw_boton_text_counter++{
			var max_width = 0, size = array_length(array_name), a = text_x
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
				max_width = max(max_width, string_width(array_name[deslizante + b]))
			draw_set_color(c_ltgray)
			draw_rectangle(xpos, ypos + 20, xpos + max_width + 20, ypos + 20 * (min(max_height, size) + 1), false)
			draw_set_color(c_black)
			draw_rectangle(xpos, ypos + 20, xpos + max_width + 20, ypos + 20 * (min(max_height, size) + 1), true)
			ypos += 20
			if size > max_height
				deslizante = floor(draw_deslizante_vertical(xpos + 10, ypos, ypos + 20 * min(max_height, size), deslizante, 0, size - max_height, 0, 1))
			if deslizante + max_height < size and mouse_wheel_down()
				deslizante++
			if deslizante > 0 and mouse_wheel_up()
				deslizante--
			for(var i = deslizante; i < min(deslizante + max_height, size); i++){
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