function set_edificio(mode, select, edificio = control.null_edificio, _server = false){
	with control{
		if edificio = null_edificio or edificio.vida <= 0
			exit
		var index = edificio.index
		if online and not _server{
			server_set_edificio(mode, select, edificio)
			if not servidor
				exit
		}
		//Cambiar modo
		if in(index, id_selector, id_overflow, id_planta_de_reciclaje) and edificio.mode != mode{
			edificio.mode = bool(mode)
			mover(edificio)
		}
		//Seleccionar edificio
		if in(index, id_selector, id_recurso_infinito, id_planta_de_reciclaje) and edificio.select != select{
			if in(index, id_selector, id_recurso_infinito) and select < -1 or select >= rss_max
				exit
			if index = id_recurso_infinito and edificio.select >= 0
				edificio.carga_output[edificio.select] = false
			edificio.select = select
			if index = id_recurso_infinito
				edificio.carga_output[select] = true
			mover(edificio)
		}
		//Líquido infinito
		else if index = id_liquido_infinito{
			if select < -1 or select >= liquido_max
				exit
			if edificio.select >= 0 and select = -1{
				change_flujo(0, edificio)
				edificio.flujo.almacen = 0
			}
			edificio.select = select
			if edificio.select >= 0 and edificio.flujo.liquido = -1
				change_flujo(edificio_flujo_consumo[index], edificio)
			edificio.flujo.liquido = select
			if grafic_luz and select = idl_lava and not edificio.luz{
				for(var b = array_length(edificio.flujo.edificios) - 1; b >= 0; b--){
					var temp_edificio = edificio.flujo.edificios[b]
					encender_luz(true, temp_edificio)
				}
			}
		}
		//Planta química
		else if index = id_planta_quimica and edificio.select != select{
			if select < 0 or select > 2
				exit
			change_flujo(0, edificio)
			if edificio.flujo.almacen = 0 and edificio.flujo.generacion = 0
				edificio.flujo.liquido = -1
			for(var i = 0; i < rss_max; i++){
				if i = idr_sal
					continue
				edificio.carga[i] = 0
				edificio.carga_max[i] = 0
				edificio.carga_input[i] = false
				edificio.carga_output[i] = false
			}
			edificio.carga_total = 0
			edificio.select = select
			edificio.fuel = 0
			edificio.proceso = -1
			edificio.carga_max[idr_sal] = 10
			//Ácido
			if select = 0{
				edificio.carga_max[idr_piedra_sulfatada] = 10
				edificio.carga_input[idr_piedra_sulfatada] = true
				edificio.receptor = true
				edificio.emisor = false
				edificio.flujo_consumo_max = -50
				edificio.energia_consumo_max = 80
			}
			//Explosivos
			else if select = 1{
				edificio.carga_max[idr_compuesto_incendiario] = 10
				edificio.carga_input[idr_compuesto_incendiario] = true
				edificio.carga_output[idr_explosivo] = true
				edificio.receptor = true
				edificio.emisor = true
				edificio.flujo_consumo_max = 30
				edificio.energia_consumo_max = 0
			}
			//Baterías
			else if select = 2{
				edificio.carga_max[idr_cobre] = 10
				edificio.carga_input[idr_cobre] = true
				edificio.carga_output[idr_bateria] = true
				edificio.receptor = true
				edificio.emisor = true
				edificio.flujo_consumo_max = 40
				edificio.energia_consumo_max = 80
			}
			calcular_edificios_adyascentes(edificio, false)
			mover_in(edificio)
		}
		//Fábrica de drones
		else if in(index, id_fabrica_de_drones, id_fabrica_de_drones_grande) and edificio.select != select and (edificio.enemigo or not tag_drones_terrestres[select]){
			if select < 0 or select >= dron_max
				exit
			edificio.carga = array_create(rss_max, 0)
			edificio.carga_max = array_create(rss_max, 0)
			edificio.carga_input = array_create(rss_max, false)
			edificio.carga_total = 0
			edificio.select = select
			edificio.proceso = 0
			edificio.start = false
			for(var b = array_length(dron_precio_id[select]) - 1; b >= 0; b--){
				var c = 2 * dron_precio_num[select, b]
				edificio.carga_max[dron_precio_id[select, b]] = c
				edificio.carga_input[dron_precio_id[select, b]] = true
				if dron_precio_id[select, b] = idr_uranio_bruto{
					edificio.carga_max[idr_uranio_enriquecido] = c
					edificio.carga_input[idr_uranio_enriquecido] = true
					edificio.carga_max[idr_uranio_empobrecido] = c
					edificio.carga_input[idr_uranio_empobrecido] = true
				}
			}
			calcular_edificios_adyascentes(edificio)
			mover_in(edificio)
		}
		//Refinería de Petróleo
		else if index = id_refineria_de_petroleo
			edificio.select = clamp(select, 0, 100)
		//Silo de Misiles
		else if index = id_silo_de_misiles and edificio.select != select{
			if select < 0 or select >= array_length(misiles_nombre)
				exit
			edificio.select = select
			edificio.mode = false
			for(var a = 0; a < rss_max; a++){
				edificio.carga[a] = 0
				edificio.carga_max[a] = 0
				edificio.carga_input[a] = false
			}
			for(var a = array_length(misiles_precio_id[select]) - 1; a >= 0; a--){
				edificio.carga_max[misiles_precio_id[select, a]] = misiles_precio_num[select, a]
				edificio.carga_input[misiles_precio_id[select, a]] = true
			}
			edificio.array_real[0] = misiles_petroleo[select]
			edificio.array_real[1] = misiles_tiempo[select]
		}
		if edificio_draw_estatico[index]
			for(var c = edificio.chunk_mina; c <= edificio.chunk_maxa; c++)
				for(var d = edificio.chunk_minb; d <= edificio.chunk_maxb; d++)
					chunk_edificios_dirty[# c, d] = true
	}
}