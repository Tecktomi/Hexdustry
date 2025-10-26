function draw_text_sprite(x, y, text){
	draw_text(x, y, string_replace_all(text, "[*]", "  "))
	for(var a = string_pos("[", text); a > 0; text = string_delete(text, 1, a)){
		var subtext = string_copy(text, 1, a)
		draw_sprite(control.recurso_sprite[real(string_copy(text, a + 1, string_pos("]", text) - a))], 0, x + string_width(subtext), y + string_height(subtext))
	}
}