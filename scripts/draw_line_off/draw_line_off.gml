function draw_line_off(x1, y1, x2, y2){
	draw_line(x1 * control.zoom - control.camx, y1 * control.zoom - control.camy, x2 * control.zoom - control.camx, y2 * control.zoom - control.camy)
}