function descubrir_zona(a, b){
	with control{
		ini_open("settings.ini")
		world_visible[# a, b] = 2
		ini_write_real("World visible", $"{a},{b}", 2)
		for(var c = 0; c < 6; c++){
			var temp_complex = next_to(a, b, c), d = max(world_visible[# temp_complex.a, temp_complex.b], 1)
			world_visible[# temp_complex.a, temp_complex.b] = d
			ini_write_real("World visible", $"{temp_complex.a},{temp_complex.b}", d)
		}
		ini_close()
	}
}