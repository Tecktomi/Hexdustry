function draw_text_sprite(x, y, text){
	var size = string_length(text), xx = x
	for(var a = 0; a < size; a++){
		var char = string_char_at(text, a)
		if char = "["{
			var b = string_pos("]", text)
			if b != -1{
				var c = real(string_digits(string_copy(text, 1, b - 1)))
				draw_sprite(recurso_sprite[c], 0, xx, y)
				xx += 20
				a = b
			}
		}
		else{
			draw_text(x, y, char)
			text = string_delete(text, 0, 1)
			xx += string_width(char)
		}
	}
}