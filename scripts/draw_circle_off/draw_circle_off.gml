function draw_circle_off(x, y, r, outline){
	draw_circle(x * control.zoom - control.camx, y * control.zoom - control.camy, r * control.zoom, outline)
}