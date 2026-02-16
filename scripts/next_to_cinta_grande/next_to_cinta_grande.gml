function next_to_cinta_grande(a = 0, b = 0, dir = 0){
	if dir = 0{
		if b mod 2 = 0
			return [[a, b - 1], [a + 1, b], [a + 1, b + 2], [a, b + 3]]
		else
			return [[a + 1, b - 1], [a + 1, b], [a + 1, b + 2], [a + 1, b + 3]]
	}
	else if dir = 1{
		if b mod 2 = 0
			return [[a - 1, b - 1], [a, b - 2], [a, b - 1], [a, b + 1]]
		else
			return [[a + 1, b + 1], [a + 1, b - 1], [a, b - 2], [a, b - 1]]
	}
	else if dir = 2{
		if b mod 2 = 0
			return [[a - 1, b - 1], [a - 1, b + 1], [a, b - 2], [a, b - 1]]
		else
			return [[a + 1, b - 1], [a, b - 2], [a, b - 1], [a, b + 1]]
	}
	else if dir = 3{
		if b mod 2 = 0
			return [[a - 1, b - 1], [a - 1, b], [a - 1, b + 2], [a - 1, b + 3]]
		else
			return [[a, b - 1], [a - 1, b], [a - 1, b + 2], [a, b + 3]]
	}
	else if dir = 4{
		if b mod 2 = 0
			return [[a - 1, b + 1], [a - 1, b + 3], [a, b + 4], [a, b + 3]]
		else
			return [[a, b + 1], [a, b + 3], [a, b + 4], [a + 1, b + 3]]
	}
	else if dir = 5{
		if b mod 2 = 0
			return [[a - 1, b + 3], [a, b + 4], [a, b + 3], [a, b + 1]]
		else
			return [[a, b + 3], [a, b + 4], [a + 1, b + 3], [a + 1, b + 1]]
	}
}