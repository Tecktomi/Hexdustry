function next_to(a, b, dir){
	with control{
		dir = (dir + 6) mod 6
		return [a + DESFACE_A[b & 1, dir], b + DESFACE_B[b & 1, dir]]
	}
}