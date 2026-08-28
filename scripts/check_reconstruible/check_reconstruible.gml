function check_reconstruible(index = 0, _dibujo = true, _jugador = jugador){
	with control{
		var _comprable = true, temp_text = "", a, flag_3, size_2, enemigo, output
		for(a = 0; a < array_length(edificio_precio_id[index]); a++)
			if jugador_recursos[_jugador, edificio_precio_id[index, a]] < edificio_precio_num[index, a]{
				_comprable = false
				if _dibujo
					temp_text += $"  {recurso_nombre[edificio_precio_id[index, a]]} {jugador_recursos[_jugador, edificio_precio_id[index, a]]}/{edificio_precio_num[index, a]}\n"
			}
		if _dibujo and not _comprable
			temp_text = $"{L.construir_recursos_insuficientes}\n" + temp_text
		draw_set_color(c_red)
		flag_3 = false
		for(a = array_length(drones) - 1; a >= 0; a--){
			enemigo = drones[a]
			if enemigo.jugador = jugador
				continue
			if _dibujo
				draw_circle_off(enemigo.x, enemigo.y, 100, true)
			if not flag_3 and distance_sqr(mouse_x, mouse_y, enemigo.x * zoom - camx, enemigo.y * zoom - camy) < ENEMIGO_CERCA_SQR * sqr(zoom){
				if _dibujo
					temp_text += $"{L.construir_enemigos_cerca}\n"
				_comprable = false
				flag_3 = true
			}
		}
		draw_set_color(c_white)
		output = {_comprable : _comprable, motivo : temp_text}
		return output
	}
}