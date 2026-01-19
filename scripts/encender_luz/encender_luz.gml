function encender_luz(encender = true, edificio = control.null_edificio, fuerza = 6){
	with control{
		if encender xor edificio.luz{
			if encender{
					edificio.punteros[3] = array_length(luces)
					array_push(luces, {a : edificio.a, b : edificio.b, x : edificio.center_x, y : edificio.center_y, r : fuerza, source : edificio})
				}
			else{
				var luz = luces[array_length(luces) - 1], point = edificio.punteros[3]
				luz.source.punteros[3] = point
				luces[point] = luz
				array_pop(luces)
			}
			edificio.luz = encender
		}
	}
}