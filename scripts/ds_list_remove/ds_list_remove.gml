function ds_list_remove(lista, elemento){
	if ds_list_find_index(lista, elemento) = -1{
		show_debug_message("Error en ds_list_remove(" + string(lista) + ", " + string(elemento) + ")")
		return
	}
	else
		ds_list_delete(lista, ds_list_find_index(lista, elemento))
}