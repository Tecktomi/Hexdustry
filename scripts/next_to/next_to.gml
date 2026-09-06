function next_to(a, b, dir){
	dir = (dir + 6) mod 6
	return [a + control.DESFACE_A[b & 1, dir], b + control.DESFACE_B[b & 1, dir]]
}