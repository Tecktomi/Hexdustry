function turret_target(edificio = control.null_edificio){
	with control{
		var dis = infinity, temp_complex = abtoxy(edificio.a, edificio.b), a = temp_complex.a, b = temp_complex.b
		for(var c = 0; c < array_length(enemigos); c++){
			var enemigo = enemigos[c], d = sqrt(sqr(a - enemigo.a) + sqr(b - enemigo.b))
			if d < dis{
				dis = d
				edificio.target = enemigo
			}
		}
	}
}