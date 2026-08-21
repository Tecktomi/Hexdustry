function small_connected_components_removal(target = idt_agua_salada_profunda, set = idt_pasto, size = 25){
	with control{
		var visitado = usable_grid_bool, b, bmod, a, xx, yy, j, aa, bb, c, aaa, bbb
		ds_grid_clear(visitado, false)
		for(b = 0; b < ysize; b++){
			bmod = b & 1
			for(a = 0; a < xsize; a++){
				if not visitado[# a, b] and terreno[# a, b] = target{
					visitado[# a, b] = true
					xx = array_create(1, a)
					yy = array_create(1, b)
					for(j = 0; j < array_length(xx); j++){
						aa = xx[j]
						bb = yy[j]
						bmod = bb & 1
						for(c = 0; c < 6; c++){
							aaa = aa + DESFACE_A[bmod, c]
							bbb = bb + DESFACE_B[bmod, c]
							if aaa < 0 or bbb < 0 or aaa >= xsize or bbb >= ysize
								continue
							if not visitado[# aaa, bbb]{
								visitado[# aaa, bbb] = true
								if terreno[# aaa, bbb] = target{
									array_push(xx, aaa)
									array_push(yy, bbb)
								}
							}
						}
					}
					if array_length(xx) < size for(j = 0; j < array_length(xx); j++)
						terreno[# xx[j], yy[j]] = set
				}
				visitado[# a, b] = true
			}
		}
	}
}