function text_wrap(str, max_width){
	var temp_text = "", parrafos = string_split(str, "\n", true), a, trozos, line_width, b
	for(a = 0; a < array_length(parrafos); a++){
	    trozos = string_split(parrafos[a], " ", true)
		line_width = 0
		for(b = 0; b < array_length(trozos); b++){
			if line_width > max_width{
				temp_text += "\n"
				line_width = 0
			}
			temp_text += trozos[b] + " "
			line_width += string_width(trozos[b] + " ")
		}
		temp_text += "\n"
	}
	return string_trim(temp_text)
}