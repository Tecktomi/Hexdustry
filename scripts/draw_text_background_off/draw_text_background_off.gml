function draw_text_background_off(x, y, text){
	draw_text_background(x * control.zoom - control.camx, y * control.zoom - control.camy, text)
}