//Dibujo de fondo
if background = spr_hexagono{
	var temp_surf = surface_create(room_width, room_height)
	surface_set_target(temp_surf)
	for(var a = 0; a < xsize; a++)
		for(var b = 0; b < ysize; b++){
			var temp_terreno = terreno[a, b]
			var temp_complex = abtoxy(a, b)
			draw_sprite(terreno_sprite[temp_terreno.terreno], 0, temp_complex.a, temp_complex.b)
			if temp_terreno.ore >= 0
				draw_sprite(ore_sprite[temp_terreno.ore], (temp_terreno.ore_amount < 50), temp_complex.a, temp_complex.b)
		}
	background = sprite_create_from_surface(temp_surf, 0, 0, room_width, room_height, false, false, 0, 0)
	surface_reset_target()
	surface_free(temp_surf)
}
draw_sprite(background, 0, 0, 0)
//Dibujo de edificios
for(var a = 0; a < xsize; a++)
	for(var b = 0; b < ysize; b++){
		var temp_terreno = terreno[a, b]
		var temp_edificio = terreno[a, b].edificio
		var temp_complex = abtoxy(a, b)
		if temp_terreno.edificio_draw{
			//Dibujo caminos
			if edificio_camino[temp_edificio.index] or edificio_nombre[temp_edificio.index] = "Tunel"{
				draw_sprite_ext(edificio_sprite[temp_edificio.index], image_index / 4, temp_complex.a, temp_complex.b, 1, 1, (temp_edificio.dir - 1) * 60, c_white, 1)
				if temp_edificio.carga_total > 0{
					var c = 1.2 * (max(temp_edificio.proceso, temp_edificio.waiting * 20) - 10)
					var d = temp_edificio.dir * pi / 3 + pi / 6
					draw_sprite(rss_item_sprite[temp_edificio.carga_id], 0, temp_complex.a + c * cos(d), temp_complex.b - c * sin(d))
				}
				if edificio_nombre[temp_edificio.index] = "Selector" and temp_edificio.select >= 0
					draw_sprite_ext(edificio_sprite_2[temp_edificio.index], image_index / 4, temp_complex.a, temp_complex.b, 1, 1, (temp_edificio.dir - 1) * 60, rss_item_color[temp_edificio.select], 1)
			}
			else{
				//Dibujo edificios con horno
				if in(edificio_nombre[temp_edificio.index], "Horno", "Generador") and temp_edificio.fuel > 0
					draw_sprite_ext(edificio_sprite_2[temp_edificio.index], image_index / 4, temp_complex.a, temp_complex.b, 1, 1, temp_edificio.dir * 60, c_white, 1)
				else if in(edificio_nombre[temp_edificio.index], "Bateria")
					draw_sprite_ext(edificio_sprite[temp_edificio.index], floor(10 * temp_edificio.red.bateria / temp_edificio.red.bateria_max), temp_complex.a, temp_complex.b, 1, 1, temp_edificio.dir * 60, c_white, 1)
				else
					draw_sprite_ext(edificio_sprite[temp_edificio.index], image_index / 4, temp_complex.a, temp_complex.b, 1, 1, temp_edificio.dir * 60, c_white, 1)
			}
			//Dibujo estados
			if temp_edificio.waiting{
				draw_set_color(c_yellow)
				draw_circle(temp_complex.a, temp_complex.b, 4, false)
			}
			if temp_edificio.idle{
				draw_set_color(c_red)
				draw_circle(temp_complex.a, temp_complex.b + 8, 4, false)
			}
		}
	}
//Dibujo items
for(var a = 0; a < xsize; a++)
	for(var b = 0; b < ysize; b++){
		var temp_terreno = terreno[a, b]
		var temp_edificio = terreno[a, b].edificio
		var temp_complex = abtoxy(a, b)
		if temp_terreno.edificio_draw{
			//Dibujo de items en los caminos
			if (edificio_camino[temp_edificio.index] or edificio_nombre[temp_edificio.index] = "Tunel") and temp_edificio.carga_total > 0{
				var c = 1.2 * (max(temp_edificio.proceso, temp_edificio.waiting * 20) - 10)
				var d = temp_edificio.dir * pi / 3 + pi / 6
				draw_sprite(rss_item_sprite[temp_edificio.carga_id], 0, temp_complex.a + c * cos(d), temp_complex.b - c * sin(d))
			}
			//Dibujo de los links eléctricos
			else if edificio_electricidad[temp_edificio.index]{
				draw_set_color(c_yellow)
				for(var c = 0; c < ds_list_size(temp_edificio.energy_link); c++){
					var temp_edificio_2 = ds_list_find_value(temp_edificio.energy_link, c)
					var temp_complex_2 = abtoxy(temp_edificio.a, temp_edificio.b)
					var temp_complex_3 = abtoxy(temp_edificio_2.a, temp_edificio_2.b)
					draw_line(temp_complex_2.a, temp_complex_2.b, temp_complex_3.a, temp_complex_3.b)
				}
			}
		}
	}
var flag = true
//Seleccionar recurso
if show_menu{
	draw_set_color(c_gray)
	draw_rectangle(show_menu_x, show_menu_y, show_menu_x + 160, show_menu_y + 28, false)
	if edificio_nombre[show_menu_build.index] = "Selector"
		draw_rectangle(show_menu_x, show_menu_y + 28, show_menu_x + 160, show_menu_y + 28 * (2 + floor((rss_max - 1) / 5)), false)
	draw_set_color(c_dkgray)
	draw_rectangle(show_menu_x, show_menu_y, show_menu_x + 160, show_menu_y + 28, true)
	if edificio_nombre[show_menu_build.index] = "Selector"
		draw_rectangle(show_menu_x, show_menu_y + 28, show_menu_x + 160, show_menu_y + 28 * (2 + floor((rss_max - 1) / 5)), true)
	draw_text(show_menu_x, show_menu_y, "Invertir")
	if edificio_nombre[show_menu_build.index] = "Selector"
		for(var a = 0; a < rss_max; a++)
			draw_sprite(rss_item_sprite[a], 0, show_menu_x + 32 * a + 16, show_menu_y + 28 * (1 + floor(a / 5)) + 14)
	if mouse_x > show_menu_x and mouse_y > show_menu_y and mouse_x < show_menu_x + 160{
		//Invertir
		if mouse_y > show_menu_y and mouse_y < show_menu_y + 28{
			flag = false
			if mouse_check_button_pressed(mb_left){
				mouse_clear(mb_left)
				show_menu = false
				show_menu_build.mode = not show_menu_build.mode
			}
		}
		//Elegir recurso
		else if mouse_y > show_menu_y + 28 and mouse_y < show_menu_y + 28 * (2 + floor((rss_max - 1) / 5)) and edificio_nombre[show_menu_build.index] = "Selector"{
			var a = floor((mouse_x - show_menu_x) / 32) + 5 * floor((mouse_y - show_menu_y) / 28 - 1)
			flag = false
			if a >= 0 and a < rss_max{
				draw_set_color(c_white)
				draw_set_valign(fa_bottom)
				draw_text(show_menu_x + 20, show_menu_y, rss_name[a])
				draw_set_valign(fa_top)
				if mouse_check_button_pressed(mb_left){
					mouse_clear(mb_left)
					show_menu = false
					show_menu_build.select = a
				}
			}
		}
	}
}
//Información mouse
var temp_hexagono = instance_position(mouse_x, mouse_y, obj_hexagono), mx = 0, my = 0
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
var temp_terreno = terreno[mx, my]
var temp_edificio = temp_terreno.edificio
var temp_coordenada = temp_edificio.coordenadas
if temp_hexagono != noone and flag{
	//Mostrar terreno
	var temp_text = string(mx) + ", " + string(my) + "\n"
	temp_text += terreno_name[temp_terreno.terreno] + "\n"
	if temp_terreno.ore >= 0
		temp_text += rss_name[ore_recurso[temp_terreno.ore]] + ": " + string(temp_terreno.ore_amount) + "\n"
	temp_text += "___________________\n"
	if temp_terreno.edificio_bool{
		//Seleccionar edificios
		if mouse_check_button_pressed(mb_left) and build_index = 0{
			mouse_clear(mb_left)
			if in(edificio_nombre[temp_edificio.index], "Selector", "Overflow"){
				show_menu = true
				show_menu_build = temp_edificio
				show_menu_x = abtoxy(temp_edificio.a, temp_edificio.b).a
				show_menu_y = abtoxy(temp_edificio.a, temp_edificio.b).b
			}
		}
		temp_text += edificio_nombre[temp_edificio.index] + "\n"
		//Mostrar inputs
		draw_set_color(c_blue)
		var temp_complex = abtoxy(temp_edificio.a, temp_edificio.b)
		for(var a = 0; a < ds_list_size(temp_edificio.inputs); a++){
			var temp_edificio_2 = ds_list_find_value(temp_edificio.inputs, a)
			var temp_complex_2 = abtoxy(temp_edificio_2.a, temp_edificio_2.b)
			draw_arrow(temp_complex_2.a, temp_complex_2.b, temp_complex.a, temp_complex.b, 12)
		}
		//Mostrar outputs
		draw_set_color(c_red)
		temp_complex = abtoxy(temp_edificio.a, temp_edificio.b)
		for(var a = 0; a < ds_list_size(temp_edificio.outputs); a++){
			var temp_edificio_2 = ds_list_find_value(temp_edificio.outputs, a)
			var temp_complex_2 = abtoxy(temp_edificio_2.a, temp_edificio_2.b)
			draw_arrow(temp_complex.a, temp_complex.b, temp_complex_2.a, temp_complex_2.b, 12)
		}
		//Mostrar carga
		if temp_edificio.carga_total > 0{
			temp_text += "Almacen:\n"
			for(var a = 0; a < rss_max; a++)
				if temp_edificio.carga[a] > 0
					temp_text += "  " + rss_name[a] + ": " + string(temp_edificio.carga[a]) + "\n"
		}
		//Mostrar recursos subterraneos
		if in(edificio_nombre[temp_edificio.index], "Taladro", "Taladro electrico")
			if temp_edificio.idle
				temp_text += "Sin recursos\n"
			else{
				var temp_array = [0], temp_text_2 = ""
				for(var a = 0; a < rss_max; a++)
					temp_array[a] = 0
				for(var a = 0; a < ds_list_size(temp_edificio.coordenadas); a++){
					temp_complex = ds_list_find_value(temp_edificio.coordenadas, a)
					var temp_terreno_2 = terreno[temp_complex.a, temp_complex.b]
					if temp_terreno_2.ore >= 0
						temp_array[ore_recurso[temp_terreno_2.ore]] += temp_terreno_2.ore_amount
				}
				for(var a = 0; a < rss_max; a++)
					if temp_array[a] > 0
						temp_text_2 += "  " + rss_name[a] + ": " + string(temp_array[a]) + "\n"
				if temp_text_2 != ""
					temp_text += "Recursos disponibles:\n" + temp_text_2
			}
		//Mostrar combustión
		if in(edificio_nombre[temp_edificio.index], "Horno", "Generador")
			temp_text += "Combustion: " + string(floor(temp_edificio.fuel / 30)) + "/10" + "\n"
		//Mostrar inputs
		if edificio_receptor[temp_edificio.index]{
			var temp_text_2 = ""
			for(var a = 0; a < rss_max; a++)
				if temp_edificio.carga_max[a] > 0
					temp_text_2 += "  " + rss_name[a] + ": " + string(temp_edificio.carga_max[a]) + "\n"
			if temp_text_2 != ""
				temp_text += "Acepta:\n" + temp_text_2
		}
		//Mostrar outputs
		if edificio_emisor[temp_edificio.index]{
			var temp_text_2 = ""
			for(var a = 0; a < rss_max; a++)
				if temp_edificio.carga_output[a]
					temp_text_2 += "  " + rss_name[a] + "\n"
			if temp_text_2 != ""
				temp_text += "Entrega:\n" + temp_text_2
		}
		//Mostrar red electrica
		if edificio_electricidad[temp_edificio.index]{
			var temp_red = temp_edificio.red
			if edificio_elec_consumo[temp_edificio.index] > 0 and temp_red.consumo > temp_red.generacion and temp_red.bateria = 0
				temp_text += "Funcionando al " + string(floor(100 * temp_red.generacion / temp_red.consumo)) + "% de su capacidad\n"
			temp_text += "Red " + string(ds_list_find_index(redes, temp_red)) + "\n"
			temp_text += "  Consumo: " + string(temp_red.consumo) + "\n"
			temp_text += "  Generacion: " + string(temp_red.generacion) + "\n"
			temp_text += "  Bateria: " + string(temp_red.bateria) + "\n"
			temp_text += "  Edificios:\n"
			for(var a = 0; a < ds_list_size(temp_red.edificios); a++){
				var temp_edificio_2 = ds_list_find_value(temp_red.edificios, a)
				temp_text += "    " + string(edificio_nombre[temp_edificio_2.index]) + "\n"
			}
		}
		temp_text += "___________________\n"
	}
	draw_set_color(c_white)
	draw_text(0, 0, temp_text)
}
//Construir
flag = false
if keyboard_check_pressed(vk_anykey) and real(keyboard_lastkey) >= 48 and real(keyboard_lastkey) < 49 + edificio_max{
	build_index = real(keyboard_lastkey) - 47
	flag = true
}
if keyboard_check_pressed(vk_anykey) and real(keyboard_lastkey) = 219{
	build_index = 11
	flag = true
}
if keyboard_check_pressed(ord("Q")){
	build_index = 12
	flag = true
}
if (mouse_check_button_pressed(mb_right) or keyboard_check_pressed(vk_escape)) and (build_index > 0 or show_menu){
	mouse_clear(mb_right)
	build_index = 0
	show_menu = false
}
if build_index > 0{
	if flag and not edificio_rotable[build_index]
		build_dir = 0
	//Rotar
	if mouse_wheel_up() and edificio_rotable[build_index]{
		build_dir = (build_dir + 1) mod 6
		flag = true
	}
	if mouse_wheel_down() and edificio_rotable[build_index]{
		build_dir = build_dir - 1 + 6 * (build_dir = 0)
		flag = true
	}
	if last_mx != mx or last_my != my or flag{
		build_list = get_size(mx, my, build_dir, edificio_size[build_index])
		show_menu = false
	}
	last_mx = mx
	last_my = my
	if temp_hexagono != noone{
		var temp_array, temp_array_2
		flag = true
		//Vista previa edificios arrastrables
		if edificio_camino[build_index]{
			//Iniciar arrastre
			if mouse_check_button_pressed(mb_left){
				mx_clic = mx
				my_clic = my
			}
			//Arrastre
			if mouse_check_button(mb_left){
				ds_list_clear(pre_build_list)
				var temp_complex_2 = abtoxy(mx_clic, my_clic)
				draw_sprite_ext(edificio_sprite[build_index], 0, temp_complex_2.a, temp_complex_2.b, 1, 1, (build_dir - 1) * 60, c_white, 0.5)
				ds_list_add(pre_build_list, {a : mx_clic, b : my_clic})
				if mx_clic != mx or my_clic != my{
					var angle = radtodeg((arctan2(temp_complex_2.b - mouse_y, mouse_x - temp_complex_2.a) + 2 * pi) mod (2 * pi))
					build_dir = floor(angle / 60)
					var a = mx_clic, b = my_clic, temp_complex_3
					do{
						temp_complex_3 = next_to(a, b, build_dir)
						ds_list_add(pre_build_list, temp_complex_3)
						a = temp_complex_3.a
						b = temp_complex_3.b
						temp_complex_3 = abtoxy(temp_complex_3.a, temp_complex_3.b)
						draw_sprite_ext(edificio_sprite[build_index], 0, temp_complex_3.a, temp_complex_3.b, 1, 1, (build_dir - 1) * 60, c_white, 0.5)
					}
					until(temp_complex_3.a < min(mouse_x, temp_complex_2.a) or
						temp_complex_3.a > max(mouse_x, temp_complex_2.a) or
						temp_complex_3.b < min(mouse_y, temp_complex_2.b) or
						temp_complex_3.b > max(mouse_y, temp_complex_2.b))
				}
			}
			//Mostrar caminos solos
			else{
				var temp_complex = next_to(mx, my, build_dir)
				var temp_complex_2 = abtoxy(mx, my)
				var temp_complex_3 = abtoxy(temp_complex.a, temp_complex.b)
				draw_arrow(temp_complex_2.a, temp_complex_2.b, temp_complex_3.a, temp_complex_3.b, 8)
				draw_sprite_ext(edificio_sprite[build_index], 0, temp_complex_2.a, temp_complex_2.b, 1, 1, (build_dir - 1) * 60, c_white, 0.5)
			}
			//Construir en cadena
			if mouse_check_button_released(mb_left) and (mx_clic != mx or my_clic != my){
				flag = false
				for(var a = 0; a < ds_list_size(pre_build_list); a++){
					var temp_complex_2 = ds_list_find_value(pre_build_list, a)
					f1(build_index, build_dir, temp_complex_2.a, temp_complex_2.b)
				}
				if not keyboard_check(vk_lshift)
					build_index = 0
			}
		}
		//Vista previa tuneles
		else if edificio_nombre[build_index] = "Tunel"{
			var temp_complex_2 = abtoxy(mx, my), flag_2 = false
			draw_sprite_ext(edificio_sprite[build_index], 0, temp_complex_2.a, temp_complex_2.b, 1, 1, (build_dir - 1) * 60, c_white, 0.5)
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
					if temp_edificio_2.index = build_index and temp_edificio_2.dir = (build_dir + 3) mod 6{
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
					draw_sprite_ext(spr_tunel_view, 0, temp_complex_2.a, temp_complex_2.b, 1, 1, (build_dir - 1) * 60, c_white, 0.5)
				}
			}
		}
		//Vista previo edificios no arrastrables
		else{
			var temp_complex_2 = abtoxy(mx, my)
			draw_sprite_ext(edificio_sprite[build_index], 0, temp_complex_2.a, temp_complex_2.b, 1, 1, build_dir * 60, c_white, 0.5)
			//Visión previa taladro
			if in(edificio_nombre[build_index], "Taladro", "Taladro electrico"){
				for(var a = 0; a < rss_max; a++){
					temp_array[a] = 0
					temp_array_2[a] = 0
				}
				var b = 0
				for(var a = 0; a < ds_list_size(build_list); a++){
					temp_complex_2 = ds_list_find_value(build_list, a)
					if temp_complex_2.a >= 0 and temp_complex_2.b >= 0 and temp_complex_2.a < xsize and temp_complex_2.b < ysize{
						var temp_terreno_2 = terreno[temp_complex_2.a, temp_complex_2.b]
						if temp_terreno_2.ore >= 0{
							temp_array[ore_recurso[temp_terreno_2.ore]]++
							temp_array_2[ore_recurso[temp_terreno_2.ore]] += temp_terreno_2.ore_amount
							b++
						}
					}
				}
				var temp_text = ""
				for(var a = 0; a < rss_max; a++)
					if temp_array[a] > 0
						temp_text += rss_name[a] + ": " + string(temp_array_2[a]) + "(" + string(temp_array[a] * 100 / b) + "%)\n"
				if temp_text = ""
					temp_text = "Necesita recursos"
				draw_text(mouse_x + 20, mouse_y, temp_text)
			}
			//Vista previa Cables
			else if edificio_electricidad[build_index]
				draw_circle(temp_complex_2.a, temp_complex_2.b, 100, true)
		}
		//Construir
		function f1(build_index, build_dir, mx, my){
			var flag = true, flag_2 = false, build_list = get_size(mx, my, build_dir, edificio_size[build_index]), temp_edificio
			for(var a = 0; a < ds_list_size(build_list); a++){
				var temp_complex_2 = ds_list_find_value(build_list, a)
				var aa = temp_complex_2.a
				var bb = temp_complex_2.b
				var temp_terreno = terreno[aa, bb]
				//Checkear coliciones
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize or (temp_terreno.edificio_bool and not (edificio_camino[build_index] and temp_terreno.edificio.index = build_index)) or in(temp_terreno.terreno, 2){
					flag = false
					break
				}
				//Reemplazar caminos
				if temp_terreno.edificio_bool and edificio_camino[build_index] and temp_terreno.edificio.index = build_index
					delete_edificio(temp_terreno.edificio)
				//Checkear minerales
				if in(edificio_nombre[build_index], "Taladro", "Taladro electrico") and temp_terreno.ore >= 0
					flag_2 = true
			}
			if in(edificio_nombre[build_index], "Taladro", "Taladro electrico") and not flag_2
				flag = false
			if flag{
				if edificio_nombre[build_index] = "Tunel" and build_able
					build_index = 12
				temp_edificio = add_edificio(build_index, build_dir, mx, my)
			}
			//Algoritmo link de tuneles
			if edificio_nombre[build_index] = "Tunel"{
				temp_edificio.idle = not build_able
				if build_able{
					if not build_target.idle{
						build_target.link.idle = true
						ds_list_remove(build_target.outputs, build_target.link)
						ds_list_remove(build_target.link.inputs, build_target)
					}
					build_target.idle = false
					ds_list_add(temp_edificio.inputs, build_target)
					ds_list_add(build_target.outputs, temp_edificio)
					temp_edificio.link = build_target
					build_target.link = temp_edificio
					if build_target.waiting
						mover(build_target)
				}
			}
		}
		if mouse_check_button_released(mb_left) and not temp_terreno.edificio_bool and flag{
			f1(build_index, build_dir, mx, my)
			if not keyboard_check(vk_lshift)
				build_index = 0
		}
	}
}
//Romper
else if ((mouse_check_button(mb_right) and prev_change) or mouse_check_button_pressed(mb_right)) and temp_hexagono != noone and temp_terreno.edificio_bool and temp_edificio.index != 0
	delete_edificio(temp_edificio)
//Ciclo edificios
for(var a = 0; a < ds_list_size(edificios); a++){
	temp_edificio = ds_list_find_value(edificios, a)
	if not temp_edificio.idle{
		//Accion taladro
		if in(edificio_nombre[temp_edificio.index], "Taladro", "Taladro electrico") and temp_edificio.carga_total < edificio_carga_max[temp_edificio.index]{
			if in(edificio_nombre[temp_edificio.index], "Taladro electrico") and temp_edificio.red.generacion < temp_edificio.red.consumo and temp_edificio.red.bateria = 0
				temp_edificio.proceso += temp_edificio.red.generacion / temp_edificio.red.consumo
			else
				temp_edificio.proceso++
			if temp_edificio.proceso >= edificio_proceso[temp_edificio.index]{
				temp_edificio.proceso = 0
				var temp_list = ds_list_create(), temp_complex_2 = {a : 0, b : 0}
				flag = false
				ds_list_copy(temp_list, temp_edificio.coordenadas)
				ds_list_shuffle(temp_list)
				while not ds_list_empty(temp_list){
					temp_complex_2 = ds_list_find_value(temp_list, 0)
					temp_terreno = terreno[temp_complex_2.a, temp_complex_2.b]
					ds_list_delete(temp_list, 0)
					if temp_terreno.ore >= 0{
						temp_edificio.carga[ore_recurso[temp_terreno.ore]]++
						temp_edificio.carga_total++
						temp_terreno.ore_amount--
						if temp_terreno.ore_amount = 0{
							temp_terreno.ore = -1
							background = spr_hexagono
						}
						flag = true
						break
					}
				}
				ds_list_destroy(temp_list)
				if flag
					temp_edificio.waiting = not mover(temp_edificio)
				else{
					temp_edificio.idle = true
					temp_edificio.red.consumo -= abs(edificio_elec_consumo[temp_edificio.index])
				}
			}
		}
		//Accion caminos
		if (edificio_camino[temp_edificio.index] or edificio_nombre[temp_edificio.index] = "Tunel") and temp_edificio.carga_total > 0{
			temp_edificio.proceso++
			if temp_edificio.proceso = 20{
				temp_edificio.proceso = 0
				temp_edificio.waiting = not mover(temp_edificio)
			}
		}
		//Acción horno
		if edificio_nombre[temp_edificio.index] = "Horno" and (temp_edificio.carga[0] > 0 or temp_edificio.carga[3] > 0) and (temp_edificio.carga[1] > 0 or temp_edificio.fuel > 0){
			if temp_edificio.fuel > 0
				temp_edificio.fuel--
			if temp_edificio.carga[2] < 2 and temp_edificio.carga[4] < 2{
				if temp_edificio.fuel = 0{
					temp_edificio.fuel = rss_comb_time[1]
					temp_edificio.carga[1]--
					temp_edificio.carga_total--
				}
				temp_edificio.proceso++
				if temp_edificio.proceso = edificio_proceso[temp_edificio.index]{
					temp_edificio.proceso = 0
					if temp_edificio.carga[3] > 0{
						temp_edificio.carga[3]--
						temp_edificio.carga[4]++
					}
					else{
						temp_edificio.carga[0]--
						temp_edificio.carga[2]++
					}
					temp_edificio.waiting = not mover(temp_edificio)
				}
			}
		}
		//Acción generador
		if edificio_nombre[temp_edificio.index] = "Generador"{
			if temp_edificio.fuel > 0
				temp_edificio.fuel--
			if temp_edificio.fuel = 0{
				temp_edificio.red.generacion -= temp_edificio.energy_output
				temp_edificio.energy_output = 0
				if temp_edificio.carga[1] > 0{
					temp_edificio.energy_output = abs(edificio_elec_consumo[temp_edificio.index])
					temp_edificio.red.generacion += temp_edificio.energy_output
					temp_edificio.fuel = rss_comb_time[1]
					temp_edificio.carga[1]--
					temp_edificio.carga_total--
					mover(temp_edificio)
				}
			}
		}
	}
}
//Ciclo de redes
for(var a = 0; a < ds_list_size(redes); a++){
	var temp_red = ds_list_find_value(redes, a)
	temp_red.bateria = min(max(temp_red.bateria + (temp_red.generacion - temp_red.consumo) / 30, 0), temp_red.bateria_max)
}
if keyboard_check_pressed(ord("R"))
	game_restart()
if keyboard_check(ord("L")){
	var temp_text = ""
	for(var a = 0; a < ds_list_size(redes); a++){
		draw_set_color(make_color_hsv(a * 40, 255, 255))
		var temp_red = ds_list_find_value(redes, a)
		temp_text += "Red " + string(a) + ":\n"
		temp_text += "  Consumo: " + string(temp_red.consumo) + "\n"
		temp_text += "  Generacion: " + string(temp_red.generacion) + "\n"
		temp_text += "  Bateria: " + string(temp_red.bateria) + "/" + string(temp_red.bateria_max) + "\n"
		temp_text += "  Edificios:\n"
		for(var b = 0; b < ds_list_size(temp_red.edificios); b++){
			temp_edificio = ds_list_find_value(temp_red.edificios, b)
			temp_text += "    " + string(edificio_nombre[temp_edificio.index]) + "\n"
			var temp_complex = abtoxy(temp_edificio.a, temp_edificio.b)
			for(var c = 0; c < ds_list_size(temp_edificio.energy_link); c++){
				var temp_edificio_2 = ds_list_find_value(temp_edificio.energy_link, c)
				var temp_complex_2 = abtoxy(temp_edificio_2.a, temp_edificio_2.b)
				draw_line(temp_complex.a, temp_complex.b, temp_complex_2.a, temp_complex_2.b)
			}
		}
	}
	draw_set_color(c_white)
	draw_text(0, 20, temp_text)
}