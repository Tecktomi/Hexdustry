function flujo_text(flujo = control.null_flujo){
	with control{
		var temp_text = "  Edificios:\n", temp_array = []
		for(var a = 0; a < array_length(edificio_nombre); a++)
			array_push(temp_array, 0)
		for(var a = 0; a < ds_list_size(flujo.edificios); a++)
			temp_array[flujo.edificios[|a].index]++
		for(var a = 0; a < array_length(edificio_nombre); a++)
			if temp_array[a] > 0
				temp_text += $"    {edificio_nombre[a]}: {temp_array[a]}\n"
		return temp_text
	}
}