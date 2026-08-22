function sound_change(){
	var a
	sonido = not sonido
	if not sonido{
		for(a = 0; a < SONIDOS_MAX; a++)
			audio_pause_sound(sonido_id[a])
		for(a = 0; a < MUSICA_MAX; a++)
			audio_pause_sound(MUSICA[a])
	}
	else for(a = 0; a < SONIDOS_MAX; a++)
		audio_resume_sound(sonido_id[a])
	save_setting("", "sonido", sonido)
}