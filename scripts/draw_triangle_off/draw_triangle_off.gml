function draw_triangle_off(x1, y1,x2, y2, x3, y3, outline){
	with control
		draw_triangle(x1 * zoom - camx, y1 * zoom - camy, x2 * zoom - camx, y2 * zoom - camy, x3 * zoom - camx, y3 * zoom - camy, outline)
}