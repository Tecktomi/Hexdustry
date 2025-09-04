function path_find(equipo, enemigo = control.null_enemigo){
	with control{
		var dis = infinity, a = enemigo.a, b = enemigo.b
		if equipo{
			for(var d = 0; d < ds_list_size(enemigos); d++){
				var dron = enemigos[|d], c = sqr(a - dron.a) + sqr(b - dron.b)
				if c < dis{
					dis = c
					enemigo.target = null_edificio
					enemigo.target_unit = dron
				}
			}
		}
		else{
			var temp_complex = xytoab(enemigo.a, enemigo.b)
			enemigo.target = edificio_cercano[# temp_complex.a, temp_complex.b]
			enemigo.target_unit = null_enemigo
			for(var d = 0; d < ds_list_size(drones_aliados); d++){
				var dron = drones_aliados[|d], c = sqr(a - dron.a) + sqr(b - dron.b)
				if c < dis{
					dis = c
					enemigo.target = null_edificio
					enemigo.target_unit = dron
				}
			}
		}
	}
}