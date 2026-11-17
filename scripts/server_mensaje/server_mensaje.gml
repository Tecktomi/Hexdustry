function server_mensaje(nombre, mensaje){
	if mensaje = ""
		exit
	with control{
		var buffer = buffer_create(1, buffer_grow, 1)
		buffer_write(buffer, buffer_u8, net_mensaje)
		buffer_write(buffer, buffer_string, string(nombre))
		buffer_write(buffer, buffer_string, string(mensaje))
		server_send(buffer)
	}
}