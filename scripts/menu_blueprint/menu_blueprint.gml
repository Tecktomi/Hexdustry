function menu_blueprint(mx, my){
	with control{
		var len, a, b, i, buffer, aa, bb, aaa, bbb, aaaa, temp_complex, temp_blueprint, len2, index, dir, sprite, surf, size, tempa, tempb, temp_array_real, temp_array_real_2, temp_dir
		len = array_length(blueprint)
		var flip = (((blueprint_mod2 + my) mod 2) = 1), _rotar = false
		//Guardar
		if not blueprint_safe{
			draw_set_halign(fa_center)
			if draw_boton(room_width / 2, 40, L.guardar_plano){
				blueprint_safe = true
				buffer = buffer_create(2 + 4 * len, buffer_grow, 1)
				buffer_write(buffer, buffer_u8, len)
				buffer_write(buffer, buffer_bool, blueprint_mod2)
				for(a = 0; a < len; a++){
					temp_blueprint = blueprint[a]
					buffer_write(buffer, buffer_u8, temp_blueprint.a)
					buffer_write(buffer, buffer_u8, temp_blueprint.b)
					buffer_write(buffer, buffer_u8, temp_blueprint.index)
					buffer_write(buffer, buffer_u8, temp_blueprint.dir)
					buffer_write(buffer, buffer_s16, temp_blueprint.rot0)
					buffer_write(buffer, buffer_s16, temp_blueprint.rot4)
					buffer_write(buffer, buffer_s16, temp_blueprint.rot5)
				}
				buffer_save(buffer, $"Blueprints/{day_format()}.txt")
				buffer_delete(buffer)
				surf = surface_create(room_width, room_height)
				surface_set_target(surf)
				var color = draw_get_color(), max_width = 0, max_height = 0, min_width = infinity, min_height = infinity
				draw_set_color(make_color_rgb(255, 0, 255))
				draw_rectangle(0, 0, room_width, room_height, false)
				draw_set_color(color)
				for(a = 0; a < len; a++){
					temp_blueprint = blueprint[a]
					aaa = temp_blueprint.a + mx
					if flip and (temp_blueprint.b & 1){
						if blueprint_mod2
							aaa--
						else
							aaa++
					}
					temp_complex = abtoxy(aaa, temp_blueprint.b + my)
					aa = temp_complex[0]
					bb = temp_complex[1]
					index = temp_blueprint.index
					dir = temp_blueprint.dir
					draw_edificio(aa, bb, index, dir)
					size = edificio_size[index] + 1
					min_width = min(min_width, aa - camx - 48 * floor(size / 2))
					min_height = min(min_height, bb - camy - 14 * size)
					max_width = max(max_width, aa - camx + 48 * ceil(size / 2))
					max_height = max(max_height, bb - camy + 14 * size)
				}
				sprite = sprite_create_from_surface(surf, min_width, min_height, max_width - min_width, max_height - min_height, true, false, 0, 0)
				sprite_save(sprite, 0, $"Blueprints/{day_format()}.png")
				surface_reset_target()
				surface_free(surf)
				sprite_delete(sprite)
			}
			draw_set_halign(fa_left)
		}
		//Cancelar
		if mouse_check_button_pressed(mb_right){
			mouse_clear(mb_right)
			array_resize(blueprint, 0)
		}
		//Rotar
		if keyboard_check_pressed(CONTROL_ROTAR) or mouse_wheel_up() or mouse_wheel_down(){
			keyboard_clear(CONTROL_ROTAR)
			_rotar = true
			temp_dir = true
			if mouse_wheel_down()
				temp_dir = true
			else if mouse_wheel_up()
				temp_dir = false
			if keyboard_check(vk_lshift)
				temp_dir = not temp_dir
			blueprint_mina = infinity
			blueprint_minb = infinity
			for(a = 0; a < len; a++){
				temp_blueprint = blueprint[a]
				size = edificio_size[temp_blueprint.index]
				if (size & 1) = 0
					blueprint[a].dir = 5 - temp_blueprint.dir
				else if temp_dir
					blueprint[a].dir = (temp_blueprint.dir + 5) mod 6
				else
					blueprint[a].dir = (temp_blueprint.dir + 1) mod 6
				b = temp_blueprint.rot0
				if temp_dir{
					blueprint[a].rot0 = -temp_blueprint.rot4
					blueprint[a].rot4 = temp_blueprint.rot5
					blueprint[a].rot5 = b
				}
				else{
					blueprint[a].rot0 = temp_blueprint.rot5
					blueprint[a].rot5 = temp_blueprint.rot4
					blueprint[a].rot4 = -b
				}
				if (size & 1) = 0{
					if temp_blueprint.dir = 0 and temp_dir
						blueprint[a].rot5--
					if temp_blueprint.dir = 5 and not temp_dir
						blueprint[a].rot0++
				}
				temp_blueprint = blueprint[a]
				tempa = mx
				tempb = my
				temp_array_real = [temp_blueprint.rot0, temp_blueprint.rot4, temp_blueprint.rot5]
				temp_array_real_2 = [0, 4, 5]
				for(i = 0; i < 3; i++){
					if temp_array_real[i] < 0
						temp_array_real_2[i] = (temp_array_real_2[i] + 3) mod 6
					repeat(abs(temp_array_real[i])){
						tempa = tempa + DESFACE_A[tempb & 1, temp_array_real_2[i]]
						tempb = tempb + DESFACE_B[tempb & 1, temp_array_real_2[i]]
					}
				}
				blueprint[a].a = tempa - mx
				blueprint[a].b = tempb - my
				blueprint_mina = min(blueprint_mina, blueprint[a].a)
				blueprint_minb = min(blueprint_minb, blueprint[a].b)
			}
			for(a = 0; a < len; a++){
				blueprint[a].a -= blueprint_mina
				blueprint[a].b -= blueprint_minb
			}
			blueprint_mod2 = (blueprint_minb & 1)
		}
		//Detectar colisiones
		if not (last_mx = mx and last_my = my) or _rotar{
			for(a = 0; a < len; a++){
				temp_blueprint = blueprint[a]
				aaa = temp_blueprint.a + mx
				if flip and (temp_blueprint.b & 1) = 1{
					if blueprint_mod2
						aaa--
					else
						aaa++
				}
				blueprint[a].construible = check_colision(aaa, temp_blueprint.b + my, temp_blueprint.index, temp_blueprint.dir)
			}
		}
		//Dibujar Blueprint
		for(a = 0; a < len; a++){
			temp_blueprint = blueprint[a]
			aaa = temp_blueprint.a + mx
			if flip and (temp_blueprint.b & 1){
				if blueprint_mod2
					aaa--
				else
					aaa++
			}
			temp_complex = abtoxy(aaa, temp_blueprint.b + my)
			aa = temp_complex[0]
			bb = temp_complex[1]
			index = temp_blueprint.index
			dir = temp_blueprint.dir
			draw_edificio(aa, bb, index, dir, 0.5)
			if not temp_blueprint.construible{
				size = get_size(aaa, temp_blueprint.b + my, dir, edificio_size[index])
				len2 = array_length(size)
				for(b = 0; b < len2;){
					aaaa = size[b++]
					bbb = size[b++]
					temp_complex = abtoxy(aaaa, bbb)
					draw_sprite_off(spr_rojo, 0, temp_complex[0], temp_complex[1],,,,, 0.5)
				}
			}
		}
		//Construir
		if mouse_check_button_pressed(mb_left){
			mouse_clear(mb_left)
			for(a = 0; a < len; a++){
				temp_blueprint = blueprint[a]
				aaa = temp_blueprint.a + mx
				if flip and (temp_blueprint.b & 1) = 1{
					if blueprint_mod2
						aaa--
					else
						aaa++
				}
				if temp_blueprint.construible and is_comprable(edificio_precio_id[temp_blueprint.index], edificio_precio_num[temp_blueprint.index])
					construir(temp_blueprint.index, temp_blueprint.dir, aaa, temp_blueprint.b + my, true)
			}
			if not keyboard_check(vk_lshift)
				array_resize(blueprint, 0)
		}
		last_mx = mx
		last_my = my
	}
}