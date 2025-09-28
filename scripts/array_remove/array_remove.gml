function array_remove(arreglo, elemento){
	var a = array_get_index(arreglo, elemento)
	arreglo[a] = arreglo[array_length(arreglo) - 1]
	array_pop(arreglo)
}