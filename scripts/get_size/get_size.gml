function get_size(a = 0, b = 0, dir = 0, size = 0){
	var src = (size = 2.5) ? control.SIZE_2_5[b & 1, dir] : control.GET_SIZE[b & 1, dir & 1][--size], len = array_length(src), output = array_create(len, 0)
	for(var i = 0; i < len; i++){
		output[i] = src[i] + a
		i++
		output[i] = src[i] + b
	}
	return output
}