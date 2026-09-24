function draw_sprite_off(sprite, subimg, x1, y1, xscale = 1, yscale = 1, rot = 0, col = c_white, alpha = 1){
	with control
		draw_sprite_ext(sprite, subimg, x1 * zoom - camx, y1 * zoom - camy, xscale * zoom, yscale * zoom, rot, col, alpha)
}