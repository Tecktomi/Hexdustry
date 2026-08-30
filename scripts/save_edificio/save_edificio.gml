function save_edificio(buffer, edificio = control.null_edificio){
	with control{
		var mask = 0, c = 0, a, len, len_2
		mask += (edificio.input_index != 0) << c++
		mask += (edificio.output_index != 0) << c++
		mask += (edificio.proceso != 0) << c++
		mask += edificio.start << c++
		for(a = 0; a < rss_max; a++)
			mask += (edificio.carga[a] != 0) << c++
		mask += (edificio.carga_id != 0) << c++
		mask += (edificio.fuel != 0) << c++
		mask += (edificio.select != -1) << c++
		mask += (edificio.mode) << c++
		mask += edificio.waiting << c++
		mask += edificio.idle << c++
		mask += (edificio.link != null_edificio and edificio.link.punteros[ptre_total] != -1) << c++
		mask += (edificio.vida != edificio_vida[edificio.index]) << c++
		mask += (edificio.target != null_dron and edificio.target.punteros[ptrd_total] != -1) << c++
		mask += (edificio.target_edificio != null_edificio and edificio.target_edificio.punteros[ptre_total] != -1) << c++
		mask += (edificio.flujo_consumo != 0) << c++
		mask += (edificio.flujo_consumo_max != 0) << c++
		mask += (edificio.energia_consumo != 0) << c++
		mask += (edificio.energia_consumo_max != 0) << c++
		mask += (edificio.edificio_index != 0) << c++
		mask += edificio.luz << c++
		mask += (array_length(edificio.procesador_link) > 0) << c++
		mask += edificio.eliminar << c++
		mask += edificio.agregar << c++
		mask += edificio.modulo << c++
		mask += (edificio.outputs_carga_index != 0) << c++
		mask += (edificio.calor_generado != 0) << c++
		buffer_write(buffer, buffer_u64, mask)
		c = 0
		//DEMASK
		if mask & (1 << c++) buffer_write(buffer, buffer_u8, real(edificio.input_index))
		if mask & (1 << c++) buffer_write(buffer, buffer_u8, real(edificio.output_index))
		if mask & (1 << c++) buffer_write(buffer, buffer_f16, real(edificio.proceso))
		c++
		for(a = 0; a < rss_max; a++)
			if mask & (1 << c++) buffer_write(buffer, buffer_f16, real(edificio.carga[a]))
		if mask & (1 << c++) buffer_write(buffer, buffer_u8, real(edificio.carga_id))
		if mask & (1 << c++) buffer_write(buffer, buffer_u16, real(edificio.fuel))
		if mask & (1 << c++) buffer_write(buffer, buffer_f16, real(edificio.select))
		c++
		c++
		c++
		if mask & (1 << c++) buffer_write(buffer, buffer_u16, real(edificio.link.punteros[ptre_total]))
		if mask & (1 << c++) buffer_write(buffer, buffer_f16, real(edificio.vida))
		if mask & (1 << c++) buffer_write(buffer, buffer_u16, real(edificio.target.punteros[ptrd_total]))
		if mask & (1 << c++) buffer_write(buffer, buffer_u16, real(edificio.target_edificio.punteros[ptre_total]))
		if mask & (1 << c++) buffer_write(buffer, buffer_f16, real(edificio.flujo_consumo))
		if mask & (1 << c++) buffer_write(buffer, buffer_f16, real(edificio.flujo_consumo_max))
		if mask & (1 << c++) buffer_write(buffer, buffer_f16, real(edificio.energia_consumo))
		if mask & (1 << c++) buffer_write(buffer, buffer_f16, real(edificio.energia_consumo_max))
		if mask & (1 << c++) buffer_write(buffer, buffer_u16, real(edificio.edificio_index))
		c++
		if mask & (1 << c++){
			len = array_length(edificio.procesador_link)
			len_2 = 0
			for(a = 0; a < len; a++){
				if edificio.procesador_link[a] != null_edificio and edificio.procesador_link[a].punteros[ptre_total] != -1
					len_2++
				else
					array_delete(edificio.procesador_link, a--, 1)
			}
			buffer_write(buffer, buffer_u16, real(len_2))
			for(a = 0; a < len_2; a++)
				buffer_write(buffer, buffer_u16, real(edificio.procesador_link[a].punteros[ptre_total]))
		}
		c++
		c++
		c++
		if mask & (1 << c++) buffer_write(buffer, buffer_u8, real(edificio.outputs_carga_index))
		if mask & (1 << c++) buffer_write(buffer, buffer_s8, real(edificio.calor_generado))
	}
}
