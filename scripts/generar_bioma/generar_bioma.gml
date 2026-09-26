function generar_bioma(bioma){
	with control{
		var multiplicador = xsize * ysize / 10000
		ds_grid_clear(ore, -1)
		ds_grid_clear(ore_amount, 0)
		ds_grid_clear(terreno_pared_index, 0)
		var temp_peso_data, borde_agua = idt_arena, i
		random_set_seed(seed)
		//Pradera
		if bioma = 0{
			ds_grid_clear(terreno, idt_pasto)
			temp_peso_data = [[idt_piedra, 8, 60], [idt_agua, 3, 30], [idt_petroleo, 1, 20], [idt_pared_de_piedra, 4, 80], [idt_pared_de_pasto, 2, 80], [idt_lava, 1, 25], [idt_agua_salada, 1, 30], [idt_bauxita, 2, 60]]
		}
		//Desierto
		else if bioma = 1{
			ds_grid_clear(terreno, idt_arena)
			temp_peso_data = [[idt_piedra, 5, 60], [idt_agua, 2, 30], [idt_petroleo, 2, 15], [idt_pared_de_piedra, 4, 80], [idt_pared_de_arena, 3, 80], [idt_lava, 1, 25], [idt_salar, 1, 30], [idt_bauxita, 2, 60]]
			borde_agua = idt_pasto
		}
		//Cuevas
		else if bioma = 2{
			ds_grid_clear(terreno, idt_piedra)
			temp_peso_data = [[idt_piedra_cuprica, 3, 30], [idt_piedra_ferrica, 3, 30], [idt_agua, 2, 30], [idt_petroleo, 2, 20], [idt_pared_de_piedra, 6, 150], [idt_lava, 3, 25], [idt_bauxita, 2, 60]]
			borde_agua = idt_piedra_cuprica
		}
		var size = array_length(temp_peso_data), temp_terreno, cantidad, magnitud, temp_j, j, a, b, temp_list, k, temp_complex, aa, bb, c, len
		for(i = 0; i < size; i++){
			temp_terreno = temp_peso_data[i, 0]
			cantidad = temp_peso_data[i, 1] * multiplicador
			magnitud = temp_peso_data[i, 2]
			temp_j = xsize / cantidad + irandom(floor(xsize / cantidad))
			for(j = 0; j < cantidad; j++){
				a = j * temp_j
				b = irandom(ysize - 1)
				repeat(magnitud){
					temp_list = get_size(a, b, 0, 3)
					len = array_length(temp_list)
					for(k = 0; k < len;){
						aa = temp_list[k++]
						bb = temp_list[k++]
						if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
							continue
						if terreno[# aa, bb] != idt_agua{
							terreno[# aa, bb] = temp_terreno
							if temp_terreno = idt_piedra{
								c = random(1)
								if c < 0.2
									terreno[# aa, bb] = c < 0.1 ? idt_piedra_cuprica : idt_piedra_ferrica
							}
						}
					}
					var d = irandom(5)
					repeat(2){
						a += DESFACE_A[b & 1, d]
						b += DESFACE_B[b & 1, d]
					}
					a = clamp(a, 0, xsize - 1)
					b = clamp(b, 0, ysize - 1)
				}
			}
		}
		var bmod
		//Generar bordes
		for(b = 0; b < ysize; b++){
			bmod = b & 1
			for(a = 0; a < xsize; a++){
				temp_terreno = terreno[# a, b]
				//Añadir arena
				if tag_agua_baja[temp_terreno]{
					for(c = 0; c < 6; c++){
						aa = a + DESFACE_A[bmod, c]
						bb = b + DESFACE_B[bmod, c]
						if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
							continue
						if not tag_agua[terreno[# aa, bb]]
							terreno[# aa, bb] = borde_agua
						if brandom(){
							aa += DESFACE_A[bb & 1, c]
							bb += DESFACE_B[bb & 1, c]
							if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
								continue
							if not tag_agua[terreno[# aa, bb]]
								terreno[# aa, bb] = borde_agua
						}
					}
				}
				//Piedra al rededor de Petróleo
				else if temp_terreno = idt_petroleo{
					for(c = 0; c < 6; c++){
						aa = a + DESFACE_A[bmod, c]
						bb = b + DESFACE_B[bmod, c]
						if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
							continue
						if terreno[# aa, bb] != idt_petroleo
							terreno[# aa, bb] = idt_piedra
					}
				}
				//Basalto al rededor de la Lava
				else if temp_terreno = idt_lava{
					for(c = 0; c < 6; c++){
						aa = a + DESFACE_A[bmod, c]
						bb = b + DESFACE_B[bmod, c]
						if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
							continue
						if terreno[# aa, bb] != idt_lava{
							if random(1) < 0.9
								terreno[# aa, bb] = idt_basalto
							else
								terreno[# aa, bb] = idt_basalto_sulfatado
						}
						if brandom(){
							var d = irandom(5)
							aa += DESFACE_A[bb & 1, d]
							bb += DESFACE_B[bb & 1, d]
							if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
								continue
							if terreno[# aa, bb] != idt_lava{
								if random(1) < 0.9
									terreno[# aa, bb] = idt_basalto
								else
									terreno[# aa, bb] = idt_basalto_sulfatado
							}
						}
					}
				}
				//Añadir agua profunda
				if tag_agua_baja[temp_terreno]{
					var flag = true
					for(c = 0; c < 6; c++){
						aa = a + DESFACE_A[bmod, c]
						bb = b + DESFACE_B[bmod, c]
						if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
							continue
						if not tag_agua[terreno[# aa, bb]]{
							flag = false
							break
						}
					}
					if flag
						if temp_terreno = idt_agua
							terreno[# a, b] = idt_agua_profunda
						else if temp_terreno = idt_agua_salada
							terreno[# a, b] = idt_agua_salada_profunda
				}
			}
		}
		//Limpiar zona del núcleo
		var temp_list_nucleo = get_size(floor(xsize / 2), floor(ysize / 2), 0, 7)
		len = array_length(temp_list_nucleo)
		var temp_terreno_change = array_create(terreno_max, idt_pasto)
		temp_terreno_change[idt_pared_de_arena] = idt_arena
		temp_terreno_change[idt_agua] = idt_arena
		temp_terreno_change[idt_agua_salada] = idt_arena
		temp_terreno_change[idt_pared_de_piedra] = idt_piedra
		temp_terreno_change[idt_agua_profunda] = idt_piedra
		temp_terreno_change[idt_agua_salada_profunda] = idt_piedra
		temp_terreno_change[idt_petroleo] = idt_piedra
		temp_terreno_change[idt_pared_de_nieve] = idt_nieve
		temp_terreno_change[idt_hielo] = idt_nieve
		temp_terreno_change[idt_pared_de_pasto] = idt_pasto
		temp_terreno_change[idt_lava] = idt_basalto
		for(a = 0; a < len;){
			aa = temp_list_nucleo[a++]
			bb = temp_list_nucleo[a++]
			if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
				continue
			if not terreno_caminable[terreno[# aa, bb]]
				terreno[# aa, bb] = temp_terreno_change[terreno[# aa, bb]]
		}
		//Crear núcleo
		while array_length(edificios_index[id_nucleo]) > 0
			delete_edificio(edificios_index[id_nucleo][0])
		nucleos[jugador] = add_edificio(0, 0, floor(xsize / 2), floor(ysize / 2))
		jugador_recursos[jugador, idr_cobre] = 100
		carga_inicial = array_create(rss_max, 0)
		array_copy(carga_inicial, 0, jugador_recursos[jugador], 0, rss_max)
		//Menas de recursos
		if bioma = 0
			temp_peso_data = [[4, 30], [4, 30], [4, 25], [2, 30]]
		else if bioma = 1
			temp_peso_data = [[4, 25], [4, 25], [4, 35], [2, 30]]
		else if bioma = 2
			temp_peso_data = [[6, 20], [6, 20], [3, 30], [3, 25]]
		var d
		for(i = 0; i < ore_max; i++){
			cantidad = temp_peso_data[i, 0] * multiplicador
			magnitud = temp_peso_data[i, 1]
			for(j = 0; j < cantidad; j++){
				a = j * xsize / cantidad + irandom(floor(xsize / cantidad))
				b = irandom(ysize - 1)
				repeat(magnitud){
					temp_list = get_size(a, b, 0, 3)
					len = array_length(temp_list)
					for(k = 0; k < len;){
						aa = temp_list[k++]
						bb = temp_list[k++]
						if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
							continue
						temp_terreno = terreno[# aa, bb]
						if terreno_caminable[temp_terreno]{
							if ore[# aa, bb] != i{
								ore_amount[# aa, bb] = 0
								if tag_ore_piedras[i] and tag_terreno_piedras[temp_terreno]
									terreno[# aa, bb] = i = ido_cobre ? idt_piedra_cuprica : idt_piedra_ferrica
								ore[# aa, bb] = i
							}
							ds_grid_add(ore_amount, aa, bb, floor(random_range(0.3, 1) * ore_size[i]))
						}
					}
					d = irandom(5)
					a = clamp(a + DESFACE_A[b & 1, d], 0, xsize - 1)
					b = clamp(b + DESFACE_B[b & 1, d], 0, ysize - 1)
				}
			}
		}
		//Limpiar al rededor del núcleo
		len = array_length(temp_list_nucleo)
		for(a = 0; a < len;){
			aa = temp_list_nucleo[a++]
			bb = temp_list_nucleo[a++]
			if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
				continue
			ore[# aa, bb] = -1
			ore_amount[# aa, bb] = 0
		}
		//Spawn point
		do{
			if irandom(1) = 0{
				spawn_x = 3 + (xsize - 7) * irandom(1)
				spawn_y = irandom_range(3, ysize - 4)
			}
			else{
				spawn_x = irandom_range(3, xsize - 4)
				spawn_y = 3 + (ysize - 7) * irandom(1)
			}
		}
		until terreno_caminable[terreno[# spawn_x, spawn_y]]
		clear_olas()
	}
}