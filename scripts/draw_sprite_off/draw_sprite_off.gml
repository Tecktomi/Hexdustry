function draw_sprite_off(sprite, subimg, x1, y1, xscale = 1, yscale = 1, rot = 0, col = c_white, alpha = 1){
	draw_sprite_ext(sprite, subimg, x1 * control.zoom - control.camx, y1 * control.zoom - control.camy, xscale * control.zoom, yscale * control.zoom, rot, col, alpha)
}