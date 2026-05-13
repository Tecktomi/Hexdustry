function sound_change(){
	sonido = not sonido
	if not sonido{
		for(var a = 0; a < SONIDOS_MAX; a++)
			audio_pause_sound(sonido_id[a])
		for(var a = 0; a < MUSICA_MAX; a++)
			audio_pause_sound(MUSICA[a])
	}
	else for(var a = 0; a < SONIDOS_MAX; a++)
		audio_resume_sound(sonido_id[a])
	save_setting("", "sonido", sonido)
}