function draw_arco(x, y, r, angle_1, angle_2, presicion = pi / 64){
	var angleplus
	for(var angle = angle_1; angle < angle_2; angle += presicion){
		angleplus = min(angle + presicion, angle_2)
		draw_triangle(x, y, x + r * cos(angle), y - r * sin(angle), x + r * cos(angleplus), y - r * sin(angleplus), false)
	}
}