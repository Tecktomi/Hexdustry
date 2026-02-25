function array_remove(arreglo, elemento){
	var a = array_get_index(arreglo, elemento)
	if a = -1{
		show_debug_message($"No se pudo encontrar {string_struct(elemento, 1)} en {string_struct(arreglo, 1)}")
		show_error("", true)
	}
	arreglo[a] = arreglo[array_length(arreglo) - 1]
	array_pop(arreglo)
}