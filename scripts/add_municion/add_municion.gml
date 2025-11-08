function add_municion(x = 0, y = 0, hmove = 0, vmove = 0, tipo = 0, dis = 0, dmg = 0, target = control.null_edificio, target_build = control.null_edificio){
	var municion = {
		x : x,
		y : y,
		hmove : hmove,
		vmove : vmove,
		tipo : tipo,
		dis : dis,
		dmg : dmg,
		target : target,
		target_build : target_build
	}
	return municion
}