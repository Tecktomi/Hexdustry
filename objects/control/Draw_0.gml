#region Dibujo
	//Dibujo de fondo
	if background = spr_hexagono{
		var temp_surf = surface_create(room_width, room_height)
		surface_set_target(temp_surf)
		for(var a = 0; a < xsize; a++)
			for(var b = 0; b < ysize; b++){
				var temp_terreno = terreno[a, b]
				var temp_complex = abtoxy(a, b), aa = temp_complex.a, bb = temp_complex.b, c = temp_terreno.ore
				draw_sprite(terreno_sprite[temp_terreno.terreno], 0, aa, bb)
				if c >= 0
					draw_sprite(ore_sprite[c], temp_terreno.ore_random + 2 * (temp_terreno.ore_amount < 50), aa, bb)
			}
		background = sprite_create_from_surface(temp_surf, 0, 0, room_width, room_height, false, false, 0, 0)
		surface_reset_target()
		surface_free(temp_surf)
	}
	draw_sprite_stretched(background, 0, -camx, -camy, room_width * zoom, room_height * zoom)
	//Dibujo de edificios
	for(var a = 0; a < xsize; a++)
		for(var b = 0; b < ysize; b++){
			var temp_terreno = terreno[a, b]
			if temp_terreno.edificio_draw{
				var temp_edificio = terreno[a, b].edificio, index = temp_edificio.index, var_edificio_nombre = edificio_nombre[index], dir = temp_edificio.dir, aa = temp_edificio.x, bb = temp_edificio.y
				//Dibujo caminos
				if edificio_camino[index] or var_edificio_nombre = "Túnel"{
					if in(var_edificio_nombre, "Selector", "Overflow")
						draw_sprite_off(edificio_sprite[index], real(temp_edificio.mode), aa, bb,,, (dir - 1) * 60)
					else if in(var_edificio_nombre, "Cinta Transportadora", "Enrutador", "Cinta Magnética"){
						var c = image_index / 4
						if in(var_edificio_nombre, "Cinta Magnética")
							c = image_index / 2
						if (dir mod 3) = 1
							draw_sprite_off(edificio_sprite[index], c, aa, bb,, power(-1, dir > 1))
						else
							draw_sprite_off(edificio_sprite_2[index], c, aa, bb, power(-1, ((dir + 1) mod 6) > 1), power(-1, dir > 2))
					}
					else
						draw_sprite_off(edificio_sprite[index], image_index / 4, aa, bb,,, (dir - 1) * 60)
					if var_edificio_nombre = "Selector" and temp_edificio.select >= 0
						draw_sprite_off(edificio_sprite_2[index], image_index / 4, aa, bb,,, (dir - 1) * 60, recurso_color[temp_edificio.select])
				}
				else{
					//Dibujo edificios con horno
					if in(var_edificio_nombre, "Horno", "Generador") and temp_edificio.fuel > 0
						draw_sprite_off(edificio_sprite_2[index], image_index / 4, aa, bb, power(-1, dir))
					//Dibujo de bateria
					else if in(var_edificio_nombre, "Batería")
						draw_sprite_off(edificio_sprite[index], floor(10 * temp_edificio.red.bateria / temp_edificio.red.bateria_max), aa, bb,,, dir * 60)
					//Dibujo bomba
					else if in(var_edificio_nombre, "Bomba Hidráulica"){
						draw_sprite_off(edificio_sprite[index], 0, aa, bb, power(-1, dir))
						draw_sprite_off(spr_bomba_rotor, 1, aa + power(-1, dir) * 8, bb + 14,,, image_index)
						draw_sprite_off(spr_bomba_cupula, 1, aa + power(-1, dir) * 8, bb + 14)
					}
					else if in(var_edificio_nombre, "Tubería", "Depósito", "Líquido Infinito"){
						draw_sprite_off(edificio_sprite[index], 0, aa, bb)
						if temp_edificio.flujo.liquido = -1
							draw_sprite_off(edificio_sprite_2[index], 0, aa, bb)
						else
							draw_sprite_off(edificio_sprite_2[index], 0, aa, bb,,,, liquido_color[temp_edificio.flujo.liquido], temp_edificio.flujo.cantidad / temp_edificio.flujo.cantidad_max)
					}
					//Torres 1x1
					else if in(var_edificio_nombre, "Torre"){
						draw_sprite_off(edificio_sprite[index], 0, aa, bb)
						draw_sprite_off(edificio_sprite_2[index], 0, aa, bb,,, temp_edificio.select)
					}
					//Torres 2x2
					else if in(var_edificio_nombre, "Rifle"){
						draw_sprite_off(edificio_sprite[index], 0, aa, bb, power(-1, dir))
						draw_sprite_off(edificio_sprite_2[index], 0, aa + 9 * power(-1, dir), bb + 14,,, temp_edificio.select)
					}
					//Dibujo 2x2
					else if edificio_size[index] mod 2 = 0
						draw_sprite_off(edificio_sprite[index], image_index / 4, aa, bb, power(-1, dir))
					//Dibujo predeterminado
					else
						draw_sprite_off(edificio_sprite[index], image_index / 4, aa, bb,,, dir * 60)
				}
				//Dibujo estados
				if info{
					if temp_edificio.waiting{
						draw_set_color(c_yellow)
						draw_circle_off(aa, bb, 4, false)
					}
					if temp_edificio.idle{
						draw_set_color(c_red)
						draw_circle_off(aa, bb + 8, 4, false)
					}
				}
				if temp_edificio.vida < edificio_vida[index]{
					draw_set_color(make_color_hsv(120 * temp_edificio.vida / edificio_vida[index], 255, 255))
					draw_circle_off(aa, bb, 5, false)
					draw_set_color(c_white)
				}
			}
		}
	//Dibujo items y links electricos
	for(var a = 0; a < xsize; a++)
		for(var b = 0; b < ysize; b++){
			var temp_terreno = terreno[a, b]
			var temp_edificio = temp_terreno.edificio, index = temp_edificio.index
			var temp_complex = abtoxy(a, b), aa = temp_complex.a, bb = temp_complex.b
			if temp_terreno.edificio_draw{
				//Dibujo de items en los caminos
				if (edificio_camino[index] or (index = 6)) and temp_edificio.carga_total > 0{
					var c = 1.2 * (max(temp_edificio.proceso, temp_edificio.waiting * edificio_proceso[index]) - edificio_proceso[index] / 2) * 20 / edificio_proceso[index]
					var d = temp_edificio.dir * pi / 3 + pi / 6
					draw_sprite_off(recurso_sprite[temp_edificio.carga_id], 0, aa + c * cos(d), bb - c * sin(d))
				}
				//Dibujo de items saliendo del tunel
				else if index = 16 and temp_edificio.carga_total > 0{
					var c = 1.2 * (max(temp_edificio.proceso, temp_edificio.waiting * edificio_proceso[index]) - edificio_proceso[index] / 2) * 20 / edificio_proceso[index]
					var d = temp_edificio.dir * pi / 3 + pi / 6
					draw_sprite_off(recurso_sprite[temp_edificio.carga_id], 0, aa - c * cos(d), bb + c * sin(d))
				}
				//Dibujo de los links eléctricos
				else if edificio_electricidad[index]{
					draw_set_color(c_yellow)
					for(var c = 0; c < ds_list_size(temp_edificio.energy_link); c++){
						var temp_edificio_2 = temp_edificio.energy_link[|c]
						draw_line_off(temp_edificio.x, temp_edificio.y, temp_edificio_2.x, temp_edificio_2.y)
					}
				}
			}
		}
#endregion
var flag = true, xmouse = (mouse_x + camx) / zoom, ymouse = (mouse_y + camy) / zoom
//Seleccionar recurso
if show_menu{
	var aa = abtoxy(show_menu_build.a, show_menu_build.b).a * zoom - camx
	var bb = abtoxy(show_menu_build.a, show_menu_build.b).b * zoom - camy
	var var_edificio_nombre = edificio_nombre[show_menu_build.index]
	draw_set_color(c_gray)
	draw_triangle(aa - 10 * zoom, bb + 20 * zoom, aa + 10 * zoom, bb + 20 * zoom, aa, bb + 10 * zoom, false)
	draw_rectangle(aa - 80 * zoom, bb + 20 * zoom, aa + 80 * zoom, bb + 40 * zoom, false)
	if in(var_edificio_nombre, "Selector")
		draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 28 * ceil(rss_max / 5)) * zoom, false)
	if in(var_edificio_nombre, "Líquido Infinito")
		draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 20 * lq_max) * zoom, false)
	draw_set_color(c_dkgray)
	draw_triangle(aa - 10 * zoom, bb + 20 * zoom, aa + 10 * zoom, bb + 20 * zoom, aa, bb + 10 * zoom, true)
	draw_rectangle(aa - 80 * zoom, bb + 20 * zoom, aa + 80 * zoom, bb + 40 * zoom, true)
	if in(var_edificio_nombre, "Selector")
		draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 28 * ceil(rss_max / 5)) * zoom, true)
	if in(var_edificio_nombre, "Líquido Infinito")
		draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 20 * lq_max) * zoom, true)
	if in(var_edificio_nombre, "Selector", "Overflow")
		draw_text(aa - 80 * zoom, bb + 20 * zoom, "INVERTIR")
	if in(var_edificio_nombre, "Selector")
		for(var a = 0; a < rss_max; a++)
			draw_sprite_stretched(recurso_sprite[a], 0, aa + (-80 + 32 * (a mod 5)) * zoom, bb + (40 + 28 * floor(a / 5)) * zoom, 32 * zoom, 28 * zoom)
	if in(var_edificio_nombre, "Líquido Infinito"){
		draw_text(aa - 80 * zoom, bb + 20 * zoom, "Ningún líquido")
		for(var a = 0; a < lq_max; a++)
			draw_text(aa - 80 * zoom, bb + 20 * (1 + a + zoom), liquido_nombre[a])
	}
	if mouse_x > aa - 80 * zoom and mouse_y > bb + 20 * zoom and mouse_x < aa + 80 * zoom{
		if in(var_edificio_nombre, "Selector", "Overflow") and mouse_y < bb + 40 * zoom{
			flag = false
			if mouse_check_button_pressed(mb_left){
				mouse_clear(mb_left)
				show_menu = false
				show_menu_build.mode = not show_menu_build.mode
			}
		}
		else if in(var_edificio_nombre, "Selector") and mouse_y < bb + (40 + 28 * ceil(rss_max / 5)) * zoom{
			flag = false
			var a = floor((mouse_x - (aa - 80 * zoom)) / (32 * zoom)) + 5 * floor((mouse_y - (bb + 40 * zoom)) / (28 * zoom))
			if a >= 0 and a < rss_max{
				draw_set_color(c_gray)
				draw_rectangle(mouse_x, mouse_y, mouse_x + string_width(recurso_nombre[a]), mouse_y + string_height(recurso_nombre[a]), false)
				draw_set_color(c_white)
				draw_text(mouse_x, mouse_y, recurso_nombre[a])
				if mouse_check_button_pressed(mb_left){
					mouse_clear(mb_left)
					show_menu = false
					show_menu_build.select = a
				}
			}
		}
		else if in(var_edificio_nombre, "Líquido Infinito") and mouse_y < bb + (40 + 20 * lq_max) * zoom{
			if mouse_check_button_pressed(mb_left){
				mouse_clear(mb_left)
				show_menu = false
				var a = floor((mouse_y - (bb + 20 * (1 + zoom))) / (20 * zoom))
				if show_menu_build.select >= 0 and a = -1{
					show_menu_build.flujo.generacion -= 999999
					show_menu_build.flujo.cantidad = 0
				}
				show_menu_build.select = a
				if show_menu_build.select >= 0 and show_menu_build.flujo.liquido = -1
					show_menu_build.flujo.generacion += 999999
				show_menu_build.flujo.liquido = show_menu_build.select
			}
		}
	}
}
//Terreno bajo el mouse
var temp_hexagono = instance_position(xmouse, ymouse, obj_hexagono), mx = 0, my = 0
if temp_hexagono != noone{
	mx = temp_hexagono.a
	my = temp_hexagono.b
	prev_change = false
	if mx != prev_x or my != prev_y{
		prev_x = mx
		prev_y = my
		prev_change = true
	}
}
var temp_terreno = terreno[mx, my], temp_edificio = temp_terreno.edificio, temp_coordenada = temp_edificio.coordenadas
//Mostrar detalles de edificios al pasar el mouse_por encima
if temp_hexagono != noone and flag{
	//Mostrar terreno
	var temp_text = $"{mx}, {my}\n"
	temp_text += $"{terreno_nombre[temp_terreno.terreno]}\n"
	if temp_terreno.ore >= 0
		temp_text += $"{recurso_nombre[ore_recurso[temp_terreno.ore]]}: {temp_terreno.ore_amount}\n"
	temp_text += "___________________\n"
	if temp_terreno.edificio_bool{
		var index = temp_edificio.index, var_edificio_nombre = edificio_nombre[index]
		//Seleccionar edificios
		if mouse_check_button_pressed(mb_left) and build_index = 0{
			mouse_clear(mb_left)
			if in(var_edificio_nombre, "Selector", "Overflow", "Líquido Infinito"){
				show_menu = true
				show_menu_build = temp_edificio
				show_menu_x = temp_edificio.x * zoom
				show_menu_y = temp_edificio.y * zoom
			}
		}
		temp_text += $"{var_edificio_nombre}\n"
		if info{
			//Mostrar inputs
			draw_set_color(c_blue)
			for(var a = 0; a < ds_list_size(temp_edificio.inputs); a++){
				var temp_edificio_2 = temp_edificio.inputs[|a]
				draw_arrow_off(temp_edificio_2.x, temp_edificio_2.y, temp_edificio.x, temp_edificio.y, 12)
			}
			//Mostrar outputs
			draw_set_color(c_red)
			for(var a = 0; a < ds_list_size(temp_edificio.outputs); a++){
				var temp_edificio_2 = temp_edificio.outputs[|a]
				draw_arrow_off(temp_edificio.x, temp_edificio.y, temp_edificio_2.x, temp_edificio_2.y, 12)
			}
		}
		//Mostrar carga
		if temp_edificio.carga_total > 0{
			temp_text += "Almacen:\n"
			for(var a = 0; a < rss_max; a++)
				if temp_edificio.carga[a] > 0
					temp_text += $"  {recurso_nombre[a]}: {temp_edificio.carga[a]}\n"
			if info and temp_edificio.carga_total > 0
				temp_text += $"    Total: {temp_edificio.carga_total}\n"
		}
		//Mostrar recursos subterraneos
		if in(var_edificio_nombre, "Taladro", "Taladro Eléctrico")
			if temp_edificio.idle
				temp_text += "Sin recursos\n"
			else{
				var temp_array = [0], temp_text_2 = ""
				for(var a = 0; a < rss_max; a++)
					temp_array[a] = 0
				for(var a = 0; a < ds_list_size(temp_edificio.coordenadas); a++){
					var temp_complex = temp_edificio.coordenadas[|a]
					var temp_terreno_2 = terreno[temp_complex.a, temp_complex.b]
					if temp_terreno_2.ore >= 0
						temp_array[ore_recurso[temp_terreno_2.ore]] += temp_terreno_2.ore_amount
					else if terreno_recurso_bool[temp_terreno_2.terreno] and in(var_edificio_nombre, "Taladro Eléctrico")
						temp_array[terreno_recurso_id[temp_terreno_2.terreno]] = -1
				}
				for(var a = 0; a < rss_max; a++)
					if temp_array[a] > 0
						temp_text_2 += $"  {recurso_nombre[a]}: {temp_array[a]}\n"
					else if temp_array[a] = -1
						temp_text_2 += $"  {recurso_nombre[a]}\n"
				if temp_text_2 != ""
					temp_text += $"Recursos disponibles:\n{temp_text_2}"
			}
		//Mostrar combustión
		if in(var_edificio_nombre, "Horno", "Generador")
			temp_text += $"Combustion: {floor(temp_edificio.fuel / 30)} s\n"
		//Mostrar rango de cables
		if in(var_edificio_nombre, "Cable"){
			draw_set_color(c_white)
			draw_circle_off(temp_edificio.x, temp_edificio.y, 90, true)
		}
		//Mostrar rango de torres
		if in(var_edificio_nombre, "Torre", "Láser", "Rifle"){
			if var_edificio_nombre = "Torre"
				var alc = 180
			else if var_edificio_nombre = "Láser"
				alc = 120
			else if var_edificio_nombre = "Rifle"
				alc = 300
			draw_set_color(c_white)
			draw_circle_off(temp_edificio.x, temp_edificio.y, alc, true)
			if not ds_list_empty(enemigos) and temp_edificio.target != null_enemigo{
				if distance(temp_edificio.x, temp_edificio.y, temp_edificio.target.a, temp_edificio.target.b) > alc
					var color = c_white
				else
					color = c_red
				draw_sprite_off(spr_target, 0, temp_edificio.target.a, temp_edificio.target.b,,,, color)
			}
		}
		//Mostrar inputs
		if info and edificio_receptor[index]{
			if edificio_input_all[index]
				temp_text += "Acepta todo\n"
			else{
				var temp_text_2 = ""
				for(var a = 0; a < rss_max; a++)
					if temp_edificio.carga_max[a] > 0
						temp_text_2 += $"  {recurso_nombre[a]}: {temp_edificio.carga_max[a]}\n"
				if temp_text_2 != ""
					temp_text += "Acepta:\n" + temp_text_2
			}
		}
		//Mostrar outputs
		if info and edificio_emisor[index]{
			if edificio_output_all[index]
				temp_text += "Entrega todo\n"
			else{
				var temp_text_2 = ""
				for(var a = 0; a < rss_max; a++)
					if temp_edificio.carga_output[a]
						temp_text_2 += $"  {recurso_nombre[a]}\n"
				if temp_text_2 != ""
					temp_text += $"Entrega:\n{temp_text_2}"
			}
		}
		//Mostrar red electrica
		if edificio_electricidad[index]{
			var temp_red = temp_edificio.red
			if edificio_elec_consumo[index] > 0 and temp_red.consumo > temp_red.generacion and temp_red.bateria = 0
				temp_text += $"Funcionando al {floor(100 * temp_red.generacion / temp_red.consumo)}% de su capacidad\n"
			temp_text += $"Red {ds_list_find_index(redes, temp_red)}\n"
			temp_text += $"  Consumo: {temp_red.consumo}\n"
			temp_text += $"  Generacion: {temp_red.generacion}\n"
			temp_text += $"  Batería: {floor(temp_red.bateria)}/{temp_red.bateria_max}\n"
			if info{
				temp_text += "  Edificios:\n"
				for(var a = 0; a < ds_list_size(temp_red.edificios); a++){
					var temp_edificio_2 = temp_red.edificios[|a]
					temp_text += $"    {edificio_nombre[temp_edificio_2.index]}\n"
				}
			}
			for(var a = 0; a < ds_list_size(temp_edificio.energy_link); a++){
				var temp_edificio_2 = temp_edificio.energy_link[|a]
				draw_set_color(c_red)
				var temp_complex_2 = abtoxy(temp_edificio.a, temp_edificio.b)
				var temp_complex_3 = abtoxy(temp_edificio_2.a, temp_edificio_2.b)
				draw_line_off(temp_complex_2.a, temp_complex_2.b, temp_complex_3.a, temp_complex_3.b)
			}
		}
		//Mostrar red de líquido
		if edificio_flujo[index]{
			var temp_flujo = temp_edificio.flujo
			temp_text += $"Tubería {ds_list_find_index(flujos, temp_flujo)}:\n"
			if temp_flujo.liquido = -1
				temp_text += "  Sin liquidos\n"
			else
				temp_text += $"  {liquido_nombre[temp_flujo.liquido]}\n"
			if info{
				temp_text += $"  Generacion: {temp_flujo.generacion}\n"
				temp_text += $"  Consumo: {temp_flujo.consumo}\n"
				temp_text += $"  Almacenado: {floor(temp_flujo.cantidad)}/{temp_flujo.cantidad_max}\n"
				temp_text += "  Edificios:\n"
				for(var a = 0; a < ds_list_size(temp_flujo.edificios); a++){
					var temp_edificio_2 = temp_flujo.edificios[|a]
					temp_text += $"    {edificio_nombre[temp_edificio_2.index]}\n"
				}
			}
		}
		if info and edificio_proceso[index] > 1
			temp_text += $"Proceso: {floor(temp_edificio.proceso)}/{edificio_proceso[index]}\n"
		temp_text += "___________________\n"
	}
	draw_text_background(0, 0, temp_text)
}
flag = false
#region Menú de edificios
	var just_pressed = false
	if mouse_check_button_pressed(mb_right) and build_index = 0 and not temp_terreno.edificio_bool{
		mouse_clear(mb_right)
		if build_menu = 0{
			build_menu = 1
			menu_x = mouse_x
			menu_y = mouse_y
		}
		else if build_menu = 1
			build_menu = 0
		else
			build_menu = 1
	}
	if build_menu = 1{
		menu_array = [2, 1, 12, 14, 19]
		var b = 2 * pi / array_length(menu_array)
		draw_set_color(c_white)
		draw_circle(menu_x, menu_y, 100, true)
		draw_circle(menu_x, menu_y, 10, false)
		for(var a = 0; a < array_length(menu_array); a++){
			var angle = a * b
			draw_sprite_stretched(edificio_sprite[menu_array[a]], 0, menu_x - 15 + 100 * cos(angle + b / 2), menu_y - 15 - 100 * sin(angle + b / 2), 30, 30)
			draw_line(menu_x, menu_y, menu_x + 100 * cos(angle), menu_y - 100 * sin(angle))
		}
		if distance(mouse_x, mouse_y, menu_x, menu_y) < 100{
			var temp_text = ""
			b = floor((array_length(menu_array) - arctan2(mouse_y - menu_y, mouse_x - menu_x) / b) mod array_length(menu_array))
			if b = 0
				temp_text = "Transporte"
			else if b = 1
				temp_text = "Producción"
			else if b = 2
				temp_text = "Electricidad"
			else if b = 3
				temp_text = "Fluidos"
			else if b = 4
				temp_text = "Defensa"
			draw_text_background(mouse_x + 20, mouse_y, temp_text)
			if mouse_check_button_pressed(mb_left){
				mouse_clear(mb_left)
				build_menu = 2
				if b = 0 //Transporte
					menu_array = [2, 3, 4, 5, 6, 18]
				else if b = 1 //Producción
					menu_array = [1, 7, 8, 9, 22, 24]
				else if b = 2 //Electricidad
					menu_array = [10, 11, 12, 13]
				else if b = 3 //Fluidos
					menu_array = [14, 15, 23, 26]
				else if b = 4 //Defensa
					menu_array = [19, 20, 21, 25]
			}
		}
		else if mouse_check_button_pressed(mb_left){
			mouse_clear(mb_left)
			build_menu = 0
		}
	}
	else if build_menu = 2{
		var b = 2 * pi / array_length(menu_array)
		draw_set_color(c_white)
		draw_circle(menu_x, menu_y, 100, true)
		draw_circle(menu_x, menu_y, 10, false)
		for(var a = 0; a < array_length(menu_array); a++){
			var angle = a * b
			draw_sprite_stretched(edificio_sprite[menu_array[a]], 0, menu_x - 15 + 100 * cos(angle + b / 2), menu_y - 15 - 100 * sin(angle + b / 2), 30, 30)
			draw_line(menu_x, menu_y, menu_x + 100 * cos(angle), menu_y - 100 * sin(angle))
		}
		if distance(mouse_x, mouse_y, menu_x, menu_y) < 100{
			b = menu_array[floor((array_length(menu_array) - arctan2(mouse_y - menu_y, mouse_x - menu_x) / b) mod array_length(menu_array))]
			var temp_text = $"{edificio_nombre[b]}\n"
			for(var c = 0; c < array_length(edificio_precio_id[b]); c++)
				temp_text += $"  {recurso_nombre[edificio_precio_id[b, c]]}: {edificio_precio_num[b, c]}\n"
			draw_text_background(mouse_x, mouse_y + 20, temp_text)
			if mouse_check_button_pressed(mb_left){
				mouse_clear(mb_left)
				build_index = b
				build_menu = 0
				flag = true
				just_pressed = true
			}
		}
		else if mouse_check_button_pressed(mb_left){
			mouse_clear(mb_left)
			build_menu = 1
		}
	}
#endregion
//Acceso directo
if keyboard_check_pressed(vk_anykey) and (not in(keyboard_lastkey, ord("M"), ord("N")) or cheat)
	for(var a = 1; a < edificio_max; a++)
		if real(keyboard_lastkey) = edificio_key[a]{
			keyboard_clear(keyboard_lastkey)
			build_index = a
			flag = true
		}
//Cancelar construcción o cerrar menú del selector
if (mouse_check_button_pressed(mb_right) or keyboard_check_pressed(vk_escape)) and (build_index > 0 or show_menu){
	mouse_clear(mb_right)
	build_index = 0
	show_menu = false
}
//Vista previa y construcción
if build_index > 0{
	var var_edificio_nombre = edificio_nombre[build_index]
	if flag and not edificio_rotable[build_index]
		build_dir = 0
	if flag and edificio_size[build_index] mod 2 = 0
		build_dir = 5 * (build_dir mod 2)
	//Rotar
	if edificio_rotable[build_index] and not keyboard_check(vk_lcontrol){
		if mouse_wheel_up(){
			if edificio_size[build_index] mod 2 = 0
				build_dir = 5 - build_dir
			else
				build_dir = (build_dir + 1) mod 6
			flag = true
		}
		if mouse_wheel_down(){
			if edificio_size[build_index] mod 2 = 0
				build_dir = 5 - build_dir
			else
				build_dir = build_dir - 1 + 6 * (build_dir = 0)
			flag = true
		}
	}
	if last_mx != mx or last_my != my or flag{
		build_list = get_size(mx, my, build_dir, edificio_size[build_index])
		show_menu = false
	}
	last_mx = mx
	last_my = my
	var comprable = true
	if not cheat{
		for(var a = 0; a < array_length(edificio_precio_id[build_index]); a++)
			if nucleo.carga[edificio_precio_id[build_index, a]] < edificio_precio_num[build_index, a]{
				comprable = false
				break
			}
		for(var a = 0; a < ds_list_size(enemigos); a++){
			var enemigo = enemigos[|a]
			draw_set_color(c_red)
			draw_circle(enemigo.a, enemigo.b, 100, true)
		}
	}
	if temp_hexagono != noone{
		var temp_array, temp_array_2, temp_text = ""
		if not comprable{
			temp_text += "Recursos insuficientes\n"
			for(var a = 0; a < array_length(edificio_precio_id[build_index]); a++)
				if nucleo.carga[edificio_precio_id[build_index, a]] < edificio_precio_num[build_index, a]
					temp_text += $"  {recurso_nombre[edificio_precio_id[build_index, a]]} {nucleo.carga[edificio_precio_id[build_index, a]]}/{edificio_precio_num[build_index, a]}\n"
			for(var a = 0; a < ds_list_size(build_list); a++){
				var temp_complex_2 = build_list[|a]
				var temp_complex_3 = abtoxy(temp_complex_2.a, temp_complex_2.b)
				draw_sprite_off(spr_rojo, 0, temp_complex_3.a, temp_complex_3.b,,,,, 0.5)
			}
		}
		flag = true
		//Vista previa caminos
		if edificio_camino[build_index] or var_edificio_nombre = "Tubería"{
			//Iniciar arrastre
			if mouse_check_button_pressed(mb_left){
				mx_clic = mx
				my_clic = my
				clicked = true
			}
			//Arrastre
			if mouse_check_button(mb_left){
				ds_list_clear(pre_build_list)
				var temp_complex_2 = abtoxy(mx_clic, my_clic), aa = temp_complex_2.a, bb = temp_complex_2.b
				if in(var_edificio_nombre, "Tubería")
					draw_sprite_off(edificio_sprite[build_index], 0, aa, bb,,,,, 0.5)
				else if not in(var_edificio_nombre, "Cinta Transportadora", "Enrutador", "Cinta Magnética")
					draw_sprite_off(edificio_sprite[build_index], 0, aa, bb,,, (build_dir - 1) * 60,, 0.5)
				else{
					if (build_dir mod 3) = 1
						draw_sprite_off(edificio_sprite[build_index], image_index / 4, aa, bb,, power(-1, build_dir > 1),,, 0.5)
					else
						draw_sprite_off(edificio_sprite_2[build_index], image_index / 4, aa, bb, power(-1, ((build_dir + 1) mod 6) > 1), power(-1, build_dir > 2),,, 0.5)
				}
				ds_list_add(pre_build_list, {a : mx_clic, b : my_clic})
				if mx_clic != mx or my_clic != my{
					var angle = radtodeg((arctan2(bb * zoom - camy - mouse_y, mouse_x - aa * zoom + camx) + 2 * pi) mod (2 * pi))
					build_dir = floor(angle / 60)
					var a = mx_clic, b = my_clic, temp_complex_3
					do{
						temp_complex_3 = next_to(a, b, build_dir)
						ds_list_add(pre_build_list, temp_complex_3)
						a = temp_complex_3.a
						b = temp_complex_3.b
						temp_complex_3 = abtoxy(a, b)
						var aaa = temp_complex_3.a, bbb = temp_complex_3.b
						if in(var_edificio_nombre, "Tubería")
							draw_sprite_off(edificio_sprite[build_index], 0, aaa, bbb,,,,, 0.5)
						else if not in(var_edificio_nombre, "Cinta Transportadora", "Enrutador")
							draw_sprite_off(edificio_sprite[build_index], 0, aaa, bbb,,, (build_dir - 1) * 60,, 0.5)
						else{
							if (build_dir mod 3) = 1
								draw_sprite_off(edificio_sprite[build_index], image_index / 4, aaa, bbb,, power(-1, build_dir > 1),,, 0.5)
							else
								draw_sprite_off(edificio_sprite_2[build_index], image_index / 4, aaa, bbb, power(-1, ((build_dir + 1) mod 6) > 1), power(-1, build_dir > 2),,, 0.5)
						}
					}
					until(temp_complex_3.a < min(xmouse, aa) or
						temp_complex_3.a > max(xmouse, aa) or
						temp_complex_3.b < min(ymouse, bb) or
						temp_complex_3.b > max(ymouse, bb))
				}
			}
			//Mostrar caminos solos
			else{
				var temp_complex = next_to(mx, my, build_dir)
				var temp_complex_2 = abtoxy(mx, my), aa = temp_complex_2.a, bb = temp_complex_2.b
				var temp_complex_3 = abtoxy(temp_complex.a, temp_complex.b)
				if not in(var_edificio_nombre, "Tubería"){
					draw_set_color(c_black)
					draw_arrow_off(aa, bb, temp_complex_3.a, temp_complex_3.b, 8)
				}
				if not in(var_edificio_nombre, "Cinta Transportadora", "Cinta Magnética", "Tubería"){
					draw_sprite_off(edificio_sprite[build_index], 0, aa, bb,,, (build_dir - 1) * 60,, 0.5)
					temp_complex = next_to(mx, my, (build_dir + 1) mod 6)
					temp_complex_3 = abtoxy(temp_complex.a, temp_complex.b)
					draw_arrow_off(aa, bb, temp_complex_3.a, temp_complex_3.b, 8)
					temp_complex = next_to(mx, my, (build_dir + 5) mod 6)
					temp_complex_3 = abtoxy(temp_complex.a, temp_complex.b)
					draw_arrow_off(aa, bb, temp_complex_3.a, temp_complex_3.b, 8)
				}
				else{
					if in(var_edificio_nombre, "Tubería")
						draw_sprite_off(edificio_sprite[build_index], 0, aa, bb,,,,, 0.5)
					else if (build_dir mod 3) = 1
						draw_sprite_off(edificio_sprite[build_index], image_index / 4, aa, bb,, power(-1, build_dir > 1),,, 0.5)
					else
						draw_sprite_off(edificio_sprite_2[build_index], image_index / 4, aa, bb, power(-1, ((build_dir + 1) mod 6) > 1), power(-1, build_dir > 2),,, 0.5)
				}
			}
			//Construir en cadena
			if mouse_check_button_released(mb_left) and clicked{
				flag = false
				for(var a = 0; a < ds_list_size(pre_build_list); a++){
					comprable = true
					if not cheat
						for(var b = 0; b < array_length(edificio_precio_id[build_index]); b++)
							if nucleo.carga[edificio_precio_id[build_index, b]] < edificio_precio_num[build_index, b]{
								comprable = false
								break
							}
					if in(var_edificio_nombre, "Tubería")
						build_dir = 0
					if comprable{
						var temp_complex_2 = pre_build_list[|a]
						f1(build_index, build_dir, temp_complex_2.a, temp_complex_2.b)
					}
				}
				if not keyboard_check(vk_lshift){
					build_index = 0
					clicked = false
				}
			}
		}
		//Vista previa no caminos
		else{
			if var_edificio_nombre = "Túnel"{
				var temp_complex_2 = abtoxy(mx, my), flag_2 = false
				draw_sprite_off(edificio_sprite[build_index], 0, temp_complex_2.a, temp_complex_2.b,,, (build_dir - 1) * 60,, 0.5)
				var a = mx, b = my, c = 0
				//Evaluar si es construible
				build_able = false
				repeat(10){
					c++
					temp_complex_2 = next_to(a, b, build_dir)
					a = temp_complex_2.a
					b = temp_complex_2.b
					if a < 0 or b < 0 or a >= xsize or b >= ysize
						break
					var temp_terreno_2 = terreno[a, b]
					if temp_terreno_2.edificio_bool{
						var temp_edificio_2 = temp_terreno_2.edificio
						if edificio_nombre[temp_edificio_2.index] = "Túnel" and temp_edificio_2.dir = (build_dir + 3) mod 6{
							build_target = temp_edificio_2
							build_able = true
							break
						}
					}
				}
				//Dibujar vista previa
				if build_able{
					a = mx
					b = my
					repeat(c - 1){
						temp_complex_2 = next_to(a, b, build_dir)
						a = temp_complex_2.a
						b = temp_complex_2.b
						temp_complex_2 = abtoxy(a, b)
						draw_sprite_off(spr_tunel_view, 0, temp_complex_2.a, temp_complex_2.b,,, (build_dir - 1) * 60,, 0.5)
					}
				}
			}
			else{
				var temp_complex_2 = abtoxy(mx, my)
				if edificio_size[build_index] mod 2 = 0
					draw_sprite_off(edificio_sprite[build_index], 0, temp_complex_2.a, temp_complex_2.b, power(-1, build_dir),,,, 0.5)
				else
					draw_sprite_off(edificio_sprite[build_index], 0, temp_complex_2.a, temp_complex_2.b,,, build_dir * 60,, 0.5)
				//Visión previa taladro
				if in(var_edificio_nombre, "Taladro", "Taladro Eléctrico"){
					for(var a = 0; a < rss_max; a++){
						temp_array[a] = 0
						temp_array_2[a] = 0
					}
					var b = 0
					for(var a = 0; a < ds_list_size(build_list); a++){
						var temp_complex_3 = build_list[|a]
						var aa = temp_complex_3.a, bb = temp_complex_3.b
						if aa >= 0 and bb >= 0 and aa < xsize and bb < ysize{
							var temp_terreno_2 = terreno[aa, bb]
							if temp_terreno_2.ore >= 0{
								temp_array[ore_recurso[temp_terreno_2.ore]]++
								temp_array_2[ore_recurso[temp_terreno_2.ore]] += temp_terreno_2.ore_amount
								b++
							}
							else if terreno_recurso_bool[temp_terreno_2.terreno] and in(var_edificio_nombre, "Taladro Eléctrico"){
								temp_array[terreno_recurso_id[temp_terreno_2.terreno]]++
								temp_array_2[terreno_recurso_id[temp_terreno_2.terreno]] = -1
								b++
							}
						}
					}
					var flag_2 = false
					for(var a = 0; a < rss_max; a++){
						if temp_array_2[a] > 0{
							flag_2 = true
							temp_text += $"{recurso_nombre[a]}: {temp_array_2[a]}({round(temp_array[a] * 100 / b)}%)\n"
						}
						else if temp_array_2[a] = -1{
							flag_2 = true
							temp_text += $"{recurso_nombre[a]}({round(temp_array[a] * 100 / b)}%)\n"
						}
					}
					for(var a = 0; a < ds_list_size(build_list); a++){
						temp_complex_2 = build_list[|a]
						var aa = temp_complex_2.a, bb = temp_complex_2.b
						if aa >= 0 and aa < xsize and bb >= 0 and bb < ysize and in(terreno_nombre[terreno[aa, bb].terreno], "Agua", "Agua Profunda"){
							flag_2 = false
							break
						}
					}
					if not flag_2
						temp_text += "Terreno invalido"
				}
				if in(var_edificio_nombre, "Bomba Hidráulica"){
					var flag_2 = true
					for(var a = 0; a < ds_list_size(build_list); a++){
						var temp_complex_3 = build_list[|a]
						var aa = temp_complex_3.a, bb = temp_complex_3.b
						if aa >= 0 and bb >= 0 and aa < xsize and bb < ysize{
							var temp_terreno_2 = terreno[aa, bb]
							if not in(terreno_nombre[temp_terreno_2.terreno], "Agua", "Agua Profunda"){
								flag_2 = false
								break
							}
						}
					}
					if not flag_2
						temp_text += "Debe ser construido sobre agua"
				}
				//Vista previa Cables
				if in(var_edificio_nombre, "Cable")
					draw_circle_off(temp_complex_2.a, temp_complex_2.b, 90, true)
				//Vista previa Alcance de torres
				if in(var_edificio_nombre, "Torre", "Láser", "Rifle"){
					if var_edificio_nombre = "Torre"
						var alc = 180
					else if var_edificio_nombre = "Láser"
						alc = 120
					else if var_edificio_nombre = "Rifle"
						alc = 300
					draw_circle_off(temp_complex_2.a, temp_complex_2.b, alc, true)
				}
			}
			if mouse_check_button_pressed(mb_left) and flag and comprable and (not temp_terreno.edificio_bool or ((var_edificio_nombre = "Túnel") and edificio_camino[temp_terreno.edificio.index])){
				f1(build_index, build_dir, mx, my)
				if not keyboard_check(vk_lshift)
					build_index = 0
			}
		}
		draw_text_background(mouse_x + 20, mouse_y, temp_text)
		//Construir
		function f1(build_index, build_dir, mx, my){
			var flag = true, flag_2 = false, build_list = get_size(mx, my, build_dir, edificio_size[build_index]), temp_edificio, var_edificio_nombre = edificio_nombre[build_index], temp_complex = abtoxy(mx, my)
			for(var a = 0; a < ds_list_size(build_list); a++){
				var temp_complex_2 = build_list[|a], aa = temp_complex_2.a, bb = temp_complex_2.b
				//Asegurarse de que esté dentro del mundo
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize{
					flag = false
					break
				}
				var temp_terreno = terreno[aa, bb]
				//Checkear coliciones
				if temp_terreno.edificio_bool and not ((edificio_camino[build_index] or (var_edificio_nombre = "Túnel")) and edificio_camino[temp_terreno.edificio.index]){
					flag = false
					break
				}
				//Checkear agua
				if not in(var_edificio_nombre, "Bomba Hidráulica", "Tubería") and in(terreno_nombre[temp_terreno.terreno], "Agua", "Agua Profunda"){
					flag = false
					break
				}
				//Reemplazar caminos
				if temp_terreno.edificio_bool and (edificio_camino[build_index] or (var_edificio_nombre = "Túnel")) and edificio_camino[temp_terreno.edificio.index]
					delete_edificio(aa, bb)
				//Checkear minerales
				if in(var_edificio_nombre, "Taladro", "Taladro Eléctrico") and temp_terreno.ore >= 0
					flag_2 = true
				//Checkear minerales
				if in(var_edificio_nombre, "Taladro Eléctrico") and terreno_recurso_bool[temp_terreno.terreno]
					flag_2 = true
				//Checkear agua
				if in(var_edificio_nombre, "Bomba Hidráulica") and not in(terreno_nombre[temp_terreno.terreno], "Agua", "Agua Profunda")
					flag = false
			}
			//Detectar enemigos cerca
			if flag
				for(var a = 0; a < ds_list_size(enemigos); a++){
					var enemigo = enemigos[|a]
					if sqrt(sqr(enemigo.a - temp_complex.a) + sqr(enemigo.b - temp_complex.b)) < 100{
						flag = false
						break
					}
				}
			if flag and in(var_edificio_nombre, "Taladro", "Taladro Eléctrico") and not flag_2
				flag = false
			if flag and var_edificio_nombre = "Túnel" and build_able and build_target.index = 6
				build_index = 16
			if flag
				temp_edificio = add_edificio(build_index, build_dir, mx, my)
			//Algoritmo link de tuneles
			if var_edificio_nombre = "Túnel"{
				temp_edificio.idle = not build_able
				if build_able{
					if not build_target.idle{
						build_target.link.idle = true
						ds_list_remove(build_target.outputs, build_target.link)
						ds_list_remove(build_target.link.inputs, build_target)
					}
					build_target.idle = false
					if build_index = 16{
						ds_list_add(temp_edificio.inputs, build_target)
						ds_list_add(build_target.outputs, temp_edificio)
					}
					else{
						ds_list_add(temp_edificio.outputs, build_target)
						ds_list_add(build_target.inputs, temp_edificio)
					}
					temp_edificio.link = build_target
					build_target.link = temp_edificio
					if build_target.waiting
						mover(build_target.a, build_target.b)
				}
			}
			//Actualizar recursos
			if not cheat
				for(var a = 0; a < array_length(edificio_precio_id[build_index]); a++){
					nucleo.carga[edificio_precio_id[build_index, a]] -= edificio_precio_num[build_index, a]
					nucleo.carga_total -= edificio_precio_num[build_index, a]
				}
		}
	}
}
else
//Destruir edificio
if ((mouse_check_button(mb_right) and prev_change) or mouse_check_button_pressed(mb_right)) and temp_hexagono != noone and temp_terreno.edificio_bool and temp_edificio.index != 0{
	mouse_clear(mb_right)
	delete_edificio(mx, my)
}
//Ciclo edificios
for(var a = 0; a < ds_list_size(edificios); a++){
	var edificio = edificios[|a]
	if not edificio.idle{
		var index = edificio.index, var_edificio_nombre = edificio_nombre[index]
		//Accion taladro
		if in(var_edificio_nombre, "Taladro", "Taladro Eléctrico") and edificio.carga_total < edificio_carga_max[index]{
			if edificio_electricidad[index]{
				if edificio.proceso < 0{
					edificio.red.consumo += abs(edificio_elec_consumo[index])
					edificio.proceso++
				}
				var b = 1
				if edificio.flujo.liquido = 1 and edificio.flujo.cantidad >= 1{
					b = 1.6
					edificio.flujo.cantidad--
				}
				if edificio.red.generacion < edificio.red.consumo and edificio.red.bateria = 0
					edificio.proceso += b * edificio.red.generacion / edificio.red.consumo
				else
					edificio.proceso += b
			}
			else
				edificio.proceso++
			if edificio.proceso >= edificio_proceso[index]{
				edificio.proceso = -1
				var temp_list = ds_list_create(), temp_complex_2 = {a : 0, b : 0}
				flag = false
				ds_list_copy(temp_list, edificio.coordenadas)
				ds_list_shuffle(temp_list)
				while not ds_list_empty(temp_list){
					temp_complex_2 = temp_list[|0]
					temp_terreno = terreno[temp_complex_2.a, temp_complex_2.b]
					ds_list_delete(temp_list, 0)
					if temp_terreno.ore >= 0{
						edificio.carga[ore_recurso[temp_terreno.ore]]++
						edificio.carga_total++
						temp_terreno.ore_amount--
						if temp_terreno.ore_amount = 50
							background = spr_hexagono
						else if temp_terreno.ore_amount = 0{
							temp_terreno.ore = -1
							background = spr_hexagono
						}
						flag = true
						break
					}
					else if terreno_recurso_bool[temp_terreno.terreno] and in(var_edificio_nombre, "Taladro Eléctrico"){
						edificio.carga[terreno_recurso_id[temp_terreno.terreno]]++
						edificio.carga_total++
						flag = true
						break
					}
				}
				ds_list_destroy(temp_list)
				if flag
					edificio.waiting = not mover(edificio.a, edificio.b)
				else
					edificio.idle = true
				if edificio_electricidad[index]
					edificio.red.consumo -= abs(edificio_elec_consumo[index])
			}
		}
		//Accion caminos
		else if (edificio_camino[index] or var_edificio_nombre = "Túnel") and edificio.carga_total > 0 and not edificio.waiting{
			edificio.proceso++
			if edificio.proceso = edificio_proceso[index]{
				edificio.proceso = 0
				edificio.waiting = not mover(edificio.a, edificio.b)
			}
		}
		//Acción horno
		else if var_edificio_nombre = "Horno" and (edificio.carga[0] > 1 or edificio.carga[3] > 1 or edificio.carga[5] > 1) and (edificio.carga[1] > 0 or edificio.fuel > 0){
			if edificio.fuel > 0
				edificio.fuel--
			if edificio.carga[2] < 2 and edificio.carga[4] < 2 and edificio.carga[7] < 2{
				if edificio.fuel = 0 and edificio.carga[1] > 0{
					edificio.fuel = recurso_combustion_time[1]
					edificio.carga[1]--
					edificio.carga_total--
				}
				edificio.proceso++
				if edificio.proceso >= edificio_proceso[index]{
					if edificio.carga[5] > 1{
						edificio.carga[5] -= 2
						edificio.carga[7]++
						edificio.carga_total--
						edificio.proceso -= floor(edificio_proceso[index] * 2.5)
					}
					else if edificio.carga[3] > 1{
						edificio.carga[3] -= 2
						edificio.carga[4]++
						edificio.carga_total--
						edificio.proceso -= floor(edificio_proceso[index] * 1.5)
					}
					else if edificio.carga[0] > 1{
						edificio.carga[0] -= 2
						edificio.carga[2]++
						edificio.carga_total--
						edificio.proceso -= edificio_proceso[index]
					}
					edificio.waiting = not mover(edificio.a, edificio.b)
				}
			}
		}
		//Acción generador
		else if in(var_edificio_nombre, "Generador"){
			if edificio.fuel > 0
				edificio.fuel--
			if edificio.fuel = 0{
				edificio.red.generacion -= edificio.energy_output
				edificio.energy_output = 0
				if edificio.carga[1] > 0{
					edificio.energy_output = abs(edificio_elec_consumo[index])
					edificio.red.generacion += edificio.energy_output
					edificio.fuel = recurso_combustion_time[1]
					edificio.carga[1]--
					edificio.carga_total--
					mover_in(edificio)
				}
			}
		}
		//Acción de la bomba hidraulica
		else if in(var_edificio_nombre, "Bomba Hidráulica"){
			var temp_flujo = edificio.flujo
			if in(temp_flujo.liquido, -1, 0){
				temp_flujo.generacion -= edificio.proceso
				if edificio.red.generacion < edificio.red.consumo and edificio.red.bateria = 0
					edificio.proceso = 50 * edificio.red.generacion / edificio.red.consumo
				else
					edificio.proceso = 50
				temp_flujo.generacion += edificio.proceso
				temp_flujo.liquido = 0
			}
		}
		//Acción de triturador
		else if in(var_edificio_nombre, "Triturador") and edificio.carga[6] > 0{
			if edificio.proceso < 0{
				edificio.red.consumo += abs(edificio_elec_consumo[index])
				edificio.proceso++
			}
			if edificio.red.generacion < edificio.red.consumo and edificio.red.bateria = 0
				edificio.proceso += edificio.red.generacion / edificio.red.consumo
			else
				edificio.proceso++
			if edificio.proceso >= edificio_proceso[index]{
				edificio.proceso -= edificio_proceso[index] + 1
				edificio.carga[6]--
				edificio.carga[5]++
				edificio.waiting = not mover(edificio.a, edificio.b)
				edificio.red.consumo -= abs(edificio_elec_consumo[index])
			}
		}
		//Fábrica de concreto
		else if in(var_edificio_nombre, "Fábrica de Concreto"){
			flag = true
			for(var b = 0; b < array_length(edificio_input_id[index]); b++)
				if edificio.carga[edificio_input_id[index, b]] < edificio_input_num[index, b]{
					flag = false
					break
				}
			if flag and not (edificio.flujo.liquido = 0 and edificio.flujo.cantidad >= 30)
				flag = false
			if flag{
				if edificio.proceso < 0{
					edificio.red.consumo += abs(edificio_elec_consumo[index])
					edificio.proceso++
				}
				if edificio.red.generacion < edificio.red.consumo and edificio.red.bateria = 0
					edificio.proceso += edificio.red.generacion / edificio.red.consumo
				else
					edificio.proceso++
				if edificio.proceso >= edificio_proceso[index]{
					edificio.proceso -= edificio_proceso[index] + 1
					edificio.flujo.cantidad -= 30
					for(var b = 0; b < array_length(edificio_input_id[index]); b++){
						edificio.carga[edificio_input_id[index, b]] -= edificio_input_num[index, b]
						edificio.carga_total -= edificio_input_num[index, b]
					}
					for(var b = 0; b < array_length(edificio_output_id[index]); b++){
						edificio.carga[edificio_output_id[index, b]]++
						edificio.carga_total++
					}
					edificio.waiting = not mover(edificio.a, edificio.b)
					edificio.red.consumo -= abs(edificio_elec_consumo[index])
				}
			}
		}
		//Acción de torres
		else if in(var_edificio_nombre, "Torre", "Rifle"){
			edificio.proceso++
			if var_edificio_nombre = "Torre"
				var alc = 180
			else
				alc = 300
			if edificio.target != null_enemigo
				edificio.select = radtodeg(-arctan2(edificio.x - edificio.target.a, edificio.target.b - edificio.y)) - 90
			if edificio.flujo.liquido = 0 and edificio.flujo.cantidad >= 3 and edificio.target = null_enemigo and distance(edificio.x, edificio.y, edificio.target.a, edificio.target.b) < alc{
				edificio.flujo.cantidad -= 3
				edificio.proceso += 0.5
			}
			if edificio.proceso >= edificio_proceso[index]{
				edificio.proceso -= edificio_proceso[index] + 1
				edificio.target = null_enemigo
				if not ds_list_empty(enemigos)
					turret_target(edificio)
				if edificio.target != null_enemigo and ((var_edificio_nombre = "Torre" and (edificio.carga[0] > 0 or edificio.carga[3] > 0 or edificio.carga[6] > 0)) or (var_edificio_nombre = "Rifle" and (edificio.carga[2] > 0 or edificio.carga[4] > 0))) and distance(edificio.x, edificio.y, edificio.target.a, edificio.target.b) < alc{
					if edificio.carga[4] > 0{
						edificio.carga[4]--
						edificio.target.vida -= 7
					}
					else if edificio.carga[2] > 0{
						edificio.carga[2]--
						edificio.target.vida -= 5
					}
					else if edificio.carga[3] > 0{
						edificio.carga[3]--
						edificio.target.vida -= 3
					}
					else if edificio.carga[0] > 0{
						edificio.carga[0]--
						edificio.target.vida -= 2
					}
					else{
						edificio.carga[6]--
						edificio.target.vida--
					}
					edificio.carga_total--
					mover_in(edificio)
					if edificio.target.vida <= 0{
						ds_list_remove(enemigos, edificio.target)
						edificio.target = null_enemigo
						turret_target(edificio)
					}
				}
			}
		}
		else if in(var_edificio_nombre, "Láser"){
			edificio.target = null_enemigo
			if not ds_list_empty(enemigos)
				turret_target(edificio)
			if edificio.target != null_enemigo and distance(edificio.x, edificio.y, edificio.target.a, edificio.target.b) < 120{
				if not edificio.mode
					edificio.red.consumo += abs(edificio_elec_consumo[index])
				edificio.mode = true
				if edificio.red.generacion < edificio.red.consumo and edificio.red.bateria = 0{
					edificio.target.vida -= 0.03 * edificio.red.generacion / edificio.red.consumo
					draw_set_alpha(edificio.red.generacion / edificio.red.consumo)
				}
				else
					edificio.target.vida -= 0.03
				draw_set_color(c_red)
				draw_arrow_off(edificio.x, edificio.y, edificio.target.a, edificio.target.b, 2)
				draw_set_alpha(1)
				if edificio.target.vida <= 0{
					ds_list_remove(enemigos, edificio.target)
					edificio.target = null_enemigo
					turret_target(edificio)
				}
			}
			else{
				if edificio.mode
					edificio.red.consumo -= abs(edificio_elec_consumo[index])
				edificio.mode = false
			}
		}
		//Planta química
		else if in(var_edificio_nombre, "Planta Química"){
			if edificio.select > 0{
				edificio.select--
				if edificio.select = 0
					edificio.flujo.generacion -= 30
			}
			if edificio.carga[5] > 1 and edificio.carga[7] > 1 and (edificio.carga[1] > 0 or edificio.fuel > 0){
				if edificio.fuel > 0
					edificio.fuel--
				if in(edificio.flujo.liquido, -1, 1) and edificio.flujo.cantidad < edificio.flujo.cantidad_max{
					if edificio.fuel = 0 and edificio.carga[1] > 0{
						edificio.fuel = recurso_combustion_time[1]
						edificio.carga[1]--
						edificio.carga_total--
					}
					edificio.proceso++
					if edificio.proceso >= edificio_proceso[index]{
						edificio.carga[5] -= 2
						edificio.carga[7] -= 2
						edificio.carga_total -= 4
						edificio.proceso -= edificio_proceso[index]
						edificio.flujo.liquido = 1
						edificio.select = 30
						edificio.flujo.generacion += 30
						edificio.flujo.cantidad = min(edificio.flujo.cantidad + 30, edificio.flujo.cantidad_max)
						edificio.waiting = not mover(edificio.a, edificio.b)
					}
				}
			}
		}
		//Fábrica de explosivos
		else if var_edificio_nombre = "Fábrica de Explosivos" and edificio.carga[1] > 0 and edificio.carga[6] > 0 and edificio.flujo.liquido = 1 and edificio.flujo.cantidad >= 30{
			if edificio.proceso < 0{
				edificio.red.consumo += abs(edificio_elec_consumo[index])
				edificio.proceso++
			}
			if edificio.red.generacion < edificio.red.consumo and edificio.red.bateria = 0
				edificio.proceso += edificio.red.generacion / edificio.red.consumo
			else
				edificio.proceso++
			if edificio.proceso >= edificio_proceso[index]{
				edificio.proceso -= edificio_proceso[index] + 1
				edificio.carga[1]--
				edificio.carga[6]--
				edificio.carga[9]++
				edificio.carga_total--
				edificio.flujo.cantidad -= 30
				edificio.waiting = not mover(edificio.a, edificio.b)
				edificio.red.consumo -= abs(edificio_elec_consumo[index])
			}
		}
	}
}
//Ciclo de los enemigos
for(var a = 0; a < ds_list_size(enemigos); a++){
	var enemigo = enemigos[|a], aa = enemigo.a, bb = enemigo.b
	draw_sprite_off(spr_enemigo, 0, aa, bb)
	if enemigo.vida < enemigo.vida_max{
		draw_set_color(make_color_hsv(120 * enemigo.vida / enemigo.vida_max, 255, 255))
		draw_circle_off(aa, bb - 20, 5, false)
		draw_set_color(c_white)
	}
	if enemigo.target.vida <= 0
		enemigo.target = null_edificio
	if not ds_list_empty(edificios) and enemigo.target = null_edificio
		path_find(enemigo)
	var edificio = enemigo.target, dis = distance(aa, bb, edificio.x, edificio.y)
	if dis > 50{
		enemigo.a += (edificio.x - aa) / dis
		enemigo.b += (edificio.y - bb) / dis
	}
	else{
		edificio.vida--
		if edificio.vida <= 0{
			delete_edificio(edificio.a, edificio.b, true)
			enemigo.target = null_edificio
			path_find(enemigo)
		}
	}
}
#region Generación de enemigos
	if image_index > 9000 or keyboard_check_pressed(vk_space){
		if image_index mod 900 = 0 or keyboard_check_pressed(vk_space){
			var a = irandom(array_length(borde_mapa) - 1), temp_complex = abtoxy(borde_mapa[a, 0], borde_mapa[a, 1]), b = 5 + floor(sqr((image_index - 9000) / 4500))
			var enemigo = {
				a : temp_complex.a,
				b : temp_complex.b,
				vida_max : b,
				vida : b,
				target : null_edificio
			}
			path_find(enemigo)
			ds_list_add(enemigos, enemigo)
		}
	}
	var temp_text_right = ""
	if image_index < 9000
		temp_text_right += $"{floor((9000 - image_index) / 60)} segundos para los enemigos\n"
	if build_index > 0
		temp_text_right += $"{edificio_nombre[build_index]}\n"
	if temp_text_right != ""{
		temp_text_right = string_trim(temp_text_right)
		draw_set_halign(fa_right)
		draw_text_background(room_width, 0, temp_text_right)
		draw_set_halign(fa_left)
	}
#endregion
//Ciclo de redes
for(var a = 0; a < ds_list_size(redes); a++){
	var temp_red = redes[|a]
	temp_red.bateria = clamp(temp_red.bateria + (temp_red.generacion - temp_red.consumo) / 30, 0, temp_red.bateria_max)
}
//Ciclo flujos
for(var a = 0; a < ds_list_size(flujos); a++){
	var temp_flujo = flujos[|a]
	temp_flujo.cantidad = clamp(temp_flujo.cantidad + (temp_flujo.generacion - temp_flujo.consumo) / 30, 0, temp_flujo.cantidad_max)
	if temp_flujo.cantidad = 0
		temp_flujo.liquido = -1
}
#region INPUT
	if keyboard_check_pressed(ord("P"))
		game_restart()
	if keyboard_check_pressed(ord("I"))
		info = not info
	//Mostrar redes electricas
	if keyboard_check(ord("L")){
		var temp_text = ""
		for(var a = 0; a < ds_list_size(redes); a++){
			draw_set_color(make_color_hsv(a * 40, 255, 255))
			var temp_red = redes[|a]
			temp_text += $"Red {a}:\n"
			temp_text += $"  Consumo: {temp_red.consumo}\n"
			temp_text += $"  Generacion: {temp_red.generacion}\n"
			temp_text += $"  Batería: {floor(temp_red.bateria)}/{temp_red.bateria_max}\n"
			temp_text += "  Edificios:\n"
			for(var b = 0; b < ds_list_size(temp_red.edificios); b++){
				temp_edificio = temp_red.edificios[|b]
				temp_text += $"    {edificio_nombre[temp_edificio.index]}\n"
				for(var c = 0; c < ds_list_size(temp_edificio.energy_link); c++){
					var temp_edificio_2 = temp_edificio.energy_link[|c]
					draw_line_off(temp_edificio.x, temp_edificio.y, temp_edificio_2.x, temp_edificio_2.y)
				}
			}
		}
		draw_set_color(c_white)
		draw_text(0, 20, temp_text)
	}
	//Mostrar redes hidraulicas
	if keyboard_check(ord("O")){
		var temp_text = ""
		for(var a = 0; a < ds_list_size(flujos); a++){
			draw_set_color(make_color_hsv(a * 40, 255, 255))
			var temp_flujo = flujos[|a]
			temp_text += $"Tubería {a}:\n"
			if temp_flujo.liquido = -1
				temp_text += "Sin liquidos\n"
			else
				temp_text += $"{liquido_nombre[temp_flujo.liquido]}\n"
			temp_text += $"  Generacion: {temp_flujo.generacion}\n"
			temp_text += $"  Consumo: {temp_flujo.consumo}\n"
			temp_text += $"  Almacenado: {floor(temp_flujo.cantidad)}/{temp_flujo.cantidad_max}\n"
			temp_text += "  Edificios:\n"
			for(var b = 0; b < ds_list_size(temp_flujo.edificios); b++){
				temp_edificio = temp_flujo.edificios[|b]
				temp_text += $"    {edificio_nombre[temp_edificio.index]}\n"
				for(var c = 0; c < ds_list_size(temp_edificio.energy_link); c++){
					var temp_edificio_2 = temp_edificio.energy_link[|c]
					draw_line_off(temp_edificio.x, temp_edificio.y, temp_edificio_2.x, temp_edificio_2.y)
				}
			}
		}
		draw_set_color(c_white)
		draw_text(0, 20, temp_text)
	}
	//Comandos
	if string_ends_with(keyboard_string, "cheat"){
		keyboard_string = ""
		cheat = not cheat
	}
	if keyboard_check_pressed(vk_escape)
		game_end()
#endregion
#region Control de camara
	if keyboard_check_pressed(vk_f4)
		window_set_fullscreen(not window_get_fullscreen())
	if keyboard_check(vk_lcontrol) and mouse_wheel_up() and zoom < 4{
		camx -= room_width * zoom / 2
		camy -= room_height * zoom / 2
		zoom *= power(2, 0.2)
		camx += room_width * zoom / 2
		camy += room_height * zoom / 2
	}
	if keyboard_check(vk_lcontrol) and mouse_wheel_down() and zoom > 1{
		camx -= room_width * zoom / 2
		camy -= room_height * zoom / 2
		zoom /= power(2, 0.2)
		camx = max(0, min(camx + room_width * zoom / 2, room_width * (zoom - 1)))
		camy = max(0, min(camy + room_height * zoom/ 2, room_height * (zoom - 1)))
	}
	if mouse_x > room_width - 40
		camx = min(camx + 4 + 12 * keyboard_check(vk_lshift), room_width * (zoom - 1))
	if mouse_y > room_height - 40
		camy = min(camy + 4 + 12 * keyboard_check(vk_lshift), room_height * (zoom - 1))
	if mouse_x < 40 and camx > 0
		camx = max(camx - 4 - 12 * keyboard_check(vk_lshift), 0)
	if mouse_y < 40 and camy > 0
	camy = max(camy - 4 - 12 * keyboard_check(vk_lshift), 0)
#endregion