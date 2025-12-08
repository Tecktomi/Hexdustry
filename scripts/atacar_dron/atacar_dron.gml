function atacar_dron(dron = control.null_enemigo, edificio = control.null_edificio){
	with control{
		var aa = dron.a, bb = dron.b
		//Ataque araña
		if dron.index = 0{
			draw_set_color(c_red)
			draw_line_off(aa, bb, edificio.x, edificio.y)
			if edificio_herir(edificio, vel){
				var temp_complex = xytoab(aa, bb)
				if temp_complex.a >= 0
					dron.target = edificio_cercano[# temp_complex.a, temp_complex.b]
			}
			return false
		}
		//Ataque explosivo
		else if dron.index = 3{
			explosion(aa, bb, edificio)
			destroy_dron(dron)
			return true
		}
		//Ataque tanque
		else if dron.index = 4{
			dron.step += vel
			if dron.step = 120{
				dron.step = 0
				var dis = distance(dron.a, dron.b, edificio.x, edificio.y)
				var municion = add_municion(dron.a, dron.b, vel * 25 * (edificio.x - dron.a) / dis, vel * 25 * (edificio.y - dron.b) / dis, 3, dis / 25, 30, null_enemigo, edificio)
				array_push(municiones, municion)
			}
			return false
		}
		//Ataque Helicoptero
		else if dron.index = 5{
			dron.step += vel
			if dron.step = 15{
				dron.step = 0
				var dis = distance(dron.a, dron.b, edificio.x, edificio.y)
				var municion = add_municion(dron.a, dron.b, vel * 25 * (edificio.x - dron.a) / dis, vel * 25 * (edificio.y - dron.b) / dis, 0, dis / 25, 10, null_enemigo, edificio)
				array_push(municiones, municion)
			}
			return false
		}
		return false
	}
}