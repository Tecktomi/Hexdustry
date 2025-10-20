function get_input_string(text, def){
	window_set_fullscreen(false)
	var a = get_string(text, def)
	return a = undefined ? def : a
}