function redo_pathfind(){
	with control{
		var a, edificio
		for(a = array_length(edificios_index[id_nucleo]) - 1; a >= 0; a--){
			edificio = edificios_index[id_nucleo][a]
			edificio_pathfind(edificio)
		}
	}
}