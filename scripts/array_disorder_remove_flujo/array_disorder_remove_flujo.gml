function flujo_puntero(flujo = control.null_flujo, edificio = control.null_edificio){
	return (edificio.flujo = flujo) ? ptre_flujo_1 : ptre_flujo_2
}

function array_disorder_remove_flujo(flujo = control.null_flujo, edificio = control.null_edificio){
	var array = flujo.edificios, len = array_length(array)
	var pointer = flujo_puntero(flujo, edificio), point = edificio.punteros[pointer]
	if array[point] != edificio
		show_error($"ERROR - array_disorder_remove_flujo\n{string_struct(edificio, 1)} no está en este flujo", true)
	var temp_struct = array[len - 1]
	temp_struct.punteros[flujo_puntero(flujo, temp_struct)] = point
	array[point] = temp_struct
	array_pop(array)
}

function array_disorder_push_flujo(flujo = control.null_flujo, edificio = control.null_edificio){
	edificio.punteros[flujo_puntero(flujo, edificio)] = array_length(flujo.edificios)
	array_push(flujo.edificios, edificio)
}