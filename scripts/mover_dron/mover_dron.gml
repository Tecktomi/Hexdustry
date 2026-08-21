function mover_dron(dron = control.null_dron, x, y, _server = false){
	with control{
		if online and not _server{
			server_mover_dron(x, y, dron)
			if not servidor
				exit
		}
		var index = dron.index, temp_complex = xytoab(x, y), aa = temp_complex[0], bb = temp_complex[1]
		if tag_drones_de_ataque[index] and edificio_bool[# aa, bb]{
			var edificio = edificio_id[# aa, bb]
			if edificio.enemigo != dron.enemigo{
				x = edificio.center_x
				y = edificio.center_y
				dron.temp_target = edificio
			}
		}
		dron.modo = 1
		if index = idd_bombardero{
			dron.move_xmove = x
			dron.move_ymove = y
		}
		else if tag_drones_terrestres[index]{
			dron.move_xmove = 0
			dron.move_ymove = 0
			dron.move_a = aa
			dron.move_b = bb
			dron.last_dir = -1
		}
		else if index = idd_minero{
			if edificio_bool[# aa, bb] and edificio_id[# aa, bb].index = id_almacen{
				dron.modo = 0
				dron.target = edificio_id[# aa, bb]
			}
			else{
				var dis = distance(dron.x, dron.y, x, y)
				dron.move_xmove = (x - dron.x) / dis
				dron.move_ymove = (y - dron.y) / dis
				dron.move_dis = dis / dron_vel[index]
			}
		}
		else{
			var dis = distance(dron.x, dron.y, x, y)
			dron.move_xmove = (x - dron.x) / dis
			dron.move_ymove = (y - dron.y) / dis
			dron.move_dis = dis / dron_vel[index]
		}
		dron.move_x = x
		dron.move_y = y
	}
}