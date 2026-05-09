function sort_drones(){
	with control{
		dron_sort = array_create(dron_max, 0)
		var temp_dron_sort = array_create(dron_max)
		for(var a = 0; a < dron_max; a++)
			temp_dron_sort[a] = {
				name : dron_nombre[a],
				index : a
			}
		array_sort(temp_dron_sort, sort_order)
		for(var a = 0; a < dron_max; a++)
			dron_sort[a] = temp_dron_sort[a].index
	}
}