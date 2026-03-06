function save_edificio(buffer, edificio = control.null_edificio){
	with control{
		var mask = 0, c = 0
		mask += (edificio.input_index != 0) << c++
		mask += (edificio.output_index != 0) << c++
		mask += (edificio.proceso != 0) << c++
		mask += edificio.start << c++
		for(var a = 0; a < rss_max; a++)
			mask += (edificio.carga[a] != 0) << c++
		mask += (edificio.carga_id != 0) << c++
		mask += (edificio.fuel != 0) << c++
		mask += edificio.waiting << c++
		mask += edificio.idle << c++
		mask += (edificio.link != null_edificio) << c++
		mask += (edificio.vida != edificio_vida[edificio.index]) << c++
		mask += (edificio.target != null_dron) << c++
		mask += (edificio.target_edificio != null_edificio) << c++
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
		buffer_write(buffer, buffer_u64, mask)
		c = 0
		//DEMASK
		if mask & (1 << c++) buffer_write(buffer, buffer_u8, real(edificio.input_index))
		if mask & (1 << c++) buffer_write(buffer, buffer_u8, real(edificio.output_index))
		if mask & (1 << c++) buffer_write(buffer, buffer_f16, real(edificio.proceso))
		if mask & (1 << c++) buffer_write(buffer, buffer_bool, bool(edificio.start))
		for(var a = 0; a < rss_max; a++)
			if mask & (1 << c++) buffer_write(buffer, buffer_f16, real(edificio.carga[a]))
		if mask & (1 << c++) buffer_write(buffer, buffer_u8, real(edificio.carga_id))
		if mask & (1 << c++) buffer_write(buffer, buffer_u16, real(edificio.fuel))
		if mask & (1 << c++) buffer_write(buffer, buffer_bool, bool(edificio.waiting))
		if mask & (1 << c++) buffer_write(buffer, buffer_bool, bool(edificio.idle))
		if mask & (1 << c++) buffer_write(buffer, buffer_u16, real(edificio.link.punteros[12]))
		if mask & (1 << c++) buffer_write(buffer, buffer_f16, real(edificio.vida))
		if mask & (1 << c++) buffer_write(buffer, buffer_u16, real(edificio.target.punteros[2]))
		if mask & (1 << c++) buffer_write(buffer, buffer_u16, real(edificio.target_edificio.punteros[12]))
		if mask & (1 << c++) buffer_write(buffer, buffer_f16, real(edificio.flujo_consumo))
		if mask & (1 << c++) buffer_write(buffer, buffer_f16, real(edificio.flujo_consumo_max))
		if mask & (1 << c++) buffer_write(buffer, buffer_f16, real(edificio.energia_consumo))
		if mask & (1 << c++) buffer_write(buffer, buffer_f16, real(edificio.energia_consumo_max))
		if mask & (1 << c++) buffer_write(buffer, buffer_u16, real(edificio.edificio_index))
		if mask & (1 << c++) buffer_write(buffer, buffer_bool, bool(edificio.luz))
		if mask & (1 << c++){
			var len = array_length(edificio.procesador_link)
			buffer_write(buffer, buffer_u16, real(len))
			for(var a = 0; a < len; a++)
				buffer_write(buffer, buffer_u16, real(edificio.procesador_link[a].punteros[12]))
		}
		if mask & (1 << c++) buffer_write(buffer, buffer_bool, bool(edificio.eliminar))
		if mask & (1 << c++) buffer_write(buffer, buffer_bool, bool(edificio.agregar))
		if mask & (1 << c++) buffer_write(buffer, buffer_bool, bool(edificio.modulo))
		if mask & (1 << c++) buffer_write(buffer, buffer_u8, real(edificio.outputs_carga_index))
	}
}
