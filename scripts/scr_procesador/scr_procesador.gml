function scr_procesador(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if edificio_energia[index]
			var red = edificio.red, red_power = red.eficiencia
		if procesador_select != edificio
			edificio.proceso += red_power
		while edificio.proceso >= 1{
			edificio.proceso--
			if array_length(edificio.instruccion) = 0
				continue
			edificio.select = ++edificio.select mod max(1, array_length(edificio.instruccion))
			var pc = edificio.instruccion[edificio.select], pc0 = pc[0]
			//Continue
			if pc0 = 0
				continue
			//Set {A} to {val}
			else if pc0 = 1{
				if pc[2] = 0
					edificio.variables[pc[1]] = edificio.variables[pc[3]]
				else if pc[2] = 1
					edificio.variables[pc[1]] = real(string_digits(string(pc[3])))
				else
					edificio.variables[pc[1]] = string(pc[3])
			}
			//Set {A} to [VAR]{B} [sin, cos, tan, random, floor, round, ceil, sqr, sqrt, pi] [VAR]{C}
			else if pc0 = 2{
				var val = edificio.variables[pc[1]]
				if pc[3] = 0
					var val2 = edificio.variables[pc[4]]
				else
					val2 = pc[4]
				var type2 = typeof(val2)
				if pc[2] = 0 and type2 = "number"
					val = sin(val2)
				else if pc[2] = 1 and type2 = "number"
					val = cos(val2)
				else if pc[2] = 2 and type2 = "number"
					val = tan(val2)
				else if pc[2] = 3 and type2 = "number"
					val = random(val2)
				else if pc[2] = 4 and type2 = "number"
					val = floor(val2)
				else if pc[2] = 5 and type2 = "number"
					val = round(val2)
				else if pc[2] = 6 and type2 = "number"
					val = ceil(val2)
				else if pc[2] = 7 and type2 = "number"
					val = sqr(val2)
				else if pc[2] = 8 and type2 = "number"
					val = sqrt(val2)
				else if pc[2] = 9
					val = pi
				edificio.variables[pc[1]] = val
			}
			//Set {A} to [+, -, *, /, div, mod, or, and, xor, <<, >>, power] [VAR]{B}
			else if pc0 = 3{
				var val = edificio.variables[pc[1]]
				if pc[2] = 0
					var val2 = edificio.variables[pc[3]]
				else
					val2 = pc[3]
				if pc[5] = 0
					var val3 = edificio.variables[pc[6]]
				else
					val3 = pc[6]
				var type2 = typeof(val2), type3 = typeof(val3)
				if pc[4] = 0{
					if type2 = "string"
						val = val2 + string(val3)
					else
						val = val2 + val3
				}
				else if pc[4] = 1 and not(type2 = "string" or type3 = "string")
					val = val2 - val3
				else if pc[4] = 2 and not (type2 = "string")
					val = val2 * val3
				else if pc[4] = 3 and not (type2 = "string" or type3 = "string")
					val = val2 / val3
				else if pc[4] = 4 and not (type2 = "string" or type3 = "string")
					val = val2 div val3
				else if pc[4] = 5 and not (type2 = "string" or type3 = "string")
					val = val2 % val3
				else if pc[4] = 6
					val = val2 | val3
				else if pc[4] = 7
					val = val2 & val3
				else if pc[4] = 8
					val = val2 ^ val3
				else if pc[4] = 9
					val = val2 << val3
				else if pc[4] = 10
					val = val2 >> val3
				else if pc[4] = 11 and not (type2 = "string" or type3 = "string")
					val = power(val2, val3)
				edificio.variables[pc[1]] = val
			}
			//If [VAR]{A} [yes, no][<, >, =] [VAR]{B}, jump to [VAR]{int}
			else if pc0 = 4{
				var val3 = 0, val1 = undefined, val2 = undefined
				if pc[1] = 0
					val1 = edificio.variables[pc[2]]
				else
					val1 = pc[2]
				if string_digits(string(val1)) = string(val1)
					val1 = real(val1)
				else
					val1 = string(val1)
				if pc[5] = 0
					val2 = edificio.variables[pc[6]]
				else
					val2 = pc[6]
				if string_digits(string(val2)) = string(val2)
					val2 = real(val2)
				else
					val2 = string(val2)
				if typeof(val1) != typeof(val2){
					show_debug_message($"{val1}, {val2}")
					continue
				}
				if pc[7] = 0
					val3 = edificio.variables[pc[8]] - 1
				else
					val3 = pc[8] - 1
				if pc[4] = 0 and (not pc[3] xor (val1 < val2))
					edificio.select = val3
				if pc[4] = 1 and (not pc[3] xor (val1 > val2))
					edificio.select = val3
				if pc[4] = 2 and (not pc[3] xor (val1 = val2))
					edificio.select = val3
			}
			//Set VAR_{A} to [eneabled, carga, etc...][VAR]{B} from LINK[VAR]{C}
			else if pc0 = 5{
				var b = array_length(edificio.procesador_link), temp_edificio = null_edificio, val = -1
				if b = 0 or not is_real(pc[6])
					continue
				if pc[5] = 0{
					if not is_real(edificio.variables[pc[6]])
						continue
					temp_edificio = edificio.procesador_link[clamp(edificio.variables[pc[6]], 0, b - 1)]
				}
				else
					temp_edificio = edificio.procesador_link[clamp(pc[6], 0, b - 1)]
				b = 0
				if pc[2] = b++
					val = real(temp_edificio.punteros[4] >= 0)
				else if pc[2] = b++{
					if not is_real(pc[4])
						continue
					var val2 = 0
					if pc[3] = 0{
						val2 = edificio.variables[pc[4]]
						if not is_real(val2)
							continue
					}
					else
						val2 = pc[4]
					val = temp_edificio.carga[clamp(val2, 0, rss_max - 1)]
				}
				else if pc[2] = b++{
					if edificio_flujo[temp_edificio.index]
						val = temp_edificio.flujo.liquido
				}
				else if pc[2] = b++{
					if edificio_flujo[temp_edificio.index]
						val = temp_edificio.flujo.almacen
				}
				else if pc[2] = b++{
					if edificio_flujo[temp_edificio.index]
						val = temp_edificio.flujo.almacen_max
				}
				else if pc[2] = b++{
					if edificio_flujo[temp_edificio.index]
						val = temp_edificio.flujo.generacion
				}
				else if pc[2] = b++{
					if edificio_flujo[temp_edificio.index]
						val = temp_edificio.flujo.consumo
				}
				else if pc[2] = b++{
					if edificio_energia[temp_edificio.index]
						val = temp_edificio.red.bateria
				}
				else if pc[2] = b++{
					if edificio_energia[temp_edificio.index]
						val = temp_edificio.red.bateria_max
				}
				else if pc[2] = b++{
					if edificio_energia[temp_edificio.index]
						val = temp_edificio.red.generacion
				}
				else if pc[2] = b++{
					if edificio_energia[temp_edificio.index]
						val = temp_edificio.red.consumo
				}
				edificio.variables[pc[1]] = val
			}
			//Control LINK[VAR]{A} to set [Eneable] to [VAR]{B}
			else if pc0 = 6{
				var b = array_length(edificio.procesador_link), temp_edificio = null_edificio, val = undefined
				if b = 0 or not is_real(pc[2])
					continue
				if pc[1] = 0{
					if not is_real(edificio.variables[pc[2]])
						continue
					temp_edificio = edificio.procesador_link[clamp(edificio.variables[pc[2]], 0, b - 1)]
				}
				else
					temp_edificio = edificio.procesador_link[clamp(pc[2], 0, b - 1)]
				if pc[4] = 0
					val = edificio.variables[pc[5]]
				else
					val = pc[5]
				if pc[3] = 0 and is_real(val){
					if bool(val)
						activar_edificio(temp_edificio)
					else
						desactivar_edificio(temp_edificio)
				}
			}
			//Set VAR_{A} to value of cell [VAR]{B} of LINK[VAR]{C}
			else if pc0 = 7{
				var b = array_length(edificio.procesador_link), val = 0, temp_edificio = null_edificio
				if b = 0 or not is_real(pc[3]) or not is_real(pc[5])
					continue
				if pc[4] = 0{
					if not is_real(edificio.variables[pc[5]])
						continue
					temp_edificio = edificio.procesador_link[clamp(edificio.variables[pc[5]], 0, b - 1)]
				}
				else
					temp_edificio = edificio.procesador_link[clamp(pc[5], 0, b - 1)]
				if temp_edificio.index != id_memoria
					continue
				if pc[2] = 0
					val = real(edificio.variables[pc[3]])
				else
					val = real(pc[3])
				edificio.variables[pc[1]] = temp_edificio.variables[clamp(val, 0, 127)]
			}
			//Write [VAR]{A} into value of cell [VAR]{B} of LINK[VAR]{c}
			else if pc0 = 8{
				var b = array_length(edificio.procesador_link), val = undefined, val2 = 0, temp_edificio = null_edificio
				if b = 0 or not is_real(pc[4]) or not is_real(pc[6])
					continue
				if pc[5] = 0{
					if not is_real(edificio.variables[pc[6]])
						continue
					temp_edificio = edificio.procesador_link[clamp(edificio.variables[pc[6]], 0, b - 1)]
				}
				else
					temp_edificio = edificio.procesador_link[clamp(pc[6], 0, b - 1)]
				if not in(temp_edificio.index, id_mensaje, id_procesador, id_memoria)
					continue
				if pc[3] = 0
					val2 = edificio.variables[pc[4]]
				else
					val2 = pc[4]
				if not is_real(val2)
					continue
				if pc[1] = 0
					val = edificio.variables[pc[2]]
				else
					val = pc[2]
				if temp_edificio.index = id_mensaje
					temp_edificio.variables[0] = val
				else if temp_edificio.index = id_procesador
					temp_edificio.variables[clamp(val2, 0, 15)] = val
				else if temp_edificio.index = id_memoria
					temp_edificio.variables[clamp(val2, 0, 127)] = val
			}
			//Draw to LINK[VAR]{A} [clear(), color(r, g, b), rectangle(x, y, w, h), line(x1, y1, x2, y2), triangle(x1, y1, x2, y2, x3, y3)]
			else if pc0 = 9{
				var b = array_length(edificio.procesador_link), val = "", temp_edificio = null_edificio
				if b = 0 or not is_real(pc[2])
					continue
				if pc[1] = 0{
					if not is_real(edificio.variables[pc[2]])
						continue
					temp_edificio = edificio.procesador_link[clamp(edificio.variables[pc[2]], 0, b - 1)]
				}
				else
					temp_edificio = edificio.procesador_link[clamp(pc[2], 0, b - 1)]
				if temp_edificio.index != id_pantalla
					continue
				if pc[3] = 0
					temp_edificio.instruccion = array_create(0, array_create(1, 0))
				else if pc[3] = 8
					temp_edificio.mode = true
				else{
					var temp_array = [pc[3] - 1], temp_array_2 = [3, 3, 4, 4, 6, 3, 3], a = temp_array_2[pc[3] - 1]
					for(var i = 0; i < a; i++){
						var j = 0
						if pc[4 + 2 * i] = 0{
							if not is_real(pc[5 + 2 * i])
								continue
							j = edificio.variables[pc[5 + 2 * i]]
						}
						else
							j = pc[5 + 2 * i]
						if not is_real(j) and pc[3] != 7
							continue
						array_push(temp_array, j)
					}
					array_push(temp_edificio.instruccion, temp_array)
				}
			}
		}
	}
}