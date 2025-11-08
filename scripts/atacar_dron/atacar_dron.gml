function atacar_dron(dron = control.null_enemigo, edificio = control.null_edificio){
	with control{
		var aa = dron.a, bb = dron.b
		//Ataque araña
		if dron.index = 0{
			draw_set_color(c_red)
			draw_line_off(aa, bb, edificio.x, edificio.y)
			if dron.index = 0
				edificio.vida--
			else
				edificio.vida -= 5
			if edificio.vida <= 0{
				delete_edificio(edificio.a, edificio.b, true)
				var temp_complex = xytoab(aa, bb)
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
			if ++dron.step = 120{
				dron.step = 0
				var dis = distance(dron.a, dron.b, edificio.x, edificio.y)
				var municion = add_municion(dron.a, dron.b, 25 * (edificio.x - dron.a) / dis, 25 * (edificio.y - dron.b) / dis, 3, dis / 25, 30, null_enemigo, edificio)
				array_push(municiones, municion)
			}
			return false
		}
		return false
	}
}