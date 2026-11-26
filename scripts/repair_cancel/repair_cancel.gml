function repair_cancel(a, b, _repair_array){
	with control{
		for(var i = 0; i < array_length(_repair_array); i += 6)
			if _repair_array[i] = a and _repair_array[i + 1] = b{
				array_delete(_repair_array, i, 6)
				return true
			}
		return false
	}
}