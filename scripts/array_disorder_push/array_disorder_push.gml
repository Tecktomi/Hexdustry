function array_disorder_push(array, struct, pointer){
	struct.punteros[pointer] = array_length(array)
	array_push(array, struct)
}