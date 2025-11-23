function draw_boton_text(xpos, ypos, variable, es_real = true, detect_real = false, box = false, input_layer = 0){
	with control{
		if draw_boton(xpos, ypos, (es_real ? "" : "'") + string(variable) + (es_real ? "" : "'"),,,, box, input_layer){
			if detect_real
				es_real = (keyboard_string = string_digits(keyboard_string))
			if es_real
				keyboard_string = string_digits(string(variable))
			else
				keyboard_string = string(variable)
			get_keyboard_string = draw_boton_text_counter
			get_keyboard_cursor = string_length(keyboard_string) + 1
			get_keyboard_text = keyboard_string
			input_layer = 0
			editor_list = false
		}
		if get_keyboard_string = draw_boton_text_counter++{
			draw_line(xpos, ypos + 16, xpos + text_x, ypos + 16)
			if detect_real
				es_real = (keyboard_string = string_digits(keyboard_string))
			var pre_text = string_copy($"'get_keyboard_text'", 1, get_keyboard_cursor)
			var cursor_x = xpos + string_width(pre_text)
			draw_line(cursor_x, ypos, cursor_x, ypos + 16)
			if keyboard_check_pressed(vk_anykey){
				if keyboard_check_pressed(vk_left)
					get_keyboard_cursor = max(1, get_keyboard_cursor - 1)
				else if keyboard_check_pressed(vk_right)
					get_keyboard_cursor = min(string_length(get_keyboard_text) + 1, get_keyboard_cursor + 1)
				else if keyboard_check_pressed(vk_backspace) and get_keyboard_cursor > 1
					get_keyboard_text = string_delete(get_keyboard_text, --get_keyboard_cursor, 1)
				else{
					var new_input = keyboard_lastchar
					if new_input != "" and ord(new_input) >= 32 and ord(new_input) < 127
						get_keyboard_text = string_insert(new_input, get_keyboard_text, get_keyboard_cursor++)
				}
			}
			keyboard_string = get_keyboard_text
			if es_real
				variable = (string_digits(keyboard_string) = "" ? 0 : real(string_digits(keyboard_string)))
			else
				variable = keyboard_string
			exit_keyboard_input()
		}
		return variable
	}
}