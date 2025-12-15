function flujo_text(flujo = control.null_flujo){
	with control{
		var temp_text = "  Edificios:\n", temp_array = []
		for(var a = 0; a < edificio_max; a++)
			array_push(temp_array, 0)
		for(var a = array_length(flujo.edificios) - 1; a >= 0; a--)
			temp_array[flujo.edificios[a].index]++
		for(var a = 0; a < edificio_max; a++)
			if temp_array[a] > 0
				temp_text += $"    {edificio_nombre_display[a]}: {temp_array[a]}\n"
		return temp_text
	}
}