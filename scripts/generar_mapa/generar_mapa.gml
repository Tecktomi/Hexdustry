function generar_mapa(seed = random_get_seed(), fondo = 0, terrenos = array_create(0, {target : 0, size : 0, count : 0}), reemplazo = array_create(0, {start : 0, target : array_create(0, 0), finish : 0}), menas = array_create(0, {target : 0, size : 0, count : 0})){
	with control{
		random_set_seed(seed)
		ds_grid_clear(terreno, fondo)
		ds_grid_clear(ore, -1)
		ds_grid_clear(ore_amount, 0)
		//Generar Menas de Terrenos
		for(var i = array_length(terrenos) - 1; i >= 0; i--){
			var mena = terrenos[i], mena_id = mena.target
			repeat(mena.count){
				var a = irandom(xsize - 1), b = irandom(ysize - 1)
				repeat(mena.size){
					var temp_list = get_size(a, b, 0, 3)
					for(var j = 0; j < 7; j++){
						var temp_complex = temp_list[|j], aa = temp_complex.a, bb = temp_complex.b
						if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize or not terreno_caminable[terreno[# aa, bb]]
							continue
						if terreno_caminable[terreno[# aa, bb]] and ore[# aa, bb] >= 0{
							ds_grid_add(ore, aa, bb, -1)
							ds_grid_set(ore_amount, aa, bb, 0)
						}
						ds_grid_set(terreno, aa, bb, mena_id)
					}
					var temp_complex = next_to(a, b, irandom(5))
					a = clamp(temp_complex.a, 0, xsize - 1)
					b = clamp(temp_complex.b, 0, ysize - 1)
				}
			}
		}
		//Generar Bordes de Terrenos
		for(var i = array_length(reemplazo) - 1; i >= 0; i++){
			var temp_reemplazo = reemplazo[i], start = temp_reemplazo.start, target = temp_reemplazo.target, finish = temp_reemplazo.finish
			for(var a = 0; a < xsize; a++)
				for(var b = 0; b < ysize; b++)
					if terreno[# a, b] = start{
						var flag = true
						for(var j = 0; j < 6; j++){
							var temp_complex = next_to(a, b, j), aa = temp_complex.a, bb = temp_complex.b
							if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
								continue
							if not array_contains(target, terreno[# aa, bb]){
								flag = false
								break
							}
						}
						if flag
							ds_grid_set(terreno, a, b, finish)
					}
		}
		//Generar Menas de Recursos
		for(var i = array_length(menas) - 1; i >= 0; i--){
			var mena = menas[i], mena_id = mena.target, mena_ore_size = ore_size[mena_id]
			repeat(mena.count){
				var a = irandom(xsize - 1), b = irandom(ysize - 1)
				repeat(mena.size){
					var temp_list = get_size(a, b, 0, 3)
					for(var j = 0; j < 7; j++){
						var temp_complex = temp_list[|j], aa = temp_complex.a, bb = temp_complex.b
						if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize or not terreno_caminable[terreno[# aa, bb]]
							continue
						if ore[# aa, bb] != mena_id
							ds_grid_add(ore_amount, aa, bb, floor(random_range(0.3, 1) * mena_ore_size))
						else
							ds_grid_set(ore_amount, aa, bb, floor(random_range(0.3, 1) * mena_ore_size))
						ds_grid_set(ore, aa, bb, mena_id)
					}
					var temp_complex = next_to(a, b, irandom(5))
					a = clamp(temp_complex.a, 0, xsize - 1)
					b = clamp(temp_complex.b, 0, ysize - 1)
				}
			}
		}
	}
}