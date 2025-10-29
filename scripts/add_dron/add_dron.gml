function add_dron(a, b, index){
	with control{
		var temp_complex = abtoxy(a, b)
		var enemigo = {
			a : temp_complex.a,
			b : temp_complex.b,
			index : real(index),
			vida : dron_vida_max[index],
			target : null_edificio,
			chunk_x : clamp(round(a / 6), 0, ds_grid_width(chunk_enemigos) - 1),
			chunk_y : clamp(round(b / 12), 0, ds_grid_height(chunk_enemigos) - 1),
			posa : a,
			posb : b,
			carga : array_create(rss_max, 0),
			carga_total : 0,
			modo : 0
		}
		return enemigo
	}
}