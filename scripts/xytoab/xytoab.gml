function xytoab(x, y){
    var px = x - 16, py = y - 14;
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
	var best_a = rx,  best_b = rz, best_d = infinity;
	for (var dir = -1; dir < 8; dir++){
		var a, b;
		if dir = -1{
			a = rx
			b = rz
		}
		else if dir = 6{
			a = rx - 1
			b = rz
		}
		else if dir = 7{
			a = rx + 1
			b = rz
		}
		else{
			var n = next_to(rx, rz, dir)
			a = n.a
			b = n.b
		}
		var temp_complex = abtoxy(a, b), hx = temp_complex.a, hy = temp_complex.b;
		var dxx = x - hx, dyy = y - hy, d = dxx * dxx + dyy * dyy;
		if d < best_d{
			best_d = d
			best_a = a
			best_b = b
		}
	}
	return {
		a : best_a,
		b : best_b
	}
}