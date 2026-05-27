function small_connected_components_removal(target = idt_agua_salada_profunda, set = idt_pasto, size = 25){
	with control{
		var visitado = usable_grid_bool
		ds_grid_clear(visitado, false)
		for(var b = 0; b < ysize; b++){
			var bmod = b & 1
			for(var a = 0; a < xsize; a++){
				if not visitado[# a, b] and terreno[# a, b] = target{
					visitado[# a, b] = true
					var xx = array_create(1, a), yy = array_create(1, b)
					for(var j = 0; j < array_length(xx); j++){
						var aa = xx[j], bb = yy[j]
						bmod = bb & 1
						for(var c = 0; c < 6; c++){
							var aaa = aa + DESFACE[bmod][c, 0], bbb = bb + DESFACE[bmod][c, 1]
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
					if array_length(xx) < size for(var j = 0; j < array_length(xx); j++)
						terreno[# xx[j], yy[j]] = set
				}
				visitado[# a, b] = true
			}
		}
	}
}