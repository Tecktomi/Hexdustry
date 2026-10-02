function get_arround(a, b, dir, size){
	with control{
		var src = GET_ARROUND[b & 1, dir & 1][--size], len = array_length(src), output = array_create(len, 0)
		if size = 2.5{
			var temp_complex = next_to(a, b, (dir + 2) mod 6), i
			output[++i] = temp_complex
			var temp_array = [4, 4, 5, 0, 0, 1, 1, 2, 3]
			for(var c = 0; c < array_length(temp_array); c++){
				temp_complex = next_to(temp_complex[0], temp_complex[1], (dir + temp_array[c]) mod 6)
				output[++i] = temp_complex
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