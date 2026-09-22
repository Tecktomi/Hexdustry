function get_arround(a, b, dir, size){
	with control{
		var src = GET_ARROUND[b & 1, dir & 1][--size], len = array_length(src), output = array_create(len, 0)
		for(var i = 0; i < len; i++){
			output[i] = src[i] + a
			i++
			output[i] = src[i] + b
		}
		return output
	}
}