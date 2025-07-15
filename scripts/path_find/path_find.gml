function path_find(enemigo = control.null_enemigo){
	with control{
		var dis = infinity, a = enemigo.a, b = enemigo.b
		for(a = 0; a < ds_list_size(edificios); a++){
			var edificio = edificios[|a]
			if not edificio_camino[edificio.index]{
				var temp_complex = abtoxy(edificio.a, edificio.b)
				var c = sqrt(sqr(a - temp_complex.a) + sqr(b - temp_complex.b))
				if c < dis{
					dis = c
					enemigo.target = edificio
				}
			}
		}
	}
}