function xytoab(_x, _y){
	return [
		control.array_xytoa[_x - 48 * floor(_x / 48), _y - 28 * floor(_y / 28)] + floor(_x / 48),
		control.array_xytob[_x - 48 * floor(_x / 48), _y - 28 * floor(_y / 28)] + 2 * floor(_y / 28)]
}