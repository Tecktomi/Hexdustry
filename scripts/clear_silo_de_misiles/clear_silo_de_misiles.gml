function clear_silo_de_misiles(edificio = control.null_edificio){
	with control{
		mover_in(edificio)
		edificio.mode = false
		edificio.proceso = 0
		edificio.array_real[0] = 1
		edificio.array_real[1] = 1
		edificio.array_real[2] = -1
		edificio.array_real[3] = -1
		for(var b = 0; b < array_length(misiles_precio_id[edificio.select]); b++)
			edificio.carga[misiles_precio_id[edificio.select, b]] = 0
		edificio.select = -1
	}
}