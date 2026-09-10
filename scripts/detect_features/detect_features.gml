function detect_features(){
	with control{
		var a, b, c, d, aa, bb, aaa, bbb, bmod, i, j, maxi, temp_beta, temp_lago, temp_list = array_create(0, 0), counter = 0, dir
		ds_grid_clear(usable_grid_bool, true)
		ds_grid_clear(beta_grid, null_beta)
		array_resize(betas, 0)
		for(a = 0; a < xsize; a++)
			for(b = 0; b < ysize; b++)
				if usable_grid_bool[# a, b] and terreno_caminable[terreno[# a, b]]{
					usable_grid_bool[# a, b] = false
					c = ore[# a, b]
					if c >= 0{
						temp_beta = {
							recurso : c,
							terrenos : [a, b],
							center_x : a,
							center_y : b,
							cantidad : ore_amount[# a, b]
						}
						array_push(betas, temp_beta)
						maxi = 6
						array_resize(temp_list, 0)
						array_push(temp_list, a, b, 0)
						for(counter = 0; counter < array_length(temp_list);){
							aa = temp_list[counter++]
							bb = temp_list[counter++]
							dir = temp_list[counter++]
							bmod = bb & 1
							for(i = 0; i < maxi; i++){
								j = (i + dir + 5) mod 6
								aaa = aa + DESFACE_A[bmod, j]
								bbb = bb + DESFACE_B[bmod, j]
								if aaa < 0 or bbb < 0 or aaa >= xsize or bbb >= ysize
									continue
								if usable_grid_bool[# aaa, bbb] and ore[# aaa, bbb] = c and terreno_caminable[terreno[# aaa, bbb]]{
									usable_grid_bool[# aaa, bbb] = false
									beta_grid[# aaa, bbb] = temp_beta
									array_push(temp_list, aaa, bbb, j)
									array_push(temp_beta.terrenos, aaa, bbb)
									temp_beta.center_x += aaa
									temp_beta.center_y += bbb
									temp_beta.cantidad += ore_amount[# aaa, bbb]
								}
							}
							maxi = 3
						}
					}
				}
		for(a = array_length(betas) - 1; a >= 0; a--){
			temp_beta = betas[a]
			b = array_length(temp_beta.terrenos) / 2
			temp_beta.center_x /= b
			temp_beta.center_y /= b
		}
		ds_grid_clear(usable_grid_bool, true)
		ds_grid_clear(lago_grid, null_lago)
		array_resize(lagos, 0)
		for(a = 0; a < xsize; a++)
			for(b = 0; b < ysize; b++)
				if usable_grid_bool[# a, b]{
					usable_grid_bool[# a, b] = false
					c = terreno[# a, b]
					if terreno_liquido[c]{
						if c = idt_agua
							d = idt_agua_profunda
						else if c = idt_agua_profunda
							d = idt_agua
						else if c = idt_agua_salada
							d = idt_agua_salada_profunda
						else if c = idt_agua_salada_profunda
							d = idt_agua_salada
						else d = -1
						temp_lago = {
							liquido : tag_terreno_liquido[c],
							terrenos : [a, b],
							center_x : a,
							center_y : b
						}
						array_push(lagos, temp_lago)
						maxi = 6
						array_resize(temp_list, 0)
						array_push(temp_list, a, b, 0)
						for(counter = 0; counter < array_length(temp_list);){
							aa = temp_list[counter++]
							bb = temp_list[counter++]
							dir = temp_list[counter++]
							bmod = bb & 1
							for(i = 0; i < maxi; i++){
								j = (i + dir + 5) mod 6
								aaa = aa + DESFACE_A[bmod, j]
								bbb = bb + DESFACE_B[bmod, j]
								if aaa < 0 or bbb < 0 or aaa >= xsize or bbb >= ysize
									continue
								if usable_grid_bool[# aaa, bbb] and (terreno[# aaa, bbb] = c or terreno[# aaa, bbb] = d){
									usable_grid_bool[# aaa, bbb] = false
									lago_grid[# aaa, bbb] = temp_lago
									array_push(temp_list, aaa, bbb, j)
									array_push(temp_lago.terrenos, aaa, bbb)
									temp_lago.center_x += aaa
									temp_lago.center_y += bbb
								}
							}
							maxi = 3
						}
					}
				}
		for(a = array_length(lagos) - 1; a >= 0; a--){
			temp_lago = lagos[a]
			b = array_length(temp_lago.terrenos) / 2
			temp_lago.center_x /= b
			temp_lago.center_y /= b
		}
	}
}