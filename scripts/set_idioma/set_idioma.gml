function set_idioma(file, change = true){
	with control{
		if file_exists(file){
			var buff = buffer_load(file), txt = buffer_read(buff, buffer_string)
			buffer_delete(buff)
			L = json_parse(txt)
			if change{
				for(var a = 0; a < edificio_max; a++){
					edificio_nombre_display[a] = variable_struct_get(L, edificio_nombre[a])
					edificio_descripcion[a] = variable_struct_get(L, "descripcion_" + edificio_nombre[a])
					edificio_descripcion[a] = text_wrap(edificio_descripcion[a], 400)
				}
				sort_edificios()
				for(var a = 0; a < rss_max; a++){
					recurso_nombre_display[a] = variable_struct_get(L, recurso_nombre[a])
					recurso_descripcion[a] = variable_struct_get(L, "descripcion_" + recurso_nombre[a])
					recurso_descripcion[a] = text_wrap(recurso_descripcion[a], 400)
				}
				sort_recursos()
				for(var a = 0; a < terreno_max; a++)
					terreno_nombre_display[a] = variable_struct_get(L, terreno_nombre[a])
				for(var a = 0; a < dron_max; a++)
					dron_nombre_display[a] = variable_struct_get(L, dron_nombre[a])
				for(var a = 0; a < array_length(categoria_nombre); a++)
					categoria_nombre_display[a] = variable_struct_get(L, categoria_nombre[a])
				for(var a = 0; a < array_length(objetivos_nombre); a++)
					objetivos_nombre_display[a] = variable_struct_get(L, $"objetivo_{objetivos_nombre[a]}")
				for(var a = 0; a < array_length(procesador_instrucciones_nombre); a++)
					procesador_instrucciones_nombre_display[a] = variable_struct_get(L, $"procesador_{procesador_instrucciones_nombre[a]}")
			}
		}
	}
}