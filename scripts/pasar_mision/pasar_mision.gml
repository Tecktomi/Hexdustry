function pasar_mision(){
	with control{
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
		}
	}
}