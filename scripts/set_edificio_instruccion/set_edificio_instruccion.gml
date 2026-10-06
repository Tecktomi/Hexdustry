function set_edificio_instruccion(edificio = control.null_edificio, data = {}, _server = false){
	with control{
		if (GRABANDO or online) and not _server{
			server_set_instrucciones(edificio, data)
			if online and not servidor
				exit
		}
		if edificio.index = id_puerto_de_carga{
			if data.cambio = cambio_instrucciones_add_comando
				array_push(edificio.instruccion, [0, 0, 0])
			else if data.cambio = cambio_instrucciones_delete_comando{
				array_delete(edificio.instruccion, data.instruccion, 1)
				if array_length(edificio.instruccion) = 0
					edificio.select = 0
				else
					edificio.select = edificio.select mod array_length(edificio.instruccion)
			}
			else if data.cambio = cambio_instrucciones_cambio_recurso
				edificio.instruccion[data.instruccion, 0] = data.rss
			else if data.cambio = cambio_instrucciones_cambio_input
				edificio.instruccion[data.instruccion, 1] = data.pointer
			else if data.cambio = cambio_instrucciones_cambio_output
				edificio.instruccion[data.instruccion, 2] = data.pointer
		}
		else if edificio.index = id_procesador{
			if data.cambio = cambio_instrucciones_add_comando{
				var new_instruccion = array_create(array_length(procesador_default_instruccion[data.instruccion]), 0)
				array_copy(new_instruccion, 0, procesador_default_instruccion[data.instruccion], 0, array_length(procesador_default_instruccion[data.instruccion]))
				new_instruccion[0] = data.instruccion
				array_push(edificio.instruccion, new_instruccion)
			}
			else if data.cambio = cambio_instrucciones_delete_comando
				array_delete(edificio.instruccion, data.instruccion, 1)
			else if data.cambio = cambio_instrucciones_set_variable{
				if is_real(data.valor)
					array_set(edificio.variables[data.instruccion], data.pos, real(data.valor))
				else
					array_set(edificio.variables[data.instruccion], data.pos, string(data.valor))
			}
			else if data.cambio = cambio_instruccion_copiar{
				var new_instruccion = array_create(array_length(edificio.instruccion[data.instruccion]), 0)
				array_copy(new_instruccion, 0, edificio.instruccion[data.instruccion], 0, array_length(edificio.instruccion[data.instruccion]))
				new_instruccion[0] = data.instruccion
				array_insert(edificio.instruccion, data.instruccion + 1, new_instruccion)
			}
			else if data.cambio = cambio_instruccion_mover{
				array_insert(edificio.instruccion, data.instruccion, edificio.instruccion[data.prev])
				array_delete(edificio.instruccion, data.prev + (data.prev > data.instruccion), 1)
			}
			else if data.cambio = cambio_instruccion_set{
				if is_real(data.valor)
					array_set(edificio.instruccion[data.instruccion], data.pos, real(data.valor))
				else
					array_set(edificio.instruccion[data.instruccion], data.pos, string(data.valor))
			}
		}
		else if edificio.index = id_memoria
			edificio.variables[data.instruccion] = data.valor
	}
}