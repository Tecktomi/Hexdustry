function descubrir_zona(a, b, _mision = -1){
	with control{
		ini_open("settings.ini")
		world_visible[# a, b] = 2
		ini_write_real("World visible", $"{a},{b}", 2)
		var bmod = b & 1, c, aa, bb, d, buffer
		for(c = 0; c < 6; c++){
			aa = a + DESFACE_A[bmod, c]
			bb = b + DESFACE_B[bmod, c]
			d = max(world_visible[# aa, bb], 1)
			world_visible[# aa, bb] = d
			ini_write_real("World visible", $"{aa},{bb}", d)
		}
		if _mision != -1{
			ini_write_real("World _mision", _mision, 1)
			buffer = buffer_create(1024, buffer_grow, 1)
			save_game_buffer(buffer)
			buffer_save(buffer, $"Tutorial/_mision{_mision}.save")
			buffer_delete(buffer)
		}
		ini_close()
	}
}