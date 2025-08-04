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
			for(var d = 0; d < ds_list_size(edificios_targeteables); d++){
				var edificio = edificios_targeteables[|d], c = sqr(a - edificio.x) + sqr(b - edificio.y)
				if c < dis{
					dis = c
					enemigo.target = edificio
					enemigo.target_unit = null_enemigo
				}
			}
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