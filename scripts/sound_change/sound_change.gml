function sound_change(){
	var a
	sonido = not sonido
	if not sonido{
		for(a = 0; a < SONIDOS_MAX; a++)
			audio_pause_sound(sonido_id[a])
	}
	else for(a = 0; a < SONIDOS_MAX; a++)
		audio_resume_sound(sonido_id[a])
	if sonido and clima
		audio_resume_sound(clima_tipo = clima_lluvia ? snd_rain : snd_wind)
	if not sonido and clima
		audio_pause_sound(clima_tipo = clima_lluvia ? snd_rain : snd_wind)
	save_setting("", "sonido", sonido)
}