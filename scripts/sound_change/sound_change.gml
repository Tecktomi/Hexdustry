function sound_change(){
	sonido = not sonido
	if not sonido{
		for(var a = 0; a < sonidos_max; a++)
			audio_pause_sound(sonido_id[a])
		for(var a = 0; a < musica_max; a++)
			audio_pause_sound(musica[a])
	}
	else for(var a = 0; a < sonidos_max; a++)
		audio_resume_sound(sonido_id[a])
	ini_open("settings.ini")
	ini_write_real("", "sonido", sonido)
	ini_close()
}