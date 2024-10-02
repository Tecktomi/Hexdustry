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
				draw_sprite(ore_sprite[temp_terreno.ore], (temp_terreno.ore_amount < 30), temp_complex.a, temp_complex.b)
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
			if in(temp_edificio.index, 2, 3){
				draw_sprite_ext(edificio_sprite[temp_edificio.index], image_index / 4, temp_complex.a, temp_complex.b, 1, 1, (temp_edificio.dir - 1) * 60, c_white, 1)
				if temp_edificio.carga_total > 0{
					var c = 1.2 * (max(temp_edificio.proceso, temp_edificio.waiting * 20) - 10)
					var d = temp_edificio.dir * pi / 3 + pi / 6
					draw_sprite(ore_item_sprite[temp_edificio.carga_id], 0, temp_complex.a + c * cos(d), temp_complex.b - c * sin(d))
				}
			}
			else
				draw_sprite_ext(edificio_sprite[temp_edificio.index], image_index / 4, temp_complex.a, temp_complex.b, 1, 1, temp_edificio.dir * 60, c_white, 1)
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
if temp_hexagono != noone{
	var temp_text = string(mx) + ", " + string(my) + "\n"
	if temp_terreno.ore >= 0
		temp_text += ore_name[temp_terreno.ore] + ": " + string(temp_terreno.ore_amount) + "\n"
	if temp_terreno.edificio_bool{
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
		if temp_edificio.carga_total > 0
			temp_text += "Carga: "
		for(var a = 0; a < ore_max; a++)
			if temp_edificio.carga[a] > 0
				temp_text += string(temp_edificio.carga[a]) + " " + ore_name[a] + "\n"
		temp_text += "Output_index: " + string(temp_edificio.output_index) + "/" + string(ds_list_size(temp_edificio.outputs)) + "\n"
		if temp_edificio.idle and in(temp_edificio.index, 1)
			temp_text += "Sin recursos\n"
		if edificio_receptor[temp_edificio.index]{
			temp_text += "Acepta: \n"
			for(var a = 0; a < ore_max; a++)
				temp_text += ore_name[a] + ": " + string(temp_edificio.carga_max[a]) + "\n"
		}
		if edificio_emisor[temp_edificio.index]{
			temp_text += "Entrega: \n"
			for(var a = 0; a < ore_max; a++)
				if temp_edificio.carga_output[a]
					temp_text += ore_name[a] + "\n"
		}
	}
	draw_set_color(c_white)
	draw_text(0, 0, temp_text)
}
//Construir
var flag = false
if keyboard_check_pressed(ord(1)){
	build_index = 1
	flag = true
}
if keyboard_check_pressed(ord(2)){
	build_index = 2
	flag = true
}
if keyboard_check_pressed(ord(3)){
	build_index = 3
	flag = true
}
if keyboard_check_pressed(ord(4)){
	build_index = 4
	flag = true
}
if (mouse_check_button_pressed(mb_right) or keyboard_check_pressed(vk_escape)) and build_index > 0
	build_index = 0
if build_index > 0{
	if mouse_wheel_up(){
		build_dir = (build_dir + 1) mod 6
		flag = true
	}
	if mouse_wheel_down(){
		build_dir = build_dir - 1 + 6 * (build_dir = 0)
		flag = true
	}
	if last_mx != mx or last_my != my or flag
		build_list = get_size(mx, my, build_dir, edificio_size[build_index])
	last_mx = mx
	last_my = my
	if temp_hexagono != noone{
		var temp_array, temp_array_2
		if in(build_index, 2, 3){
			var temp_complex = next_to(mx, my, build_dir)
			var temp_complex_2 = abtoxy(mx, my)
			var temp_complex_3 = abtoxy(temp_complex.a, temp_complex.b)
			draw_arrow(temp_complex_2.a, temp_complex_2.b, temp_complex_3.a, temp_complex_3.b, 8)
			draw_sprite_ext(edificio_sprite[build_index], 0, (mx + (my mod 2) / 2) * 48 + 16, (my + 1) * 14, 1, 1, (build_dir - 1) * 60, c_white, 0.5)
		}
		else{
			draw_sprite_ext(edificio_sprite[build_index], 0, (mx + (my mod 2) / 2) * 48 + 16, (my + 1) * 14, 1, 1, build_dir * 60, c_white, 0.5)
			if in(build_index, 1){
				for(var a = 0; a < array_length(ore_name); a++){
					temp_array[a] = 0
					temp_array_2[a] = 0
				}
				var b = 0
				for(var a = 0; a < ds_list_size(build_list); a++){
					var temp_complex_2 = ds_list_find_value(build_list, a)
					if temp_complex_2.a >= 0 and temp_complex_2.b >= 0 and temp_complex_2.a < xsize and temp_complex_2.b < ysize and terreno[temp_complex_2.a, temp_complex_2.b].ore >= 0{
						temp_array[terreno[temp_complex_2.a, temp_complex_2.b].ore]++
						temp_array_2[terreno[temp_complex_2.a, temp_complex_2.b].ore] += terreno[temp_complex_2.a, temp_complex_2.b].ore_amount
						b++
					}
				}
				var temp_text = ""
				for(var a = 0; a < array_length(ore_name); a++)
					if temp_array[a] > 0
						temp_text += ore_name[a] + ": " + string(temp_array_2[a]) + "(" + string(temp_array[a] * 100 / b) + "%)\n"
				draw_text(mouse_x + 20, mouse_y, temp_text)
			}
		}
		if mouse_check_button_pressed(mb_left) and not temp_terreno.edificio_bool{
			flag = true
			var flag_2 = false
			for(var a = 0; a < ds_list_size(build_list); a++){
				var temp_complex_2 = ds_list_find_value(build_list, a)
				var aa = temp_complex_2.a
				var bb = temp_complex_2.b
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize or terreno[aa, bb].edificio_bool or in(terreno[aa, bb].terreno, 2){
					flag = false
					break
				}
				if in(build_index, 1) and terreno[aa, bb].ore >= 0
					flag_2 = true
			}
			if in(build_index, 1) and not flag_2
				flag = false
			if flag
				temp_edificio = add_edificio(build_index, build_dir, mx, my)
			if not keyboard_check(vk_lshift)
				build_index = 0
		}
	}
}
//Romper
else if mouse_check_button(mb_right) and prev_change and temp_hexagono != noone and temp_terreno.edificio_bool and temp_edificio.index != 0
	delete_edificio(temp_edificio)
//Ciclo edificios
for(var a=0; a<ds_list_size(edificios); a++){
	temp_edificio = ds_list_find_value(edificios, a)
	if not temp_edificio.idle{
		if in(temp_edificio.index, 1) and temp_edificio.carga_total < edificio_carga_max[temp_edificio.index]{
			temp_edificio.proceso++
			if temp_edificio.proceso = edificio_proceso[temp_edificio.index]{
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
						temp_edificio.carga[temp_terreno.ore]++
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
				else
					temp_edificio.idle = true
			}
		}
		if in(temp_edificio.index, 2, 3) and temp_edificio.carga_total > 0{
			temp_edificio.proceso++
			if temp_edificio.proceso = 20{
				temp_edificio.proceso = 0
				temp_edificio.waiting = not mover(temp_edificio)
			}
		}
		if temp_edificio.index = 4 and temp_edificio.carga[0] > 0 and temp_edificio.carga[1] > 0 and temp_edificio.carga[2] < 2{
			temp_edificio.proceso++
			if temp_edificio.proceso = edificio_proceso[4]{
				temp_edificio.proceso = 0
				temp_edificio.carga[0]--
				temp_edificio.carga[1]--
				temp_edificio.carga[2]++
				temp_edificio.carga_total--
				temp_edificio.waiting = not mover(temp_edificio)
			}
		}
	}
}
if keyboard_check_pressed(ord("R"))
	game_restart()