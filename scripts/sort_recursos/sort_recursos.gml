function sort_recursos(){
	with control{
		rss_sort = array_create(rss_max, 0)
		var temp_rss_sort = array_create(rss_max)
		for(var a = 0; a < rss_max; a++)
			temp_rss_sort[a] = {
				name : recurso_nombre_display[a],
				index : a
			}
		array_sort(temp_rss_sort, function(elm1, elm2){return elm1.name < elm2.name ? -1 : 1})
		for(var a = 0; a < rss_max; a++)
			rss_sort[a] = temp_rss_sort[a].index
	}
}