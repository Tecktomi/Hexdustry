function mover_dron(dron = control.null_dron, x, y, server = false){
	with control{
		if online and not server{
			server_mover_dron(x, y, dron)
			if not servidor
				exit
		}
		dron.modo = 1
		if dron.index = idd_bombardero{
			dron.move_xmove = x
			dron.move_ymove = y
		}
		else if dron.index = idd_minero{
			var temp_complex = xytoab(x, y), aa = temp_complex[0], bb = temp_complex[1]
			if edificio_bool[# aa, bb] and edificio_id[# aa, bb].index = id_almacen{
				dron.modo = 0
				dron.target = edificio_id[# aa, bb]
			}
			else{
				var dis = distance(dron.x, dron.y, x, y)
				dron.move_xmove = (x - dron.x) / dis
				dron.move_ymove = (y - dron.y) / dis
				dron.move_dis = dis / dron_vel[dron.index]
			}
		}
		else{
			var dis = distance(dron.x, dron.y, x, y)
			dron.move_xmove = (x - dron.x) / dis
			dron.move_ymove = (y - dron.y) / dis
			dron.move_dis = dis / dron_vel[dron.index]
		}
		dron.move_x = x
		dron.move_y = y
	}
}