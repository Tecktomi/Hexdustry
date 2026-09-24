function draw_text_off(x1, y1, text){
	with control
		draw_text(x1 * zoom - camx, y1 * zoom - camy, text)
}