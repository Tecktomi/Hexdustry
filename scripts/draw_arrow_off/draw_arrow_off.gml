function draw_arrow_off(x1, y1, x2, y2, size){
	draw_arrow(x1 * control.zoom - control.camx, y1 * control.zoom - control.camy, x2 * control.zoom - control.camx, y2 * control.zoom - control.camy, size * control.zoom)
}