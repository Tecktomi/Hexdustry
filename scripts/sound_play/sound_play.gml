function sound_play(sound, x, y, volume = 1){
	with control{
		if not sonido
			return undefined
		var dis = distance_sqr(x * zoom - camx, y * zoom - camy, room_width / 2, room_height / 2)
		if dis < 640_000 //800^2
			return audio_play_sound(sound, 0, false, clamp(zoom * 100 / (100 + sqrt(dis)), 0, volume))
	}
}