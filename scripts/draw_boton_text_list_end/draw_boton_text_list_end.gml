function draw_boton_text_list_end(){
	with control{
		if not editor_list
			return undefined
		if get_keyboard_string >= 0{
			var max_width = 0, size = array_length(editor_array_name)
			if array_length(editor_array) = 0{
				editor_array = array_create(size)
				for(var i = 0; i < array_length(editor_array_name); i++)
					editor_array[i] = i
			}
			for(var b = 0; b < min(editor_max_height, size); b++)
				max_width = max(max_width, string_width(editor_array_name[deslizante + b]))
			draw_set_color(c_ltgray)
			draw_rectangle(editor_xpos, editor_ypos + 20, editor_xpos + max_width + 20, editor_ypos + 20 * (min(editor_max_height, size) + 1), false)
			draw_set_color(c_black)
			draw_rectangle(editor_xpos, editor_ypos + 20, editor_xpos + max_width + 20, editor_ypos + 20 * (min(editor_max_height, size) + 1), true)
			editor_ypos += 20
			if size > editor_max_height
				deslizante = floor(draw_deslizante_vertical(editor_xpos + 10, editor_ypos, editor_ypos + 20 * min(editor_max_height, size), deslizante, 0, size - editor_max_height, 0, 1))
			if deslizante + editor_max_height < size and mouse_wheel_down()
				deslizante++
			if deslizante > 0 and mouse_wheel_up()
				deslizante--
			for(var i = deslizante; i < min(deslizante + editor_max_height, size); i++){
				var j = editor_array[i]
				draw_boton(editor_xpos + 20, editor_ypos, editor_array_name[j],,,, false, 1)
				editor_ypos += text_y
			}
		}
	}
}