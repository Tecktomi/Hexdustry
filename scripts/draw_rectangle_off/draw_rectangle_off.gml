function draw_rectangle_off(x1, y1, x2, y2, outline){
	draw_rectangle(x1 * control.zoom - control.camx, y1 * control.zoom - control.camy, x2 * control.zoom - control.camx, y2 * control.zoom - control.camy, outline)
}