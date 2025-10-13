function sound_play(sound, x, y, volume = 1){
	var dis = distance_sqr(x * control.zoom - control.camx, y * control.zoom - control.camy, room_width / 2, room_height / 2)
	if dis < 490_000 //700^2
		return audio_play_sound(sound, 0, false, clamp(zoom * 100 / (100 + sqrt(dis)), 0, volume))
}