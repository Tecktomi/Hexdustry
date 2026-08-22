function draw_circle_off(x1, y1, r, outline){
	draw_circle(x1 * control.zoom - control.camx, y1 * control.zoom - control.camy, r * control.zoom, outline)
}