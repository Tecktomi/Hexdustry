function add_municion(x = 0, y = 0, hmove = 0, vmove = 0, tipo = 0, dis = 0, dmg = 0, radio = 2500, target = control.null_edificio, target_build = control.null_edificio, enemigo = false, humo = false){
	var offset = random(0.3)
	var municion = {
		x : x + offset * hmove,
		y : y + offset * vmove,
		origen_x : x,
		origen_y : y,
		hmove : hmove,
		vmove : vmove,
		tipo : tipo,
		dis : dis,
		dmg : dmg,
		radio : radio,
		target : target,
		target_build : target_build,
		enemigo : enemigo,
		humo : humo
	}
	return municion
}