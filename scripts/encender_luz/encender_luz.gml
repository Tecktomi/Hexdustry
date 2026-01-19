function encender_luz(encender = true, edificio = control.null_edificio, fuerza = 5){
	with control{
		if encender xor edificio.luz{
			if encender{
					edificio.luz_pointer = array_length(luces)
					array_push(luces, {a : edificio.a, b : edificio.b, x : edificio.x, y : edificio.y, r : fuerza, source : edificio})
				}
			else{
				var luz = luces[array_length(luces) - 1]
				luz.source.luz_pointer = edificio.luz_pointer
				luces[edificio.luz_pointer] = luz
				array_pop(luces)
			}
			edificio.luz = encender
		}
	}
}