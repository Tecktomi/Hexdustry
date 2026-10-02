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
			//PLACEHOLDER
		}
	}
}