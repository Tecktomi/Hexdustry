function draw_boton_text_list_end(){
	with control{
		if not editor_list
			exit
		if get_keyboard_string >= 0{
			var max_width = 0, size = array_length(editor_array_name), a
			if array_length(editor_array) = 0{
				editor_array = array_create(size)
				for(a = 0; a < array_length(editor_array_name); a++)
					editor_array[a] = a
			}
			for(a = 0; a < min(editor_max_height, size); a++)
				max_width = max(max_width, string_width(editor_array_name[deslizante[get_keyboard_string] + a]))
			var color = draw_get_color(), item_height = DEVISE ? 20 : 40
			draw_set_color(c_ltgray)
			draw_rectangle(editor_xpos, editor_ypos + item_height, editor_xpos + max_width + item_height, editor_ypos + item_height * (min(editor_max_height, size) + 1), false)
			draw_set_color(c_black)
			draw_rectangle(editor_xpos, editor_ypos + item_height, editor_xpos + max_width + item_height, editor_ypos + item_height * (min(editor_max_height, size) + 1), true)
			draw_set_color(color)
			editor_ypos += item_height
			scroll(editor_xpos + 10, editor_ypos, size, editor_max_height, item_height, scroll_draw_boton_text_list_end, {xpos : editor_xpos + 20, ypos : editor_ypos}, get_keyboard_string)
		}
	}
}