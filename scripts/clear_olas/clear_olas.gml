function clear_olas(){
	with control{
		ds_grid_clear(terreno_pared_index, 0)
		ds_grid_clear(background_bool, false)
		for(var a = 0; a < chunk_xsize; a++)
			for(var b = 0; b < chunk_ysize; b++)
				if background[# a, b] != spr_hexagono
					sprite_delete(background[# a, b])
		ds_grid_clear(background, spr_hexagono)
		var desface = [[[0, -1], [0, -2], [-1, -1], [-1, 1], [0, 2], [0, 1]], [[1, -1], [0, -2], [0, -1], [0, 1], [0, 2], [1, 1]]]
		for(var b = 0; b < ysize; b++){
			var des = b mod 2
			for(var a = 0; a < xsize; a++){
				var temp_terreno = terreno[# a, b]
				//Olas en Agua Salada
				if temp_terreno = idt_agua_salada{
					var c = 0
					for(var i = 0; i < 6; i++){
						var aa = a + desface[des][i, 0], bb = b + desface[des][i, 1]
						if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
							continue
						if not terreno_liquido[terreno[# aa, bb]]
							c += 1 << i
					}
					terreno_pared_index[# a, b] = c
				}
				//Paredes
				else if terreno_pared[temp_terreno]{
					var c = 0; for(var i = 3; i < 6; i++){
						var aa = a + desface[des][i, 0], bb = b + desface[des][i, 1]
						if aa < 0 or aa >= xsize or bb >= ysize
							continue
						if not terreno_pared[terreno[# aa, bb]]
							c += 1 << (5 - i)
					}
					terreno_pared_index[# a, b] = 7 - c
				}
				//Borrar ores
				if not terreno_caminable[temp_terreno]{
					ore[# a, b] = -1
					ore_amount[# a, b] = 0
				}
			}
		}
	}
}