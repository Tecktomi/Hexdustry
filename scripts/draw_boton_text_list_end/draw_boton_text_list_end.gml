function draw_boton_text_list_end(){
	with control{
		if not editor_list
			exit
		if get_keyboard_string >= 0{
			var max_width = 0, size = array_length(editor_array_name)
			if array_length(editor_array) = 0{
				editor_array = array_create(size)
				for(var i = 0; i < array_length(editor_array_name); i++)
					editor_array[i] = i
			}
			for(var b = 0; b < min(editor_max_height, size); b++)
				max_width = max(max_width, string_width(editor_array_name[deslizante[get_keyboard_string] + b]))
			var color = draw_get_color()
			draw_set_color(c_ltgray)
			draw_rectangle(editor_xpos, editor_ypos + 20, editor_xpos + max_width + 20, editor_ypos + 20 * (min(editor_max_height, size) + 1), false)
			draw_set_color(c_black)
			draw_rectangle(editor_xpos, editor_ypos + 20, editor_xpos + max_width + 20, editor_ypos + 20 * (min(editor_max_height, size) + 1), true)
			draw_set_color(color)
			editor_ypos += 20
			scroll(editor_xpos + 10, editor_ypos, size, editor_max_height, 20, scroll_draw_boton_text_list_end, {xpos : editor_xpos + 20, ypos : editor_ypos}, get_keyboard_string)
		}
	}
}