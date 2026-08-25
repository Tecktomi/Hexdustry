function dron_move_terrestre(dron = control.null_dron){
	with control{
		if dron.change_pos or (dron.move_xmove = 0 and dron.move_ymove = 0){
			var aa = dron.a, bb = dron.b
			if aa = dron.move_a and bb = dron.move_b
				dron.modo = 0
			else{
				var xx = dron.x, yy = dron.y, vel = dron_vel[dron.index]
				var angle = floor(point_direction(xx, yy, dron.move_x, dron.move_y) / 30), b, aaa, bbb
				dron.move_xmove = 0
				dron.move_ymove = 0
				for(var a = 0; a < 6; a++){
					b = preset_dir[angle, a]
					if b = dron.last_dir
						continue
					aaa = aa + DESFACE_A[bb & 1, b]
					bbb = bb + DESFACE_B[bb & 1, b]
					if aaa < 0 or bbb < 0 or aaa >= xsize or bbb >= ysize
						continue
					if terreno_caminable[terreno[# aaa, bbb]]{
						dron.move_xmove = vel * COS_ANGLE_DIR[b]
						dron.move_ymove = -vel * SIN_ANGLE_DIR[b]
						dron.last_dir = (b + 3) mod 6
						break
					}
				}
				if dron.move_xmove = 0 and dron.move_ymove = 0{
					dron.modo = 0
					dron.last_dir = -1
				}
			}
		}
		else{
			dron.x += dron.move_xmove
			dron.y += dron.move_ymove
		}
	}
}