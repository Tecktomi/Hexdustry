function draw_rectangle_off(x1, y1, x2, y2, outline){
	with control
		draw_rectangle(x1 * zoom - camx, y1 * zoom - camy, x2 * zoom - camx, y2 * zoom - camy, outline)
}