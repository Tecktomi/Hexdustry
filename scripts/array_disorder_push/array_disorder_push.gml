function array_disorder_push(array, struct, pointer){
	if pointer < 0 or array_length(struct.punteros) <= pointer
		show_error($"ERROR - array_disorder_push\n{string_struct(struct, 1)} no tiene punteros hasta {pointer}", true)
	struct.punteros[pointer] = array_length(array)
	array_push(array, struct)
}