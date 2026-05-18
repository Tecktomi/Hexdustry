function draw_text_xpos(x, y, text, info = false){
	with control{
		draw_text(x, y, text)
		text_x = string_width(text)
		text_y = string_height(text)
		if info{
			text_xtext = string_delete(text, 0, string_last_pos("\n", text))
			text_ytext = string_delete(text, string_last_pos("\n", text), string_length(text))
			text_xpos = string_width(text_xtext)
			text_ypos = string_height(text_ytext)
		}
		return x + text_x
	}
}