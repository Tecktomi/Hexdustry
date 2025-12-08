function set_terreno(a, b, index){
	with control{
		if terreno[# a, b] != index{
			ds_grid_set(terreno, a, b, real(index))
			if grafic_pared and terreno_pared[index]{
				for(var i = 0; i < 3; i++){
					var temp_complex = next_to(a, b, i), aa = temp_complex.a, bb = temp_complex.b
					if aa < 0 or bb < 0 or aa >= xsize
						continue
					if terreno[# aa, bb] = index
						ds_grid_set(terreno_pared_index, aa, bb, terreno_pared_index[# aa, bb] ^ (1 << (2 - i)))
				}
				var c = 0
				for(var i = 0; i < 3; i++){
					var temp_complex = next_to(a, b, 3 + i), aa = temp_complex.a, bb = temp_complex.b
					if aa < 0 or aa >= xsize or bb >= ysize
						continue
					if terreno[# aa, bb] = index
						c += 1 << (2 - i)
				}
				ds_grid_set(terreno_pared_index, a, b, c)
			}
			if not terreno_caminable[index]{
				ds_grid_set(ore, a, b, -1)
				ds_grid_set(ore_amount, a, b, 0)
			}
			update_background(a, b)
		}
	}
}