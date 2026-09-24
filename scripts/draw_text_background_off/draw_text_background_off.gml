function draw_text_background_off(x1, y1, text){
	with control
		draw_text_background(x1 * zoom - camx, y1 * zoom - camy, text)
}