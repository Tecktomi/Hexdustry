function sound_play_edificio(sound, x, y, volume = 1){
	with control{
		if not sonido
			return undefined
		var dis = distance_sqr(x * zoom - camx, y * zoom - camy, room_width / 2, room_height / 2)
		if dis < 490_000 //700^2
			volumen[sound] = max(volumen[sound], clamp(zoom * 100 / (100 + sqrt(dis)), 0, volume))
	}
}