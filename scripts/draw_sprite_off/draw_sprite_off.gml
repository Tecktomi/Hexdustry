function draw_sprite_off(sprite, subimg, x, y, xscale = 1, yscale = 1, rot = 0, col = c_white, alpha = 1){
	draw_sprite_ext(sprite, subimg, x * control.zoom - control.camx, y * control.zoom - control.camy, xscale * control.zoom, yscale * control.zoom, rot, col, alpha)
}