function sort_edificios(){
	with control{
		var temp_edi_sort = array_create(edificio_max), a
		for(a = 0; a < edificio_max; a++){
			temp_edi_sort[a] = {
				name : edificio_nombre[a],
				index : a
			}
		}
		array_sort(temp_edi_sort, sort_order)
		for(a = 0; a < edificio_max; a++)
			edi_sort[a] = temp_edi_sort[a].index
	}
}