function set_edificio_instruccion(edificio = control.null_edificio, cambio = 0, data = {}, manual = false){
	with control{
		if (GRABANDO or online) and manual{
			server_set_instrucciones(edificio, cambio, data)
			if online and not servidor
				exit
		}
		if cambio = cambio_activar{
			edificio.agregar = true
			array_push(edificios_pendientes, edificio)
		}
		else if cambio = cambio_rotar_tunel{
			var _jugador = edificio.jugador, link = edificio.link
			if edificio.index = id_tunel_salida{
				array_disorder_remove(edificios_index[id_tunel_salida], edificio, ptre_index)
				array_disorder_push(edificios_index[id_tunel], edificio, ptre_index)
				array_disorder_remove(edificios_jugador_index[_jugador,id_tunel_salida], edificio, ptre_jugador_index)
				array_disorder_push(edificios_jugador_index[_jugador,id_tunel], edificio, ptre_jugador_index)
				array_disorder_remove(edificios_index[id_tunel], link, ptre_index)
				array_disorder_push(edificios_index[id_tunel_salida], link, ptre_index)
				array_disorder_remove(edificios_jugador_index[_jugador, id_tunel], link, ptre_jugador_index)
				array_disorder_push(edificios_jugador_index[_jugador,id_tunel_salida], link, ptre_jugador_index)
				link.index = id_tunel_salida
				edificio.index = id_tunel
				calcular_inputs_outputs(edificio)
				calcular_inputs_outputs(link)
				calcular_edificios_adyascentes(edificio)
				calcular_edificios_adyascentes(link)
				array_push(edificio.outputs, link)
				array_push(link.inputs, edificio)
			}
			else{
				array_disorder_remove(edificios_index[id_tunel], edificio, ptre_index)
				array_disorder_push(edificios_index[id_tunel_salida], edificio, ptre_index)
				array_disorder_remove(edificios_jugador_index[_jugador,id_tunel], edificio, ptre_jugador_index)
				array_disorder_push(edificios_jugador_index[_jugador,id_tunel_salida], edificio, ptre_jugador_index)
				array_disorder_remove(edificios_index[id_tunel_salida], link, ptre_index)
				array_disorder_push(edificios_index[id_tunel], link, ptre_index)
				array_disorder_remove(edificios_jugador_index[_jugador, id_tunel_salida], link, ptre_jugador_index)
				array_disorder_push(edificios_jugador_index[_jugador,id_tunel], link, ptre_jugador_index)
				edificio.index = id_tunel_salida
				edificio.link.index = id_tunel
				calcular_inputs_outputs(edificio)
				calcular_inputs_outputs(edificio.link)
				calcular_edificios_adyascentes(edificio)
				calcular_edificios_adyascentes(edificio.link)
				array_push(edificio.inputs, edificio.link)
				array_push(edificio.link.outputs, edificio)
			}
			set_camino_dir(edificio)
			set_camino_dir(edificio.link)
		}
		else if cambio = cambio_silo_target{
			edificio.array_real[2] = data._x
			edificio.array_real[3] = data._y
			edificio.fuel = 200
		}
		else if edificio.index = id_puerto_de_carga{
			if cambio = cambio_instrucciones_add_comando
				array_push(edificio.instruccion, array_create(5, 0))
			else if cambio = cambio_instrucciones_delete_comando{
				array_delete(edificio.instruccion, data.instruccion, 1)
				if array_length(edificio.instruccion) = 0
					edificio.select = 0
				else
					edificio.select = edificio.select mod array_length(edificio.instruccion)
			}
			else if cambio = cambio_instrucciones_cambio_recurso
				edificio.instruccion[data.instruccion, 0] = real(data.rss)
			else if cambio = cambio_instrucciones_cambio_input{
				edificio.instruccion[data.instruccion, 1] = real(data.a)
				edificio.instruccion[data.instruccion, 2] = real(data.b)
			}
			else if cambio = cambio_instrucciones_cambio_output{
				edificio.instruccion[data.instruccion, 3] = real(data.a)
				edificio.instruccion[data.instruccion, 4] = real(data.b)
			}
		}
		else if edificio.index = id_procesador{
			if cambio = cambio_instrucciones_add_comando{
				var new_instruccion = array_create(array_length(procesador_default_instruccion[data.instruccion]), 0)
				array_copy(new_instruccion, 0, procesador_default_instruccion[data.instruccion], 0, array_length(procesador_default_instruccion[data.instruccion]))
				new_instruccion[0] = real(data.instruccion)
				array_push(edificio.instruccion, new_instruccion)
			}
			else if cambio = cambio_instrucciones_delete_comando
				array_delete(edificio.instruccion, data.instruccion, 1)
			else if cambio = cambio_instrucciones_set_variable{
				if is_real(data.valor)
					edificio.variables[data.instruccion] = real(data.valor)
				else
					edificio.variables[data.instruccion] = string(data.valor)
			}
			else if cambio = cambio_instruccion_copiar{
				var new_instruccion = array_create(array_length(edificio.instruccion[data.instruccion]), 0)
				array_copy(new_instruccion, 0, edificio.instruccion[data.instruccion], 0, array_length(edificio.instruccion[data.instruccion]))
				new_instruccion[0] = real(data.instruccion)
				array_insert(edificio.instruccion, data.instruccion + 1, new_instruccion)
			}
			else if cambio = cambio_instruccion_mover{
				array_insert(edificio.instruccion, data.instruccion, edificio.instruccion[data.prev])
				array_delete(edificio.instruccion, data.prev + (data.prev > data.instruccion), 1)
			}
			else if cambio = cambio_instruccion_set{
				if is_real(data.valor)
					array_set(edificio.instruccion[data.instruccion], data.pos, real(data.valor))
				else
					array_set(edificio.instruccion[data.instruccion], data.pos, string(data.valor))
			}
			else if cambio = cambio_instruccion_next
				edificio.proceso = 1
			else if cambio = cambio_vincular{
				var target = edificio_id[# data.desa, data.desb]
				if not array_contains(edificio.procesador_link, target){
					array_push(edificio.procesador_link, target)
					array_push(target.procesador_link, edificio)
				}
				else{
					array_remove(edificio.procesador_link, target)
					array_remove(target.procesador_link, edificio)
				}
			}
		}
		else if edificio.index = id_memoria
			edificio.variables[data.instruccion] = data.valor
		else if cambio = cambio_vaciar_deposito{
			edificio.flujo.almacen = 0
			edificio.flujo.liquido = -1
		}
		else if cambio = cambio_target_drones{
			if edificio.array_real[0] = -1{
				edificio.array_real[0] = real(data.desa)
				edificio.array_real[1] = real(data.desb)
			}
			else{
				edificio.array_real[0] = -1
				edificio.array_real[1] = -1
			}
		}
	}
}