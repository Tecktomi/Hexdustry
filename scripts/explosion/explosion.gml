function explosion(aa = 0, bb = 0, edificio = control.null_edificio){
	with control{
		sound_play(snd_explosion, aa, bb)
		array_push(efectos, add_efecto(spr_explosion, 0, aa, bb, 24, 1 / 3))
		edificio_herir(edificio, 100)
		var temp_complex = xytoab(aa, bb)
		if temp_complex.a >= 0{
			var chunk_x = floor(temp_complex.a / chunk_width), chunk_y = floor(temp_complex.b / chunk_height), maxa = min(chunk_x + 1, xsize / chunk_width), maxb = min(chunk_y + 1, ysize / chunk_height)
			for(var a = max(chunk_x - 1, 0); a <= maxa; a++)
				for(var b = max(chunk_y - 1, 0); b <= maxb; b++){
					var temp_array = chunk_edificios[# a, b]
					for(var i = array_length(temp_array); i > 0; i--){
						edificio = temp_array[i - 1]
						var dis = distance_sqr(aa, bb, edificio.x, edificio.y)
						if dis < 14_400//120^2
							edificio_herir(edificio, 1000 / (10 + sqrt(dis)))
					}
				}
			for(var a = array_length(drones_aliados); a > 0; a--){
				var temp_dron = drones_aliados[a - 1], dis = distance_sqr(aa, bb, edificio.x, edificio.y)
				if dis < 14_400{//120^2
					temp_dron.vida -= 1000 / (10 + sqrt(dis))
					if temp_dron.vida <= 0
						destroy_dron(temp_dron)
				}
			}
		}
	}
}