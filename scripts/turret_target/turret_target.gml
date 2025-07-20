function turret_target(edificio = control.null_edificio){
	with control{
		var dis = infinity
		for(var c = 0; c < ds_list_size(enemigos); c++){
			var enemigo = enemigos[|c], d = sqr(edificio.x - enemigo.a) + sqr(edificio.y - enemigo.b)
			if d < dis{
				dis = d
				edificio.target = enemigo
			}
		}
	}
}