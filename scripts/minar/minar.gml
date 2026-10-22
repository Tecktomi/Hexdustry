function minar(a, b){
	with control{
		if --ore_amount[# a, b] = 50
			update_background(a, b)
		else if ore_amount[# a, b] <= 0{
			update_background(a, b)
			ore[# a, b] = -1
			var temp_beta = beta_grid[# a, b], len = array_length(temp_beta.terrenos), aa, bb
			for(var c = 0; c < len; c += 2){
				aa = temp_beta.terrenos[c]
				bb = temp_beta.terrenos[c + 1]
				if aa = a and bb = b{
					temp_beta.terrenos[c] = temp_beta.terrenos[len - 2]
					temp_beta.terrenos[c + 1] = temp_beta.terrenos[len - 1]
					array_pop(temp_beta.terrenos)
					array_pop(temp_beta.terrenos)
					break
				}
			}
			return true
		}
		return false
	}
}