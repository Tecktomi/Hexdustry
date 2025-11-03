function turret_target(edificio = control.null_edificio, alc_min = 0){
	with control{
		var dis = edificio_alcance_sqr[edificio.index], size = array_length(enemigos)
		if alc_min = 0{
			for(var c = 0; c < size; c++){
				var enemigo = enemigos[c], d = distance_sqr(edificio.x, edificio.y, enemigo.a, enemigo.b)
				if d < dis{
					dis = d
					edificio.target = enemigo
				}
			}
		}
		else for(var c = 0; c < size; c++){
			var enemigo = enemigos[c], d = distance_sqr(edificio.x, edificio.y, enemigo.a, enemigo.b)
			if d < dis and d > alc_min{
				dis = d
				edificio.target = enemigo
			}
		}
	}
}