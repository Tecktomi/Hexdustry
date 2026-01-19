function draw_shadow(){
	with control{
		/*if not surface_exists(surface_lava)
			surface_lava = surface_create(xsize * 48, ysize * 14)*/
		surface_set_target(surface_lava)
		draw_clear_alpha(c_black, 0.5)
		gpu_set_blendmode(bm_dest_alpha)
		for(var a = 0; a < xsize; a++)
			for(var b = 0; b < ysize; b++)
				if terreno[# a, b] = idt_lava{
					var temp_complex = abtoxy(a, b)
					draw_sprite_ext(spr_blur_32, 0, temp_complex.a, temp_complex.b, 5, 5, 0, c_white, 0.5)
				}
		gpu_set_blendmode(bm_normal)
		surface_reset_target()
	}
}