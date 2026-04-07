function minar(a, b){
	with control{
		if --ore_amount[# a, b] = 50
			update_background(a, b)
		else if ore_amount[# a, b] <= 0{
			update_background(a, b)
			ore[# a, b] = -1
			var temp_beta = beta[# a, b], len = array_length(temp_beta.terrenos)
			for(var c = 0; c < len; c++){
				var temp_terreno = temp_beta.terrenos[c]
				if temp_terreno[0] = a and temp_terreno[1] = b{
					temp_beta.terrenos[c] = temp_beta.terrenos[len - 1]
					array_pop(temp_beta.terrenos)
					break
				}
			}
			return true
		}
		return false
	}
}