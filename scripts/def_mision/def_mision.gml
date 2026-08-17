function def_mision(nombre = "", nombre_idioma = array_create(0, ""), objetivo = 0, target_id = 0, target_num = 0, texto = array_create(0, {x : 0, y : 0, texto : "", texto_idioma : array_create(IDIOMAS, "")}), tiempo_edit = false, tiempo = 0, tiempo_victoria = false, tiempo_show = false, camera_move = false, camera_x = 0, camera_y = 0, switch_oleadas = false){
	return {
		nombre : nombre,
		nombre_idioma : nombre_idioma,
		objetivo : objetivo,
		target_id : target_id,
		target_num : target_num,
		tiempo_edit : tiempo_edit,
		tiempo_victoria : tiempo_victoria,
		tiempo : tiempo,
		tiempo_show : tiempo_show,
		camera_move : camera_move,
		camera_x : camera_x,
		camera_y : camera_y,
		switch_oleadas : switch_oleadas,
		texto : texto
	}
}