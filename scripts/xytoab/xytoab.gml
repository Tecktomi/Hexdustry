function xytoab(_x, _y){
	with control{
		var px = floor(_x / 48), py = floor(_y / 28)
		return [grid_xytoa[# _x - 48 * px, _y - 28 * py] + px, grid_xytob[# _x - 48 * px, _y - 28 * py] + 2 * py]
	}
}