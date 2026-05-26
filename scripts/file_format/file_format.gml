function file_format(file){
	if string_pos(".", file) > 0
		file = string_delete(file, string_pos(".", file), string_length(file))
	while string_pos("/", file) > 0
		file = string_delete(file, 0, string_pos("/", file))
	return file
}