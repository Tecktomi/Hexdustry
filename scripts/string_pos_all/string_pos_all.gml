function string_pos_all(text = "", substring = ""){
	var output = array_create(0, 0), len = string_length(substring)
	var pos = string_pos_ext(substring, text, 1)
	while pos != 0{
		array_push(output, pos)
		pos = string_pos_ext(substring, text, pos + len)
	}
	return output
}