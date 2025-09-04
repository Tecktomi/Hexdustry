#region Dibujo
	var mina = floor(camx / zoom / 48), minb = floor(camy / zoom / 14), maxa = ceil((camx + room_width) / zoom / 48), maxb = ceil((camy + room_height) / zoom / 14)
	//Dibujo de fondo
	for(var a = 0; a < xsize / 24; a++)
		for(var b = 0; b < ysize / 51; b++){
			if background[a, b] = spr_hexagono{
				var temp_surf = surface_create(room_width, room_height)
				surface_set_target(temp_surf)
				for(var c = a * 24; c < min((a + 1) * 24, xsize); c++)
					for(var d = b * 51; d < min((b + 1) * 51, ysize); d++){
						var temp_terreno = terreno[c, d], temp_complex = abtoxy(c, d), aa = temp_complex.a - a * 24 * 48, bb = temp_complex.b - b * 51 * 14, e = temp_terreno.ore
						draw_sprite(terreno_sprite[temp_terreno.terreno], 0, aa, bb)
						if e >= 0
							draw_sprite(ore_sprite[e], temp_terreno.ore_random + 2 * (temp_terreno.ore_amount < 50), aa, bb)
					}
				array_set(background[a], b, sprite_create_from_surface(temp_surf, 0, 0, room_width, room_height, false, false, 0, 0))
				surface_reset_target()
				surface_free(temp_surf)
			}
			draw_sprite_stretched(background[a, b], 0, -camx + a * 24 * 48 * zoom, -camy + b * 51 * 14 * zoom, room_width * zoom, room_height * zoom)
		}
	//Dibujo de edificios
	for(var a = mina; a < maxa; a++)
		for(var b = minb; b < maxb; b++){
			var temp_terreno = terreno[a, b]
			if temp_terreno.edificio_draw{
				var edificio = terreno[a, b].edificio, index = edificio.index, var_edificio_nombre = edificio_nombre[index], dir = edificio.dir, aa = edificio.x, bb = edificio.y
				//Dibujo caminos
				if edificio_camino[index] or var_edificio_nombre = "Túnel"{
					if in(var_edificio_nombre, "Selector", "Overflow")
						draw_sprite_off(edificio_sprite[index], real(edificio.mode), aa, bb,,, (dir - 1) * 60)
					else if in(var_edificio_nombre, "Cinta Transportadora", "Enrutador", "Cinta Magnética"){
						var c = image_index / 2
						if in(var_edificio_nombre, "Cinta Magnética")
							c = image_index
						if (dir mod 3) = 1
							draw_sprite_off(edificio_sprite[index], c, aa, bb,, power(-1, dir > 1))
						else
							draw_sprite_off(edificio_sprite_2[index], c, aa, bb, power(-1, ((dir + 1) mod 6) > 1), power(-1, dir > 2))
					}
					else
						draw_sprite_off(edificio_sprite[index], image_index / 4, aa, bb,,, (dir - 1) * 60)
					if var_edificio_nombre = "Selector" and edificio.select >= 0
						draw_sprite_off(edificio_sprite_2[index], image_index / 4, aa, bb,,, (dir - 1) * 60, recurso_color[edificio.select])
				}
				else{
					//Dibujo edificios con horno
					if in(var_edificio_nombre, "Horno", "Generador") and edificio.fuel > 0
						draw_sprite_off(edificio_sprite_2[index], image_index / 4, aa, bb, power(-1, dir))
					//Dibujo de bateria
					else if in(var_edificio_nombre, "Batería")
						draw_sprite_off(edificio_sprite[index], floor(10 * edificio.red.bateria / edificio.red.bateria_max), aa, bb,,, dir * 60)
					//Dibujo bomba
					else if in(var_edificio_nombre, "Bomba Hidráulica", "Turbina", "Refinería de Petróleo"){
						draw_sprite_off(edificio_sprite[index], 0, aa, bb, power(-1, dir))
						if edificio.flujo.liquido = -1
							draw_sprite_off(spr_bomba_color, 0, aa + power(-1, dir) * 8, bb + 14)
						else
							draw_sprite_off(spr_bomba_color, 0, aa + power(-1, dir) * 8, bb + 14,,,, liquido_color[edificio.flujo.liquido], edificio.flujo.almacen / edificio.flujo.almacen_max)
						draw_sprite_off(spr_bomba_rotor, 1, aa + power(-1, dir) * 8, bb + 14,,, image_index)
						draw_sprite_off(spr_bomba_cupula, 1, aa + power(-1, dir) * 8, bb + 14)
					}
					else if in(var_edificio_nombre, "Tubería", "Depósito", "Líquido Infinito", "Refinería de Petróleo", "Bomba de Evaporación"){
						draw_sprite_off(edificio_sprite[index], 0, aa, bb)
						if edificio.flujo.liquido = -1
							draw_sprite_off(edificio_sprite_2[index], 0, aa, bb)
						else
							draw_sprite_off(edificio_sprite_2[index], 0, aa, bb,,,, liquido_color[edificio.flujo.liquido], edificio.flujo.almacen / edificio.flujo.almacen_max)
					}
					//Torres 1x1
					else if in(var_edificio_nombre, "Torre"){
						draw_sprite_off(edificio_sprite[index], 0, aa, bb)
						draw_sprite_off(edificio_sprite_2[index], 0, aa, bb,,, edificio.select)
					}
					//Torres 2x2
					else if in(var_edificio_nombre, "Rifle"){
						draw_sprite_off(edificio_sprite[index], 0, aa, bb, power(-1, dir))
						draw_sprite_off(edificio_sprite_2[index], 0, aa + 9 * power(-1, dir), bb + 14,,, edificio.select)
					}
					//Dibujo 2x2
					else if edificio_size[index] mod 2 = 0
						draw_sprite_off(edificio_sprite[index], image_index / 4, aa, bb, power(-1, dir))
					//Dibujo predeterminado
					else
						draw_sprite_off(edificio_sprite[index], image_index / 4, aa, bb,,, dir * 60)
					if var_edificio_nombre = "Recurso Infinito" and edificio.select >= 0
						draw_sprite_off(edificio_sprite_2[index], image_index / 4, aa, bb,,,, recurso_color[edificio.select])
				}
				//Dibujo estados
				if info and edificio.waiting{
					draw_set_color(c_yellow)
					draw_circle_off(aa, bb + 16, 4, false)
				}
				if edificio.idle{
					draw_set_color(c_red)
					draw_circle_off(aa, bb + 8, 4, false)
				}
				if edificio.vida < edificio_vida[index]{
					draw_set_color(make_color_hsv(120 * edificio.vida / edificio_vida[index], 255, 255))
					draw_circle_off(aa, bb, 5, false)
					draw_set_color(c_white)
				}
			}
		}
	//Dibujo items y links electricos
	for(var a = mina; a < maxa; a++)
		for(var b = minb; b < maxb; b++){
			var temp_terreno = terreno[a, b]
			if temp_terreno.edificio_draw{
				var edificio = temp_terreno.edificio, index = edificio.index, temp_complex = abtoxy(a, b), aa = temp_complex.a, bb = temp_complex.b
				if edificio.carga_total > 0{
					//Dibujo de items en los caminos
					if (edificio_camino[index] or index = 6){
						var proceso = edificio_proceso[index]
						var c = 1.2 * (max(edificio.proceso, edificio.waiting * proceso) - proceso / 2) * 20 / proceso
						var d = edificio.dir * pi / 3 + pi / 6
						draw_sprite_off(recurso_sprite[edificio.carga_id], 0, aa + c * cos(d), bb - c * sin(d))
					}
					//Dibujo de items saliendo del tunel
					else if index = 16{
						var proceso = edificio_proceso[index]
						var c = 1.2 * (max(edificio.proceso, edificio.waiting * proceso) - proceso / 2) * 20 / proceso
						var d = edificio.dir * pi / 3 + pi / 6
						draw_sprite_off(recurso_sprite[edificio.carga_id], 0, aa - c * cos(d), bb + c * sin(d))
					}
				}
				//Dibujo de los links eléctricos
				if edificio_energia[index]{
					draw_set_color(c_yellow)
					for(var c = 0; c < ds_list_size(edificio.energia_link); c++){
						var edificio_2 = edificio.energia_link[|c]
						draw_line_off(edificio.x, edificio.y, edificio_2.x, edificio_2.y)
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
	var index = show_menu_build.index, var_edificio_nombre = edificio_nombre[index]
	draw_set_color(c_gray)
	draw_triangle(aa - 10 * zoom, bb + 20 * zoom, aa + 10 * zoom, bb + 20 * zoom, aa, bb + 10 * zoom, false)
	draw_rectangle(aa - 80 * zoom, bb + 20 * zoom, aa + 80 * zoom, bb + 40 * zoom, false)
	if in(var_edificio_nombre, "Selector", "Recurso Infinito")
		draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 28 * ceil(rss_max / 5)) * zoom, false)
	if in(var_edificio_nombre, "Líquido Infinito")
		draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 20 * lq_max) * zoom, false)
	draw_set_color(c_dkgray)
	draw_triangle(aa - 10 * zoom, bb + 20 * zoom, aa + 10 * zoom, bb + 20 * zoom, aa, bb + 10 * zoom, true)
	draw_rectangle(aa - 80 * zoom, bb + 20 * zoom, aa + 80 * zoom, bb + 40 * zoom, true)
	if in(var_edificio_nombre, "Selector", "Recurso Infinito")
		draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 28 * ceil(rss_max / 5)) * zoom, true)
	if in(var_edificio_nombre, "Líquido Infinito")
		draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 20 * lq_max) * zoom, true)
	if in(var_edificio_nombre, "Selector", "Overflow")
		draw_text(aa - 80 * zoom, bb + 20 * zoom, "INVERTIR")
	if in(var_edificio_nombre, "Selector", "Recurso Infinito")
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
		else if in(var_edificio_nombre, "Selector", "Recurso Infinito") and mouse_y < bb + (40 + 28 * ceil(rss_max / 5)) * zoom{
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
					change_flujo(0, show_menu_build)
					show_menu_build.flujo.almacen = 0
				}
				show_menu_build.select = a
				if show_menu_build.select >= 0 and show_menu_build.flujo.liquido = -1
					change_flujo(edificio_flujo_consumo[index], show_menu_build)
				show_menu_build.flujo.liquido = a
			}
		}
	}
	if mouse_check_button_pressed(mb_right){
		mouse_clear(mb_right)
		show_menu = false
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
var temp_terreno = terreno[mx, my], edificio = temp_terreno.edificio, temp_coordenada = edificio.coordenadas
//Mostrar detalles de edificios al pasar el mouse_por encima
if temp_hexagono != noone and flag{
	//Mostrar terreno
	var temp_text = $"{mx}, {my}\n"
	temp_text += $"{terreno_nombre[temp_terreno.terreno]}\n"
	if temp_terreno.ore >= 0
		temp_text += $"{recurso_nombre[ore_recurso[temp_terreno.ore]]}: {temp_terreno.ore_amount}\n"
	temp_text += "___________________\n"
	if temp_terreno.edificio_bool{
		var index = edificio.index, var_edificio_nombre = edificio_nombre[index]
		//Seleccionar edificios
		if mouse_check_button_pressed(mb_left) and build_index = 0 and build_menu = 0 and in(var_edificio_nombre, "Selector", "Overflow", "Líquido Infinito", "Recurso Infinito"){
			mouse_clear(mb_left)
			show_menu = true
			show_menu_build = edificio
			show_menu_x = edificio.x * zoom
			show_menu_y = edificio.y * zoom
		}
		temp_text += $"{var_edificio_nombre}\n"
		if info{
			//Mostrar inputs
			draw_set_color(c_blue)
			for(var a = 0; a < ds_list_size(edificio.inputs); a++){
				var edificio_2 = edificio.inputs[|a]
				draw_arrow_off(edificio_2.x, edificio_2.y, edificio.x, edificio.y, 12)
			}
			//Mostrar outputs
			draw_set_color(c_red)
			for(var a = 0; a < ds_list_size(edificio.outputs); a++){
				var edificio_2 = edificio.outputs[|a]
				draw_arrow_off(edificio.x, edificio.y, edificio_2.x, edificio_2.y, 12)
			}
		}
		//Mostrar carga
		if edificio.carga_total > 0{
			temp_text += "Almacen:\n"
			for(var a = 0; a < rss_max; a++)
				if edificio.carga[a] > 0
					temp_text += $"  {recurso_nombre[a]}: {edificio.carga[a]}\n"
			if info and edificio.carga_total > 0
				temp_text += $"    Total: {edificio.carga_total}\n"
		}
		//Mostrar recursos subterraneos
		if in(var_edificio_nombre, "Taladro", "Taladro Eléctrico")
			if edificio.idle
				temp_text += "Sin recursos\n"
			else{
				var temp_array = [0], temp_text_2 = ""
				for(var a = 0; a < rss_max; a++)
					temp_array[a] = 0
				for(var a = 0; a < ds_list_size(edificio.coordenadas); a++){
					var temp_complex = edificio.coordenadas[|a]
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
			temp_text += $"Combustion: {floor(edificio.fuel / 30)} s\n"
		//Mostrar rango de cables
		if in(var_edificio_nombre, "Cable"){
			draw_set_color(c_white)
			draw_circle_off(edificio.x, edificio.y, 90, true)
		}
		//Mostrar rango de torres
		if in(var_edificio_nombre, "Torre", "Láser", "Rifle"){
			if var_edificio_nombre = "Torre"
				var alc = 180
			else if var_edificio_nombre = "Láser"
				alc = 220
			else if var_edificio_nombre = "Rifle"
				alc = 300
			draw_set_color(c_white)
			draw_circle_off(edificio.x, edificio.y, alc, true)
			if not ds_list_empty(enemigos) and edificio.target != null_enemigo{
				if distance(edificio.x, edificio.y, edificio.target.a, edificio.target.b) > alc
					var color = c_white
				else
					color = c_red
				draw_sprite_off(spr_target, 0, edificio.target.a, edificio.target.b,,,, color)
			}
		}
		//Mostrar inputs
		if info and edificio_receptor[index]{
			if edificio_input_all[index]
				temp_text += "Acepta todo\n"
			else{
				var temp_text_2 = ""
				for(var a = 0; a < rss_max; a++)
					if edificio.carga_max[a] > 0
						temp_text_2 += $"  {recurso_nombre[a]}: {edificio.carga_max[a]}\n"
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
					if edificio.carga_output[a]
						temp_text_2 += $"  {recurso_nombre[a]}\n"
				if temp_text_2 != ""
					temp_text += $"Entrega:\n{temp_text_2}"
			}
		}
		//Mostrar red electrica
		if edificio_energia[index]{
			var red = edificio.red
			if edificio_energia_consumo[index] > 0{
				temp_text += $"Consumiendo {edificio.energia_consumo} energía\n"
				if var_edificio_nombre = "Fábrica de Concreto"
					temp_text += $"Funcionando al {floor(100 * clamp((red.generacion + red.bateria) / min(red.consumo, 1), 0, 1) * clamp((edificio.flujo.generacion + edificio.flujo.almacen) / min(edificio.flujo.consumo, 1), 0, 1))}% de su capacidad\n"
				else
					temp_text += $"Funcionando al {floor(100 * clamp((red.generacion + red.bateria) / min(red.consumo, 1), 0, 1))}% de su capacidad\n"
			}
			temp_text += $"Red {ds_list_find_index(redes, red)}\n"
			temp_text += $"  Consumo: {red.consumo}\n"
			temp_text += $"  Generacion: {red.generacion}\n"
			temp_text += $"  Batería: {floor(red.bateria)}/{red.bateria_max}\n"
			if info
				temp_text += red_text(red)
			for(var a = 0; a < ds_list_size(edificio.energia_link); a++){
				var edificio_2 = edificio.energia_link[|a]
				draw_set_color(c_red)
				var temp_complex_2 = abtoxy(edificio.a, edificio.b)
				var temp_complex_3 = abtoxy(edificio_2.a, edificio_2.b)
				draw_line_off(temp_complex_2.a, temp_complex_2.b, temp_complex_3.a, temp_complex_3.b)
			}
		}
		//Mostrar red de líquido
		if edificio_flujo[index]{
			var flujo = edificio.flujo
			temp_text += $"Tubería {ds_list_find_index(flujos, flujo)}:\n"
			if flujo.liquido = -1
				temp_text += "  Sin liquidos\n"
			else
				temp_text += $"  {liquido_nombre[flujo.liquido]}\n"
			if edificio_flujo_consumo[index] > 0
				temp_text += $"Consumiendo {edificio.flujo_consumo} líquido\n"
			temp_text += $"  Generacion: {flujo.generacion}\n"
			temp_text += $"  Consumo: {flujo.consumo}\n"
			temp_text += $"  Almacenado: {floor(flujo.almacen)}/{flujo.almacen_max}\n"
			if info
				temp_text += flujo_text(flujo)
		}
		if info and edificio_proceso[index] > 1
			temp_text += $"Proceso: {floor(edificio.proceso)}/{edificio_proceso[index]}\n"
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
					menu_array = [1, 7, 8, 9, 22, 23, 24, 29, 30]
				else if b = 2 //Electricidad
					menu_array = [10, 11, 12, 13, 28]
				else if b = 3 //Fluidos
					menu_array = [33, 15, 14, 26]
				else if b = 4 //Defensa
					menu_array = [19, 20, 21, 25, 31]
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
		for(var a = 0; a < array_length(menu_array); a++){
			var angle = a * b, comprable = true, index = menu_array[a]
			draw_line(menu_x, menu_y, menu_x + 100 * cos(angle), menu_y - 100 * sin(angle))
			if not cheat{
				for(var c = 0; c < array_length(edificio_precio_id[index]); c++)
					if nucleo.carga[edificio_precio_id[index, c]] < edificio_precio_num[index, c]{
						comprable = false
						break
					}
				if not comprable{
					draw_set_alpha(0.5)
					draw_set_color(c_red)
					for(var angle_2 = angle; angle_2 < angle + b; angle_2 += pi / 64)
						draw_triangle(menu_x, menu_y, menu_x + 100 * cos(angle_2), menu_y - 100 * sin(angle_2), menu_x + 100 * cos(min(angle_2 + pi / 64, angle + b)), menu_y - 100 * sin(min(angle_2 + pi / 64, angle + b)), false)
					draw_set_alpha(1)
					draw_set_color(c_white)
				}
			}
			draw_sprite_stretched(edificio_sprite[index], 0, menu_x - 15 + 100 * cos(angle + b / 2), menu_y - 15 - 100 * sin(angle + b / 2), 30, 30)
		}
		draw_circle(menu_x, menu_y, 10, false)
		if distance(mouse_x, mouse_y, menu_x, menu_y) < 100{
			b = menu_array[floor((array_length(menu_array) - arctan2(mouse_y - menu_y, mouse_x - menu_x) / b) mod array_length(menu_array))]
			var temp_text = $"{edificio_nombre[b]} (hotkey: {edificio_key[b]})\n"
			if not cheat
				for(var c = 0; c < array_length(edificio_precio_id[b]); c++)
					temp_text += $"  {recurso_nombre[edificio_precio_id[b, c]]}: {edificio_precio_num[b, c]}\n"
			temp_text += $"{edificio_descripcion[b]}\n"
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
if keyboard_check_pressed(vk_anykey) and (not in(keyboard_lastchar, "A", "D", "W", "S", " ") or cheat){
	for(var a = 1; a < array_length(edificio_nombre); a++)
		if string_ends_with(keyboard_string, edificio_key[a]){
			keyboard_string = ""
			build_index = a
			build_menu = 0
			flag = true
		}
	keyboard_step = 30
}
if --keyboard_step = 0
	keyboard_string = ""
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
	var comprable = true, temp_text = ""
	//Detectar si el terreno existe
	for(var a = 0; a < ds_list_size(build_list); a++){
		var temp_complex_2 = build_list[|a], aa = temp_complex_2.a, bb = temp_complex_2.b
		if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize{
			comprable = false
			break
		}
	}
	if comprable and temp_hexagono != noone{
		//Detectar recursos y enemigos cerca
		if not cheat{
			for(var a = 0; a < array_length(edificio_precio_id[build_index]); a++)
				if nucleo.carga[edificio_precio_id[build_index, a]] < edificio_precio_num[build_index, a]{
					comprable = false
					temp_text += $"  {recurso_nombre[edificio_precio_id[build_index, a]]} {nucleo.carga[edificio_precio_id[build_index, a]]}/{edificio_precio_num[build_index, a]}\n"
				}
			if not comprable
				temp_text = "Recursos insuficientes\n" + temp_text
			draw_set_color(c_red)
			var flag_3 = false
			for(var a = 0; a < ds_list_size(enemigos); a++){
				var enemigo = enemigos[|a]
				draw_circle_off(enemigo.a, enemigo.b, 100, true)
				if not flag_3 and sqrt(sqr(mouse_x - enemigo.a + camx) + sqr(mouse_y - enemigo.b + camy)) < 100{
					temp_text += "¡Hay enemigos demasiado cerca!\n"
					comprable = false
					flag_3 = true
				}
			}
			draw_set_color(c_white)
		}
		draw_set_color(c_red)
		var temp_complex = abtoxy(spawn_x, spawn_y)
		draw_circle_off(temp_complex.a, temp_complex.b, 250, true)
		if sqrt(sqr(mouse_x - temp_complex.a + camx) + sqr(mouse_y - temp_complex.b + camy)) < 250{
			temp_text += "Zona de generación de enemigos\n"
			comprable = false
		}
		for(var a = 0; a < ds_list_size(build_list); a++){
			var temp_complex_2 = build_list[|a]
			temp_terreno = terreno[temp_complex_2.a, temp_complex_2.b]
			if in(terreno_nombre[temp_terreno.terreno], "Pared de Piedra"){
				temp_text += "Terreno inválido\n"
				comprable = false
				break
			}
		}
		//Detectar que no esté en terreno prohíbido
		if not in(var_edificio_nombre, "Tubería", "Bomba de Evaporación", "Bomba Hidráulica")
			for(var a = 0; a < ds_list_size(build_list); a++){
				var temp_complex_2 = build_list[|a]
				temp_terreno = terreno[temp_complex_2.a, temp_complex_2.b]
				if in(terreno_nombre[temp_terreno.terreno], "Agua", "Agua Profunda", "Petróleo"){
					temp_text += "Terreno inválido\n"
					comprable = false
					break
				}
			}
		//Detectar que las bombas tengan líquidos
		if in(var_edificio_nombre, "Bomba Hidráulica"){
			flag = false
			var liquido = -1
			for(var a = 0; a < ds_list_size(build_list); a++){
					var temp_complex_2 = build_list[|a]
					temp_terreno = terreno[temp_complex_2.a, temp_complex_2.b]
					if in(terreno_nombre[temp_terreno.terreno], "Agua", "Agua Profunda", "Petróleo"){
						flag = true
						if in(terreno_nombre[temp_terreno.terreno], "Agua", "Agua Profunda"){
							if not in(liquido, -1, 0){
								flag = false
								temp_text += "No se puede combinar líquidos\n"
								break
							}
							liquido = 0
						}
						else{
							if not in(liquido, -1, 1){
								flag = false
								temp_text += "No se puede combinar líquidos\n"
								break
							}
							liquido = 1
						}
					}
				}
			if not flag{
				comprable = false
				temp_text += "Necesita ser construido sobre agua o petróleo\n"
			}
		}
		else if in(var_edificio_nombre, "Bomba de Evaporación"){
			flag = false
			for(var a = 0; a < ds_list_size(build_list); a++){
					var temp_complex_2 = build_list[|a]
					temp_terreno = terreno[temp_complex_2.a, temp_complex_2.b]
					if in(terreno_nombre[temp_terreno.terreno], "Agua", "Agua Profunda"){
						flag = true
						break
					}
				}
			if not flag{
				comprable = false
				temp_text += "Necesita ser construido sobre agua"
			}
		}
		//Detectar que los taladros tengan recursos
		if in(var_edificio_nombre, "Taladro", "Taladro Eléctrico"){
			var temp_array, temp_array_2, b = 0
			flag = false
			for(var a = 0; a < rss_max; a++){
				temp_array[a] = 0
				temp_array_2[a] = 0
			}
			//Buscar minerales superficiales
			for(var a = 0; a < ds_list_size(build_list); a++){
				var temp_complex_2 = build_list[|a]
				temp_terreno = terreno[temp_complex_2.a, temp_complex_2.b]
				if temp_terreno.ore >= 0{
					temp_array[ore_recurso[temp_terreno.ore]]++
					temp_array_2[ore_recurso[temp_terreno.ore]] += temp_terreno.ore_amount
					b++
					flag = true
				}
			}
			//Buscar piedra o arena
			if in(var_edificio_nombre, "Taladro Eléctrico"){
				for(var a = 0; a < ds_list_size(build_list); a++){
					var temp_complex_2 = build_list[|a]
					temp_terreno = terreno[temp_complex_2.a, temp_complex_2.b]
					if temp_terreno.ore = -1 and in(terreno_nombre[temp_terreno.terreno], "Piedra", "Arena", "Piedra con Cobre", "Piedra con Hierro", "Piedra con Azufre"){
						temp_array[terreno_recurso_id[temp_terreno.terreno]]++
						temp_array_2[terreno_recurso_id[temp_terreno.terreno]] = -1
						b++
						flag = true
					}
				}
			}
			if not flag{
				comprable = false
				if in(var_edificio_nombre, "Taladro")
					temp_text += "Necesita ser construido sobre minerales"
				else if in(var_edificio_nombre, "Taladro Eléctrico")
					temp_text += "Necesita ser construido sobre minerales, piedra o arena"
			}
			//Escribir porcentajes de recursos
			else for(var a = 0; a < rss_max; a++){
				if temp_array_2[a] > 0
					temp_text += $"{recurso_nombre[a]}: {temp_array_2[a]}({round(temp_array[a] * 100 / b)}%)\n"
				else if temp_array_2[a] = -1
						temp_text += $"{recurso_nombre[a]}({round(temp_array[a] * 100 / b)}%)\n"
			}
		}
		//Detectar que no haya otros edificios debajo
		if edificio_camino[build_index] or in(var_edificio_nombre, "Túnel"){
			for(var a = 0; a < ds_list_size(build_list); a++){
				var temp_complex_2 = build_list[|a]
				temp_terreno = terreno[temp_complex_2.a, temp_complex_2.b]
				if temp_terreno.edificio_bool{
					var temp_edificio = temp_terreno.edificio
					if not edificio_camino[temp_edificio.index]{
						temp_text += "Terreno ocupado\n"
						comprable = false
						break
					}
				}
			}
		}
		else for(var a = 0; a < ds_list_size(build_list); a++){
			var temp_complex_2 = build_list[|a]
			temp_terreno = terreno[temp_complex_2.a, temp_complex_2.b]
			if temp_terreno.edificio_bool{
				temp_text += "Terreno ocupado\n"
				comprable = false
				break
			}
		}
		//No se puede construir
		if not comprable{
			var temp_complex_2 = abtoxy(mx, my)
			draw_edificio(temp_complex_2.a, temp_complex_2.b, build_index, build_dir)
			for(var a = 0; a < ds_list_size(build_list); a++){
				temp_complex_2 = build_list[|a]
				var temp_complex_3 = abtoxy(temp_complex_2.a, temp_complex_2.b)
				draw_sprite_off(spr_rojo, 0, temp_complex_3.a, temp_complex_3.b,,,,, 0.5)
			}
			draw_text_background(mouse_x + 20, mouse_y, temp_text)
		}
		//Si se puede construir
		else{
			temp_complex = abtoxy(mx, my)
			if not (mouse_check_button(mb_left) and (edificio_camino[build_index] or var_edificio_nombre = "Tubería"))
				draw_edificio(temp_complex.a, temp_complex.b, build_index, build_dir, 0.5)
			var temp_array, temp_array_2
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
					draw_edificio(aa, bb, build_index, build_dir, 0.5)
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
							draw_edificio(aaa, bbb, build_index, build_dir, 0.5)
						}
						until(temp_complex_3.a < min(xmouse, aa) or
							temp_complex_3.a > max(xmouse, aa) or
							temp_complex_3.b < min(ymouse, bb) or
							temp_complex_3.b > max(ymouse, bb))
					}
				}
				//Mostrar caminos solos
				else{
					temp_complex = next_to(mx, my, build_dir)
					var temp_complex_2 = abtoxy(mx, my), aa = temp_complex_2.a, bb = temp_complex_2.b
					var temp_complex_3 = abtoxy(temp_complex.a, temp_complex.b)
					if not in(var_edificio_nombre, "Tubería"){
						draw_set_color(c_black)
						draw_arrow_off(aa, bb, temp_complex_3.a, temp_complex_3.b, 8)
					}
					if not in(var_edificio_nombre, "Cinta Transportadora", "Cinta Magnética", "Tubería"){
						temp_complex = next_to(mx, my, (build_dir + 1) mod 6)
						temp_complex_3 = abtoxy(temp_complex.a, temp_complex.b)
						draw_arrow_off(aa, bb, temp_complex_3.a, temp_complex_3.b, 8)
						temp_complex = next_to(mx, my, (build_dir + 5) mod 6)
						temp_complex_3 = abtoxy(temp_complex.a, temp_complex.b)
						draw_arrow_off(aa, bb, temp_complex_3.a, temp_complex_3.b, 8)
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
				}
			}
			//Vista previa no caminos
			else{
				if var_edificio_nombre = "Túnel"{
					var temp_complex_2 = abtoxy(mx, my), flag_2 = false
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
							var edificio_2 = temp_terreno_2.edificio
							if edificio_nombre[edificio_2.index] = "Túnel" and edificio_2.dir = (build_dir + 3) mod 6{
								build_target = edificio_2
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
					//Vista previa Cables
					if in(var_edificio_nombre, "Cable"){
						draw_circle_off(temp_complex_2.a, temp_complex_2.b, 90, true)
						var temp_list_complex = get_size(mx, my, build_dir, 7)
						for(var a = 0; a < ds_list_size(temp_list_complex); a++){
							var temp_complex_3= temp_list_complex[|a], aa = temp_complex_3.a, bb = temp_complex_3.b
							if (aa != mx or bb != my) and aa >= 0 and bb >= 0 and aa < xsize and bb < ysize{
								var temp_terreno_2 = terreno[aa, bb]
								if temp_terreno_2.edificio_draw{
									var temp_edificio = temp_terreno_2.edificio
									if edificio_energia[temp_edificio.index]
										draw_line(temp_complex_2.a, temp_complex_2.b, temp_edificio.x, temp_edificio.y)
								}
							}
						}
					}
					//Vista previa Alcance de torres
					if in(var_edificio_nombre, "Torre", "Láser", "Rifle"){
						if var_edificio_nombre = "Torre"
							var alc = 180
						else if var_edificio_nombre = "Láser"
							alc = 220
						else if var_edificio_nombre = "Rifle"
							alc = 300
						draw_circle_off(temp_complex_2.a, temp_complex_2.b, alc, true)
					}
				}
				if mouse_check_button_pressed(mb_left) and flag and comprable and (not temp_terreno.edificio_bool or ((var_edificio_nombre = "Túnel") and edificio_camino[temp_terreno.edificio.index]))
					f1(build_index, build_dir, mx, my)
			}
			if edificio_energia[build_index] and var_edificio_nombre != "Cable"{
				var temp_complex_2 = abtoxy(mx, my), temp_list_complex = get_size(mx, my, build_dir, 7)
				for(var a = 0; a < ds_list_size(temp_list_complex); a++){
					var temp_complex_3= temp_list_complex[|a], aa = temp_complex_3.a, bb = temp_complex_3.b
					if (aa != mx or bb != my) and aa >= 0 and bb >= 0 and aa < xsize and bb < ysize{
						var temp_terreno_2 = terreno[aa, bb]
						if temp_terreno_2.edificio_draw{
							var temp_edificio = temp_terreno_2.edificio
							if edificio_nombre[temp_edificio.index] = "Cable"
								draw_line_off(temp_complex_2.a, temp_complex_2.b, temp_edificio.x, temp_edificio.y)
						}
					}
				}
			}
			draw_text_background(mouse_x + 20, mouse_y, temp_text)
			//Construir
			function f1(build_index, build_dir, mx, my){
				var flag = true, flag_2 = false, build_list = get_size(mx, my, build_dir, edificio_size[build_index]), edificio, var_edificio_nombre = edificio_nombre[build_index], temp_complex = abtoxy(mx, my)
				for(var a = 0; a < ds_list_size(build_list); a++){
					var temp_complex_2 = build_list[|a], aa = temp_complex_2.a, bb = temp_complex_2.b
					//Asegurarse de que esté dentro del mundo
					if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize{
						flag = false
						break
					}
					var temp_terreno = terreno[aa, bb]
					if in(terreno_nombre[temp_terreno.terreno], "Pared de Piedra"){
						flag = false
						break
					}
					//Checkear coliciones
					if temp_terreno.edificio_bool and not ((edificio_camino[build_index] or (var_edificio_nombre = "Túnel")) and edificio_camino[temp_terreno.edificio.index]){
						flag = false
						break
					}
					//Checkear agua
					if not in(var_edificio_nombre, "Bomba de Evaporación", "Bomba Hidráulica", "Tubería") and in(terreno_nombre[temp_terreno.terreno], "Agua", "Agua Profunda", "Petróleo"){
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
					if in(var_edificio_nombre, "Bomba Hidráulica") and not in(terreno_nombre[temp_terreno.terreno], "Agua", "Agua Profunda", "Petróleo")
						flag = false
					if in(var_edificio_nombre, "Bomba de Evaporación") and not in(terreno_nombre[temp_terreno.terreno], "Agua", "Agua Profunda")
						flag = false
				}
				//Detectar enemigos cerca
				if flag and not cheat
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
					edificio = add_edificio(build_index, build_dir, mx, my)
				//Algoritmo link de tuneles
				if var_edificio_nombre = "Túnel"{
					edificio.idle = not build_able
					if build_able{
						if not build_target.idle{
							build_target.link.idle = true
							ds_list_remove(build_target.outputs, build_target.link)
							ds_list_remove(build_target.link.inputs, build_target)
						}
						build_target.idle = false
						if build_index = 16{
							ds_list_add(edificio.inputs, build_target)
							ds_list_add(build_target.outputs, edificio)
						}
						else{
							ds_list_add(edificio.outputs, build_target)
							ds_list_add(build_target.inputs, edificio)
						}
						edificio.link = build_target
						build_target.link = edificio
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
}
//Destruir edificio
else if ((mouse_check_button(mb_right) and prev_change) or mouse_check_button_pressed(mb_right)) and temp_hexagono != noone and temp_terreno.edificio_bool and edificio.index != 0{
	mouse_clear(mb_right)
	delete_edificio(mx, my)
}
if pausa{
	image_index--
	var color = draw_get_color()
	draw_set_color(c_white)
	draw_set_halign(fa_center)
	draw_set_font(ft_titulo)
	draw_text(room_width / 2, 100, "P A U S A")
	draw_set_font(ft_letra)
	draw_text(room_width / 2, 150, "Presiona P para continuar")
	draw_set_halign(fa_left)
	draw_set_alpha(0.2)
	draw_rectangle(0, 0, room_width, room_height, false)
	draw_set_alpha(1)
	draw_set_color(color)
}
//Ciclos
else{
	//Ciclo edificios
	for(var a = 0; a < ds_list_size(edificios); a++){
		edificio = edificios[|a]
		if not edificio.idle{
			var index = edificio.index, var_edificio_nombre = edificio_nombre[index]
			if edificio_energia[index]
				var red = edificio.red, red_power = clamp((red.generacion + red.bateria) / max(1, red.consumo), 0, 1)
			if edificio_flujo[index]
				var flujo = edificio.flujo, flujo_power = clamp((flujo.generacion + flujo.almacen) / max(1, flujo.consumo), 0, 1)
			//Accion taladro
			if in(var_edificio_nombre, "Taladro", "Taladro Eléctrico") and edificio.carga_total < edificio_carga_max[index]{
				if in(var_edificio_nombre, "Taladro Eléctrico"){
					change_energia(edificio_energia_consumo[index], edificio)
					if red_power > 0 and edificio.flujo_consumo = 0 and flujo.liquido = 1
						change_flujo(edificio_flujo_consumo[index], edificio)
					var b = 1 + 0.6 * (flujo.liquido = 1 ? flujo_power : 0)
					edificio.proceso += b * red_power
				}
				else in(var_edificio_nombre, "Taladro"){
					change_flujo(edificio_flujo_consumo[index], edificio)
					edificio.proceso += 1 + 0.6 * (flujo.liquido = 0 ? flujo_power : 0)
				}
				if edificio.proceso >= edificio_proceso[index]{
					edificio.proceso = 0
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
							if edificio.carga_total = edificio_carga_max[index]
								change_energia(0, edificio)
							temp_terreno.ore_amount--
							if temp_terreno.ore_amount = 50{
								sprite_delete(background[floor(temp_complex_2.a / 24), floor(temp_complex_2.b / 51)])
								array_set(background[floor(temp_complex_2.a / 24)], floor(temp_complex_2.b / 51), spr_hexagono)
							}
							else if temp_terreno.ore_amount = 0{
								temp_terreno.ore = -1
								sprite_delete(background[floor(temp_complex_2.a / 24), floor(temp_complex_2.b / 51)])
								array_set(background[floor(temp_complex_2.a / 24)], floor(temp_complex_2.b / 51), spr_hexagono)
							}
							flag = true
							break
						}
						else if terreno_recurso_bool[temp_terreno.terreno] and in(var_edificio_nombre, "Taladro Eléctrico"){
							edificio.carga[terreno_recurso_id[temp_terreno.terreno]]++
							edificio.carga_total++
							if edificio.carga_total = edificio_carga_max[index]
								change_energia(0, edificio)
							flag = true
							break
						}
					}
					ds_list_destroy(temp_list)
					if flag
						edificio.waiting = not mover(edificio.a, edificio.b)
					else{
						edificio.idle = true
						change_energia(0, edificio)
					}
					if in(var_edificio_nombre, "Taladro Eléctrico") and flujo.liquido = 1
						change_flujo(0, edificio)
					if in(var_edificio_nombre, "Taladro") and flujo.liquido = 0
						change_flujo(0, edificio)
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
						mover_in(edificio)
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
					if edificio.carga[12] > 0 or edificio.carga[1] > 0{
						if edificio.carga[12] > 0{
							edificio.fuel = recurso_combustion_time[12]
							edificio.carga[12]--
						}
						if edificio.carga[1] > 0{
							edificio.fuel = recurso_combustion_time[1]
							edificio.carga[1]--
						}
						change_energia(edificio_energia_consumo[index], edificio)
						edificio.carga_total--
						mover_in(edificio)
					}
					else
						change_energia(0, edificio)
				}
			}
			//Turbina
			else if in(var_edificio_nombre, "Turbina"){
				if edificio.fuel > 0
					edificio.fuel--
				if edificio.fuel = 0 and flujo.liquido = 0{
					if edificio.carga[1] > 0 or edificio.carga[12] > 0{
						if edificio.carga[12] > 0{
							edificio.fuel = recurso_combustion_time[12]
							edificio.carga[12]--
						}
						if edificio.carga[1] > 0{
							edificio.fuel = recurso_combustion_time[1]
							edificio.carga[1]--
						}
						change_energia(edificio_energia_consumo[index] * flujo_power, edificio)
						change_flujo(edificio_flujo_consumo[index], edificio)
						edificio.carga_total--
						mover_in(edificio)
					}
					else{
						change_energia(0, edificio)
						change_flujo(0, edificio)
					}
				}
			}
			//Acción de la bomba hidraulica
			else if in(var_edificio_nombre, "Bomba Hidráulica"){
				if in(flujo.liquido, -1, edificio.select){
					change_energia(edificio_energia_consumo[index], edificio)
					if edificio.select = 2
						change_flujo(red_power * edificio_flujo_consumo[index] / 10, edificio)
					else
						change_flujo(red_power * edificio_flujo_consumo[index], edificio)
					flujo.generacion -= edificio.proceso
					if flujo.almacen = flujo.almacen_max and flujo.generacion >= flujo.consumo{
						change_energia(0, edificio)
						change_flujo(0, edificio)
					}
					flujo.liquido = edificio.select
				}
				else{
					change_energia(0, edificio)
					change_flujo(0, edificio)
				}
			}
			//Acción de triturador
			else if in(var_edificio_nombre, "Triturador") and edificio.carga[6] > 0{
				if edificio.proceso < 0{
					change_energia(edificio_energia_consumo[index], edificio)
					edificio.proceso++
				}
				edificio.proceso += red_power
				if edificio.proceso >= edificio_proceso[index]{
					edificio.proceso -= edificio_proceso[index] + 1
					edificio.carga[6]--
					edificio.carga[5]++
					edificio.waiting = not mover(edificio.a, edificio.b)
					change_energia(0, edificio)
				}
			}
			//Fábrica de concreto
			else if in(var_edificio_nombre, "Fábrica de Concreto", "Refinería de Petróleo", "Fábrica de Compuestos Incendiarios"){
				if in(var_edificio_nombre, "Fábrica de Concreto")
					flag = (flujo.liquido = 0)
				else if in(var_edificio_nombre, "Refinería de Petróleo", "Fábrica de Compuestos Incendiarios")
					flag = (flujo.liquido = 2)
				if flag and edificio_receptor[index]
					for(var b = 0; b < array_length(edificio_input_id[index]); b++)
						if edificio.carga[edificio_input_id[index, b]] = 0{
							flag = false
							break
						}
				if flag{
					if edificio.proceso < 0{
						change_energia(edificio_energia_consumo[index], edificio)
						change_flujo(edificio_flujo_consumo[index], edificio)
						edificio.proceso++
					}
					edificio.proceso += red_power * flujo_power
					if edificio.proceso >= edificio_proceso[index]{
						edificio.proceso -= edificio_proceso[index] + 1
						for(var b = 0; b < array_length(edificio_input_id[index]); b++){
							edificio.carga[edificio_input_id[index, b]]--
							edificio.carga_total--
						}
						for(var b = 0; b < array_length(edificio_output_id[index]); b++){
							edificio.carga[edificio_output_id[index, b]]++
							edificio.carga_total++
						}
						edificio.waiting = not mover(edificio.a, edificio.b)
						change_energia(0, edificio)
						change_flujo(0, edificio)
					}
				}
			}
			//Refinería de Minerales
			else if in(var_edificio_nombre, "Refinería de Metales"){
				if flujo.liquido = 1 and (edificio.carga[9] > 2 or edificio.carga[10] > 2){
					if edificio.proceso < 0{
						change_energia(edificio_energia_consumo[index], edificio)
						change_flujo(edificio_flujo_consumo[index], edificio)
						edificio.proceso++
					}
					edificio.proceso += red_power * flujo_power
					if edificio.proceso >= edificio_proceso[index]{
						edificio.proceso -= edificio_proceso[index] + 1
						if edificio.carga[10] > 2{
							edificio.carga[10] -= 3
							edificio.carga[3]++
						}
						else{
							edificio.carga[9] -= 3
							edificio.carga[0]++
						}
						edificio.carga_total -= 2
						edificio.waiting = not mover(edificio.a, edificio.b)
						change_energia(0, edificio)
						change_flujo(0, edificio)
					}
				}
			}
			//Acción de torres
			else if in(var_edificio_nombre, "Torre", "Rifle"){
				edificio.proceso++
				if var_edificio_nombre = "Torre"
					var alc = 180
				else var_edificio_nombre = "Rifle"
					alc = 300
				if edificio.target != null_enemigo
					edificio.select = radtodeg(-arctan2(edificio.x - edificio.target.a, edificio.target.b - edificio.y)) - 90
				if edificio.flujo_consumo = 0 and flujo.liquido = 0 and edificio.target = null_enemigo and distance(edificio.x, edificio.y, edificio.target.a, edificio.target.b) < alc{
					change_flujo(edificio_flujo_consumo[index], edificio)
					edificio.proceso += 0.5
				}
				if edificio.proceso >= edificio_proceso[index]{
					edificio.proceso -= edificio_proceso[index]
					change_flujo(0, edificio)
					edificio.target = null_enemigo
					if not ds_list_empty(enemigos)
						turret_target(edificio)
					if edificio.target != null_enemigo{
						var tiro = -1
						if var_edificio_nombre = "Torre"
							var arma = 0
						else if var_edificio_nombre = "Rifle"
							arma = 1
						for(var b = 0; b < array_length(armas[arma]); b++){
							var tiro_struct = armas[arma, b]
							show_debug_message(tiro_struct)
							if edificio.carga[tiro_struct.recurso] >= tiro_struct.cantidad{
								tiro = b
								break
							}
						}
						var dis = distance(edificio.x, edificio.y, edificio.target.a, edificio.target.b)
						if tiro >= 0 and dis < alc{
							var tiro_struct = armas[arma, tiro]
							edificio.carga[tiro_struct.recurso] -= tiro_struct.cantidad
							edificio.target.vida -= tiro_struct.dmg
							edificio.carga_total -= tiro_struct.cantidad
							var municion = {
								x : edificio.x,
								y : edificio.y,
								hmove : (edificio.target.a - edificio.x) / dis,
								vmove : (edificio.target.b - edificio.y) / dis,
								tipo : 0,
								dis : dis
							}
							ds_list_add(municiones, municion)
							mover_in(edificio)
							if edificio.target.vida <= 0{
								var temp_list = ds_grid_get(chunk_enemigos, edificio.target.chunk_x, edificio.target.chunk_y)
								ds_list_remove(temp_list, edificio.target)
								ds_list_remove(enemigos, edificio.target)
								edificio.target = null_enemigo
								turret_target(edificio)
							}
						}
					}
				}
			}
			else if in(var_edificio_nombre, "Láser"){
				edificio.target = null_enemigo
				if not ds_list_empty(enemigos)
					turret_target(edificio)
				if edificio.target != null_enemigo and distance(edificio.x, edificio.y, edificio.target.a, edificio.target.b) < 220{
					change_energia(edificio_energia_consumo[index], edificio)
					edificio.mode = true
					edificio.target.vida -= red_power / 2
					draw_set_alpha(red_power)
					draw_set_color(c_red)
					draw_line_off(edificio.x + 12, edificio.y + 14, edificio.target.a, edificio.target.b)
					draw_set_alpha(1)
					if edificio.target.vida <= 0{
						change_energia(0, edificio)
						var temp_list = ds_grid_get(chunk_enemigos, edificio.target.chunk_x, edificio.target.chunk_y)
						ds_list_remove(temp_list, edificio.target)
						ds_list_remove(enemigos, edificio.target)
						edificio.target = null_enemigo
						turret_target(edificio)
					}
				}
				else
					change_energia(0, edificio)
			}
			//Planta química
			else if in(var_edificio_nombre, "Planta de Ácido"){
				if edificio.select > 0{
					edificio.select--
					if edificio.select = 0
						change_flujo(0, edificio)
				}
				if edificio.carga[5] > 1 and edificio.carga[11] > 1 and (edificio.carga[1] > 0 or edificio.fuel > 0){
					if edificio.fuel > 0
						edificio.fuel--
					if in(flujo.liquido, -1, 1) and flujo.almacen < flujo.almacen_max{
						if edificio.fuel = 0 and edificio.carga[1] > 0{
							edificio.fuel = recurso_combustion_time[1]
							edificio.carga[1]--
							edificio.carga_total--
						}
						edificio.proceso++
						if edificio.proceso >= edificio_proceso[index]{
							edificio.carga[5] -= 2
							edificio.carga[11] -= 2
							edificio.carga_total -= 4
							edificio.proceso -= edificio_proceso[index]
							flujo.liquido = 1
							edificio.select = 30
							change_flujo(edificio_flujo_consumo[index], edificio)
							edificio.waiting = not mover(edificio.a, edificio.b)
						}
					}
				}
			}
			//Fábrica de Drones
			else if in(var_edificio_nombre, "Fábrica de Drones"){
				flag = true
				var flag_2 = false, xx = edificio.a, yy = edificio.b
				for(var b = 0; b < array_length(edificio_input_id[index]); b++)
					if edificio.carga[edificio_input_id[index, b]] < edificio_input_num[index, b]{
						flag = false
						break
					}
				if flag for(var b = 0; b < ds_list_size(edificio.bordes); b++){
					show_debug_message(1)
					var temp_complex = edificio.bordes[|b], aa = temp_complex.a, bb = temp_complex.b
					temp_terreno = terreno[aa, bb]
					if not temp_terreno.edificio_bool and not bool_unidad[# aa, bb]{
						flag_2 = true
						xx = aa
						yy = bb
						break
					}
				}
				if flag and flag_2{
					if edificio.proceso < 0{
						change_energia(edificio_energia_consumo[index], edificio)
						edificio.proceso++
					}
					edificio.proceso += red_power
					if edificio.proceso >= edificio_proceso[index]{
						edificio.proceso -= edificio_proceso[index] + 1
						for(var b = 0; b < array_length(edificio_input_id[index]); b++){
							edificio.carga_total -= edificio.carga[edificio_input_id[index, b]]
							edificio.carga[edificio_input_id[index, b]] = 0
						}
						var temp_complex = abtoxy(xx, yy)
						var dron = {
							a : temp_complex.a,
							b : temp_complex.b,
							vida_max : 100,
							vida : 100,
							target : null_edificio,
							target_unit : null_enemigo,
							chunk_x : 0,
							chunk_y : 0
						}
						ds_grid_set(bool_unidad, xx, yy, true)
						path_find(true, dron)
						ds_list_add(drones_aliados, dron)
						edificio.waiting = not mover(edificio.a, edificio.b)
						change_energia(0, edificio)
					}
				}
			}
			//Recursos Infinitos
			else if in(var_edificio_nombre, "Recurso Infinito"){
				if edificio.select != -1{
					edificio.carga[edificio.select] = 1
					edificio.waiting = not mover(edificio.a, edificio.b)
				}
			}
			else if in(var_edificio_nombre, "Panel Solar")
				change_energia(energia_solar * edificio_energia_consumo[index], edificio)
			else if in(var_edificio_nombre, "Bomba de Evaporación")
				change_flujo(energia_solar * edificio_flujo_consumo[index], edificio)
		}
	}
	//Ciclo de los enemigos
	for(var a = 0; a < ds_list_size(enemigos); a++){
		var enemigo = enemigos[|a], aa = enemigo.a, bb = enemigo.b
		draw_sprite_off(spr_dron, 0, aa, bb)
		draw_sprite_off(spr_dron_color, 0, aa, bb,,,, c_red)
		if enemigo.vida < enemigo.vida_max{
			draw_set_color(make_color_hsv(120 * enemigo.vida / enemigo.vida_max, 255, 255))
			draw_circle_off(aa, bb - 20, 5, false)
			draw_set_color(c_white)
		}
		if enemigo.target != null_edificio and enemigo.target.vida <= 0
			enemigo.target = null_edificio
		if enemigo.target_unit != null_enemigo and enemigo.target_unit.vida <= 0
			enemigo.target_unit = null_enemigo
		if (not ds_list_empty(edificios) and enemigo.target = null_edificio) or (not ds_list_empty(drones_aliados) and enemigo.target_unit = null_enemigo)
			path_find(false, enemigo)
		//Target edificios
		if enemigo.target != null_edificio{
			edificio = enemigo.target
			var dis = distance(aa, bb, edificio.x, edificio.y)
			if dis > 50{
				enemigo.a += (edificio.x - aa) / dis
				enemigo.b += (edificio.y - bb) / dis
			}
			else{
				edificio.vida--
				if edificio.vida <= 0{
					delete_edificio(edificio.a, edificio.b, true)
					enemigo.target = null_edificio
					path_find(false, enemigo)
				}
			}
		}
		//Target unidades
		else if enemigo.target_unit != null_enemigo{
			var dron = enemigo.target_unit
			var dis = distance(aa, bb, dron.a, dron.b)
			if dis > 50{
				enemigo.a += (dron.a - aa) / dis
				enemigo.b += (dron.b - bb) / dis
			}
			else{
				dron.vida--
				if dron.vida <= 0{
					ds_list_remove(drones_aliados, dron)
					enemigo.target_unit = null_edificio
					path_find(false, enemigo)
				}
			}
		}
		//Cambiar de chunk
		var temp_list = ds_grid_get(chunk_enemigos, enemigo.chunk_x, enemigo.chunk_y)
		var temp_complex = xytoab(aa, bb)
		aa = temp_complex.a
		bb = temp_complex.b
		if clamp(round(aa / 6), 0, ds_grid_width(chunk_enemigos) - 1) != enemigo.chunk_x or clamp(round(bb / 12), 0, ds_grid_height(chunk_enemigos) - 1) != enemigo.chunk_y{
			ds_list_remove(temp_list, enemigo)
			enemigo.chunk_x = clamp(round(aa / 6), 0, ds_grid_width(chunk_enemigos) - 1)
			enemigo.chunk_y = clamp(round(bb / 12), 0, ds_grid_height(chunk_enemigos) - 1)
			temp_list = ds_grid_get(chunk_enemigos, enemigo.chunk_x, enemigo.chunk_y)
			ds_list_add(temp_list, enemigo)
		}
		aa = enemigo.a
		bb = enemigo.b
		//Alejarse de los enemigos cercanos
		for(var b = 0; b < ds_list_size(temp_list); b++){
			var temp_enemigo = temp_list[|b]
			if temp_enemigo != enemigo{
				var dis = distance(aa, bb, temp_enemigo.a, temp_enemigo.b)
				if dis < 20{
					enemigo.a += (aa - temp_enemigo.a) / dis
					enemigo.b += (bb - temp_enemigo.b) / dis
				}
			}
		}
	}
	//Ciclo drones aliados
	for(var a = 0; a < ds_list_size(drones_aliados); a++){
		var dron = drones_aliados[|a], aa = dron.a, bb = dron.b
		draw_sprite_off(spr_dron, 0, aa, bb)
		draw_sprite_off(spr_dron_color, 0, aa, bb,,,, c_blue)
		if dron.vida < dron.vida_max{
			draw_set_color(make_color_hsv(120 * dron.vida / dron.vida_max, 255, 255))
			draw_circle_off(aa, bb - 20, 5, false)
			draw_set_color(c_white)
		}
		if dron.target_unit != null_enemigo and dron.target_unit.vida <= 0
			dron.target_unit = null_enemigo
		if not ds_list_empty(enemigos) and dron.target_unit = null_enemigo
			path_find(true, dron)
		if dron.target_unit != null_enemigo{
			var enemigo = dron.target_unit
			var dis = distance(aa, bb, enemigo.a, enemigo.b)
			if dis > 50{
				dron.a += (enemigo.a - aa) / dis
				dron.b += (enemigo.b - bb) / dis
			}
			else if --enemigo.vida <= 0{
				var temp_list = ds_grid_get(chunk_enemigos, edificio.target.chunk_x, edificio.target.chunk_y)
				ds_list_remove(temp_list, edificio.target)
				ds_list_remove(enemigos, enemigo)
				dron.target_unit = null_edificio
				path_find(true, dron)
			}
		}
	}
	//Ciclo de disparos
	draw_set_color(c_black)
	for(var a = 0; a < ds_list_size(municiones); a++){
		var municion = municiones[|a]
		draw_circle_off(municion.x, municion.y, 2, false)
		municion.x += 25 * municion.hmove
		municion.y += 25 * municion.vmove
		municion.dis -= 25
		if municion.dis <= 0
			ds_list_delete(municiones, a--)
	}
	#region Generación de enemigos
		if image_index > 14400 or keyboard_check_pressed(vk_enter){
			if image_index mod 3600 = 0 or keyboard_check_pressed(vk_enter){
				var c = 100 + floor(sqr((image_index - 14400) / 900)), d = enemigos_spawned++, e = 1, flag_2 = false
				for(var i = 0; i < array_length(size_size); i++)
					if d <= size_size[i]{
						e = i + 1
						flag_2 = true
						break
					}
				if not flag_2
					e = array_length(size_size)
				var temp_complex_list = get_size(spawn_x, spawn_y, 0, e)
				for(var i = 0; i < min(ds_list_size(temp_complex_list), d); i++){
					var temp_complex = temp_complex_list[|i], aa = temp_complex.a, bb = temp_complex.b, temp_complex_2 = abtoxy(aa, bb)
					var enemigo = {
						a : temp_complex_2.a,
						b : temp_complex_2.b,
						vida_max : c,
						vida : c,
						target : null_edificio,
						target_unit : null_enemigo,
						chunk_x : clamp(round(aa / 6), 0, ds_grid_width(chunk_enemigos) - 1),
						chunk_y : clamp(round(bb / 12), 0, ds_grid_height(chunk_enemigos) - 1)
					}
					var temp_list = ds_grid_get(chunk_enemigos, enemigo.chunk_x, enemigo.chunk_y)
					ds_list_add(temp_list, enemigo)
					path_find(false, enemigo)
					ds_list_add(enemigos, enemigo)
				}
			}
		}
		var temp_text_right = ""
		if image_index < 14400{
			var seg =floor((14400 - image_index) / 60)
			temp_text_right += $"{seg > 60 ? string(floor(seg / 60)) + " m " : ""}{seg mod 60} s para los enemigos\n"
		}
		if build_index > 0
			temp_text_right += $"{edificio_nombre[build_index]}\n"
		if temp_text_right != ""{
			temp_text_right = string_trim(temp_text_right)
			draw_set_halign(fa_right)
			draw_text_background(room_width, 0, temp_text_right)
			draw_set_halign(fa_left)
		}
	#endregion
	energia_solar = clamp(2 * sin((image_index + 900) / 1800), 0, 1)
	draw_set_alpha((1 - energia_solar) / 3)
	draw_set_color(c_black)
	draw_rectangle(0, 0, room_width, room_height, false)
	draw_set_alpha(1)
	//Ciclo de redes
	for(var a = 0; a < ds_list_size(redes); a++){
		var red = redes[|a]
		red.bateria = clamp(red.bateria + (red.generacion - red.consumo) / 30, 0, red.bateria_max)
		red.eficiencia = clamp((red.generacion + red.bateria) / max(1, red.consumo), 0, 1)
	}
	//Ciclo flujos
	for(var a = 0; a < ds_list_size(flujos); a++){
		var flujo = flujos[|a]
		flujo.almacen = clamp(flujo.almacen + (flujo.generacion - flujo.consumo) / 30, 0, flujo.almacen_max)
		if flujo.almacen = 0 and flujo.generacion = 0
			flujo.liquido = -1
	}
}
#region INPUT
	if keyboard_check_pressed(ord("P"))
		pausa = not pausa
	if keyboard_check_pressed(ord("R"))
		game_restart()
	if keyboard_check_pressed(ord("I"))
		info = not info
	if keyboard_check_pressed(ord("L"))
		flow = not flow
	//Mostrar redes electricas
	if keyboard_check(ord("O")){
		var temp_text = ""
		for(var a = 0; a < ds_list_size(redes); a++){
			var red = redes[|a]
			temp_text += $"Red {a}:\n"
			temp_text += $"  Consumo: {red.consumo}\n"
			temp_text += $"  Generacion: {red.generacion}\n"
			temp_text += $"  Batería: {floor(red.bateria)}/{red.bateria_max}\n"
			temp_text += red_text(red)
			draw_set_color(make_color_hsv(255 * a / ds_list_size(redes), 255, 255))
			for(var b = 0; b < ds_list_size(red.edificios); b++){
				edificio = red.edificios[|b]
				for(var c = 0; c < ds_list_size(edificio.energia_link); c++){
					var edificio_2 = edificio.energia_link[|c]
					draw_arrow_off(edificio.x, edificio.y, edificio_2.x, edificio_2.y, 8)
				}
			}
		}
		draw_text_background(0, 0, temp_text)
	}
	//Mostrar redes hidraulicas
	if keyboard_check(ord("U")){
		var temp_text = ""
		for(var a = 0; a < ds_list_size(flujos); a++){
			var flujo = flujos[|a]
			temp_text += $"Tubería {a}:\n"
			if flujo.liquido = -1
				temp_text += "Sin liquidos\n"
			else
				temp_text += $"{liquido_nombre[flujo.liquido]}\n"
			temp_text += $"  Generacion: {flujo.generacion}\n"
			temp_text += $"  Consumo: {flujo.consumo}\n"
			temp_text += $"  Almacenado: {floor(flujo.almacen)}/{flujo.almacen_max}\n"
			temp_text += flujo_text(flujo)
			draw_set_color(make_color_hsv(255 * a / ds_list_size(flujos), 255, 255))
			for(var b = 0; b < ds_list_size(flujo.edificios); b++){
				edificio = flujo.edificios[|b]
				for(var c = 0; c < ds_list_size(edificio.flujo_link); c++){
					var edificio_2 = edificio.flujo_link[|c]
					draw_arrow_off(edificio.x, edificio.y, edificio_2.x, edificio_2.y, 8)
				}
			}
		}
		draw_text_background(0, 0, temp_text)
	}
	//Comandos
	if string_ends_with(keyboard_string, "cheat"){
		keyboard_string = ""
		cheat = not cheat
		build_index = 0
	}
	if cheat and string_ends_with(keyboard_string, "dron"){
		keyboard_string = ""
		var dron = {
			a : mouse_x + random_range(-32, 32),
			b : mouse_y + random_range(-32, 32),
			vida_max : 100,
			vida : 100,
			target : null_edificio,
			target_unit : null_enemigo,
			chunk_x : 0,
			chunk_y : 0
		}
		path_find(true, dron)
		ds_list_add(drones_aliados, dron)
		build_index = 0
	}
	if keyboard_check_pressed(vk_escape)
		game_end()
#endregion
#region Control de camara
	if keyboard_check_pressed(vk_f4)
		window_set_fullscreen(not window_get_fullscreen())
	if keyboard_check(vk_lcontrol) and mouse_wheel_up() and zoom < 4{
		camx -= xsize * 48 * zoom / 2
		camy -= ysize * 14 * zoom / 2
		zoom *= power(2, 0.2)
		camx += xsize * 48 * zoom / 2
		camy += ysize * 14 * zoom / 2
	}
	if keyboard_check(vk_lcontrol) and mouse_wheel_down() and zoom > 1{
		camx -= xsize * 48 * zoom / 2
		camy -= ysize * 14 * zoom / 2
		zoom /= power(2, 0.2)
		camx = clamp(camx + xsize * 48 * zoom / 2, 0, xsize * 48 * zoom - room_width)
		camy = clamp(camy + ysize * 14 * zoom/ 2, 0, ysize * 14 * zoom - room_height)
	}
	if mouse_x > room_width - 40 or keyboard_check(ord("D"))
		camx = min(camx + 4 + 12 * keyboard_check(vk_lshift), xsize * 48 * zoom - room_width)
	if mouse_y > room_height - 40 or keyboard_check(ord("S"))
		camy = min(camy + 4 + 12 * keyboard_check(vk_lshift), ysize * 14 * zoom - room_height)
	if mouse_x < 40 and camx > 0 or keyboard_check(ord("A"))
		camx = max(camx - 4 - 12 * keyboard_check(vk_lshift), 0)
	if mouse_y < 40 and camy > 0 or keyboard_check(ord("W"))
		camy = max(camy - 4 - 12 * keyboard_check(vk_lshift), 0)
	if flow
		draw_path_find()
#endregion