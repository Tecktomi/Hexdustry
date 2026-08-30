function encender_luz(encender = true, edificio = control.null_edificio, fuerza = 6){
	with control{
		var luz, point
		if encender xor edificio.luz{
			if encender{
					edificio.punteros[ptre_luz] = array_length(luces)
					array_push(luces, {a : edificio.a, b : edificio.b, x : edificio.center_x, y : edificio.center_y, r : fuerza, source : edificio})
				}
			else{
				luz = luces[array_length(luces) - 1]
				point = edificio.punteros[ptre_luz]
				luz.source.punteros[ptre_luz] = point
				luces[point] = luz
				array_pop(luces)
			}
			edificio.luz = encender
		}
	}
}