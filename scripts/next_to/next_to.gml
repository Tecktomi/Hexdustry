function next_to(a, b, dir){
	var aa, bb, par = [[1, -1], [0, -2], [0, -1], [0, 1], [0, 2], [1, 1]], impar = [[0, -1], [0, -2], [-1, -1], [-1, 1], [0, 2], [0, 1]]
	dir = dir mod 6
	if (b & 1){
		aa = a + par[dir, 0]
		bb = b + par[dir, 1]
	}
	else{
		aa = a + impar[dir, 0]
		bb = b + impar[dir, 1]
	}
	return {
		a : aa,
		b : bb
	}
}