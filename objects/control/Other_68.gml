var type = async_load[? "type"]
if type = network_type_data{
	var buffer = async_load[? "buffer"]
    buffer_seek(buffer, buffer_seek_start, 0)
    var msg = buffer_read(buffer, buffer_u8)
	show_debug_message($"{msg}")
	if msg = 1{
		var temp_socket = async_load[? "id"]
		array_push(server_jugadores, temp_socket)
		handle_hello(temp_socket, buffer)
	}
	else if msg = 2
		handle_welcome(buffer)
	else if msg = 3
		handle_add_edificio(buffer)
	else if msg = 4
		handle_delete_edificio(buffer)
    else if msg = 5 and servidor{
		var reply = buffer_create(256, buffer_grow, 1)
		buffer_write(reply, buffer_u8, 6)
		network_send_udp(udp_socket, async_load[? "ip"], async_load[? "port"], reply, buffer_tell(reply))
		buffer_delete(reply)
	}
	else if msg = 6{
		server_ip = async_load[? "ip"]
	}
}