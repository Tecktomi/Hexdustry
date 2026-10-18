function draw_line_off(x1, y1, x2, y2){
	draw_line(x1 * zoom - camx, y1 * zoom - camy, x2 * zoom - camx, y2 * zoom - camy)
}