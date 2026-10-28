function mover_dron(dron = control.null_dron, x, y, manual = false){
	with control{
		if (GRABANDO or online) and manual{
			server_mover_dron(x, y, dron)
			if online and not servidor
				exit
		}
		var index = dron.index, temp_complex = xytoab(x, y), aa = temp_complex[0], bb = temp_complex[1]
		if dron.index = idd_mula{
			if edificio_bool[# aa, bb] and edificio_id[# aa, bb].index = id_puerto_de_carga{
				dron.modo = DRON_BUSCAR_INSTRUCCION
				dron.target = edificio_id[# aa, bb]
				dron.temp_target = edificio_id[# aa, bb]
				exit
			}
		}
		else if dron.index = idd_minero{
			if edificio_bool[# aa, bb] and edificio_id[# aa, bb].index = id_almacen{
				dron.modo = DRON_MINAR
				dron.target = edificio_id[# aa, bb]
				exit
			}
		}
		else if tag_drones_de_ataque[index]{
			if edificio_bool[# aa, bb]{
				var edificio = edificio_id[# aa, bb]
				if edificio.jugador != dron.jugador{
					x = edificio.center_x
					y = edificio.center_y
					dron.temp_target = edificio
					dron.modo = DRON_ATACAR
					exit
				}
			}
		}
		dron.modo = DRON_MOVER
		if index = idd_bombardero{
			dron.move_xmove = x
			dron.move_ymove = y
		}
		else if tag_drones_terrestres[index] or tag_dron_marino[index]{
			dron.move_xmove = 0
			dron.move_ymove = 0
			dron.move_a = aa
			dron.move_b = bb
			dron.last_dir = -1
		}
		else{
			var dis = point_distance(dron.x, dron.y, x, y)
			dron.move_xmove = (x - dron.x) / dis
			dron.move_ymove = (y - dron.y) / dis
			dron.move_dis = dis / dron_vel[index]
		}
		dron.move_x = x
		dron.move_y = y
	}
}