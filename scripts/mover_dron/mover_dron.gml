function mover_dron(dron = control.null_dron, x, y){
	with control{
		dron.modo = 1
		if dron.index = idd_bombardero{
			dron.array_real[0] = x
			dron.array_real[1] = y
		}
		else{
			var dis = distance(dron.x, dron.y, x, y)
			dron.array_real[0] = (x - dron.x) / dis
			dron.array_real[1] = (y - dron.y) / dis
			dron.array_real[2] = dis / dron_vel[dron.index]
		}
		dron.array_real[3] = x
		dron.array_real[4] = y
	}
}