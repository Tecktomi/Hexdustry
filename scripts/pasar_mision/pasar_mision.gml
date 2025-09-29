function pasar_mision(){
	with control{
		if ++mision_actual >= array_length(mision_nombre){
			mision_actual = -1
			show_message("Todas las misiones completadas")
		}
		else{
			mision_counter = 0
		}
	}
}