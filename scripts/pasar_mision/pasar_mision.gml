function pasar_mision(){
	with control{
		if ++mision_actual >= array_length(mision_nombre){
			mision_actual = -1
			if not show_question(mision_texto_victoria + "\n\n¿Seguir jugando?")
				game_restart()
		}
		else{
			mision_counter = 0
		}
	}
}