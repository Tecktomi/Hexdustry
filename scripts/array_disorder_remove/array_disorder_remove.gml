function array_disorder_remove(array = [], struct = {}, pointer){
	var len = array_length(array), point = real(struct.punteros[pointer])
	struct.punteros[pointer] = -1
	if point = len - 1{
		array_pop(array)
		exit
	}
	var temp_struct = array[len - 1]
	if pointer < 0 or pointer >= array_length(struct.punteros)
		show_error($"ERROR - array_disorder_remove\n{string_struct(struct, 1)} no tiene punteros hasta {pointer}", true)
	if array[point] != struct
		show_error($"ERROR - array_disorder_remove\n{string_struct(array, 1)} no contiene a {string_struct(struct, 1)}", true)
	temp_struct.punteros[pointer] = point
	array[point] = temp_struct
	array_pop(array)
}