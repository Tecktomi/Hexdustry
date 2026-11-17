function valid_number(val){
	return is_real(val) and not is_nan(val) and not is_infinity(val)
}
function valid_link(edificio = control.null_edificio, pc, pos){
	var b = array_length(edificio.procesador_link)
	if b = 0 or not valid_number(pc[pos + 1])
		return null_edificio
	if pc[pos] = 0{
		if not valid_number(edificio.variables[pc[pos + 1]])
			return null_edificio
		return edificio.procesador_link[clamp(edificio.variables[pc[pos + 1]], 0, b - 1)]
	}
	else
		return edificio.procesador_link[clamp(pc[pos + 1], 0, b - 1)]
}
function var_o_val(edificio, pc, pos){
	if pc[pos] = 0
		return edificio.variables[pc[pos + 1]]
	else
		return pc[pos + 1]
}
function scr_procesador(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		edificio.proceso += red_power
		var pc, pc0, val, type2, type3, b, temp_edificio, val2, val3, i, j, temp_array, temp_array_2, flag
		while edificio.proceso >= 1{
			edificio.proceso--
			if array_length(edificio.instruccion) = 0
				continue
			edificio.select = ++edificio.select mod max(1, array_length(edificio.instruccion))
			pc = edificio.instruccion[edificio.select]
			pc0 = pc[0]
			//Continue
			if pc0 = 0
				continue
			//Set {A} to {val}
			else if pc0 = 1{
				if pc[2] = 0
					edificio.variables[pc[1]] = edificio.variables[pc[3]]
				else if pc[2] = 1{
					val = real(string_digits_ext(string(pc[3])))
					if valid_number(pc[3])
						edificio.variables[pc[1]] = val
				}
				else
					edificio.variables[pc[1]] = string(pc[3])
			}
			//Set {A} to [VAR]{B} [sin, cos, tan, random, floor, round, ceil, sqr, sqrt, pi] [VAR]{C}
			else if pc0 = 2{
				val = edificio.variables[pc[1]]
				val2 = var_o_val(edificio, pc, 3)
				type2 = typeof(val2)
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
				else if pc[2] = 8 and type2 = "number" and val2 >= 0
					val = sqrt(val2)
				else if pc[2] = 9
					val = pi
				else if pc[2] = 10
					val = array_length(edificio.procesador_link)
				edificio.variables[pc[1]] = val
			}
			//Set {A} to [VAR]{b] [+, -, *, /, div, mod, or, and, xor, <<, >>, power] [VAR]{C}
			else if pc0 = 3{
				val = edificio.variables[pc[1]]
				val2 = var_o_val(edificio, pc, 2)
				val3 = var_o_val(edificio, pc, 5)
				type2 = typeof(val2)
				type3 = typeof(val3)
				if pc[4] = 0{
					if type2 = "string"
						val = val2 + string(val3)
					else if type3 != "string"
						val = val2 + val3
				}
				else if pc[4] = 1 and not(type2 = "string" or type3 = "string")
					val = val2 - val3
				else if pc[4] = 2 and not (type2 = "string") and ((val2 > 0 and val2 = floor(val2) and val2 < 256) or type3 != "string")
					val = val2 * val3
				else if pc[4] = 3 and not (type2 = "string" or type3 = "string")
					val = (val3 = 0 ? NaN : val2 / val3)
				else if pc[4] = 4 and not (type2 = "string" or type3 = "string")
					val = (val3 = 0 ? NaN : (val2 / val3 < 0 ? ceil(val2 / val3) : floor(val2 / val3)))
				else if pc[4] = 5 and not (type2 = "string" or type3 = "string")
					val = (val3 = 0 ? NaN : val2 % val3)
				else if pc[4] = 6 and not (type2 = "string" or type3 = "string")
					val = val2 | val3
				else if pc[4] = 7 and not (type2 = "string" or type3 = "string")
					val = val2 & val3
				else if pc[4] = 8 and not (type2 = "string" or type3 = "string")
					val = val2 ^ val3
				else if pc[4] = 9 and not (type2 = "string" or type3 = "string")
					val = val2 << val3
				else if pc[4] = 10 and not (type2 = "string" or type3 = "string")
					val = val2 >> val3
				else if pc[4] = 11 and not (type2 = "string" or type3 = "string")
					val = power(val2, val3)
				edificio.variables[pc[1]] = val
			}
			//If [VAR]{A} [yes, no][<, >, =] [VAR]{B}, jump to [VAR]{int}
			else if pc0 = 4{
				val = var_o_val(edificio, pc, 1)
				if valid_number(val)
					val = real(string_digits_ext(string(val)))
				else
					val = string(val)
				val2 = var_o_val(edificio, pc, 4)
				if valid_number(val2)
					val2 = real(string_digits_ext(string(val2)))
				else
					val2 = string(val2)
				if typeof(val) != typeof(val2){
					show_debug_message($"Error de procesador: comparar {val}, {val2}")
					continue
				}
				var _destino = var_o_val(edificio, pc, 6)
				if not valid_number(_destino)
					continue
				val3 = clamp(floor(_destino), 0, array_length(edificio.instruccion) - 1) - 1
				if pc[3] = 0 and val < val2
					edificio.select = val3
				else if pc[3] = 1 and val <= val2
					edificio.select = val3
				else if pc[3] = 2 and val = val2
					edificio.select = val3
				else if pc[3] = 3 and val >= val2
					edificio.select = val3
				else if pc[3] = 4 and val > val2
					edificio.select = val3
				else if pc[3] = 5 and val != val2
					edificio.select = val3
			}
			//Set VAR_{A} to [eneabled, carga, etc...][VAR]{B} from LINK[VAR]{C}
			else if pc0 = 5{
				temp_edificio = valid_link(edificio, pc, 5)
				if temp_edificio = null_edificio
					continue
				if pc[2] = 0
					val = real(temp_edificio.punteros[ptre_activo] >= 0)
				else if pc[2] = 1{
					val2 = var_o_val(edificio, pc, 3)
					if not valid_number(val2)
						continue
					val = temp_edificio.carga[clamp(val2, 0, rss_max - 1)]
				}
				else if pc[2] = 2{
					if edificio_flujo[temp_edificio.index]
						val = temp_edificio.flujo.liquido
				}
				else if pc[2] = 3{
					if edificio_flujo[temp_edificio.index]
						val = temp_edificio.flujo.almacen
				}
				else if pc[2] = 4{
					if edificio_flujo[temp_edificio.index]
						val = temp_edificio.flujo.almacen_max
				}
				else if pc[2] = 5{
					if edificio_flujo[temp_edificio.index]
						val = temp_edificio.flujo.generacion
				}
				else if pc[2] = 6{
					if edificio_flujo[temp_edificio.index]
						val = temp_edificio.flujo.consumo
				}
				else if pc[2] = 7{
					if edificio_energia[temp_edificio.index]
						val = temp_edificio.red.bateria
				}
				else if pc[2] = 8{
					if edificio_energia[temp_edificio.index]
						val = temp_edificio.red.bateria_max
				}
				else if pc[2] = 9{
					if edificio_energia[temp_edificio.index]
						val = temp_edificio.red.generacion
				}
				else if pc[2] = 10{
					if edificio_energia[temp_edificio.index]
						val = temp_edificio.red.consumo
				}
				else if pc[2] = 11{
					if tag_edificio_seteable[temp_edificio.index]
						val = real(temp_edificio.mode)
				}
				else if pc[2] = 12{
					if tag_edificio_seteable[temp_edificio.index]
						val = temp_edificio.select
				}
				edificio.variables[pc[1]] = val
			}
			//Control LINK[VAR]{A} to set [Eneable, Mode, Select] to [VAR]{B}
			else if pc0 = 6{
				temp_edificio = valid_link(edificio, pc, 1)
				if temp_edificio = null_edificio or not valid_number(pc[3])
					continue
				val = var_o_val(edificio, pc, 4)
				if not valid_number(val)
					continue
				if pc[3] = 0{
					if bool(val)
						set_edificio_instruccion(temp_edificio, cambio_activar)
					else
						desactivar_edificio(temp_edificio)
				}
				else if pc[3] = 1 and tag_edificio_seteable[temp_edificio.index]
					set_edificio(bool(val), temp_edificio.select, temp_edificio)
				else if pc[3] = 2 and tag_edificio_seteable[temp_edificio.index]{
					if temp_edificio.index = id_antena
						val = clamp(val, 0, frecuencia_max - 1)
					set_edificio(temp_edificio.mode, real(val), temp_edificio)
				}
			}
			//Set VAR_{A} to value of cell [VAR]{B} of LINK[VAR]{C}
			else if pc0 = 7{
				temp_edificio = valid_link(edificio, pc, 4)
				if temp_edificio = null_edificio or not (temp_edificio.index = id_memoria or temp_edificio.index = id_procesador or temp_edificio.index = id_antena)
					continue
				val = var_o_val(edificio, pc, 2)
				if not valid_number(val)
					continue
				if temp_edificio.index = id_memoria
					edificio.variables[pc[1]] = temp_edificio.variables[clamp(val, 0, 127)]
				else if temp_edificio.index = id_procesador
					edificio.variables[pc[1]] = temp_edificio.variables[clamp(val, 0, 15)]
				else if temp_edificio.index = id_antena{
					if temp_edificio.select < 0 or temp_edificio.select >= frecuencia_max
						continue
					edificio.variables[pc[1]] = frecuencias[temp_edificio.select]
				}
			}
			//Write [VAR]{A} into value of cell [VAR]{B} of LINK[VAR]{c}
			else if pc0 = 8{
				temp_edificio = valid_link(edificio, pc, 5)
				if temp_edificio = null_edificio or not valid_number(pc[4]) or not in(temp_edificio.index, id_mensaje, id_procesador, id_memoria, id_antena)
					continue
				val2 = var_o_val(edificio, pc, 3)
				if not valid_number(val2)
					continue
				val = var_o_val(edificio, pc, 1)
				if temp_edificio.index = id_mensaje
					temp_edificio.variables[0] = val
				else if temp_edificio.index = id_procesador
					temp_edificio.variables[clamp(val2, 0, 15)] = val
				else if temp_edificio.index = id_memoria
					temp_edificio.variables[clamp(val2, 0, 127)] = val
				else if temp_edificio.index = id_antena
					frecuencias[temp_edificio.select] = val
			}
			//Draw to LINK[VAR]{A} [clear(), color(r, g, b), rectangle(x, y, w, h), line(x1, y1, x2, y2), triangle(x1, y1, x2, y2, x3, y3), ...]
			else if pc0 = 9{
				temp_edificio = valid_link(edificio, pc, 1)
				if temp_edificio = null_edificio or temp_edificio.index != id_pantalla
					continue
				val = ""
				if pc[3] = 0
					temp_edificio.instruccion = array_create(0, array_create(1, 0))
				else if pc[3] = 1
					temp_edificio.mode = true
				else{
					temp_array = [pc[3] - 2]
					temp_array_2 = [3, 3, 4, 4, 6, 3, 3, 2]
					b = temp_array_2[pc[3] - 2]
					flag = true
					for(i = 0; i < b; i++){
						if pc[4 + 2 * i] = 0{
							if not valid_number(pc[5 + 2 * i]){
								flag = false
								continue
							}
							j = edificio.variables[pc[5 + 2 * i]]
						}
						else
							j = pc[5 + 2 * i]
						if not valid_number(j) and not (pc[3] = 8 and i = 2){
							flag = false
							continue
						}
						array_push(temp_array, j)
					}
					if flag
						array_push(temp_edificio.instruccion, temp_array)
				}
			}
		}
	}
}