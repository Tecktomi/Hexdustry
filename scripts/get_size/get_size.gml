function get_size(a = 0, b = 0, dir = 0, size = 0){
	with control{
		var src = GET_SIZE[b & 1, dir & 1][--size], len = array_length(src), output = array_create(len, 0)
		if size = 2.5{
			var c, i
			for(c = 4; c <= 6; c++){
				temp_complex = DESFACE[b & 1, (c + dir) mod 6]
				output[++i] = [a + temp_complex[0], b + temp_complex[1]]
			}
			return output
		}
		for(var i = 0; i < len; i++){
			output[i] = src[i] + a
			i++
			output[i] = src[i] + b
		}
		return output
	}
}