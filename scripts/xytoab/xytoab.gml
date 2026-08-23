function xytoab(_x, _y){
	with control{
	    var px = _x - 16, py = _y - 14;
		var bf = py / 14, af = px / 48 - (floor(bf) mod 2) * 0.5;
		var xx = af, zz = bf, yy = -xx - zz
		var rx = round(xx), ry = round(yy), rz = round(zz);
		var dx = abs(rx - xx), dy = abs(ry - yy), dz = abs(rz - zz);
		if dx > dy and dx > dz
			rx = -ry - rz
		else if dy > dz
			ry = -rx - rz
		else
			rz = -rx - ry
		var a, b, temp_complex, dxx, dyy, d, best_a = rx, best_b = rz
		temp_complex = abtoxy(rx, rz)
		dxx = _x - temp_complex[0]
		dyy = _y - temp_complex[1]
		var best_d = dxx * dxx + dyy * dyy
		if best_d < HEX_FAST_THRESHOLD
			return [clamp(rx, 0, xsize - 1), clamp(rz, 0, ysize - 1)]
		var rzmod = rz & 1
		for (var dir = 0; dir < 8; dir++){
			if dir < 6{
				a = rx + DESFACE_A[rzmod, dir]
				b = rz + DESFACE_B[rzmod, dir]
			}
			else if dir = 6{
				a = rx - 1
				b = rz
			}
			else if dir = 7{
				a = rx + 1
				b = rz
			}
			if a < 0 or b < 0 or a >= xsize or b >= ysize
				continue
			temp_complex = abtoxy(a, b)
			dxx = _x - temp_complex[0]
			dyy = _y - temp_complex[1]
			d = dxx * dxx + dyy * dyy;
			if d < best_d{
				best_d = d
				best_a = a
				best_b = b
			}
		}
		return [best_a, best_b]
	}
}