function sort_edificios(){
	with control{
		var temp_edi_sort = array_create(edificio_max)
		for(var a = 0; a < edificio_max; a++){
			temp_edi_sort[a] = {
				name : edificio_nombre_display[a],
				index : a
			}
		}
		array_sort(temp_edi_sort, function(elm1, elm2){return elm1.name < elm2.name ? -1 : 1})
		for(var a = 0; a < edificio_max; a++)
			edi_sort[a] = temp_edi_sort[a].index
	}
}