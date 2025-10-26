function draw_arco(x, y, r, angle_1, angle_2, presicion = pi / 64){
	for(var angle = angle_1; angle < angle_2; angle += presicion)
		draw_triangle(x, y, x + r * cos(angle), y - r * sin(angle), x + r * cos(min(angle + presicion, angle_2)), y - r * sin(min(angle + presicion, angle_2)), false)
}