function set_terreno(a, b, index){
	with control{
		var terreno_prev = terreno[# a, b]
		if terreno_prev != index{
			if terreno_liquido[terreno_prev] and not terreno_liquido[index]{
				for(var i = 0; i < 6; i++){
					var temp_complex = next_to(a, b, i), aa = temp_complex.a, bb = temp_complex.b
					if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
						continue
					if terreno[# aa, bb] = idt_agua_salada{
						ds_grid_add(terreno_pared_index, aa, bb, 1 << ((i + 3) mod 6))
						update_background(aa, bb)
					}
				}
			}
			else if terreno_liquido[index] and not terreno_liquido[terreno_prev]{
				for(var i = 0; i < 6; i++){
					var temp_complex = next_to(a, b, i), aa = temp_complex.a, bb = temp_complex.b
					if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
						continue
					if terreno[# aa, bb] = idt_agua_salada{
						ds_grid_add(terreno_pared_index, aa, bb, -1 << ((i + 3) mod 6))
						update_background(aa, bb)
					}
				}
			}
			if terreno_pared[terreno_prev] and not terreno_pared[index]{
				for(var i = 0; i < 3; i++){
					var temp_complex = next_to(a, b, i), aa = temp_complex.a, bb = temp_complex.b
					if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
						continue
					if terreno_pared[terreno[# aa, bb]]
						ds_grid_add(terreno_pared_index, aa, bb, -(1 << (2 - i)))
				}
			}
			else if terreno_pared[index] and not terreno_pared[terreno_prev]{
				for(var i = 0; i < 3; i++){
					var temp_complex = next_to(a, b, i), aa = temp_complex.a, bb = temp_complex.b
					if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
						continue
					if terreno_pared[terreno[# aa, bb]]
						ds_grid_add(terreno_pared_index, aa, bb, 1 << (2 - i))
				}
			}
			ds_grid_set(terreno, a, b, real(index))
			//Post cambio
			if terreno_pared[index]{
				var c = 0
				for(var i = 0; i < 3; i++){
					var temp_complex = next_to(a, b, 3 + i), aa = temp_complex.a, bb = temp_complex.b
					if aa < 0 or aa >= xsize or bb >= ysize
						continue
					if terreno_pared[terreno[# aa, bb]]
						c += 1 << (2 - i)
				}
				ds_grid_set(terreno_pared_index, a, b, c)
			}
			if not terreno_caminable[index]{
				ds_grid_set(ore, a, b, -1)
				ds_grid_set(ore_amount, a, b, 0)
			}
			if index = idt_agua_salada{
				var d = 0
				for(var i = 0; i < 6; i++){
					var temp_complex = next_to(a, b, i), aa = temp_complex.a, bb = temp_complex.b
					if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
						continue
					if not terreno_liquido[terreno[# aa, bb]]
						d += 1 << i
				}
				ds_grid_set(terreno_pared_index, a, b, d)
			}
			update_background(a, b)
		}
	}
}