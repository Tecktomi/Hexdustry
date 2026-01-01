function pasar_mision(){
	with control{
		if modo_misiones and mision_actual >= 0{
			add_mision()
			mision_actual--
			misiones_pasadas++
		}
		if ++mision_actual >= array_length(mision_nombre){
			mision_actual = -1
			win = 1
		}
		else{
			mision_counter = 0
			if mision_tiempo[mision_actual] > 0
				mision_current_tiempo = 60 * mision_tiempo[mision_actual]
			if mision_switch_oleadas[mision_actual]
				oleadas = not oleadas
			if mision_camara_move[mision_actual]{
				mision_camara_step = 60
				mision_camara_x_start = camx
				mision_camara_y_start = camy
			}
		}
	}
}