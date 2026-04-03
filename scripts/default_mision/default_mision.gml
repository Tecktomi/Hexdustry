function default_mision(len = 1){
	with control{
		mision_nombre = array_create(len, "")
		mision_objetivo = array_create(len, 0)
		mision_target_id = array_create(len, 0)
		mision_target_num = array_create(len, 0)
		mision_tiempo = array_create(len, 0)
		mision_tiempo_edit = array_create(len, false)
		mision_tiempo_victoria = array_create(len, false)
		mision_tiempo_show = array_create(len, false)
		mision_texto = array_create(len, array_create(0, {x : 0, y : 0, texto : ""}))
		mision_camara_move = array_create(len, false)
		mision_camara_x = array_create(len, 0)
		mision_camara_y = array_create(len, 0)
		mision_switch_oleadas = array_create(len, false)
	}
}