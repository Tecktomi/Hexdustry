function save(){
	with control{
		guardado = true
		if tutorial = 0{
			var buffer = buffer_create(1024, buffer_grow, 1)
			save_game_buffer(buffer)
			buffer_save(buffer, "last_save.save")
			buffer_delete(buffer)
		}
		else{
			var buffer = buffer_create(1024, buffer_grow, 1)
			save_game_buffer(buffer)
			buffer_save(buffer, $"Tutorial/mision{tutorial}.save")
			buffer_delete(buffer)
		}
	}
}