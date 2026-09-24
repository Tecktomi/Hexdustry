function draw_arrow_off(x1, y1, x2, y2, size){
	with control
		draw_arrow(x1 * zoom - camx, y1 * zoom - camy, x2 * zoom - camx, y2 * zoom - camy, size * zoom)
}