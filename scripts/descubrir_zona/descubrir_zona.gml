function descubrir_zona(a, b, mision = -1){
	with control{
		ini_open("settings.ini")
		world_visible[# a, b] = 2
		ini_write_real("World visible", $"{a},{b}", 2)
		var bmod = b & 1
		for(var c = 0; c < 6; c++){
			var aa = a + DESFACE[bmod][c, 0], bb = b + DESFACE[bmod][c, 1]
			var d = max(world_visible[# aa, bb], 1)
			world_visible[# aa, bb] = d
			ini_write_real("World visible", $"{aa},{bb}", d)
		}
		if mision != -1{
			ini_write_real("World mision", mision, 1)
			var buffer = buffer_create(1024, buffer_grow, 1)
			save_game_buffer(buffer)
			buffer_save(buffer, $"Tutorial/mision{mision}.save")
			buffer_delete(buffer)
		}
		ini_close()
	}
}