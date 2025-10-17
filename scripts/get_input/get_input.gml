function get_input(text, def){
	window_set_fullscreen(false)
	var a = get_integer(text, def)
	return a = undefined ? def : a
}