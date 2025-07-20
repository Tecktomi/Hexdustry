function path_find(enemigo = control.null_enemigo){
	with control{
		var dis = infinity, a = enemigo.a, b = enemigo.b
		for(var d = 0; d < ds_list_size(edificios_targeteables); d++){
			var edificio = edificios_targeteables[|d], c = sqr(a - edificio.x) + sqr(b - edificio.y)
			if c < dis{
				dis = c
				enemigo.target = edificio
			}
		}
	}
}