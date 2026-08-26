function step(){
	with control{
		//Detenerse por LAG
		if online and not servidor and timer + LAG > server_timer
			exit
		var a, b, cambio, temp_array_real, buffer, edificio, municion, target, _jugador, _tipo, _dmg, temp_complex, muna, munb, len, efecto, humo, fuego, temp_time, flag, temp_complex_list, i, aa, bb, enemigo, temp_text_right, file, red, flujo, temp_explosion
		//Input multijugador
		if online and not servidor
			for(a = array_length(cambios) - 1; a >= 0; a--){
				cambio = cambios[a]
				if cambio.step <= timer{
					array_delete(cambios, a, 1)
					if cambio.tipo = 0
						construir(cambio.data.index, cambio.data.dir, cambio.data.a, cambio.data.b,, true, cambio.data.cheat, cambio.data.jugador)
					else if cambio.tipo = 1
						delete_edificio(edificio_id[# cambio.data.a, cambio.data.b], false, true, cambio.data.cheat)
					else if cambio.tipo = 2
						set_edificio(cambio.data.mode, cambio.data.select, edificio_id[# cambio.data.a, cambio.data.b], true)
					else if cambio.tipo = 3
						mover_dron(drones[cambio.data.index], cambio.data.x, cambio.data.y, true)
					else if cambio.tipo = 4
						add_modulo(edificio_id[# cambio.data.a, cambio.data.b], true, cambio.data.cheat)
					else if cambio.tipo = 5
						investigar(cambio.data.index, true, cambio.data.cheat)
				}
			}
		acumulator -= LOGIC_DT
		//Estadísticas / Guardado automático
		if win = 0{
			if (++timer mod 3600) = 0{
				temp_array_real = array_create(rss_max, 0)
				array_copy(temp_array_real, 0, recursos_obtenidos_time_temp, 0, rss_max)
				for(a = 0; a < rss_max; a++)
					recursos_obtenidos[a] += recursos_obtenidos_time_temp[a]
				array_push(recursos_obtenidos_time, temp_array_real)
				recursos_obtenidos_time_temp = array_create(rss_max, 0)
				array_push(energia_producida, energia_producida_time)
				energia_producida_time = 0
				array_push(energia_consumida, energia_consumida_time)
				energia_consumida_time = 0
				array_push(energia_perdida, energia_perdida_time)
				energia_perdida_time = 0
				if auto_guardado and tutorial = 0 and os_browser = browser_not_a_browser and not mapa_editado{
					if tutorial = 0{
						buffer = buffer_create(1024, buffer_grow, 1)
						save_game_buffer(buffer)
						buffer_save(buffer, "last_save.save")
						buffer_delete(buffer)
					}
					else{
						buffer = buffer_create(1024, buffer_grow, 1)
						save_game_buffer(buffer)
						buffer_save(buffer, $"Tutorial/mision{world_tutorial[# a, b]}.save")
						buffer_delete(buffer)
					}
				}
			}
			if online and servidor and ((timer mod LAG) = 0 or (timer mod LAG) = LAG / 2)
				server_sync_timer()
		}
		//Ciclo edificios
		for(a = array_length(edificios_activos) - 1; a >= 0; a--){
			edificio = edificios_activos[a]
			if edificio.idle or edificio.vida <= 0
				continue
			edificio_script[edificio.index](edificio)
		}
		for(a = array_length(edificios_pendientes) - 1; a >= 0; a--){
			edificio = array_pop(edificios_pendientes)
			if edificio.eliminar and edificio.punteros[4] >= 0{
				edificio.eliminar = false
				array_disorder_remove(edificios_activos, edificio, 4)
				edificio.punteros[4] = -1
			}
			if edificio.agregar and edificio.punteros[4] = -1{
				edificio.agregar = false
				array_disorder_push(edificios_activos, edificio, 4)
			}
		}
		//Drones
		dron_logic()
		//Ciclo de disparos
		draw_set_alpha(0.5)
		var trazo
		for(a = array_length(municiones) - 1; a >= 0; a--){
			municion = municiones[a]
			target = municion.target
			_jugador = municion.jugador
			_tipo = municion.tipo
			_dmg = municion.dmg
			if _tipo != 2{
				if draw_once{
					draw_set_color(c_black)
					draw_circle_off(municion.x, municion.y, 2, false)
					draw_set_color(c_yellow)
					draw_line_off(municion.origen_x, municion.origen_y, municion.x, municion.y)
				}
			}
			municion.origen_x = municion.x
			municion.origen_y = municion.y
			municion.x += municion.hmove
			municion.y += municion.vmove
			if municion.rastreador{
				if municion.target != null_dron{
					municion.x += 0.2 * sign(municion.target.x - municion.x)
					municion.y += 0.2 * sign(municion.target.y - municion.y)
				}
				else if municion.target_build != null_edificio{
					municion.x += 0.2 * sign(municion.target_build.center_x - municion.x)
					municion.y += 0.2 * sign(municion.target_build.center_y - municion.y)
				}
				if (image_index mod 10) < 5 and draw_once{
					draw_set_color(c_red)
					draw_set_alpha(0.3)
					draw_circle(municion.x, municion.y, 10, false)
					draw_set_alpha(1)
				}
			}
			trazo = line_of_sight(municion.origen_x, municion.origen_y, municion.x, municion.y)
			for(b = 1; b < array_length(trazo); b++){
				muna = trazo[b, 0]
				munb = trazo[b, 1]
				if grafic_humo and municion.humo
					array_push(humos, add_humo(municion.x, municion.y, muna, munb, random_range(-1, 1), random_range(-1, 1), irandom_range(20, 30)))
				//Colisión Edificio
				if edificio_bool[# muna, munb]{
					edificio = edificio_id[# muna, munb]
					if _tipo != 4 and edificio.enemigo != municion.enemigo{
						municion.dis = 0
						break
					}
				}
				//Colisión Dron
				if _tipo != 2 and target != null_dron and target.vida > 0 and muna = target.a and munb = target.b{
					herir_dron(_dmg, target)
					if _tipo != 4{
						municion.dis = 0
						break
					}
				}
				//Munición perforadora
				if _tipo = 4
					herir_hexagono(muna, munb, floor(_dmg / 2), false, municion.jugador)
			}
			if --municion.dis <= 0{
				municiones[a] = municiones[array_length(municiones) - 1]
				array_pop(municiones)
				//Daño unidad
				if target != null_dron and target.vida > 0{
					//Daño fuego
					if _tipo = 2
						aplicar_efecto(1, 120, target)
					//Daño área
					else
						herir_hexagono(muna, munb, _dmg,, municion.jugador)
				}
				//Daño edificio
				if municion.target_build != null_edificio and municion.target_build.vida > 0
					herir_hexagono(muna, munb, _dmg,, municion.jugador)
				//Misil
				if _tipo = 1
					explosion(municion.x, municion.y, municion.target_build, municion.radio,,, _jugador)
				//Misil incendiario
				else if _tipo = 3
					explosion(municion.x, municion.y, municion.target_build, municion.radio,, true, _jugador)
			}
		}
		draw_set_alpha(1)
		//Efectos estáticos
		len = array_length(efectos)
		for(a = 0; a < len; a++){
			efecto = efectos[a]
			if show_smoke and draw_once
				draw_sprite_off(efecto.sprite, efecto.subsprite, efecto.x, efecto.y)
			efecto.subsprite += efecto.frame_speed
			if --efecto.tiempo <= 0{
				efectos[a--] = efectos[array_length(efectos) - 1]
				array_pop(efectos)
				len--
			}
		}
		//Humo
		len = array_length(humos)
		for(a = 0; a < len; a++){
			humo = humos[a]
			if show_smoke and humo.a >= mina and humo.b >= minb and humo.a < maxa and humo.b < maxb{
				if draw_once
					draw_sprite_off(spr_blur_32, max(3 - humo.time / 10, 0), humo.x, humo.y)
				humo.x += humo.hmove
				humo.y += humo.vmove
				humo.hmove *= 0.99
				humo.vmove *= 0.99
			}
			if --humo.time <= 0{
				humos[a--] = humos[--len]
				array_pop(humos)
			}
		}
		//Fuego
		draw_set_alpha(0.4)
		len = array_length(fuegos)
		for(a = 0; a < len; a++){
			fuego = fuegos[a]
			if show_smoke and fuego.a >= mina and fuego.b >= minb and fuego.a < maxa and fuego.b < maxb{
				if draw_once{
					draw_set_color(make_color_hsv(fuego.intensidad, 127, 255))
					draw_circle_off(fuego.x, fuego.y, 10, false)
				}
				fuego.x += fuego.hmove
				fuego.y += fuego.vmove
				fuego.hmove *= 0.9
				fuego.vmove *= 0.9
				if grafic_humo and random(1) < 0.05
					array_push(humos, add_humo(fuego.x, fuego.y, fuego.a, fuego.b, random_range(-1, 1), random_range(-1, 1), 15))
			}
			if --fuego.intensidad <= 0{
				fuegos[a--] = fuegos[array_length(fuegos) - 1]
				array_pop(fuegos)
				len--
				if grafic_humo and fuego.a >= mina and fuego.b >= minb and fuego.a < maxa and fuego.b < maxb
					array_push(humos, add_humo(fuego.x, fuego.y, fuego.a, fuego.b, random_range(-1, 1), random_range(-1, 1), 15))
			}
		}
		draw_set_alpha(1)
		//Oleadas
		if oleadas and (++oleadas_timer >= 60 * oleadas_tiempo_primera or (not chat_input and keyboard_check_pressed(vk_enter))){
			temp_time = oleadas_timer / 60 - oleadas_tiempo_primera
			if (temp_time mod oleadas_tiempo) = 0 or keyboard_check_pressed(vk_enter){
				a = ++oleada_count + 2
				b = 1
				flag = false
				if mision_actual >= 0 and mision.objetivo = 4 and ++mision_counter >= mision.target_num
					oleadas = false
				for(i = 0; i < array_length(SIZE_SIZE); i++)
					if a <= SIZE_SIZE[i]{
						b = i + 1
						flag = true
						break
					}
				if not flag
					b = array_length(SIZE_SIZE)
				temp_complex_list = get_size(spawn_x, spawn_y, 0, b)
				len = min(array_length(temp_complex_list), a)
				for(i = 0; i < len; i++){
					temp_complex = temp_complex_list[i]
					aa = clamp(temp_complex[0], 0, xsize - 1)
					bb = clamp(temp_complex[1], 0, ysize - 1)
					if grid_water_distance[# aa, bb] < infinity
						if irandom(len) > i + 7{
							enemigo = add_dron(aa, bb, idd_destructor, true, 1)
							i += 8
							continue
						}
						else if irandom(len) > i + 2{
							enemigo = add_dron(aa, bb, idd_barco, true, 1)
							i += 3
							continue
						}
					if not terreno_caminable[terreno[# aa, bb]] or edificio_cercano[# aa, bb] = null_edificio or (tutorial = 0 and random(1) < 0.15){
						if irandom(len) > i + 11{
							enemigo = add_dron(aa, bb, idd_bombardero, true, 1)
							i += 10
						}
						else if irandom(len) > i + 5{
							enemigo = add_dron(aa, bb, idd_helicoptero, true, 1)
							i += 4
						}
						else
							enemigo = add_dron(aa, bb, idd_kamikaze, true, 1)
					}
					else{
						if irandom(len) > i + 15{
							enemigo = add_dron(aa, bb, idd_titan, true, 1)
							i += 14
						}
						else if irandom(len) > i + 6{
							enemigo = add_dron(aa, bb, idd_tanque, true, 1)
							i += 5
						}
						else
							enemigo = add_dron(aa, bb, idd_arana, true, 1)
					}
				}
			}
		}
		//Misiones
		temp_text_right = ""
		if mision_actual >= 0 and win = 0{
			a = mision_actual
			if in(mision.objetivo, 5, 7) and not oleadas and (not chat_input and keyboard_check_pressed(vk_enter)){
				keyboard_clear(vk_enter)
				pasar_mision()
			}
			if mision.tiempo > 0{
				if mision_camara_step <= 0 and --mision_current_tiempo <= 0{
					if mision.tiempo_victoria
						pasar_mision()
					else
						win = 2
				}
			}
			else if mision.objetivo = 1{
				mision_counter = jugador_recursos[0, mision.target_id]
				if mision_counter >= mision.target_num{
					pasar_mision()
					a++
				}
			}
			else if mision.objetivo = 3{
				mision_counter = edificios_counter[mision.target_id]
				if mision_counter >= mision.target_num{
					pasar_mision()
					a++
				}
			}
			else if mision.objetivo = 6{
				mision_counter += (keyboard_check(CONTROL_RIGHT) or keyboard_check(CONTROL_LEFT) or keyboard_check(CONTROL_UP) or keyboard_check(CONTROL_DOWN))
				if mision_counter >= mision.target_num{
					pasar_mision()
					a++
				}
			}
		}
		if mision_actual = -1 and in(tutorial, 1, 2, 3, 4) and win = 0{
			draw_set_halign(fa_right)
			if draw_once and draw_boton(room_width - 20, string_height(temp_text_right) + 64, L.win_siguiente_mision, ui_verde){
				file = load_escenario_buffer($"mision_{tutorial + 1}.txt")
				if file != ""
					game_start()
				tutorial++
			}
			draw_set_halign(fa_left)
		}
		energia_solar = clamp(2 * sin((image_index + 900) / 1800), 0, 1)
		//Ciclo de redes
		for(a = array_length(redes) - 1; a >= 0; a--){
			red = redes[a]
			red.bateria = clamp(red.bateria + (red.generacion - red.consumo) / 30, 0, red.bateria_max)
			red.eficiencia = clamp((red.generacion + red.bateria) / max(1, red.consumo), 0, 1)
			red.promedio = (19 * red.promedio + red.generacion - red.consumo) / 20
			if red.edificios[0].jugador = jugador{
				energia_producida_time += red.generacion / 60
				energia_consumida_time += red.consumo / 60
				if red.eficiencia = 1 and red.bateria = red.bateria_max
					energia_perdida_time += (abs(red.generacion) - abs(red.consumo)) / 60
			}
		}
		//Ciclo flujos
		for(a = array_length(flujos) - 1; a >= 0; a--){
			flujo = flujos[a]
			flujo.almacen = clamp(flujo.almacen + (flujo.generacion - flujo.consumo) / 30, 0, flujo.almacen_max)
			flujo.promedio = (19 * flujo.promedio + flujo.generacion - flujo.consumo) / 20
			if flujo.almacen = 0
				flujo.eficiencia = clamp(flujo.generacion / max(1, flujo.consumo), 0, 1)
			else
				flujo.eficiencia = 1
			if flujo.almacen < 1 and flujo.generacion = 0{
				if grafic_luz and flujo.liquido = 3
					for(b = array_length(flujo.edificios) - 1; b >= 0; b--){
						edificio = flujo.edificios[b]
						encender_luz(false, edificio)
					}
				if flujo.liquido_forzado = 0
					flujo.liquido = -1
			}
		}
		if array_length(explosion_queue) > 0{
			for(a = array_length(explosion_queue) - 1; a >= 0; a--){
				temp_explosion = explosion_queue[a]
				explosion(temp_explosion.x, temp_explosion.y, temp_explosion.edificio, temp_explosion.radio, temp_explosion.dmg, temp_explosion.incendiario, temp_explosion.jugador)
			}
			array_resize(explosion_queue, 0)
		}
		//Explosión nuclear
		if nuclear_step > 0{
			if --nuclear_step > 150 and draw_once{
				draw_set_color(c_white)
				draw_set_alpha((nuclear_step - 150) / 150)
				draw_rectangle(0, 0, room_width, room_height, false)
			}
			if draw_once and nuclear_x >= 0
				draw_sprite_off(spr_blur, 0, nuclear_x, nuclear_y,,,,, nuclear_step / 300)
			draw_set_color(c_black)
			draw_set_alpha(1)
		}
		if image_index mod 20 = 0{
			viento_dir += random_range(-0.01, 0.01)
			viento_mag = clamp(viento_mag + random_range(-0.01, 0.01), 0.5, 2)
		}
		draw_once = false
	}
}