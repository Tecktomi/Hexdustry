function handle_add_edificio(buffer){
	with control{
		var index = real(buffer_read(buffer, buffer_u8))
		var dir = real(buffer_read(buffer, buffer_u8))
		var a = real(buffer_read(buffer, buffer_u16))
		var b = real(buffer_read(buffer, buffer_u16))
		var enemigo = bool(buffer_read(buffer, buffer_bool))
		construir(index, dir, a, b, enemigo)
	}
}