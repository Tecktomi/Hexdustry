function pasar_mision(){
	with control{
		if modo_misiones and mision_actual >= 0{
			add_mision()
			mision_actual--
			misiones_pasadas++
		}
		if ++mision_actual >= array_length(misiones){
			mision_actual = -1
			win = 1
			if mapa >= 0 and dificultad >= 0{
				ini_open("settings.ini")
				ini_write_real("Medallas", $"{mapa},{dificultad}", irandom_range(99, 999) * (12092000 + (mapa + 1) * (dificultad + 10)) + 1)
				array_set(medallas[mapa], dificultad, true)
				ini_close()
			}
		}
		else{
			mision_counter = 0
			mision = misiones[mision_actual]
			if mision.tiempo > 0
				mision_current_tiempo = 60 * mision.tiempo
			if mision.switch_oleadas
				oleadas = not oleadas
			if mision.camera_move{
				mision_camara_step = 60
				mision_camera_x_start = camx
				mision_camera_y_start = camy
			}
		}
	}
}