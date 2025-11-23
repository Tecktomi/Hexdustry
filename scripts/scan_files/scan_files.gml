function scan_files(mask, attr){
	var array = []
	for(var file = file_find_first(mask, attr); file != ""; file = file_find_next())
		array_push(array, file)
	file_find_close()
	return array
}