function get_size(a = 0, b = 0, dir = 0, size = 0){
	with control{
		var src = GET_SIZE[b & 1, dir & 1][--size], len = array_length(src), output = array_create(len, 0)
		for(var i = 0; i < len;){
			output[i++] = src[i] + a
			output[i++] = src[i] + b
		}
		return output
	}
}