function dron_target_nucleo(dron = control.null_dron){
	with control{
		var i, edificio, _jugador = dron.jugador, dis = infinity, a = clamp(dron.a, 0, xsize - 1), b = clamp(dron.b, 0, ysize - 1), xx = dron.x, yy = dron.y
		if tag_dron_marino[dron.index] or dron_aereo[dron.index]{
			for(i = array_length(edificios_index[id_nucleo]) - 1; i >= 0; i--){
				edificio = edificios_index[id_nucleo, i]
				if edificio.jugador != _jugador and point_distance(xx, yy, edificio.center_x, edificio.center_y) < dis{
					dis = point_distance(xx, yy, edificio.center_x, edificio.center_y)
					dron.target = edificio
				}
			}
		}
		else for(i = array_length(edificios_index[id_nucleo]) - 1; i >= 0; i--){
			edificio = edificios_index[id_nucleo, i]
			if edificio.jugador != _jugador and edificio.coordenadas_dis[# a, b] < dis{
				dis = edificio.coordenadas_dis[# a, b]
				dron.target = edificio
			}
		}
		if is_infinity(dis){
			dron.target = null_edificio
			return false
		}
		return true
	}
}