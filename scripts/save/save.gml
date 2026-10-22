function save(file = false){
	with control{
		guardado = true
		var buffer = buffer_create(1024, buffer_grow, 1)
		save_game_buffer(buffer)
		if tutorial = 0
			buffer_save(buffer, "last_save.save")
		else
			buffer_save(buffer, $"Tutorial/mision{tutorial}.save")
		if file{
			var _text = day_format()
			buffer_save(buffer, $"Saves/{_text}.save")
			var _sprite = minimapa()
			sprite_save(_sprite, 0, $"Saves/{_text}.png")
			sprite_delete(_sprite)
		}
		buffer_delete(buffer)
	}
}