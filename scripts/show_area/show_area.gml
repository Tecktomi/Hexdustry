function show_area(arreglo = [[0]]){
	with control{
		var mask = usable_grid_bool, len = array_length(arreglo), a, b, c, aa, bb, aaa, bbb, bmod, temp_complex
		ds_grid_clear(mask, false)
		for(a = 0; a < len; a++)
			mask[# arreglo[a, 0], arreglo[a, 1]] = true
		for(a = 0; a < len; a++){
			aa = arreglo[a, 0]
			bb = arreglo[a, 1]
			c = 0
			bmod = bb & 1
			for(b = 0; b < 6; b++){
				aaa = aa + DESFACE_A[bmod, b]
				bbb = bb + DESFACE_B[bmod, b]
				if not mask[# aaa, bbb]
					c += 1 << b
			}
			temp_complex = abtoxy(aa, bb)
			draw_sprite_ext(spr_borde_lado, c, temp_complex[0] * zoom - camx, temp_complex[1] * zoom - camy, zoom, zoom, 0, c_white, 1)
		}
	}
}