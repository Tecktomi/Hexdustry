function turret_target(edificio = control.null_edificio){
	with control{
		var dis = infinity, size = ds_list_size(enemigos)
		for(var c = 0; c < size; c++){
			var enemigo = enemigos[|c], d = sqr(edificio.x - enemigo.a) + sqr(edificio.y - enemigo.b)
			if d < dis{
				dis = d
				edificio.target = enemigo
			}
		}
	}
}