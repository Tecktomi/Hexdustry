function red_text(red = control.null_red){
	with control{
		var temp_text = "  Edificios:\n", temp_array = []
		for(var a = 0; a < edificio_max; a++)
			array_push(temp_array, 0)
		for(var a = 0; a < ds_list_size(red.edificios); a++)
			temp_array[red.edificios[|a].index]++
		for(var a = 0; a < edificio_max; a++)
			if temp_array[a] > 0
				temp_text += $"    {edificio_nombre_display[a]}: {temp_array[a]}\n"
		return temp_text
	}
}