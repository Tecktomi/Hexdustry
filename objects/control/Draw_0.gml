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
				draw_sprite(ore_sprite[temp_terreno.ore], temp_terreno.ore_random + 2 * (temp_terreno.ore_amount < 50), temp_complex.a, temp_complex.b)
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
			var temp_edificio = terreno[a, b].edificio
			var temp_complex = abtoxy(a, b)
			var aa = temp_complex.a
			var bb = temp_complex.b
			//Dibujo caminos
			if edificio_camino[temp_edificio.index] or edificio_nombre[temp_edificio.index] = "Tunel"{
				if in(edificio_nombre[temp_edificio.index], "Selector", "Overflow")
					draw_sprite_off(edificio_sprite[temp_edificio.index], real(temp_edificio.mode), aa, bb, , , (temp_edificio.dir - 1) * 60)
				else if in(edificio_nombre[temp_edificio.index], "Cinta transportadora", "Enrutador"){
					if (temp_edificio.dir mod 3) = 1
						draw_sprite_off(edificio_sprite[temp_edificio.index], image_index / 4, aa, bb, , power(-1, temp_edificio.dir > 1))
					else
						draw_sprite_off(edificio_sprite_2[temp_edificio.index], image_index / 4, aa, bb, power(-1, ((temp_edificio.dir + 1) mod 6) > 1), power(-1, temp_edificio.dir > 2))
				}
				else
					draw_sprite_off(edificio_sprite[temp_edificio.index], image_index / 4, aa, bb, , , (temp_edificio.dir - 1) * 60)
				if edificio_nombre[temp_edificio.index] = "Selector" and temp_edificio.select >= 0
					draw_sprite_off(edificio_sprite_2[temp_edificio.index], image_index / 4, aa, bb, , , (temp_edificio.dir - 1) * 60, rss_item_color[temp_edificio.select])
			}
			else{
				//Dibujo edificios con horno
				if in(edificio_nombre[temp_edificio.index], "Horno", "Generador") and temp_edificio.fuel > 0
					draw_sprite_off(edificio_sprite_2[temp_edificio.index], image_index / 4, aa, bb, power(-1, temp_edificio.dir))
				//Dibujo de bateria
				else if in(edificio_nombre[temp_edificio.index], "Bateria")
					draw_sprite_off(edificio_sprite[temp_edificio.index], floor(10 * temp_edificio.red.bateria / temp_edificio.red.bateria_max), aa, bb, , , temp_edificio.dir * 60)
				//Dibujo bomba
				else if in(edificio_nombre[temp_edificio.index], "Bomba hidraulica"){
					draw_sprite_off(edificio_sprite[temp_edificio.index], 0, aa , bb , power(-1, temp_edificio.dir))
					draw_sprite_off(spr_bomba_rotor, 1, aa + power(-1, temp_edificio.dir) * 8, bb + 14 , , , image_index)
					draw_sprite_off(spr_bomba_cupula, 1, aa + power(-1, temp_edificio.dir) * 8, bb + 14)
				}
				//Dibujo 2x2
				else if edificio_size[temp_edificio.index] mod 2 = 0
					draw_sprite_off(edificio_sprite[temp_edificio.index], image_index / 4, aa, bb, power(-1, temp_edificio.dir))
				//Dibujo predeterminado
				else
					draw_sprite_off(edificio_sprite[temp_edificio.index], image_index / 4, aa, bb, , , temp_edificio.dir * 60)
			}
			//Dibujo estados
			if info{
				if temp_edificio.waiting{
					draw_set_color(c_yellow)
					draw_circle_off(aa , bb , 4, false)
				}
				if temp_edificio.idle{
					draw_set_color(c_red)
					draw_circle_off(aa , bb + 8 , 4, false)
				}
			}
		}
	}
//Dibujo items
for(var a = 0; a < xsize; a++)
	for(var b = 0; b < ysize; b++){
		var temp_terreno = terreno[a, b]
		var temp_edificio = terreno[a, b].edificio
		var temp_complex = abtoxy(a, b)
		var aa = temp_complex.a
		var bb = temp_complex.b
		if temp_terreno.edificio_draw{
			//Dibujo de items en los caminos
			if (edificio_camino[temp_edificio.index] or temp_edificio.index = 6) and temp_edificio.carga_total > 0{
				var c = 1.2 * (max(temp_edificio.proceso, temp_edificio.waiting * 20) - 10)
				var d = temp_edificio.dir * pi / 3 + pi / 6
				draw_sprite_off(rss_item_sprite[temp_edificio.carga_id], 0, aa + c * cos(d) , bb - c * sin(d))
			}
			//Dibujo de items en los caminos
			if temp_edificio.index = 16 and temp_edificio.carga_total > 0{
				var c = 1.2 * (max(temp_edificio.proceso, temp_edificio.waiting * 20) - 10)
				var d = temp_edificio.dir * pi / 3 + pi / 6
				draw_sprite_off(rss_item_sprite[temp_edificio.carga_id], 0, aa - c * cos(d) , bb + c * sin(d))
			}
			//Dibujo de los links eléctricos
			else if edificio_electricidad[temp_edificio.index]{
				draw_set_color(c_yellow)
				for(var c = 0; c < ds_list_size(temp_edificio.energy_link); c++){
					var temp_edificio_2 = ds_list_find_value(temp_edificio.energy_link, c)
					var temp_complex_2 = abtoxy(temp_edificio.a, temp_edificio.b)
					var temp_complex_3 = abtoxy(temp_edificio_2.a, temp_edificio_2.b)
					draw_line_off(temp_complex_2.a , temp_complex_2.b , temp_complex_3.a , temp_complex_3.b)
				}
			}
		}
	}
var flag = true, xmouse = (mouse_x + camx) / zoom, ymouse = (mouse_y + camy) / zoom
//Seleccionar recurso
if show_menu{
	var aa = abtoxy(show_menu_build.a, show_menu_build.b).a * zoom - camx
	var bb = abtoxy(show_menu_build.a, show_menu_build.b).b * zoom - camy
	draw_set_color(c_gray)
	draw_triangle(aa - 10 * zoom, bb + 20 * zoom, aa + 10 * zoom, bb + 20 * zoom, aa, bb + 10 * zoom, false)
	draw_rectangle(aa - 80 * zoom, bb + 20 * zoom, aa + 80 * zoom, bb + 40 * zoom, false)
	if in(edificio_nombre[show_menu_build.index], "Selector")
		draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 28 * ceil(rss_max / 5)) * zoom, false)
	draw_set_color(c_dkgray)
	draw_triangle(aa - 10 * zoom, bb + 20 * zoom, aa + 10 * zoom, bb + 20 * zoom, aa, bb + 10 * zoom, true)
	draw_rectangle(aa - 80 * zoom, bb + 20 * zoom, aa + 80 * zoom, bb + 40 * zoom, true)
	if in(edificio_nombre[show_menu_build.index], "Selector")
		draw_rectangle(aa - 80 * zoom, bb + 40 * zoom, aa + 80 * zoom, bb + (40 + 28 * ceil(rss_max / 5)) * zoom, true)
	draw_text(aa - 80 * zoom, bb + 20 * zoom, "INVERTIR")
	if in(edificio_nombre[show_menu_build.index], "Selector")
		for(var a = 0; a < rss_max; a++)
			draw_sprite_stretched(rss_item_sprite[a], 0, aa + (-80 + 32 * (a mod 5)) * zoom, bb + (40 + 28 * floor(a / 5)) * zoom, 32 * zoom, 28 * zoom)
	if mouse_x > aa - 80 * zoom and mouse_y > bb + 20 * zoom and mouse_x < aa + 80 * zoom{
		if mouse_y < bb + 40 * zoom{
			flag = false
			if mouse_check_button_pressed(mb_left){
				mouse_clear(mb_left)
				show_menu = false
				show_menu_build.mode = not show_menu_build.mode
			}
		}
		else if mouse_y < bb + (40 + 28 * ceil(rss_max / 5)) * zoom and in(edificio_nombre[show_menu_build.index], "Selector"){
			flag = false
			var a = floor((mouse_x - (aa - 80 * zoom)) / (32 * zoom)) + 5 * floor((mouse_y - (bb + 40 * zoom)) / (28 * zoom))
			if a >= 0 and a < rss_max{
				draw_set_color(c_gray)
				draw_rectangle(mouse_x, mouse_y, mouse_x + string_width(rss_name[a]), mouse_y + string_height(rss_name[a]), false)
				draw_set_color(c_white)
				draw_text(mouse_x, mouse_y, rss_name[a])
				if mouse_check_button_pressed(mb_left){
					mouse_clear(mb_left)
					show_menu = false
					show_menu_build.select = a
				}
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
var temp_terreno = terreno[mx, my]
var temp_edificio = temp_terreno.edificio
var temp_coordenada = temp_edificio.coordenadas
//Mostrar detalles de edificios al pasar el mouse_por encima
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
				show_menu_x = abtoxy(temp_edificio.a, temp_edificio.b).a * zoom
				show_menu_y = abtoxy(temp_edificio.a, temp_edificio.b).b * zoom
			}
		}
		temp_text += edificio_nombre[temp_edificio.index] + "\n"
		if info{
			//Mostrar inputs
			draw_set_color(c_blue)
			var temp_complex = abtoxy(temp_edificio.a, temp_edificio.b)
			for(var a = 0; a < ds_list_size(temp_edificio.inputs); a++){
				var temp_edificio_2 = ds_list_find_value(temp_edificio.inputs, a)
				var temp_complex_2 = abtoxy(temp_edificio_2.a, temp_edificio_2.b)
				draw_arrow_off(temp_complex_2.a, temp_complex_2.b, temp_complex.a, temp_complex.b, 12)
			}
			//Mostrar outputs
			draw_set_color(c_red)
			temp_complex = abtoxy(temp_edificio.a, temp_edificio.b)
			for(var a = 0; a < ds_list_size(temp_edificio.outputs); a++){
				var temp_edificio_2 = ds_list_find_value(temp_edificio.outputs, a)
				var temp_complex_2 = abtoxy(temp_edificio_2.a, temp_edificio_2.b)
				draw_arrow_off(temp_complex.a, temp_complex.b, temp_complex_2.a, temp_complex_2.b, 12)
			}
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
					var temp_complex = ds_list_find_value(temp_edificio.coordenadas, a)
					var temp_terreno_2 = terreno[temp_complex.a, temp_complex.b]
					if temp_terreno_2.ore >= 0
						temp_array[ore_recurso[temp_terreno_2.ore]] += temp_terreno_2.ore_amount
					else if terreno_rss[temp_terreno_2.terreno] and in(edificio_nombre[temp_edificio.index], "Taladro electrico")
						temp_array[terreno_rss_id[temp_terreno_2.terreno]] = -1
				}
				for(var a = 0; a < rss_max; a++)
					if temp_array[a] > 0
						temp_text_2 += "  " + rss_name[a] + ": " + string(temp_array[a]) + "\n"
					else if temp_array[a] = -1
						temp_text_2 += "  " + rss_name[a] + "\n"
				if temp_text_2 != ""
					temp_text += "Recursos disponibles:\n" + temp_text_2
			}
		//Mostrar combustión
		if in(edificio_nombre[temp_edificio.index], "Horno", "Generador")
			temp_text += "Combustion: " + string(floor(temp_edificio.fuel / 30)) + "[s]\n"
		//Mostrar inputs
		if edificio_receptor[temp_edificio.index]{
			if edificio_input_all[temp_edificio.index]
				temp_text += "Acepta todo\n"
			else{
				var temp_text_2 = ""
				for(var a = 0; a < rss_max; a++)
					if temp_edificio.carga_max[a] > 0
						temp_text_2 += "  " + rss_name[a] + ": " + string(temp_edificio.carga_max[a]) + "\n"
				if temp_text_2 != ""
					temp_text += "Acepta:\n" + temp_text_2
			}
		}
		//Mostrar outputs
		if edificio_emisor[temp_edificio.index]{
			if edificio_output_all[temp_edificio.index]
				temp_text += "Entrega todo\n"
			else{
				var temp_text_2 = ""
				for(var a = 0; a < rss_max; a++)
					if temp_edificio.carga_output[a]
						temp_text_2 += "  " + rss_name[a] + "\n"
				if temp_text_2 != ""
					temp_text += "Entrega:\n" + temp_text_2
			}
		}
		//Mostrar red electrica
		if edificio_electricidad[temp_edificio.index]{
			var temp_red = temp_edificio.red
			if edificio_elec_consumo[temp_edificio.index] > 0 and temp_red.consumo > temp_red.generacion and temp_red.bateria = 0
				temp_text += "Funcionando al " + string(floor(100 * temp_red.generacion / temp_red.consumo)) + "% de su capacidad\n"
			temp_text += "Red " + string(ds_list_find_index(redes, temp_red)) + "\n"
			temp_text += "  Consumo: " + string(temp_red.consumo) + "\n"
			temp_text += "  Generacion: " + string(temp_red.generacion) + "\n"
			temp_text += "  Bateria: " + string(floor(temp_red.bateria)) + "/" + string(temp_red.bateria_max) + "\n"
			temp_text += "  Edificios:\n"
			if info
				for(var a = 0; a < ds_list_size(temp_red.edificios); a++){
					var temp_edificio_2 = ds_list_find_value(temp_red.edificios, a)
					temp_text += "    " + string(edificio_nombre[temp_edificio_2.index]) + "\n"
				}
			for(var a = 0; a < ds_list_size(temp_edificio.energy_link); a++){
				var temp_edificio_2 = ds_list_find_value(temp_edificio.energy_link, a)
				draw_set_color(c_red)
				var temp_complex_2 = abtoxy(temp_edificio.a, temp_edificio.b)
				var temp_complex_3 = abtoxy(temp_edificio_2.a, temp_edificio_2.b)
				draw_line_off(temp_complex_2.a, temp_complex_2.b, temp_complex_3.a, temp_complex_3.b)
			}
		}
		temp_text += "___________________\n"
	}
	draw_set_color(c_white)
	draw_text(0, 0, temp_text)
}
flag = false
//Menu de edificios cerrado
if build_menu = 0{
	draw_set_color(c_ltgray)
	draw_rectangle(room_width/2 - 100, room_height - 20, room_width/2 + 100, room_height, false)
	draw_set_color(c_black)
	draw_rectangle(room_width/2 - 100, room_height - 20, room_width/2 + 100, room_height, true)
	if mouse_x > room_width/2 - 100 and mouse_y > room_height - 20 and mouse_x < room_width/2 + 100 and mouse_y < room_height
		build_menu = 100
}
//Menu de edificios abierto
else{
	build_menu--
	draw_set_color(c_ltgray)
	draw_rectangle(0, room_height - 40, room_width, room_height, false)
	draw_set_color(c_black)
	draw_rectangle(0, room_height - 40, room_width, room_height, true)
	if mouse_x > 0 and mouse_y > room_height - 40 and mouse_x < room_width and mouse_y < room_height
		build_menu = 100
	for(var a = 1; a < edificio_max; a++)
		if not in(a, 16, 17){
			draw_sprite_stretched(edificio_sprite[a], 0, a * 40 + 5, room_height - 35, 30, 30)
			draw_rectangle(a * 40 + 5, room_height - 35, a * 40 + 35, room_height - 5, true)
			if mouse_x > a * 40 + 5 and mouse_y > room_height - 35 and mouse_x < a * 40 + 35 and mouse_y < room_height - 5{
				draw_set_color(c_ltgray)
				var temp_text = edificio_nombre[a] + " (" + chr(edificio_key[a]) + ")\n"
				for(var b = 0; b < array_length(edificio_precio_index[a]); b++)
					if edificio_precio_num[a, b] > 0
						temp_text += rss_name[edificio_precio_index[a, b]] + ": " + string(edificio_precio_num[a, b]) + "\n"
				draw_rectangle(mouse_x, room_height - 40 - string_height(temp_text), mouse_x + string_width(temp_text), room_height - 40, false)
				draw_set_color(c_black)
				draw_text(mouse_x, room_height - 40 - string_height(temp_text), temp_text)
				if mouse_check_button_pressed(mb_left){
					mouse_clear(mb_left)
					build_index = a
					build_menu = 0
					flag = true
				}
			}
		}
}
//Acceso directo
if keyboard_check_pressed(vk_anykey) and (not keyboard_check_pressed(ord("M")) or cheat)
	for(var a = 1; a < edificio_max; a++)
		if real(keyboard_lastkey) = edificio_key[a]{
			keyboard_clear(keyboard_lastkey)
			build_index = a
			flag = true
		}
//Cacelar construccion o cerrar menu
if (mouse_check_button_pressed(mb_right) or keyboard_check_pressed(vk_escape)) and (build_index > 0 or show_menu){
	mouse_clear(mb_right)
	build_index = 0
	show_menu = false
}
//Vista previa y construcción
if build_index > 0{
	if flag and not edificio_rotable[build_index]
		build_dir = 0
	if flag and edificio_size[build_index] mod 2 = 0
		build_dir = 5 * (build_dir mod 2)
	//Rotar
	if mouse_wheel_up() and edificio_rotable[build_index] and not keyboard_check(vk_lcontrol){
		if edificio_size[build_index] mod 2 = 0
			build_dir = 5 - build_dir
		else
			build_dir = (build_dir + 1) mod 6
		flag = true
	}
	if mouse_wheel_down() and edificio_rotable[build_index] and not keyboard_check(vk_lcontrol){
		if edificio_size[build_index] mod 2 = 0
			build_dir = 5 - build_dir
		else
			build_dir = build_dir - 1 + 6 * (build_dir = 0)
		flag = true
	}
	if last_mx != mx or last_my != my or flag{
		build_list = get_size(mx, my, build_dir, edificio_size[build_index])
		show_menu = false
	}
	last_mx = mx
	last_my = my
	var comprable = true
	if not cheat
		for(var a = 0; a < array_length(edificio_precio_index[build_index]); a++)
			if nucleo.carga[edificio_precio_index[build_index, a]] < edificio_precio_num[build_index, a]{
				comprable = false
				break
			}
	if temp_hexagono != noone{
		var temp_array, temp_array_2, temp_text = ""
		if not comprable{
			temp_text += "Recursos insuficientes\n"
			for(var a = 0; a < array_length(edificio_precio_index[build_index]); a++)
				if nucleo.carga[edificio_precio_index[build_index, a]] < edificio_precio_num[build_index, a]
					temp_text += "  " + rss_name[edificio_precio_index[build_index, a]] + " " + string(nucleo.carga[edificio_precio_index[build_index, a]]) + "/" + string(edificio_precio_num[build_index, a]) + "\n"
			for(var a = 0; a < ds_list_size(build_list); a++){
				var temp_complex_2 = ds_list_find_value(build_list, a)
				var temp_complex_3 = abtoxy(temp_complex_2.a, temp_complex_2.b)
				draw_sprite_off(spr_rojo, 0, temp_complex_3.a, temp_complex_3.b, , , , , 0.5)
			}
		}
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
				if not in(edificio_nombre[build_index], "Cinta transportadora", "Enrutador")
					draw_sprite_off(edificio_sprite[build_index], 0, temp_complex_2.a, temp_complex_2.b, , , (build_dir - 1) * 60, , 0.5)
				else{
					if (build_dir mod 3) = 1
						draw_sprite_off(edificio_sprite[build_index], image_index / 4, temp_complex_2.a, temp_complex_2.b, , power(-1, build_dir > 1), , , 0.5)
					else
						draw_sprite_off(edificio_sprite_2[build_index], image_index / 4, temp_complex_2.a, temp_complex_2.b, power(-1, ((build_dir + 1) mod 6) > 1), power(-1, build_dir > 2), , , 0.5)
				}
				ds_list_add(pre_build_list, {a : mx_clic, b : my_clic})
				if mx_clic != mx or my_clic != my{
					var angle = radtodeg((arctan2(temp_complex_2.b * zoom - camy - mouse_y, mouse_x - temp_complex_2.a * zoom + camx) + 2 * pi) mod (2 * pi))
					build_dir = floor(angle / 60)
					var a = mx_clic, b = my_clic, temp_complex_3
					do{
						temp_complex_3 = next_to(a, b, build_dir)
						ds_list_add(pre_build_list, temp_complex_3)
						a = temp_complex_3.a
						b = temp_complex_3.b
						temp_complex_3 = abtoxy(temp_complex_3.a, temp_complex_3.b)
						if not in(edificio_nombre[build_index], "Cinta transportadora", "Enrutador")
							draw_sprite_off(edificio_sprite[build_index], 0, temp_complex_3.a, temp_complex_3.b, , , (build_dir - 1) * 60, , 0.5)
						else{
							if (build_dir mod 3) = 1
								draw_sprite_off(edificio_sprite[build_index], image_index / 4, temp_complex_3.a, temp_complex_3.b, , power(-1, build_dir > 1), , , 0.5)
							else
								draw_sprite_off(edificio_sprite_2[build_index], image_index / 4, temp_complex_3.a, temp_complex_3.b, power(-1, ((build_dir + 1) mod 6) > 1), power(-1, build_dir > 2), , , 0.5)
						}
					}
					until(temp_complex_3.a < min(xmouse, temp_complex_2.a) or
						temp_complex_3.a > max(xmouse, temp_complex_2.a) or
						temp_complex_3.b < min(ymouse, temp_complex_2.b) or
						temp_complex_3.b > max(ymouse, temp_complex_2.b))
				}
			}
			//Mostrar caminos solos
			else{
				var temp_complex = next_to(mx, my, build_dir)
				var temp_complex_2 = abtoxy(mx, my)
				var temp_complex_3 = abtoxy(temp_complex.a, temp_complex.b)
				draw_set_color(c_black)
				draw_arrow_off(temp_complex_2.a, temp_complex_2.b, temp_complex_3.a, temp_complex_3.b, 8)
				if not in(edificio_nombre[build_index], "Cinta transportadora", "Enrutador"){
					draw_sprite_off(edificio_sprite[build_index], 0, temp_complex_2.a, temp_complex_2.b, , , (build_dir - 1) * 60, , 0.5)
					temp_complex = next_to(mx, my, (build_dir + 1) mod 6)
					temp_complex_3 = abtoxy(temp_complex.a, temp_complex.b)
					draw_arrow_off(temp_complex_2.a, temp_complex_2.b, temp_complex_3.a, temp_complex_3.b, 8)
					temp_complex = next_to(mx, my, (build_dir + 5) mod 6)
					temp_complex_3 = abtoxy(temp_complex.a, temp_complex.b)
					draw_arrow_off(temp_complex_2.a, temp_complex_2.b, temp_complex_3.a, temp_complex_3.b, 8)
				}
				else{
					if (build_dir mod 3) = 1
						draw_sprite_off(edificio_sprite[build_index], image_index / 4, temp_complex_2.a, temp_complex_2.b, , power(-1, build_dir > 1), , , 0.5)
					else
						draw_sprite_off(edificio_sprite_2[build_index], image_index / 4, temp_complex_2.a, temp_complex_2.b, power(-1, ((build_dir + 1) mod 6) > 1), power(-1, build_dir > 2), , , 0.5)
				}
			}
			//Construir en cadena
			if mouse_check_button_released(mb_left){
				flag = false
				for(var a = 0; a < ds_list_size(pre_build_list); a++){
					comprable = true
					if not cheat
						for(var b = 0; b < array_length(edificio_precio_index[build_index]); b++)
							if nucleo.carga[edificio_precio_index[build_index, b]] < edificio_precio_num[build_index, b]{
								comprable = false
								break
							}
					if comprable{
						var temp_complex_2 = ds_list_find_value(pre_build_list, a)
						f1(build_index, build_dir, temp_complex_2.a, temp_complex_2.b)
					}
				}
				if not keyboard_check(vk_lshift)
					build_index = 0
			}
		}
		//Vista previa tuneles
		else{
			if edificio_nombre[build_index] = "Tunel"{
				var temp_complex_2 = abtoxy(mx, my), flag_2 = false
				draw_sprite_off(edificio_sprite[build_index], 0, temp_complex_2.a, temp_complex_2.b, , , (build_dir - 1) * 60, , 0.5)
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
						if edificio_nombre[temp_edificio_2.index] = "Tunel" and temp_edificio_2.dir = (build_dir + 3) mod 6{
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
						draw_sprite_off(spr_tunel_view, 0, temp_complex_2.a, temp_complex_2.b, , , (build_dir - 1) * 60, , 0.5)
					}
				}
			}
			//Vista previo edificios no arrastrables
			else{
				var temp_complex_2 = abtoxy(mx, my)
				if edificio_size[build_index] mod 2 = 0
					draw_sprite_off(edificio_sprite[build_index], 0, temp_complex_2.a, temp_complex_2.b, power(-1, build_dir), , , , 0.5)
				else
					draw_sprite_off(edificio_sprite[build_index], 0, temp_complex_2.a, temp_complex_2.b, , , build_dir * 60, , 0.5)
				//Visión previa taladro
				if in(edificio_nombre[build_index], "Taladro", "Taladro electrico"){
					for(var a = 0; a < rss_max; a++){
						temp_array[a] = 0
						temp_array_2[a] = 0
					}
					var b = 0
					for(var a = 0; a < ds_list_size(build_list); a++){
						var temp_complex_3 = ds_list_find_value(build_list, a)
						var aa = temp_complex_3.a, bb = temp_complex_3.b
						if aa >= 0 and bb >= 0 and aa < xsize and bb < ysize{
							var temp_terreno_2 = terreno[aa, bb]
							if temp_terreno_2.ore >= 0{
								temp_array[ore_recurso[temp_terreno_2.ore]]++
								temp_array_2[ore_recurso[temp_terreno_2.ore]] += temp_terreno_2.ore_amount
								b++
							}
							else if terreno_rss[temp_terreno_2.terreno] and in(edificio_nombre[build_index], "Taladro electrico"){
								temp_array[terreno_rss_id[temp_terreno_2.terreno]]++
								temp_array_2[terreno_rss_id[temp_terreno_2.terreno]] = -1
								b++
							}
						}
					}
					var flag_2 = false
					for(var a = 0; a < rss_max; a++){
						if temp_array_2[a] > 0{
							flag_2 = true
							temp_text += rss_name[a] + ": " + string(temp_array_2[a]) + "(" + string(temp_array[a] * 100 / b) + "%)\n"
						}
						else if temp_array_2[a] = -1{
							flag_2 = true
							temp_text += rss_name[a] + "(" + string(temp_array[a] * 100 / b) + "%)\n"
						}
					}
					for(var a = 0; a < ds_list_size(build_list); a++){
						temp_complex_2 = ds_list_find_value(build_list, a)
						if temp_complex_2.a < xsize and temp_complex_2.b < ysize and in(terreno_name[terreno[temp_complex_2.a, temp_complex_2.b].terreno], "Agua", "Agua profunda"){
							flag_2 = false
							break
						}
					}
					if not flag_2
						temp_text += "Terreno invalido"
				}
				if in(edificio_nombre[build_index], "Bomba hidraulica"){
					var flag_2 = true
					for(var a = 0; a < ds_list_size(build_list); a++){
						var temp_complex_3 = ds_list_find_value(build_list, a)
						var aa = temp_complex_3.a, bb = temp_complex_3.b
						if aa >= 0 and bb >= 0 and aa < xsize and bb < ysize{
							var temp_terreno_2 = terreno[aa, bb]
							if not in(terreno_name[temp_terreno_2.terreno], "Agua", "Agua profunda"){
								flag_2 = false
								break
							}
						}
					}
					if not flag_2
						temp_text += "Debe ser construido sobre agua"
				}
				//Vista previa Cables
				if in(edificio_nombre[build_index], "Cable")
					draw_circle_off(temp_complex_2.a, temp_complex_2.b, 90, true)
			}
			draw_text(mouse_x + 20, mouse_y, temp_text)
			if mouse_check_button_pressed(mb_left) and not temp_terreno.edificio_bool and flag and comprable{
				f1(build_index, build_dir, mx, my)
				if not keyboard_check(vk_lshift)
					build_index = 0
			}
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
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize or (temp_terreno.edificio_bool and not (edificio_camino[build_index] and edificio_camino[temp_terreno.edificio.index])) or (not in(edificio_nombre[build_index], "Bomba hidraulica") and in(terreno_name[temp_terreno.terreno], "Agua", "Agua profunda")){
					flag = false
					break
				}
				//Reemplazar caminos
				if temp_terreno.edificio_bool and edificio_camino[build_index] and edificio_camino[temp_terreno.edificio.index]
					delete_edificio(aa, bb)
				//Checkear minerales
				if in(edificio_nombre[build_index], "Taladro", "Taladro electrico") and temp_terreno.ore >= 0
					flag_2 = true
				//Checkear minerales
				if in(edificio_nombre[build_index], "Taladro electrico") and terreno_rss[temp_terreno.terreno]
					flag_2 = true
				//Checkear agua
				if in(edificio_nombre[build_index], "Bomba hidraulica") and not in(terreno_name[temp_terreno.terreno], "Agua", "Agua profunda")
					flag = false
			}
			if in(edificio_nombre[build_index], "Taladro", "Taladro electrico") and not flag_2
				flag = false
			if edificio_nombre[build_index] = "Tunel" and build_able and build_target.index = 6
				build_index = 16
			if flag
				temp_edificio = add_edificio(build_index, build_dir, mx, my)
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
				for(var a = 0; a < array_length(edificio_precio_index[build_index]); a++){
					nucleo.carga[edificio_precio_index[build_index, a]] -= edificio_precio_num[build_index, a]
					nucleo.carga_total -= edificio_precio_num[build_index, a]
				}
		}
	}
}
//Romper
else if ((mouse_check_button(mb_right) and prev_change) or mouse_check_button_pressed(mb_right)) and temp_hexagono != noone and temp_terreno.edificio_bool and temp_edificio.index != 0
	delete_edificio(mx, my)
//Ciclo edificios
for(var a = 0; a < ds_list_size(edificios); a++){
	temp_edificio = ds_list_find_value(edificios, a)
	if not temp_edificio.idle{
		//Accion taladro
		if in(edificio_nombre[temp_edificio.index], "Taladro", "Taladro electrico") and temp_edificio.carga_total < edificio_carga_max[temp_edificio.index]{
			if edificio_electricidad[temp_edificio.index]{
				if temp_edificio.proceso < 0
					temp_edificio.red.consumo += abs(edificio_elec_consumo[temp_edificio.index])
				if temp_edificio.red.generacion < temp_edificio.red.consumo and temp_edificio.red.bateria = 0
					temp_edificio.proceso += temp_edificio.red.generacion / temp_edificio.red.consumo
				else
					temp_edificio.proceso++
			}
			else
				temp_edificio.proceso++
			if temp_edificio.proceso >= edificio_proceso[temp_edificio.index]{
				temp_edificio.proceso -= edificio_proceso[temp_edificio.index] + 1
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
						if temp_terreno.ore_amount = 50
							background = spr_hexagono
						else if temp_terreno.ore_amount = 0{
							temp_terreno.ore = -1
							background = spr_hexagono
						}
						flag = true
						break
					}
					else if terreno_rss[temp_terreno.terreno] and in(edificio_nombre[temp_edificio.index], "Taladro electrico"){
						temp_edificio.carga[terreno_rss_id[temp_terreno.terreno]]++
						temp_edificio.carga_total++
						flag = true
						break
					}
				}
				ds_list_destroy(temp_list)
				if flag
					temp_edificio.waiting = not mover(temp_edificio.a, temp_edificio.b)
				else
					temp_edificio.idle = true
				if edificio_electricidad[temp_edificio.index]
					temp_edificio.red.consumo -= abs(edificio_elec_consumo[temp_edificio.index])
			}
		}
		//Accion caminos
		if (edificio_camino[temp_edificio.index] or edificio_nombre[temp_edificio.index] = "Tunel") and temp_edificio.carga_total > 0 and not temp_edificio.waiting{
			temp_edificio.proceso++
			if temp_edificio.proceso = 20{
				temp_edificio.proceso = 0
				temp_edificio.waiting = not mover(temp_edificio.a, temp_edificio.b)
			}
		}
		//Acción horno
		if edificio_nombre[temp_edificio.index] = "Horno" and (temp_edificio.carga[0] > 1 or temp_edificio.carga[3] > 3 or temp_edificio.carga[5] > 7) and (temp_edificio.carga[1] > 0 or temp_edificio.fuel > 0){
			if temp_edificio.fuel > 0
				temp_edificio.fuel--
			if temp_edificio.carga[2] < 2 and temp_edificio.carga[4] < 2 and temp_edificio.carga[7] < 2{
				if temp_edificio.fuel = 0 and temp_edificio.carga[1] > 0{
					temp_edificio.fuel = rss_comb_time[1]
					temp_edificio.carga[1]--
					temp_edificio.carga_total--
				}
				temp_edificio.proceso++
				if temp_edificio.proceso >= edificio_proceso[temp_edificio.index]{
					if temp_edificio.carga[5] > 7{
						temp_edificio.carga[5] -= 8
						temp_edificio.carga[7]++
						temp_edificio.carga_total -= 7
						temp_edificio.proceso -= floor(edificio_proceso[temp_edificio.index] * 2.5)
					}
					else if temp_edificio.carga[3] > 3{
						temp_edificio.carga[3] -= 4
						temp_edificio.carga[4]++
						temp_edificio.carga_total -= 3
						temp_edificio.proceso -= floor(edificio_proceso[temp_edificio.index] * 1.5)
					}
					else if temp_edificio.carga[0] > 1{
						temp_edificio.carga[0] -= 2
						temp_edificio.carga[2]++
						temp_edificio.carga_total--
						temp_edificio.proceso -= edificio_proceso[temp_edificio.index]
					}
					temp_edificio.waiting = not mover(temp_edificio.a, temp_edificio.b)
				}
			}
		}
		//Acción generador
		if in(edificio_nombre[temp_edificio.index], "Generador"){
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
					mover(temp_edificio.a, temp_edificio.b)
				}
			}
		}
		//Acción de la bomba hidraulica
		if in(edificio_nombre[temp_edificio.index], "Bomba hidraulica"){
			for(var b = 0; b < ds_list_size(temp_edificio.flujo); b++){
				var temp_flujo = ds_list_find_value(temp_edificio.flujo, b)
				temp_flujo.generacion -= temp_edificio.proceso
				if temp_edificio.red.generacion < temp_edificio.red.consumo and temp_edificio.red.bateria = 0
					temp_edificio.proceso = temp_edificio.red.generacion / temp_edificio.red.consumo
				else
					temp_edificio.proceso = 1
				temp_flujo.generacion += temp_edificio.proceso
			}
		}
		//Acción de triturador
		if in(edificio_nombre[temp_edificio.index], "Triturador") and temp_edificio.carga[6] > 0{
			if temp_edificio.proceso < 0{
				temp_edificio.red.consumo += abs(edificio_elec_consumo[temp_edificio.index])
				temp_edificio.proceso++
			}
			if temp_edificio.red.generacion < temp_edificio.red.consumo and temp_edificio.red.bateria = 0
				temp_edificio.proceso += temp_edificio.red.generacion / temp_edificio.red.consumo
			else
				temp_edificio.proceso++
			if temp_edificio.proceso >= edificio_proceso[temp_edificio.index]{
				temp_edificio.proceso -= edificio_proceso[temp_edificio.index] + 1
				if temp_edificio.carga[6] > 0{
					temp_edificio.carga[6]--
					temp_edificio.carga[5]++
				}
				temp_edificio.waiting = not mover(temp_edificio.a, temp_edificio.b)
				temp_edificio.red.consumo -= abs(edificio_elec_consumo[temp_edificio.index])
			}
		}
	}
}
//Ciclo de redes
for(var a = 0; a < ds_list_size(redes); a++){
	var temp_red = ds_list_find_value(redes, a)
	temp_red.bateria = clamp(temp_red.bateria + (temp_red.generacion - temp_red.consumo) / 30, 0, temp_red.bateria_max)
}
if keyboard_check_pressed(ord("P"))
	game_restart()
if keyboard_check_pressed(ord("I"))
	info = not info
//Mostrar redes electricas
if keyboard_check(ord("L")){
	var temp_text = ""
	for(var a = 0; a < ds_list_size(redes); a++){
		draw_set_color(make_color_hsv(a * 40, 255, 255))
		var temp_red = ds_list_find_value(redes, a)
		temp_text += "Red " + string(a) + ":\n"
		temp_text += "  Consumo: " + string(temp_red.consumo) + "\n"
		temp_text += "  Generacion: " + string(temp_red.generacion) + "\n"
		temp_text += "  Bateria: " + string(floor(temp_red.bateria)) + "/" + string(temp_red.bateria_max) + "\n"
		temp_text += "  Edificios:\n"
		for(var b = 0; b < ds_list_size(temp_red.edificios); b++){
			temp_edificio = ds_list_find_value(temp_red.edificios, b)
			temp_text += "    " + string(edificio_nombre[temp_edificio.index]) + "\n"
			var temp_complex = abtoxy(temp_edificio.a, temp_edificio.b)
			for(var c = 0; c < ds_list_size(temp_edificio.energy_link); c++){
				var temp_edificio_2 = ds_list_find_value(temp_edificio.energy_link, c)
				var temp_complex_2 = abtoxy(temp_edificio_2.a, temp_edificio_2.b)
				draw_line_off(temp_complex.a, temp_complex.b, temp_complex_2.a, temp_complex_2.b)
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
		var temp_flujo = ds_list_find_value(flujos, a)
		temp_text += "Tuberia " + string(a) + ": "
		if temp_flujo.liquido = -1
			temp_text += "Sin liquidos\n"
		else
			temp_text += liquido_nombre[temp_flujo.liquido] + "\n"
		temp_text += "  Generacion: " + string(temp_flujo.generacion) + "\n"
		temp_text += "  Consumo: " + string(temp_flujo.consumo) + "\n"
		temp_text += "  Almacenado: " + string(floor(temp_flujo.cantidad)) + "/" + string(temp_flujo.cantidad_max) + "\n"
		temp_text += "  Edificios:\n"
		for(var b = 0; b < ds_list_size(temp_flujo.edificios); b++){
			temp_edificio = ds_list_find_value(temp_flujo.edificios, b)
			temp_text += "    " + string(edificio_nombre[temp_edificio.index]) + "\n"
			var temp_complex = abtoxy(temp_edificio.a, temp_edificio.b)
			for(var c = 0; c < ds_list_size(temp_edificio.energy_link); c++){
				var temp_edificio_2 = ds_list_find_value(temp_edificio.energy_link, c)
				var temp_complex_2 = abtoxy(temp_edificio_2.a, temp_edificio_2.b)
				draw_line_off(temp_complex.a, temp_complex.b, temp_complex_2.a, temp_complex_2.b)
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
//Control de camara
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
if mouse_y > room_height - 40 and build_menu = 0
	camy = min(camy + 4 + 12 * keyboard_check(vk_lshift), room_height * (zoom - 1))
if mouse_x < 40 and camx > 0
	camx = max(camx - 4 - 12 * keyboard_check(vk_lshift), 0)
if mouse_y < 40 and camy > 0
	camy = max(camy - 4 - 12 * keyboard_check(vk_lshift), 0)