function ds_list_choose(lista){
	return ds_list_find_value(lista, irandom(ds_list_size(lista) - 1))
}