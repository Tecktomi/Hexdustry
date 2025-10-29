function draw_boton_text(xpos, ypos, variable, es_real = true){
	with control{
		if draw_boton(xpos, ypos, (es_real ? "" : "'") + string(variable) + (es_real ? "" : "'"),,,, false){
			if es_real
				keyboard_string = string_digits(string(variable))
			else
				keyboard_string = string(variable)
			get_keyboard_string = draw_boton_text_counter
		}
		if get_keyboard_string = draw_boton_text_counter++{
			draw_line(xpos, ypos + 16, xpos + text_x, ypos + 16)
			if es_real
				variable = keyboard_string = "" ? 0 : real(string_digits(keyboard_string))
			else
				variable = keyboard_string
			exit_keyboard_input()
		}
		return variable
	}
}