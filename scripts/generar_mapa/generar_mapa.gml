function generar_mapa(seed = random_get_seed(), instrucciones = array_create(0, array_create(4, 0))){
	with control{
		random_set_seed(seed)
		var size = array_length(instrucciones), i, instruccion, tipo, dat1, dat2, dat3, a, b, temp_list, j, temp_complex, aa, bb, c, bmod, random1, temp_bool, temp_real, len
		for(i = 0; i < size; i++){
			instruccion = instrucciones[i]
			tipo = instruccion[0]
			dat1 = instruccion[1]
			dat2 = instruccion[2]
			dat3 = instruccion[3]
			if tipo = EDITOR_INSTRUCCION_CLEAR{
				ds_grid_clear(terreno, dat1)
				if not terreno_caminable[dat1]{
					ds_grid_clear(ore, -1)
					ds_grid_clear(ore_amount, 0)
				}
			}
			else if tipo = EDITOR_INSTRUCCION_MANCHAS{
				repeat(dat3){
					a = irandom(xsize - 1)
					b = irandom(ysize - 1)
					repeat(dat2){
						temp_list = get_size(a, b, 0, 3)
						len = array_length(temp_list)
						for(j = 0; j < len;){
							aa = temp_list[j++]
							bb = temp_list[j++]
							if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
								continue
							terreno[# aa, bb] = dat1
						}
						c = irandom(5)
						repeat(2){
							a = clamp(a + DESFACE_A[b & 1, c], 0, xsize - 1)
							b = clamp(b + DESFACE_B[b & 1, c], 0, ysize - 1)
						}
					}
				}
			}
			else if tipo = EDITOR_INSTRUCCION_BORDES{
				if dat1 = dat2{
					for(b = 0; b < ysize; b++){
						bmod = b & 1
						for(a = 0; a < xsize; a++)
							if terreno[# a, b] = dat1{
								for(j = 0; j < 6; j++){
									aa = a + DESFACE_A[bmod, j]
									bb = b + DESFACE_B[bmod, j]
									if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize or dat1 = terreno[# aa, bb]
										continue
									terreno[# aa, bb] = dat3
								}
							}
					}
				}
				else
					for(b = 0; b < ysize; b++){
						bmod = b & 1
						for(a = 0; a < xsize; a++)
							if terreno[# a, b] = dat1{
								for(j = 0; j < 6; j++){
									aa = a + DESFACE_A[bmod, j]
									bb = b + DESFACE_B[bmod, j]
									if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize or dat2 != terreno[# aa, bb]
										continue
									terreno[# aa, bb] = dat3
								}
							}
					}
			}
			else if tipo = EDITOR_INSTRUCCION_RUIDO{
				for(a = 0; a < xsize; a++)
					for(b = 0; b < ysize; b++)
						if irandom(99) < dat3 and terreno[# a, b] = dat1
							terreno[# a, b] = dat2
			}
			else if tipo = EDITOR_INSTRUCCION_MENAS{
				repeat(dat3){
					a = irandom(xsize - 1)
					b = irandom(ysize - 1)
					repeat(dat2){
						temp_list = get_size(a, b, 0, 3)
						len = array_length(temp_list)
						for(j = 0; j < len;){
							aa = temp_list[j++]
							bb = temp_list[j++]
							if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize or not terreno_caminable[terreno[# aa, bb]]
								continue
							if ore[# aa, bb] = dat1
								ds_grid_add(ore_amount, aa, bb, floor(random_range(0.3, 1) * ore_size[dat1]))
							else
								ds_grid_set(ore_amount, aa, bb, floor(random_range(0.3, 1) * ore_size[dat1]))
							ds_grid_set(ore, aa, bb, dat1)
						}
						c = irandom(5)
						repeat(2){
							a = clamp(a + DESFACE_A[b & 1, c], 0, xsize - 1)
							b = clamp(b + DESFACE_B[b & 1, c], 0, ysize - 1)
						}
					}
				}
			}
			else if tipo = EDITOR_INSTRUCCION_PERLIN{
				random1 = hex_perlin(xsize, ysize, 0)
				ds_grid_multiply_region(random1, 0, 0, xsize, ysize, 1 / ds_grid_get_max(random1, 0, 0, xsize, ysize))
				dat3 /= 100
				for(a = 0; a < xsize; a++)
					for(b = 0; b < ysize; b++)
						if random1[# a, b] < dat3 and terreno[# a, b] = dat2
							terreno[# a, b] = dat1
				ds_grid_destroy(random1)
			}
			else if tipo = EDITOR_INSTRUCCION_SCCR
				small_connected_components_removal(dat1, dat2, dat3)
			else if tipo = EDITOR_INSTRUCCION_CONTORNO{
				random1 = hex_perlin(xsize, ysize, 0, true)
				ds_grid_multiply_region(random1, 0, 0, xsize, ysize, 1 / ds_grid_get_max(random1, 0, 0, xsize, ysize))
				dat3 /= 100
				for(a = 0; a < xsize; a++)
					for(b = 0; b < ysize; b++)
						if random1[# a, b] < dat3 and terreno[# a, b] = dat2
							terreno[# a, b] = dat1
				ds_grid_destroy(random1)
			}
			else if tipo = EDITOR_INSTRUCCION_AUTOMATA{
				temp_bool = usable_grid_bool
				temp_real = usable_grid_real
				for(a = 0; a < xsize; a++)
					for(b = 0; b < ysize; b++)
						temp_bool[# a, b] = brandom()
				repeat(dat3){
					ds_grid_clear(temp_real, 0)
					for(b = 0; b < ysize; b++){
						bmod = b & 1
						for(a = 0; a < xsize; a++)
							if temp_bool[# a, b]
								for(j = 0; j < 6; j++){
									aa = a + DESFACE_A[bmod, j]
									bb = b + DESFACE_B[bmod, j]
									if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
										continue
									temp_real[# aa, bb] += 1
								}
					}
					for(a = 0; a < xsize; a++)
						for(b = 0; b < ysize; b++)
							temp_bool[# a, b] = (temp_real[# a, b] > dat2)
				}
				for(a = 0; a < xsize; a++)
					for(b = 0; b < ysize; b++)
						if temp_bool[# a, b]
							terreno[# a, b] = dat1
			}
			else if tipo = EDITOR_INSTRUCCION_CLEAR_RSS{
				ds_grid_clear(ore, -1)
				ds_grid_clear(ore_amount, 0)
			}
		}
	}
	clear_olas()
}