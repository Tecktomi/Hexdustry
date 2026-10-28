function menu_construccion(mx, my, xmouse, ymouse, just_pressed = false, prev_change = false, outside = false){
	with control{
		var a, b, aa, bb, temp_complex, temp_complex_2,temp_complex_3, len, flag, i, j, temp_array_real
		var _parpadeo = abs(sin(image_index / 20))
		var construible = true
		if just_pressed{
			if not edificio_rotable[build_index]
				build_dir = 0
			if edificio_size[build_index] mod 2 = 0
				build_dir = 5 * (build_dir mod 2)
		}
		if DEVISE{
			temp_mx = mx
			temp_my = my
			if (edificio_rotable[build_index] or edificio_size[build_index] mod 2 = 0) and not keyboard_check(vk_lcontrol){
				if mouse_wheel_up() or (not keyboard_check(vk_lshift) and keyboard_check_pressed(CONTROL_ROTAR)){
					keyboard_clear(CONTROL_ROTAR)
					if not edificio_rotable[build_index] and edificio_size[build_index] mod 2 = 0
						build_dir = 5 - build_dir
					else
						build_dir = (build_dir + 1) mod 6
					if not edificio_camino[build_index]
						prev_change = true
				}
				if mouse_wheel_down() or (keyboard_check(vk_lshift) and keyboard_check_pressed(CONTROL_ROTAR)){
					keyboard_clear(CONTROL_ROTAR)
					if not edificio_rotable[build_index] and edificio_size[build_index] mod 2 = 0
						build_dir = 5 - build_dir
					else
						build_dir = (build_dir + 5) mod 6
					if not edificio_camino[build_index]
						prev_change = true
				}
			}
		}
		//ANDROID
		else{
			var xpos = room_width - 80
			if draw_sprite_boton(spr_construir, 1, xpos, room_height - 80, 64, 56){
				build_index = -1
				clicked = false
			}
			xpos -= 80
			if draw_sprite_boton(spr_construir, 2, xpos, room_height - 80, 64, 56){
				construir(build_index, build_dir, mx_clic, my_clic, true)
				clicked = false
				android_clic = false
			}
			xpos -= 80
			if (edificio_rotable[build_index] or edificio_size[build_index] & 1 = 0){
				if draw_sprite_boton(spr_construir, 3, xpos, room_height - 80, 64, 56){
					if edificio_size[build_index] & 1
						build_dir = (build_dir + 1) mod 6
					else
						build_dir = 5 - build_dir
					prev_change = true
				}
				xpos -= 80
			}
			if edificio_rotable[build_index]{
				if draw_sprite_boton(spr_construir, 4, xpos, room_height - 80, 64, 56){
					if edificio_size[build_index] & 1
						build_dir = (build_dir + 5) mod 6
					else
						build_dir = 5 - build_dir
					prev_change = true
				}
				xpos -= 80
			}
			if not (mouse_x > xpos - 80 and mouse_y > room_height - 120){
				temp_mx = mx
				temp_my = my
			}
			else
				construible = false
			if mouse_check_button_pressed(mb_left)
				android_building = true
		}
		var _change = (last_mx != temp_mx or last_my != temp_my or prev_change)
		//Actualizar ante el movimiento
		if _change{
			build_list = get_size(temp_mx, temp_my, build_dir, edificio_size[build_index])
			if in(build_index, id_taladro_de_explosion, id_deposito)
				build_list_arround = get_size(temp_mx, temp_my, build_dir, edificio_size[build_index] + 2)
			else if in(build_index, id_fabrica_de_drones, id_ensambladora, id_planta_de_reciclaje, id_fabrica_de_drones_grande, id_cinta_grande)
				build_list_arround = get_arround(temp_mx, temp_my, build_dir, edificio_size[build_index])
			else if build_index = id_cable
				build_list_arround = get_size(temp_mx, temp_my, 0, 7)
			show_menu = false
			if tag_dron_encima[build_index]{
				if build_index = id_planta_de_reciclaje
					build_array_edificios = array_create(0, null_edificio)
				build_array_edificios_input = array_create(0, null_edificio)
				build_array_edificios_output = array_create(0, null_edificio)
			}
			if build_index = id_torre_reparadora
				build_array_edificios = array_create(0, null_edificio)
			comprable = true
			if tag_edificio_tuberia[build_index] and not mouse_check_button(mb_left) and not mouse_check_button_released(mb_left){
				liquido_choose = 0
				array_resize(liquido_choose_array, 0)
			}
		}
		var _comprable = true
		if _change{
			len = array_length(build_list)
			for(a = 0; a < len;){
				aa = build_list[a++]
				bb = build_list[a++]
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize{
					_comprable = false
					comprable = false
					break
				}
			}
		}
		var temp_text = ""
		//CONSTRUCCIÓN
		if _comprable and not outside{
			//Módulos
			if build_index = id_modulo{
				temp_complex = abtoxy(temp_mx, temp_my)
				draw_sprite_off(spr_item_modulo, 0, temp_complex[0], temp_complex[1],,,,, 0.5)
				if edificio_bool[# temp_mx, temp_my]{
					var temp_edificio = edificio_id[# temp_mx, temp_my], index = temp_edificio.index, temp_modulo_tier = edificio_modulo_tier[index], flag_2 = true
					if temp_modulo_tier = -1{
						temp_text = L.modulo_edificio_sin_modulo
						flag_2 = false
					}
					if temp_edificio.modulo{
						temp_text = L.modulo_edificio_con_modulo
						flag_2 = false
					}
					if flag_2 and temp_edificio.jugador = jugador{
						#region Efectos
							//Más extracción
							if in(index, id_taladro, id_taladro_electrico, id_taladro_de_explosion)
								temp_text = L.modulo_extraccion
							//Mejor canalización
							else if index = id_laser
								temp_text = L.modulo_canalizar
							//Más cadencia de fuego
							else if in(index, id_torre_basica, id_rifle, id_mortero)
								temp_text = L.modulo_cadencia
							//Más daño
							else if index = id_lanzallamas
								temp_text = L.modulo_dmg
							//Aturdir
							else if index = id_onda_de_choque
								temp_text = L.modulo_aturdir
							//Más producción líquido
							else if index = id_bomba_hidraulica
								temp_text = $"{L.modulo_mas_liquido} {liquido_nombre[temp_edificio.fuel]}\n"
							//Menos consumo electricidad
							else if in(index, id_ensambladora, id_perforadora_de_petroleo, id_refineria_de_petroleo)
								temp_text = L.modulo_menos_electricidad
							//Menos consumo líquido
							else if in(index, id_fabrica_de_concreto, id_generador_geotermico, id_turbina)
								temp_text = $"{L.modulo_menos_liquido} {liquido_nombre[0]}\n"
							//Velocidad
							else if in(index, id_fabrica_de_drones, id_fabrica_de_drones_grande, id_planta_de_reciclaje, id_planta_de_enriquecimiento, id_planta_quimica, id_refineria_de_metales, id_triturador)
								temp_text = L.modulo_produccion
							//Más producción de sal
							else if index = id_planta_desalinizadora
								temp_text = $"{L.modulo_sal} {recurso_nombre[idr_sal]}\n"
							//Evitar desastres nucleares
							else if index = id_planta_nuclear
								temp_text = L.modulo_nuclear
							//Más reparación
							else if index = id_torre_reparadora
								temp_text = L.modulo_reparadora
							//Más drones máximos
							else if index = id_nucleo
								temp_text = L.modulo_nucleo
						#endregion
						if flag_2{
							if not cheat 
								for(a = array_length(modulo_precio_id[temp_modulo_tier]) - 1; a >= 0; a--){
									temp_text += $"  {recurso_nombre[modulo_precio_id[temp_modulo_tier, a]]}: {modulo_precio_num[temp_modulo_tier, a]}\n"
									if flag_2 and jugador_recursos[jugador, modulo_precio_id[temp_modulo_tier, a]] < modulo_precio_num[temp_modulo_tier, a]
										flag_2 = false
								}
							if not flag_2
								temp_text += $"{L.construir_recursos_insuficientes}\n"
							else if (DEVISE and mouse_check_button_pressed(mb_left)) or (not DEVISE and mouse_check_button_released(mb_left)){
								add_modulo(temp_edificio, true)
								mouse_clear(mb_left)
							}
						}
					}
				}
				else
					temp_text = L.modulo_sin_edificio
				draw_text_background(min(room_width - string_width(temp_text), mouse_x + 20), min(room_height - string_height(temp_text), mouse_y), temp_text)
			}
			//Edificios
			else{
				//Detectar recursos y enemigos cerca
				if not cheat{
					for(a = array_length(edificio_precio_id[build_index]) - 1; a >= 0; a--)
						if jugador_recursos[jugador, edificio_precio_id[build_index, a]] < edificio_precio_num[build_index, a]{
							_comprable = false
							temp_text += $"  {recurso_nombre[edificio_precio_id[build_index, a]]} {jugador_recursos[jugador, edificio_precio_id[build_index, a]]}/{edificio_precio_num[build_index, a]}\n"
						}
					if not _comprable
						temp_text = $"{L.construir_recursos_insuficientes}\n{temp_text}"
					draw_set_color(ui_boton_rojo)
					var flag_3 = false
					for(var c = 0; c < EQUIPOS; c++) if not aliados[# jugador, c]
						for(a = array_length(drones_jugador[c]) - 1; a >= 0; a--){
							var dron = drones_jugador[c, a]
							draw_circle_off(dron.x, dron.y, ENEMIGO_CERCA, true)
							if not flag_3 and point_distance(mouse_x, mouse_y, dron.x * zoom - camx, dron.y * zoom - camy) < ENEMIGO_CERCA * zoom{
								temp_text += $"{L.construir_enemigos_cerca}\n"
								_comprable = false
								flag_3 = true
							}
						}
					draw_set_color(ui_texto)
				}
				draw_set_color(ui_boton_rojo)
				temp_complex = abtoxy(spawn_x, spawn_y)
				var aaa = temp_complex[0], bbb = temp_complex[1]
				draw_circle_off(aaa, bbb, 250, true)
				//Detecciones optimizadas
				if _change{
					len = array_length(build_list)
					comprable_texto = ""
					//Detectar zona de spawn
					if point_distance(mouse_x, mouse_y, aaa * zoom - camx, bbb * zoom - camy) < ENEMIGO_CERCA * zoom{
						comprable_texto += $"{L.construir_zona_enemigos}\n"
						comprable = false
					}
					//Detectar coliciones con paredes
					for(a = 0; a < len;){
						aa = build_list[a++]
						bb = build_list[a++]
						if terreno[# aa, bb] = idt_hielo and edificio_size[build_index] > 1 and build_index != id_extractor_atmosferico{
							comprable_texto += $"{L.construir_terreno_hielo}\n"
							comprable = false
							break
						}
						if terreno_pared[terreno[# aa, bb]]{
							comprable_texto += $"{L.construir_terreno_invalido}\n"
							comprable = false
							break
						}
					}
					//Detectar coliciones con líquidos
					if not tag_construible_en_liquido[build_index]
						for(a = 0; a < len;){
							aa = build_list[a++]
							bb = build_list[a++]
							if terreno_liquido[terreno[# aa, bb]]{
								comprable_texto += $"{L.construir_terreno_invalido}\n"
								comprable = false
								break
							}
						}
					if build_index = id_bomba_de_evaporacion{
						for(a = 0; a < len;){
							aa = build_list[a++]
							bb = build_list[a++]
							if in(terreno[# aa, bb], idt_agua_profunda, idt_agua_salada_profunda){
								comprable_texto += $"{L.construir_terreno_invalido}\n"
								comprable = false
								break
							}
						}
					}
					else if build_index = id_bomba_hidraulica{
						flag = false
						var liquido = -1, count = 0
						for(a = 0; a < len;){
							aa = build_list[a++]
							bb = build_list[a++]
							if terreno_liquido[terreno[# aa, bb]]{
								flag = true
								if in(terreno[# aa, bb], idt_agua, idt_agua_profunda){
									if not in(liquido, -1, idl_agua){
										flag = false
										comprable_texto += $"{L.construir_combinar_liquidos}\n"
										break
									}
									count++
									if terreno[# aa, bb] = idt_agua_profunda
										count += 0.2
									liquido = idl_agua
								}
								else if terreno[# aa, bb] = idt_petroleo{
									if not in(liquido, -1, idl_petroleo){
										flag = false
										comprable_texto += $"{L.construir_combinar_liquidos}\n"
										break
									}
									count++
									liquido = idl_petroleo
								}
								else if terreno[# aa, bb] = idt_lava{
									if not in(liquido, -1, idl_lava){
										flag = false
										comprable_texto += $"{L.construir_combinar_liquidos}\n"
										break
									}
									count++
									liquido = idl_lava
								}
								else if tag_agua_salada[terreno[# aa, bb]]{
									if not in(liquido, -1, idl_agua_salada){
										flag = false
										comprable_texto += $"{L.construir_combinar_liquidos}\n"
										break
									}
									count++
									if terreno[# aa, bb] = idt_agua_salada_profunda
										count += 0.2
									liquido = idl_agua_salada
								}
							}
						}
						if not flag{
							comprable = false
							comprable_texto += $"{L.construir_sobre_agua_lava}\n"
						}
						else
							comprable_texto += $"{L.game_producira} {round(abs(edificio_flujo_consumo[build_index]) * count / 3)} {liquido_nombre[liquido]}/s\n"
					}
					else if build_index = id_generador_geotermico{
						i = 0
						for(a = 0; a < len;){
							aa = build_list[a++]
							bb = build_list[a++]
							i += (terreno[# aa, bb] = idt_lava)
						}
						if i = 0{
							comprable = false
							comprable_texto += $"{L.construir_sobre_lava}\n"
						}
						else
							comprable_texto += $"{L.game_producira} {abs(edificio_energia_consumo[build_index]) * i / 3} {L.red_energia}/s"
					}
					else if build_index = id_bomba_de_evaporacion{
						flag = false
						for(a = 0; a < len;){
							aa = build_list[a++]
							bb = build_list[a++]
							if tag_agua[terreno[# aa, bb]]{
								flag = true
								break
							}
						}
						if not flag{
							comprable = false
							comprable_texto += $"{L.construir_sobre_agua}\n"
						}
					}
					else if build_index = id_extractor_atmosferico{
						i = 0
						for(a = 0; a < len;){
							aa = build_list[a++]
							bb = build_list[a++]
							b = terreno[# aa, bb]
							if b = idt_hielo
								i += 1.5
							else if b = idt_nieve
								i += 1.3
							else if b != idt_salar
								i++
						}
						if i = 0{
							comprable = false
							comprable_texto += $"{L.construir_sobre_salar}\n"
						}
						else
							comprable_texto += $"{L.game_producira} {abs(edificio_flujo_consumo[build_index]) * i} {liquido_nombre[0]}/s"
					}
					else if in(build_index, id_taladro, id_taladro_electrico){
						temp_array_real = array_create(rss_max, 0)
						var temp_array_2 = array_create(rss_max, 0)
						b = 0
						var u = 0.85
						flag = false
						//Buscar minerales superficiales
						for(a = 0; a < len;){
							aa = build_list[a++]
							bb = build_list[a++]
							if in(ore[# aa, bb], ido_cobre, ido_hierro, ido_carbon){
								temp_array_real[ore_recurso[ore[# aa, bb]]]++
								temp_array_2[ore_recurso[ore[# aa, bb]]] += ore_amount[# aa, bb]
								b++
								flag = true
								u += 0.05
							}
						}
						//Buscar piedra o arena
						if build_index = id_taladro_electrico{
							for(a = 0; a < len;){
								aa = build_list[a++]
								bb = build_list[a++]
								if terreno_recurso_bool[terreno[# aa, bb]]{
									u += 0.05
									if not in(ore[# aa, bb], ido_cobre, ido_hierro, ido_carbon){
										temp_array_real[terreno_recurso_id[terreno[# aa, bb]]]++
										temp_array_2[terreno_recurso_id[terreno[# aa, bb]]] = -1
										b++
										flag = true
									}
								}
							}
						}
						if not flag{
							comprable = false
							if build_index = id_taladro
								comprable_texto += L.construir_sobre_minerales
							else if build_index = id_taladro_electrico
								comprable_texto += L.construir_sobre_minerales_piedra
						}
						//Escribir porcentajes de recursos
						else{
							comprable_texto += $"{u * 60 / edificio_proceso[build_index]}/s\n"
							for(a = 0; a < rss_max; a++){
								if temp_array_2[a] > 0
									comprable_texto += $"{recurso_nombre[a]}: {temp_array_2[a]}({round(temp_array_real[a] * 100 / b)}%)\n"
								else if temp_array_2[a] = -1
									comprable_texto += $"{recurso_nombre[a]}({round(temp_array_real[a] * 100 / b)}%)\n"
							}
						}
					}
					else if build_index = id_taladro_de_explosion{
						temp_array_real = array_create(rss_max, 0)
						var temp_array_2 = array_create(rss_max, 0)
						flag = false
						len = array_length(build_list_arround)
						for(i = 0; i < len;){
							aa = build_list_arround[i++]
							bb = build_list_arround[i++]
							if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
								continue
							if ore[# aa, bb] >= 0{
								temp_array_real[ore_recurso[ore[# aa, bb]]]++
								temp_array_2[ore_recurso[ore[# aa, bb]]] += ore_amount[# aa, bb]
								flag = true
							}
							else if terreno_recurso_bool[terreno[# aa, bb]]{
								temp_array_real[terreno_recurso_id[terreno[# aa, bb]]]++
								temp_array_2[terreno_recurso_id[terreno[# aa, bb]]] = -1
								flag = true
							}
						}
						if not flag{
							comprable = false
							comprable_texto += L.construir_sobre_minerales_piedra
						}
						else for(a = 0; a < rss_max; a++){
							if temp_array_2[a] > 0
								comprable_texto += $"{recurso_nombre[a]}: {temp_array_2[a]} ({temp_array_real[a] / 5}/s)\n"
							else if temp_array_2[a] = -1
								comprable_texto += $"{recurso_nombre[a]} ({temp_array_real[a] / 5}/s)\n"
						}
					}
					//Detectar que no haya otros edificios debajo
					len = array_length(build_list)
					if edificio_camino[build_index] or tag_edificio_tunel[build_index] or build_index = id_cruce{
						for(a = 0; a < len;){
							aa = build_list[a++]
							bb = build_list[a++]
							if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
								continue
							if edificio_bool[# aa, bb]{
								var temp_edificio = edificio_id[# aa, bb]
								if not (edificio_camino[temp_edificio.index] or temp_edificio.index = id_cruce){
									comprable_texto += $"{L.construir_ocupado}\n"
									comprable = false
									break
								}
							}
						}
					}
					else for(a = 0; a < len;){
						aa = build_list[a++]
						bb = build_list[a++]
						if edificio_bool[# aa, bb]{
							comprable_texto += $"{L.construir_ocupado}\n"
							comprable = false
							break
						}
					}
				}
				if build_index = id_taladro_de_explosion{
					len = array_length(build_list_arround)
					for(a = 0; a < len;){
						aa = build_list_arround[a++]
						bb = build_list_arround[a++]
						if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
							continue
						temp_complex_2 = abtoxy(aa, bb)
						draw_sprite_off(spr_blanco, 0, temp_complex_2[0], temp_complex_2[1],,,,, 0.5)
					}
				}
				temp_text += comprable_texto
				if not comprable
					_comprable = false
				temp_complex = abtoxy(temp_mx, temp_my)
				//No se puede construir
				if not _comprable{
					if build_index = id_mina
						draw_sprite_off(tag_agua_profunda[terreno[# mx, my]] ? edificio_sprite_2[id_mina] : edificio_sprite[id_mina], 0, temp_complex[0], temp_complex[1],,,,, 0.5)
					else
						draw_edificio(temp_complex[0], temp_complex[1], build_index, build_dir, 0.5)
					len = array_length(build_list)
					for(a = 0; a < len;){
						aa = build_list[a++]
						bb = build_list[a++]
						temp_complex_2 = abtoxy(aa, bb)
						draw_sprite_off(spr_rojo, 0, temp_complex_2[0], temp_complex_2[1],,,,, 0.5)
					}
				}
				//Sí se puede construir
				else if not just_pressed{
					if not (mouse_check_button(mb_left) and (edificio_camino[build_index] or build_index = id_tuberia)) and not (not DEVISE and clicked and (edificio_camino[build_index] or in(build_index, id_tuberia, id_muro))){
						if build_index = id_mina
							draw_sprite_off(tag_agua_profunda[terreno[# mx, my]] ? edificio_sprite_2[id_mina] : edificio_sprite[id_mina], 0, temp_complex[0], temp_complex[1],,,,, 0.5)
						else
							draw_edificio(temp_complex[0], temp_complex[1], build_index, build_dir, 0.5)
					}
					var temp_array_2, flag_camino = true
					//Vista previa caminos
					if edificio_camino[build_index] or in(build_index, id_tuberia, id_muro){
						//WINDOWS
						if DEVISE{
							//Iniciar arrastre
							if mouse_check_button_pressed(mb_left){
								mx_clic = temp_mx
								my_clic = temp_my
								clicked = true
							}
							//Arrastre
							if mouse_check_button(mb_left) and construible{
								pre_build_list = [[mx_clic, my_clic]]
								pre_build_list_cruce = [false]
								temp_complex_2 = abtoxy(mx_clic, my_clic)
								aa = temp_complex_2[0]
								bb = temp_complex_2[1]
								draw_edificio(aa, bb, build_index, build_dir, 0.5)
								if mx_clic != temp_mx or my_clic != temp_my{
									var angle = radtodeg((arctan2(bb * zoom - camy - mouse_y, mouse_x - aa * zoom + camx) + 2 * pi) mod (2 * pi))
									if _change and edificio_camino[build_index]
										build_dir = floor(angle / 60)
									build_dir_camino = floor(angle / 60)
									a = mx_clic
									b = my_clic
									var _mina = max(xmouse, aa, 0), _minb = max(ymouse, bb, 0), _maxa = min(xmouse, aa, 48 * xsize), _maxb = min(ymouse, bb, 14 * ysize)
									do{
										temp_complex_3 = next_to(a, b, build_dir_camino)
										array_push(pre_build_list, temp_complex_3)
										a = temp_complex_3[0]
										b = temp_complex_3[1]
										temp_complex_3 = abtoxy(a, b)
										aaa = temp_complex_3[0]
										bbb = temp_complex_3[1]
										if tag_edificio_cinta[build_index] and (a != temp_mx or b != temp_my) and (a != mx_clic or b != my_clic) and edificio_bool[# a, b] and not in(edificio_id[# a, b].dir, build_dir, (build_dir + 3) mod 6) and tag_edificio_cinta[edificio_id[# a, b].index]{
											draw_edificio(aaa, bbb, id_cruce, 0, 0.5)
											array_push(pre_build_list_cruce, true)
										}
										else{
											draw_edificio(aaa, bbb, build_index, build_dir, 0.5)
											array_push(pre_build_list_cruce, false)
										}
									}
									until(temp_complex_3[0] < _maxa or temp_complex_3[0] > _mina or temp_complex_3[1] < _maxb or temp_complex_3[1] > _minb)
								}
							}
							//Mostrar caminos solos
							else{
								temp_complex = next_to(temp_mx, temp_my, build_dir)
								temp_complex_2 = abtoxy(temp_mx, temp_my)
								aa = temp_complex_2[0]
								bb = temp_complex_2[1]
								temp_complex_3 = abtoxy(temp_complex[0], temp_complex[1])
								if not in(build_index, id_tuberia, id_muro){
									draw_set_color(ui_fondo)
									draw_arrow_off(aa, bb, temp_complex_3[0], temp_complex_3[1], 8)
								}
								if in(build_index, id_enrutador, id_selector, id_overflow){
									temp_complex = next_to(temp_mx, temp_my, (build_dir + 1) mod 6)
									temp_complex_3 = abtoxy(temp_complex[0], temp_complex[1])
									draw_arrow_off(aa, bb, temp_complex_3[0], temp_complex_3[1], 8)
									temp_complex = next_to(temp_mx, temp_my, (build_dir + 5) mod 6)
									temp_complex_3 = abtoxy(temp_complex[0], temp_complex[1])
									draw_arrow_off(aa, bb, temp_complex_3[0], temp_complex_3[1], 8)
								}
								//Elegir entre varios líquidos
								if build_index = id_tuberia{
									if _change
										build_list_arround = get_arround(mx, my, 0, 1)
									build_rueda_flujos(_change)
								}
							}
							//Construir en cadena
							if mouse_check_button_released(mb_left) and clicked and construible{
								flag_camino = false
								clicked = false
								for(a = 0; a < array_length(pre_build_list); a++){
									_comprable = true
									if not cheat
										_comprable = is_comprable(edificio_precio_id[build_index], edificio_precio_num[build_index])
									if in(build_index, id_tuberia, id_muro)
										build_dir = 0
									if _comprable{
										temp_complex_2 = pre_build_list[a]
										if edificio_camino[build_index] and pre_build_list_cruce[a]
											construir(id_cruce, 0, temp_complex_2[0], temp_complex_2[1], true)
										else
											construir(build_index, build_dir, temp_complex_2[0], temp_complex_2[1], true)
									}
								}
							}
						}
						//Android
						else{
							//Confirmar
							if clicked{
								if mouse_check_button_released(mb_left) and point_distance(mouse_x, mouse_y, android_mouse_x, android_mouse_y) < 10{
									for(i = array_length(pre_build_list) - 1; i >= 0; i--){
										temp_complex_2 = pre_build_list[i]
										if mx = temp_complex_2[0] and my = temp_complex_2[1]{
											build_dir = temp_complex_2[2]
											j = temp_complex_2[3] + 1
											a = mx_clic
											b = my_clic
											for(var k = 0; k <= j; k++){
												if edificio_bool[# a, b] and edificio_camino[edificio_id[# a, b].index] and edificio_id[# a, b].dir mod 3 != build_dir mod 3
													construir(id_cruce, build_dir, a, b, true)
												else
													construir(build_index, build_dir, a, b, true)
												a += DESFACE_A[b & 1, build_dir]
												b += DESFACE_B[b & 1, build_dir]
											}
											clicked = false
											android_clic = false
											break
										}
									}
								}
								//Dibujo
								for(i = array_length(pre_build_list) - 1; i >= 0; i--){
									var temp_complex2 = pre_build_list[i]
									var temp_complex3 = abtoxy(temp_complex2[0], temp_complex2[1])
									j = temp_complex2[4] ? id_cruce : build_index
									if not is_comprable(edificio_precio_id[j], edificio_precio_num[j]) or not edificio_tecnologia[jugador, j] or not mision_edificios[j]
										draw_sprite_off(spr_rojo, 0, temp_complex3[0], temp_complex3[1],,,,, 0.3)
									draw_edificio(temp_complex3[0], temp_complex3[1], j, temp_complex2[2], 0.3)
								}
								var temp_complex3 = abtoxy(mx_clic, my_clic)
								draw_edificio(temp_complex3[0], temp_complex3[1], build_index, build_dir, 0.5)
							}
							//Iniciar
							else if mouse_check_button_released(mb_left) and android_clic and point_distance(mouse_x, mouse_y, android_mouse_x, android_mouse_y) < 10{
								mx_clic = mx
								my_clic = my
								clicked = true
								pre_build_list = array_create(0, array_create(4, 0))
								for(i = 0; i < 6; i++){
									a = mx_clic
									b = my_clic
									for(j = 0; j < 10; j++){
										a += DESFACE_A[b & 1, i]
										b += DESFACE_B[b & 1, i]
										if a < 0 or b < 0 or a >= xsize or b >= ysize
											continue
										if not terreno_caminable[terreno[# a, b]]
											break
										if edificio_bool[# a, b]{
											if edificio_camino[edificio_id[# a, b].index]{
												if edificio_id[# a, b].dir mod 3 = i mod 3
													array_push(pre_build_list, [a, b, i, j, 0])
												else
													array_push(pre_build_list, [a, b, i, j, 1])
											}
											else
												break
										}
										else
											array_push(pre_build_list, [a, b, i, j, 0])
									}
								}
							}
						}
					}
					//Cables
					else if build_index = id_cable{
						//Empezar a construir
						if mouse_check_button_pressed(mb_left){
							mx_clic = temp_mx
							my_clic = temp_my
							clicked = true
						}
						//Dibujar nodos cercanos
						draw_set_color(ui_color_energia)
						temp_complex_2 = abtoxy(temp_mx, temp_my)
						aa = temp_complex_2[0]
						bb = temp_complex_2[1]
						draw_circle_off(aa, bb, CABLE_RANGE, true)
						len = array_length(build_list_arround)
						for(a = 0; a < len;){
							var aaaa = build_list_arround[a++], bbbb = build_list_arround[a++]
							if aaaa < 0 or bbbb < 0 or aaaa >= xsize or bbbb >= ysize
								continue
							if (aaaa != temp_mx or bbbb != temp_my) and edificio_bool[# aaaa, bbbb]{
								var temp_edificio = edificio_id[# aaaa, bbbb]
								if temp_edificio.jugador = jugador and edificio_energia[temp_edificio.index] and point_distance(aa, bb, temp_edificio.center_x, temp_edificio.center_y) <= CABLE_RANGE
									draw_line_off(aa, bb, temp_edificio.center_x, temp_edificio.center_y)
							}
						}
						//Extender
						if mouse_check_button(mb_left) and construible{
							pre_build_list = [[mx_clic, my_clic]]
							temp_complex_2 = abtoxy(mx_clic, my_clic)
							aa = temp_complex_2[0]
							bb = temp_complex_2[1]
							var mxc = mx_clic, myc = my_clic
							draw_edificio(aa, bb, build_index, build_dir, 0.5)
							if mx_clic != temp_mx or my_clic != temp_my{
								temp_complex_3 = abtoxy(temp_mx, temp_my)
								var aaaa = temp_complex_3[0], bbbb = temp_complex_3[1]
								var dir = (360 + point_direction(aa, bb, aaaa, bbbb)) mod 360, dis = point_distance(aa, bb, aaaa, bbbb), flag_2 = false
								for(a = 0; a < floor(dis / 70); a++){
									repeat(3){
										var temp_complex_4 = next_to(mxc, myc, floor(dir / 60))
										var temp_complex_6 = abtoxy(temp_complex_4[0], temp_complex_4[1])
										var temp_dis = point_distance(temp_complex_6[0], temp_complex_6[1], aaaa, bbbb)
										var temp_complex_5 = next_to(mxc, myc, ceil(dir / 60))
										var temp_complex_7 = abtoxy(temp_complex_5[0], temp_complex_5[1])
										var temp_dis_2 = point_distance(temp_complex_7[0], temp_complex_7[1], aaaa, bbbb)
										if temp_dis > temp_dis_2{
											temp_complex_4 = temp_complex_5
											temp_dis = temp_dis_2
										}
										mxc = temp_complex_4[0]
										myc = temp_complex_4[1]
										if mxc < 0 or myc < 0 or mxc >= xsize or myc >= ysize
											break
										temp_complex_4 = abtoxy(mxc, myc)
										dir = point_direction(temp_complex_4[0], temp_complex_4[1], aaaa, bbbb)
										if temp_dis = 0{
											flag_2 = true
											break
										}
									}
									if mxc < 0 or myc < 0 or mxc >= xsize or myc >= ysize
										break
									array_push(pre_build_list, [mxc, myc])
									temp_complex_3 = abtoxy(mxc, myc)
									draw_edificio(temp_complex_3[0], temp_complex_3[1], build_index, 0, 0.5)
									if edificio_bool[# mxc, myc] or not terreno_caminable[terreno[# mxc, myc]]
										draw_sprite_off(spr_rojo, 0, temp_complex_3[0], temp_complex_3[1],,,,, 0.5)
									if flag_2
										break
								}
								if not (mxc = temp_mx and myc = temp_my)
									array_push(pre_build_list, [temp_mx, temp_my])
								draw_text(mouse_x, mouse_y + 20, temp_text)
							}
						}
						//Construir
						if mouse_check_button_released(mb_left) and clicked and construible{
							flag_camino = false
							clicked = false
							for(a = 0; a < array_length(pre_build_list); a++){
								_comprable = true
								if not cheat
									_comprable = is_comprable(edificio_precio_id[build_index], edificio_precio_num[build_index])
								if _comprable{
									temp_complex_2 = pre_build_list[a]
									construir(build_index, build_dir, temp_complex_2[0], temp_complex_2[1], true)
								}
							}
						}
					}
					//Vista previa no caminos
					else{
						if tag_edificio_tunel[build_index]{
							temp_complex_2 = abtoxy(temp_mx, temp_my)
							var flag_2 = false
							a = temp_mx
							b = temp_my
							var c = 0
							//Evaluar si es construible
							build_able = false
							repeat(10){
								c++
								a = a + DESFACE_A[b & 1, build_dir]
								b = b + DESFACE_B[b & 1, build_dir]
								if a < 0 or b < 0 or a >= xsize or b >= ysize
									break
								if edificio_bool[# a, b]{
									var edificio_2 = edificio_id[# a, b]
									if edificio_2.jugador = jugador and tag_edificio_tunel[edificio_2.index] and edificio_2.dir = (build_dir + 3) mod 6{
										build_target = edificio_2
										build_able = true
										break
									}
								}
							}
							//Dibujar vista previa
							if build_able{
								a = temp_mx
								b = temp_my
								repeat(c - 1){
									a = a + DESFACE_A[b & 1, build_dir]
									b = b + DESFACE_B[b & 1, build_dir]
									temp_complex_2 = abtoxy(a, b)
									draw_sprite_off(spr_tunel_view, 0, temp_complex_2[0], temp_complex_2[1],,, (build_dir - 1) * 60,, 0.5)
								}
							}
						}
						else{
							draw_edificio(temp_complex[0], temp_complex[1], build_index, build_dir, 0.5)
							//Torres de alta tensión
							if build_index = id_torre_de_alta_tension{
								draw_set_color(ui_color_energia)
								draw_circle_off(temp_complex[0], temp_complex[1], TORRE_TENSION_RANGE, true)
								for(var c = array_length(edificios_index[id_torre_de_alta_tension]) - 1; c >= 0; c--){
									var temp_edificio = edificios_index[id_torre_de_alta_tension][c]
									if temp_edificio.jugador = jugador and point_distance(temp_edificio.center_x, temp_edificio.center_y, temp_complex[0], temp_complex[1]) < TORRE_TENSION_RANGE{
										draw_line_off(temp_edificio.center_x, temp_edificio.center_y, temp_complex[0],temp_complex[1])
										draw_edificio_borde(temp_edificio, ui_color_energia, _parpadeo)
									}
								}
							}
							//Torre reparadora
							else if build_index = id_torre_reparadora{
								draw_set_color(ui_color_reparadora)
								draw_circle_off(temp_complex[0], temp_complex[1], edificio_alcance[build_index], true)
								if _change{
									temp_complex = abtoxy(mx, my)
									var chunk_x = clamp(floor(mx / CHUNK_WIDTH), 0, chunk_xsize - 1), chunk_y = clamp(floor(my / CHUNK_HEIGHT), 0, chunk_ysize - 1)
									var _chunk_alcance_x = ceil(edificio_alcance[build_index] / CHUNK_WIDTH / 48)
									var _chunk_alcance_y = ceil(edificio_alcance[build_index] / CHUNK_HEIGHT / 14)
									var mini = max(chunk_x - _chunk_alcance_x, 0), minj = max(chunk_y - _chunk_alcance_y, 0)
									var maxi = min(chunk_x + _chunk_alcance_x, chunk_xsize - 1), maxj = min(chunk_y + _chunk_alcance_y, chunk_ysize - 1)
									var temp_edificio, k, temp_array_edificio
									for(i = mini; i <= maxi; i++)
										for(j = minj; j <= maxj; j++){
											temp_array_edificio = ds_grid_get(chunk_edificios_jugador[jugador], i, j)
											for(k = array_length(temp_array_edificio) - 1; k >= 0; k--){
												temp_edificio = temp_array_edificio[k]
												if point_distance(temp_complex[0], temp_complex[1], temp_edificio.center_x, temp_edificio.center_y) < edificio_alcance[build_index]
													array_push(build_array_edificios, temp_edificio)
											}
										}
								}
								for(a = array_length(build_array_edificios) - 1; a >= 0; a--)
									draw_edificio_borde(build_array_edificios[a], ui_color_reparadora, _parpadeo)
							
							}
							//Vista previa Alcance de torres
							else if edificio_armas[build_index]{
								draw_set_color(ui_texto)
								draw_circle_off(temp_complex[0], temp_complex[1], edificio_alcance[build_index], true)
								if build_index = id_mortero
									draw_circle_off(temp_complex[0], temp_complex[1], 100, true)
							}
							//Taberías subterraneas
							else if build_index = id_tuberia_subterranea{
								var temp_list = get_size(temp_mx, temp_my, 0, 7)
								flag = false
								var temp_edificio = null_edificio
								len = array_length(temp_list)
								for(var c = 0; c < len;){
									aa = temp_list[c++]
									bb = temp_list[c++]
									if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
										continue
									if edificio_bool[# aa, bb] and not (aa = temp_mx and bb = temp_my){
										temp_edificio = edificio_id[# aa, bb]
										if temp_edificio.index = build_index and temp_edificio.link = null_edificio and temp_edificio.jugador = jugador{
											flag = true
											break
										}
									}
								}
								if flag{
									draw_set_color(ui_color_flujo)
									draw_line_off(temp_complex[0], temp_complex[1], temp_edificio.center_x, temp_edificio.center_y)
									draw_edificio_borde(temp_edificio, ui_color_flujo, _parpadeo)
								}
							}
							//Ensambladora
							else if build_index = id_ensambladora{
								if edificio_tecnologia[jugador, id_modulo] or not tecnologia{
									len = array_length(build_list_arround)
									for(a = 0; a < len;){
										aa = build_list_arround[a++]
										bb = build_list_arround[a++]
										if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
											continue
										if edificio_bool[# aa, bb]{
											var temp_edificio = edificio_id[# aa, bb]
											if temp_edificio.index = id_ensambladora and not temp_edificio.mode and temp_edificio.jugador = jugador{
												draw_edificio_borde(temp_edificio, ui_boton_verde, _parpadeo)
												temp_text += $"{L.conectando}\n"
												break
											}
										}
									}
								}
							}
							//Drones encima
							else if tag_dron_encima[build_index]{
								if _change{
									var temp_complex_array = cinta_grande_check(temp_mx, temp_my, build_dir, build_index), k
									build_array_edificios_input = temp_complex_array.inputs
									build_array_edificios_output = temp_complex_array.outputs
									build_agua = temp_complex_array.agua
									build_agua_x = temp_complex_array.agua_x
									build_agua_y = temp_complex_array.agua_y
									if build_index = id_planta_de_reciclaje{
										temp_complex = abtoxy(mx, my)
										var chunk_x = clamp(floor(mx / CHUNK_WIDTH), 0, chunk_xsize - 1), chunk_y = clamp(floor(my / CHUNK_HEIGHT), 0, chunk_ysize - 1)
										var _chunk_alcance_x = ceil(PLANTA_RECICLAJE_RANGE / CHUNK_WIDTH / 48)
										var _chunk_alcance_y = ceil(PLANTA_RECICLAJE_RANGE / CHUNK_HEIGHT / 14)
										var mini = max(chunk_x - _chunk_alcance_x, 0), minj = max(chunk_y - _chunk_alcance_y, 0)
										var maxi = min(chunk_x + _chunk_alcance_x, chunk_xsize - 1), maxj = min(chunk_y + _chunk_alcance_y, chunk_ysize - 1)
										var temp_edificio, temp_array_edificio
										for(i = mini; i <= maxi; i++)
											for(j = minj; j <= maxj; j++){
												temp_array_edificio = ds_grid_get(chunk_edificios_jugador[jugador], i, j)
												for(k = array_length(temp_array_edificio) - 1; k >= 0; k--){
													temp_edificio = temp_array_edificio[k]
													if point_distance(temp_complex[0], temp_complex[1], temp_edificio.center_x, temp_edificio.center_y) < PLANTA_RECICLAJE_RANGE
														array_push(build_array_edificios, temp_edificio)
												}
											}
									}
								}
								draw_set_color(ui_boton_azul)
								for(a = array_length(build_array_edificios_input) - 1; a >= 0; a--){
									var temp_edificio = build_array_edificios_input[a]
									draw_arrow_off(temp_edificio.center_x, temp_edificio.center_y, temp_complex[0], temp_complex[1], 10)
									draw_edificio_borde(temp_edificio, ui_boton_azul, _parpadeo)
								}
								draw_set_color(ui_boton_verde)
								for(a = array_length(build_array_edificios_output) - 1; a >= 0; a--){
									var temp_edificio = build_array_edificios_output[a]
									draw_arrow_off(temp_complex[0], temp_complex[1], temp_edificio.center_x, temp_edificio.center_y, 10)
									draw_edificio_borde(temp_edificio, ui_boton_verde, _parpadeo)
								}
								if build_index = id_planta_de_reciclaje{
									draw_set_color(ui_color_reciclaje)
									draw_circle_off(temp_complex[0], temp_complex[1], PLANTA_RECICLAJE_RANGE, true)
									for(a = array_length(build_array_edificios) - 1; a >= 0; a--)
										draw_edificio_borde(build_array_edificios[a], ui_color_reciclaje, _parpadeo)
								}
							}
							//Depósitos
							else if build_index = id_deposito
								build_rueda_flujos(_change)
						}
						//Construir
						if ((DEVISE and mouse_check_button_pressed(mb_left)) or (not DEVISE and mouse_check_button_released(mb_left) and android_building and construible and point_distance(mouse_x, mouse_y, android_mouse_x, android_mouse_y) < 10)) and flag_camino and _comprable and (not edificio_bool[# temp_mx, temp_my] or (build_index = id_cruce and edificio_camino[edificio_id[# temp_mx, temp_my].index])){
							android_building = false
							var temp_edificio = construir(build_index, build_dir, temp_mx, temp_my, true)
							/*
							if temp_edificio != null_edificio and tag_dron_encima[temp_edificio.index]{
								array_copy(temp_edificio.inputs_carga, 0, build_array_edificios_input, 0, array_length(build_array_edificios_input))
								for(a = array_length(temp_edificio.inputs_carga) - 1; a >= 0; a--){
									var temp_edificio_2 = temp_edificio.inputs_carga[a]
									array_push(temp_edificio_2.outputs_carga, temp_edificio)
									if array_contains(edificios_salida_drones, temp_edificio_2)
										array_disorder_remove(edificios_salida_drones, temp_edificio_2, ptre_salida_drones)
								}
								array_copy(temp_edificio.outputs_carga, 0, build_array_edificios_output, 0, array_length(build_array_edificios_output))
								for(a = array_length(temp_edificio.outputs_carga) - 1; a >= 0; a--)
									array_push(temp_edificio.outputs_carga[a].inputs_carga, temp_edificio)
								if array_length(temp_edificio.outputs_carga) = 0
									array_disorder_push(edificios_salida_drones, temp_edificio, ptre_salida_drones)
							}
							*/
						}
					}
					//Arcos eléctricos
					if build_index >= 0 and edificio_energia[build_index] and build_index != id_cable{
						temp_complex_2 = abtoxy(temp_mx, temp_my)
						temp_list_complex = get_size(temp_mx, temp_my, build_dir, 7)
						len = array_length(temp_list_complex)
						for(a = 0; a < len;){
							aa = temp_list_complex[a++]
							bb = temp_list_complex[a++]
							if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
								continue
							if (aa != temp_mx or bb != temp_my) and edificio_draw[# aa, bb]{
								var temp_edificio = edificio_id[# aa, bb]
								if temp_edificio.jugador = jugador and temp_edificio.index = id_cable
									draw_line_off(temp_complex_2[0], temp_complex_2[1], temp_edificio.center_x, temp_edificio.center_y)
							}
						}
					}
				}
				draw_text_background(min(room_width - string_width(temp_text), mouse_x + 20), min(room_height - string_height(temp_text), mouse_y), temp_text)
			}
		}
		last_mx = mx
		last_my = my
		if not DEVISE and mouse_check_button_released(mb_left)
			android_clic = true
	}
}