function generar_mapa(seed = random_get_seed(), fondo = 0, instrucciones = array_create(0, array_create(4, 0))){
	with control{
		random_set_seed(seed)
		ds_grid_clear(terreno, fondo)
		ds_grid_clear(ore, -1)
		ds_grid_clear(ore_amount, 0)
		size = array_length(instrucciones)
		for(var i = 0; i < size; i++){
			var instruccion = instrucciones[i], tipo = instruccion[0], dat1 = instruccion[1], dat2 = instruccion[2], dat3 = instruccion[3]
			//Menas de Terrenos
			if tipo = 0{
				var caminable = terreno_caminable[dat1]
				repeat(dat3){
					var a = irandom(xsize - 1), b = irandom(ysize - 1)
					repeat(dat2){
						var temp_list = get_size(a, b, 0, 3)
						for(var j = 0; j < 7; j++){
							var temp_complex = temp_list[|j], aa = temp_complex.a, bb = temp_complex.b
							if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
								continue
							set_terreno(aa, bb, dat1)
						}
						var c = irandom(5)
						repeat(2){
							var temp_complex = next_to(a, b, c)
							a = clamp(temp_complex.a, 0, xsize - 1)
							b = clamp(temp_complex.b, 0, ysize - 1)
						}
					}
				}
			}
			//Bordes de Terrenos
			else if tipo = 1{
				var caminable = terreno_caminable[dat3]
				if dat1 = dat2{
					for(var a = 0; a < xsize; a++)
						for(var b = 0; b < ysize; b++)
							if terreno[# a, b] = dat1
								for(var j = 0; j < 6; j++){
									var temp_complex = next_to(a, b, j), aa = temp_complex.a, bb = temp_complex.b
									if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize or dat1 = terreno[# aa, bb]
										continue
									set_terreno(aa, bb, dat3)
								}
				}
				else
					for(var a = 0; a < xsize; a++)
						for(var b = 0; b < ysize; b++)
							if terreno[# a, b] = dat1
								for(var j = 0; j < 6; j++){
									var temp_complex = next_to(a, b, j), aa = temp_complex.a, bb = temp_complex.b
									if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize or dat2 != terreno[# aa, bb]
										continue
									set_terreno(aa, bb, dat3)
								}
			}
			//Ruido Aleatorio
			else if tipo = 2{
				for(var a = 0; a < xsize; a++)
					for(var b = 0; b < ysize; b++)
						if irandom(99) < dat3 and terreno[# a, b] = dat1
							set_terreno(a, b, dat2)
			}
			//Menas de Recursos
			else if tipo = 3{
				repeat(dat3){
					var a = irandom(xsize - 1), b = irandom(ysize - 1)
					repeat(dat2){
						var temp_list = get_size(a, b, 0, 3)
						for(var j = 0; j < 7; j++){
							var temp_complex = temp_list[|j], aa = temp_complex.a, bb = temp_complex.b
							if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize or not terreno_caminable[terreno[# aa, bb]]
								continue
							if ore[# aa, bb] = dat1
								ds_grid_add(ore_amount, aa, bb, floor(random_range(0.3, 1) * ore_size[dat1]))
							else
								ds_grid_set(ore_amount, aa, bb, floor(random_range(0.3, 1) * ore_size[dat1]))
							ds_grid_set(ore, aa, bb, dat1)
						}
						var c = irandom(5)
						repeat(2){
							var temp_complex = next_to(a, b, c)
							a = clamp(temp_complex.a, 0, xsize - 1)
							b = clamp(temp_complex.b, 0, ysize - 1)
						}
					}
				}
			}
		}
	}
}