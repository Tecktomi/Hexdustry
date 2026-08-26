function string_digits_ext(text){
	var len = string_length(text), output = ""
	for(var a = 1; a <= len; a++)
		if control.DIGITS[string_byte_at(text, a)]
			output += string_char_at(text, a)
	return output
}