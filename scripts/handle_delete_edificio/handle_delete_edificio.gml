function handle_delete_edificio(buffer){
	with control{
		var a = real(buffer_read(buffer, buffer_u16))
		var b = real(buffer_read(buffer, buffer_u16))
		var destruccion = bool(buffer_read(buffer, buffer_bool))
		if edificio_bool[# a, b]
			delete_edificio(edificio_id[# a, b], destruccion)
	}
}