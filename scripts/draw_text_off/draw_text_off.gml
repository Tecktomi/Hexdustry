function draw_text_off(x, y, text){
	draw_text(x * control.zoom - control.camx, y * control.zoom - control.camy, text)
}