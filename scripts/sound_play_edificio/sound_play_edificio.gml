function sound_play_edificio(sound, x, y, volume = 1){
	with control{
		if not sonido
			return undefined
		var dis = point_distance(x * zoom - camx, y * zoom - camy, room_width / 2, room_height / 2)
		if dis < 700
			volumen[sound] = max(volumen[sound], clamp(zoom * 100 / (100 + dis), 0, volume))
	}
}