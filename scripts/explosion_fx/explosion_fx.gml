function explosion_fx(x, y, size){
	return {
		x : real(x),
		y : real(y),
		step : irandom_range(60, 90),
		size : real(size)
	}
}