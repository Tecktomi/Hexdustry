function get_arround_impar(x, y, radio){
	var output = [{a : real(x), b : real(y)}], frontera = [{a : real(x), b : real(y)}]
	for(var a = 0; a < radio; a++){
		var nueva_frontera = []
		for(var b = 0; b < array_length(frontera); b++){
			var temp_complex = frontera[b], aa = temp_complex.a, bb = temp_complex.b
			for(var c = 0; c < 6; c++){
				var temp_complex_2 = next_to(aa, bb, c), aaa = temp_complex_2.a, bbb = temp_complex_2.b
				if aaa < 0 or bbb < 0 or aaa >= xsize or bbb >= ysize
					continue
				array_push(nueva_frontera, {a : aaa, b : bbb})
			}
		}
		output = array_concat(output, frontera)
		frontera = nueva_frontera
	}
	return output
}