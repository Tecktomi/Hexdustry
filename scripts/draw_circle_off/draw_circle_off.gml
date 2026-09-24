function draw_circle_off(x1, y1, r, outline){
	with control
		draw_circle(x1 * zoom - camx, y1 * zoom - camy, r * zoom, outline)
}