function next_to(a, b, dir){
	var aa, bb;
	dir = dir mod 6
	if (b mod 2) = 1{
		if dir = 0{
			aa = a + 1
			bb = b - 1
		}
		else if dir = 1{
			aa = a
			bb = b - 2
		}
		else if dir = 2{
			aa = a
			bb = b - 1
		}
		else if dir = 3{
			aa = a
			bb = b + 1
		}
		else if dir = 4{
			aa = a
			bb = b + 2
		}
		else if dir = 5{
			aa = a + 1
			bb = b + 1
		}
	}
	else{
		if dir = 0{
			aa = a
			bb = b - 1
		}
		else if dir = 1{
			aa = a
			bb = b - 2
		}
		else if dir = 2{
			aa = a - 1
			bb = b - 1
		}
		else if dir = 3{
			aa = a - 1
			bb = b + 1
		}
		else if dir = 4{
			aa = a
			bb = b + 2
		}
		else if dir = 5{
			aa = a
			bb = b + 1
		}
	}
	return {
		a : aa,
		b : bb
	}
}