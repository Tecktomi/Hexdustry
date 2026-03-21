function check_reconstruible(index){
	with control{
		var comprable = true, temp_text = ""
		for(var a = 0; a < array_length(edificio_precio_id[index]); a++)
			if nucleo.carga[edificio_precio_id[index, a]] < edificio_precio_num[index, a]{
				comprable = false
				temp_text += $"  {recurso_nombre[edificio_precio_id[index, a]]} {nucleo.carga[edificio_precio_id[index, a]]}/{edificio_precio_num[index, a]}\n"
			}
		if not comprable
			temp_text = $"{L.construir_recursos_insuficientes}\n" + temp_text
		draw_set_color(c_red)
		var flag_3 = false, size_2 = array_length(enemigos)
		for(var a = 0; a < size_2; a++){
			var enemigo = enemigos[a]
			draw_circle_off(enemigo.x, enemigo.y, 100, true)
			if not flag_3 and (sqr(mouse_x - enemigo.x + camx) + sqr(mouse_y - enemigo.y + camy)) < 10000{//100^2
				temp_text += $"{L.construir_enemigos_cerca}\n"
				comprable = false
				flag_3 = true
			}
		}
		draw_set_color(c_white)
		var output = {comprable : comprable, motivo : temp_text}
		return output
	}
}