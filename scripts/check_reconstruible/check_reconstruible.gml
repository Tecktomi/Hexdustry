function check_reconstruible(index){
	with control{
		var _comprable = true, temp_text = "", a, flag_3, size_2, enemigo, output
		for(a = 0; a < array_length(edificio_precio_id[index]); a++)
			if jugador_recursos[0, edificio_precio_id[index, a]] < edificio_precio_num[index, a]{
				_comprable = false
				temp_text += $"  {recurso_nombre[edificio_precio_id[index, a]]} {jugador_recursos[0, edificio_precio_id[index, a]]}/{edificio_precio_num[index, a]}\n"
			}
		if not _comprable
			temp_text = $"{L.construir_recursos_insuficientes}\n" + temp_text
		draw_set_color(c_red)
		flag_3 = false
		size_2 = array_length(enemigos)
		for(a = 0; a < size_2; a++){
			enemigo = enemigos[a]
			draw_circle_off(enemigo.x, enemigo.y, 100, true)
			if not flag_3 and (sqr(mouse_x - enemigo.x + camx) + sqr(mouse_y - enemigo.y + camy)) < ENEMIGO_CERCA_SQR{
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