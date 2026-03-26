function string_pos_all(text = "", substring = ""){
	var output = array_create(0, 0), len = string_length(substring)
	while string_pos(substring, text) != 0{
		array_push(output, string_pos(substring, text) + array_length(output) * len)
		text = string_replace(text, substring, "")
	}
	return output
}