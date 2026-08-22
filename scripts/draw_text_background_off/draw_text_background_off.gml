function draw_text_background_off(x1, y1, text){
	draw_text_background(x1 * control.zoom - control.camx, y1 * control.zoom - control.camy, text)
}