function server_set_edificio(mode, select, edificio = control.null_edificio){
	with control{
		var buffer = buffer_create(18, buffer_grow, 1)
		buffer_write(buffer, buffer_u8, net_set_edificio)
		buffer_write(buffer, buffer_u32, real(timer))
		buffer_write(buffer, buffer_bool, bool(mode))
		buffer_write(buffer, buffer_f64, real(select))
		buffer_write(buffer, buffer_u16, real(edificio.a))
		buffer_write(buffer, buffer_u16, real(edificio.b))
		server_send(buffer)
	}
}