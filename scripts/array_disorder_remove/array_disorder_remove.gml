function array_disorder_remove(array, struct, pointer){
	var len = array_length(array), temp_struct = array[len - 1], point = struct.punteros[pointer]
	temp_struct.punteros[pointer] = point
	array[point] = temp_struct
	array_pop(array)
}