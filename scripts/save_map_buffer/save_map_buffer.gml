function save_map_buffer(buffer){
	with control{
		buffer_write(buffer, buffer_u8, xsize)
		buffer_write(buffer, buffer_u8, ysize)
		//Simplificar terreno base
		var max_terreno = 0, max_terreno_counter = 0, cordenadas = array_create(terreno_max, array_create(0, [0, 0])), recursos = array_create(0, [0, 0, 0, 0])
		for(var a = 0; a < xsize; a++)
			for(var b = 0; b < ysize; b++){
				array_push(cordenadas[terreno[# a, b]], [a, b])
				if ore[# a, b] != -1
					array_push(recursos, [a, b, real(ore[# a, b]), real(ore_amount[# a, b])])
			}
		for(var a = 0; a < terreno_max; a++)
			if array_length(cordenadas[a]) > max_terreno_counter{
				max_terreno_counter = array_length(cordenadas[a])
				max_terreno = a
			}
		buffer_write(buffer, buffer_u8, max_terreno)
		//Manchas de terreno
		for(var a = 0; a < terreno_max; a++)
			if a != max_terreno{
				var cordenada = cordenadas[a]
				buffer_write(buffer, buffer_u16, array_length(cordenada))
				for(var b = 0; b < array_length(cordenada); b++){
					buffer_write(buffer, buffer_u8, cordenada[b, 0])
					buffer_write(buffer, buffer_u8, cordenada[b, 1])
				}
			}
		//Recursos
		var len = array_length(recursos)
		buffer_write(buffer, buffer_u16, len)
		for(var a = 0; a < len; a++){
			buffer_write(buffer, buffer_u8, recursos[a, 0])
			buffer_write(buffer, buffer_u8, recursos[a, 1])
			buffer_write(buffer, buffer_u8, recursos[a, 2])
			buffer_write(buffer, buffer_u16, recursos[a, 3])
		}
	}
}