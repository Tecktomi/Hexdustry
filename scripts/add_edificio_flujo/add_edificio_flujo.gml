function add_edificio_flujo(edificio = control.null_edificio, flujo_name = "flujo", _jugador = 0, iter = 0){
	with control{
		var a = edificio.a, b = edificio.b, flujo = control.null_flujo
		var index = edificio.index, temp_list_size = get_size(a, b, edificio.dir, edificio_size[index]), temp_list_arround = get_arround(a, b, edificio.dir, edificio_size[index])
		var forzado = (array_length(edificio_flujo_liquido[index]) > iter)
		var my_liquido = forzado ? edificio_flujo_liquido[index, iter] : -1
		if index = id_tuberia and array_length(liquido_choose_array) > 1{
			forzado = true
			my_liquido = liquido_choose_array[liquido_choose]
		}
		if index = id_bomba_hidraulica{
			edificio.select = 0
			for(var c = array_length(temp_list_size) - 1; c >= 0; c--){
				var temp_complex = temp_list_size[c], aa = temp_complex[0], bb = temp_complex[1]
				if in(terreno[# aa, bb], idt_agua, idt_agua_profunda){
					edificio.select++
					if terreno[# aa, bb] = idt_agua_profunda
						edificio.select += 0.2
					edificio.fuel = 0
				}
				else if terreno[# aa, bb] = idt_petroleo{
					edificio.select++
					edificio.fuel = 2
				}
				else if terreno[# aa, bb] = idt_lava{
					edificio.select++
					edificio.fuel = 3
				}
				else if tag_agua_salada[terreno[# aa, bb]]{
					edificio.select++
					if terreno[# aa, bb] = idt_agua_salada_profunda
						edificio.select += 0.2
					edificio.fuel = 4
				}
			}
			my_liquido = edificio.fuel
		}
		//Conexión con tuberías subterráneas
		var temp_list_flujos = array_create(0, null_flujo)
		if index = id_tuberia_subterranea{
			var temp_list = get_size(a, b, 0, 7), temp_edificio = null_edificio
			for(var c = array_length(temp_list) - 1; c >= 0; c--){
				var temp_complex = temp_list[c], aa = temp_complex[0], bb = temp_complex[1]
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
					continue
				if edificio_bool[# aa, bb] and not (aa = a and bb = b){
					temp_edificio = edificio_id[# aa, bb]
					if temp_edificio.index = index and temp_edificio.link = null_edificio and temp_edificio.jugador = _jugador
					and (my_liquido = -1 or temp_edificio.flujo.liquido = -1 or my_liquido = temp_edificio.flujo.liquido){
						if my_liquido = -1
							my_liquido = temp_edificio.flujo.liquido
						edificio.link = temp_edificio
						temp_edificio.link = edificio
						array_push(edificio.flujo_link, temp_edificio)
						array_push(temp_edificio.flujo_link, edificio)
						if not array_contains(temp_list_flujos, temp_edificio.flujo)
							array_push(temp_list_flujos, temp_edificio.flujo)
						break
					}
				}
			}
		}
		//Detectar edificios adyascentes
		for(var c = array_length(temp_list_arround) - 1; c >= 0; c--){
			var temp_complex = temp_list_arround[c], aa = temp_complex[0], bb = temp_complex[1]
			if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
				continue
			if edificio_bool[# aa, bb]{
				var temp_edificio = edificio_id[# aa, bb]
				if edificio_flujo[temp_edificio.index] and (tag_edificio_tuberia[index] or tag_edificio_tuberia[temp_edificio.index]) and temp_edificio.jugador = _jugador
				and (my_liquido = -1 or temp_edificio.flujo.liquido = -1 or my_liquido = temp_edificio.flujo.liquido or my_liquido = temp_edificio.flujo_2.liquido){
					var _flujo1 = (my_liquido = -1 or temp_edificio.flujo.liquido = -1 or my_liquido = temp_edificio.flujo.liquido)
					if my_liquido = -1
						my_liquido = temp_edificio.flujo.liquido
					if iter = 0
						array_push(edificio.flujo_link, temp_edificio)
					else
						array_push(edificio.flujo_2_link, temp_edificio)
					if _flujo1{
						array_push(temp_edificio.flujo_link, edificio)
						if not array_contains(temp_list_flujos, temp_edificio.flujo)
							array_push(temp_list_flujos, temp_edificio.flujo)
					}
					else{
						array_push(temp_edificio.flujo_2_link, edificio)
						if not array_contains(temp_list_flujos, temp_edificio.flujo_2)
							array_push(temp_list_flujos, temp_edificio.flujo_2)
					}
					if temp_edificio.index = id_tuberia
						tuberia_arround(temp_edificio)
				}
			}
		}
		//Edificio solo
		if array_length(temp_list_flujos) = 0{
			flujo = def_flujo()
			flujo.liquido = my_liquido
			array_disorder_push(flujos, flujo, 0)
			struct_set(edificio, flujo_name, flujo)
			array_disorder_push(flujo.edificios, edificio, 6)
		}
		//Este edificio es una tubería
		else if tag_edificio_tuberia[index]{
			flujo = def_flujo()
			flujo.liquido = my_liquido
			for(var c = array_length(temp_list_flujos) - 1; c >= 0; c--){
				var temp_flujo = temp_list_flujos[c]
				if flujo.liquido = -1 or temp_flujo.liquido = -1 or flujo.liquido = temp_flujo.liquido{
					for(var d = array_length(temp_flujo.edificios) - 1; d >= 0; d--){
						var temp_edificio = temp_flujo.edificios[d]
						if temp_edificio.flujo = temp_flujo
						    temp_edificio.flujo = flujo
						else if temp_edificio.flujo_2 = temp_flujo
						    temp_edificio.flujo_2 = flujo
						array_disorder_push(flujo.edificios, temp_edificio, 6)
					}
					if flujo.liquido = -1
						flujo.liquido = temp_flujo.liquido
					flujo.consumo += temp_flujo.consumo
					flujo.generacion += temp_flujo.generacion
					flujo.almacen += temp_flujo.almacen
					flujo.almacen_max += temp_flujo.almacen_max
					delete(temp_flujo.edificios)
					array_disorder_remove(flujos, temp_flujo, 0)
				}
			}
			array_disorder_push(flujos, flujo, 0)
			struct_set(edificio, flujo_name, flujo)
			array_disorder_push(flujo.edificios, edificio, 6)
		}
		//Este edificio es normal
		else{
			flujo = temp_list_flujos[0]
			if my_liquido != -1
				flujo.liquido = my_liquido
			struct_set(edificio, flujo_name, flujo)
			array_disorder_push(flujo.edificios, edificio, 6)
		}
		flujo.almacen_max += edificio_flujo_almacen[index]
		if index = id_bomba_hidraulica and in(flujo.liquido, -1, edificio.fuel)
			change_flujo(edificio_flujo_consumo[index], edificio)
		else if in(index, id_bomba_de_evaporacion, id_generador_geotermico, id_extractor_atmosferico) and in(flujo.liquido, -1, idl_agua){
			change_flujo(edificio_flujo_consumo[index], edificio)
			if index = id_generador_geotermico{
				edificio.select = 0
				for(var c = array_length(temp_list_size) - 1; c >= 0; c--){
					var temp_complex_2 = temp_list_size[c], aa = temp_complex_2[0], bb = temp_complex_2[1]
					edificio.select += (terreno[# aa, bb] = idt_lava)
				}
			}
			else if index = id_extractor_atmosferico{
				edificio.select = 0
				for(var c = array_length(temp_list_size) - 1; c >= 0; c--){
					var temp_complex_2 = temp_list_size[c], aa = temp_complex_2[0], bb = temp_complex_2[1], d = terreno[# aa, bb]
					if d = idt_hielo
						edificio.select += 1.5
					else if d = idt_nieve
						edificio.select += 1.3
					else if d != idt_salar
						edificio.select++
				}
			}
		}
		else if index = id_planta_de_reciclaje
			change_flujo(edificio_flujo_consumo[index], edificio)
		if grafic_luz and flujo.liquido = idl_lava
			encender_luz(, edificio)
		if index = id_tuberia
			tuberia_arround(edificio)
	}
}