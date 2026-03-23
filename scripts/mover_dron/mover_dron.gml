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