function draw_vida(x, y, vida, vida_max){
	if  vida < vida_max{
		draw_set_color(c_black)
		draw_rectangle(x - 8, y + 14, x + 8, y + 20, false)					
		draw_set_color(make_color_rgb(255 * (1 - vida / vida_max), 255 * vida / vida_max, 0))
		draw_rectangle(x - 7, y + 15, x - 7 + 14 * vida / vida_max, y + 19, false)
	}
}