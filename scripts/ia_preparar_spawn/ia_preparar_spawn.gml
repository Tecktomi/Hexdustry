function ia_preparar_spawn(){
	with control{
		var temp_list = get_size(spawn_x, spawn_y, 0, 7), len = array_length(temp_list), a, b
		for(var i = 0; i < len;){
			a = temp_list[i++]
			b = temp_list[i++]
			if a < 0 or b < 0 or a >= xsize or b >= ysize
				continue
			set_terreno(a, b, idt_piedra)
		}
		ia_spawn_preparado = true
	}
}