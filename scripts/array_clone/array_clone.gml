function array_clone(dest, src){
	if not is_array(dest) or not is_array(src)
		show_error("array_clone a algo que no es array", true)
	array_copy(dest, 0, src, 0, array_length(src))
}