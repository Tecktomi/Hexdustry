function generar_bioma(bioma){
	with control{
		var time = current_time
		ds_grid_clear(ore, -1)
		ds_grid_clear(ore_amount, 0)
		ds_grid_clear(edificio_cercano, null_edificio)
		ds_grid_clear(edificio_cercano_dis, infinity)
		ds_grid_clear(edificio_cercano_dir, -1)
		ds_grid_clear(terreno_pared_index, 0)
		var temp_peso_data, borde_agua = idt_arena
		//Generar terreno inicial
		if bioma = 0{
			ds_grid_clear(terreno, idt_pasto)
			temp_peso_data = [[idt_piedra, 8, 60], [idt_agua, 3, 30], [idt_petroleo, 1, 20], [idt_pared_de_piedra, 4, 80], [idt_pared_de_pasto, 2, 80], [idt_lava, 1, 25], [idt_agua_salada, 1, 30]]
		}
		else if bioma = 1{
			ds_grid_clear(terreno, idt_arena)
			temp_peso_data = [[idt_piedra, 5, 60], [idt_agua, 2, 30], [idt_petroleo, 2, 15], [idt_pared_de_piedra, 4, 80], [idt_pared_de_arena, 3, 80], [idt_lava, 1, 25], [idt_salar, 1, 30]]
			borde_agua = idt_pasto
		}
		else if bioma = 2{
			ds_grid_clear(terreno, idt_piedra)
			temp_peso_data = [[idt_piedra_cuprica, 3, 30], [idt_piedra_ferrica, 3, 30], [idt_agua, 2, 30], [idt_petroleo, 2, 20], [idt_pared_de_piedra, 6, 150], [idt_lava, 3, 25]]
			borde_agua = idt_piedra_cuprica
		}
		var size = array_length(temp_peso_data)
		for(var i = 0; i < size; i++){
			var temp_terreno = temp_peso_data[i, 0], cantidad = temp_peso_data[i, 1], magnitud = temp_peso_data[i, 2]
			for(var j = 0; j < cantidad; j++){
				var a = j * xsize / cantidad + irandom(floor(xsize / cantidad)), b = irandom(ysize - 1)
				repeat(magnitud){
					var temp_list = get_size(a, b, 0, 3)
					for(var k = 0; k < 7; k++){
						var temp_complex = temp_list[|k], aa = temp_complex.a, bb = temp_complex.b
						if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
							continue
						if terreno[# aa, bb] != idt_agua{
							set_terreno(aa, bb, temp_terreno)
							if temp_terreno = idt_piedra{
								var c = random(1)
								if c < 0.1
									set_terreno(aa, bb, idt_piedra_cuprica)
								else if c < 0.2
									set_terreno(aa, bb, idt_piedra_ferrica)
							}
						}
					}
					repeat(2){
						var d = irandom(5)
						var temp_complex = next_to(a, b, d)
						a = clamp(temp_complex.a, 0, xsize - 1)
						b = clamp(temp_complex.b, 0, ysize - 1)
					}
				}
			}
		}
		//Generar bordes
		for(var a = 0; a < xsize; a++)
			for(var b = 0; b < ysize; b++){
				var temp_terreno = terreno[# a, b]
				//Añadir arena
				if grafic_array_agua_baja[temp_terreno]{
					for(var c = 0; c < 6; c++){
						var temp_complex = next_to(a, b, c), aa = temp_complex.a, bb = temp_complex.b
						if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
							continue
						if not grafic_array_agua[terreno[# aa, bb]]
							set_terreno(aa, bb, borde_agua)
						if brandom(){
							temp_complex = next_to(aa, bb, c)
							aa = temp_complex.a
							bb = temp_complex.b
							if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
								continue
							if not grafic_array_agua[terreno[# aa, bb]]
								set_terreno(aa, bb, borde_agua)
						}
					}
				}
				//Piedra al rededor de Petróleo
				else if temp_terreno = idt_petroleo{
					for(var c = 0; c < 6; c++){
						var temp_complex = next_to(a, b, c), aa = temp_complex.a, bb = temp_complex.b
						if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
							continue
						if terreno[# aa, bb] != idt_petroleo
							set_terreno(aa, bb, idt_piedra)
					}
				}
				//Basalto al rededor de la Lava
				else if temp_terreno = idt_lava{
					for(var c = 0; c < 6; c++){
						var temp_complex = next_to(a, b, c), aa = temp_complex.a, bb = temp_complex.b
						if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
							continue
						if terreno[# aa, bb] != idt_lava{
							if random(1) < 0.9
								set_terreno(aa, bb, idt_basalto)
							else
								set_terreno(aa, bb, idt_basalto_sulfatado)
						}
						if brandom(){
							temp_complex = next_to(aa, bb, irandom(5))
							aa = temp_complex.a
							bb = temp_complex.b
							if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
								continue
							if terreno[# aa, bb] != idt_lava{
								if random(1) < 0.9
									set_terreno(aa, bb, idt_basalto)
								else
									set_terreno(aa, bb, idt_basalto_sulfatado)
							}
						}
					}
				}
				//Añadir agua profunda
				if grafic_array_agua_baja[temp_terreno]{
					var flag = true
					for(var c = 0; c < 6; c++){
						var temp_complex = next_to(a, b, c), aa = temp_complex.a, bb = temp_complex.b
						if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
							continue
						if not grafic_array_agua[terreno[# aa, bb]]{
							flag = false
							break
						}
					}
					if flag
						if temp_terreno = idt_agua
							set_terreno(a, b, idt_agua_profunda)
						else if temp_terreno = idt_agua_salada
							set_terreno(a, b, idt_agua_salada_profunda)
				}
			}
		//Limpiar_zona del núcleo
		var temp_list_nucleo = get_size(floor(xsize / 2), floor(ysize / 2), 0, 7)
		for(var a = ds_list_size(temp_list_nucleo) - 1; a >= 0; a--){
			var temp_complex = temp_list_nucleo[|a], aa = temp_complex.a, bb = temp_complex.b
			if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
				continue
			if not terreno_caminable[terreno[# aa, bb]]{
				if in(terreno[# aa, bb], idt_pared_de_arena, idt_agua, idt_agua_salada)
					set_terreno(aa, bb, idt_arena)
				else if in(terreno[# aa, bb], idt_pared_de_piedra, idt_agua_profunda, idt_agua_salada_profunda, idt_petroleo)
					set_terreno(aa, bb, idt_piedra)
				else if in(terreno[# aa, bb], idt_pared_de_nieve, idt_hielo)
					set_terreno(aa, bb, idt_nieve)
				else if terreno[# aa, bb] = idt_pared_de_pasto
					set_terreno(aa, bb, idt_pasto)
				else if terreno[# aa, bb] = idt_lava
					set_terreno(aa, bb, idt_basalto)
				else
					set_terreno(aa, bb, idt_pasto)
			}
		}
		//Crear núcleo
		if array_length(nucleos) = 0{
			nucleo = add_edificio(0, 0, floor(xsize / 2), floor(ysize / 2))
			nucleo.carga[idr_cobre] = 100
			nucleo.carga_total = 100
			carga_inicial = array_create(rss_max, 0)
			array_copy(carga_inicial, 0, nucleo.carga, 0, rss_max)
		}
		//Menas de recursos
		if bioma = 0
			temp_peso_data = [[4, 30], [4, 30], [4, 25], [2, 30]]
		else if bioma = 1
			temp_peso_data = [[4, 25], [4, 25], [4, 35], [2, 30]]
		else if bioma = 2
			temp_peso_data = [[6, 20], [6, 20], [3, 30], [3, 25]]
		for(var i = 0; i < ore_max; i++){
			var cantidad = temp_peso_data[i, 0], magnitud = temp_peso_data[i, 1]
			for(var j = 0; j < cantidad; j++){
				var a = j * xsize / cantidad + irandom(floor(xsize / cantidad)), b = irandom(ysize - 1)
				repeat(magnitud){
					var temp_list = get_size(a, b, 0, 3)
					for(var k = 0; k < 7; k++){
						var temp_complex = temp_list[|k], aa = temp_complex.a, bb = temp_complex.b
						if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
							continue
						var temp_terreno = terreno[# aa, bb]
						if terreno_caminable[temp_terreno]{
							if ore[# aa, bb] != i{
								ds_grid_set(ore_amount, aa, bb, 0)
								if grafic_array_ore_piedras[i] and grafic_array_terreno_piedras[temp_terreno]
									set_terreno(aa, bb, i = ido_cobre ? idt_piedra_cuprica : idt_piedra_ferrica)
								ore[# aa, bb] = i
							}
							ds_grid_add(ore_amount, aa, bb, floor(random_range(0.3, 1) * ore_size[i]))
						}
					}
					var d = irandom(5)
					var temp_complex = next_to(a, b, d)
					a = clamp(temp_complex.a, 0, xsize - 1)
					b = clamp(temp_complex.b, 0, ysize - 1)
				}
			}
		}
		//Limpiar al rededor del núcleo
		for(var a = ds_list_size(temp_list_nucleo) - 1; a >= 0; a--){
			var temp_complex = temp_list_nucleo[|a], aa = temp_complex.a, bb = temp_complex.b
			if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
				continue
			ds_grid_set(ore, aa, bb, -1)
			ds_grid_set(ore_amount, aa, bb, 0)
		}
		//Spawn point
		do{
			if irandom(1) = 0{
				spawn_x = (xsize - 1) * irandom(1)
				spawn_y = irandom(ysize - 1)
			}
			else{
				spawn_x = irandom(xsize - 1)
				spawn_y = 1 + (ysize - 3) * irandom(1)
			}
		}
		until terreno_caminable[terreno[# spawn_x, spawn_y]]
		show_debug_message(current_time - time)
		//
	}
}