function ds_list_remove(lista, elemento){
	if ds_list_find_index(lista, elemento) = -1{
		show_error("ERROR\nIntentando eliminar un elemento que no existe en la lista", true)
		return
	}
	else
		ds_list_delete(lista, ds_list_find_index(lista, elemento))
}