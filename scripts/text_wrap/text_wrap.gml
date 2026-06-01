function text_wrap(str, max_width){
	var temp_text = ""
	var parrafos = string_split(str, "\n", true)
	for(var a = 0; a < array_length(parrafos); a++){
	    var trozos = string_split(parrafos[a], " ", true), line_width = 0
		for(var b = 0; b < array_length(trozos); b++){
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