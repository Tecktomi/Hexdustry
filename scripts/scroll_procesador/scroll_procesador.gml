function scroll_procesador(a, param = {xpos : 0, ypos : 0, edificio : null_edificio, size : 0, b : 0}){
	with control{
		var xpos = param.xpos, ypos = param.ypos, edificio = param.edificio, size = param.size
		var pc = edificio.instruccion[a], pc0 = pc[0]
		xpos = 150
		draw_set_halign(fa_right)
		draw_text_xpos(xpos, ypos, ((edificio.select + 1) mod size = a ? ">" : "") + $"{a}|")
		draw_set_halign(fa_left)
		if draw_sprite_boton(spr_basura,, xpos, ypos, 20, 20,, hover_sprite_boton_text, {a : L.procesador_borrar}){
			array_delete(edificio.instruccion, a, 1)
			return 0
		}
		xpos += 20
		if draw_sprite_boton(spr_clonar,, xpos, ypos, 20, 20,, hover_sprite_boton_text, {a : L.procesador_clonar}){
			var temp_array = []
			for(var c = 0; c < array_length(pc); c++)
				array_push(temp_array, pc[c])
			array_insert(edificio.instruccion, a + 1, temp_array)
		}
		xpos += 20
		if draw_sprite_boton(spr_flecha,, xpos, ypos, 20, 20,, hover_sprite_boton_text, {a : L.procesador_subir})
			procesador_move = a
		xpos += 20
		if procesador_move >= 0 and mouse_y > ypos and mouse_y < ypos + text_y{
			draw_set_alpha(0.3)
			draw_rectangle(150, ypos, xpos, ypos + text_y, false)
			draw_set_alpha(1)
			if mouse_check_button_released(mb_left) and a != procesador_move{
				array_insert(edificio.instruccion, a, edificio.instruccion[procesador_move])
				array_delete(edificio.instruccion, procesador_move + (procesador_move > a), 1)
				procesador_move = -1
			}
		}
		//Continue
		if pc0 = 0
			draw_text(xpos, ypos, L.procesador_continue)
		//Set {A} to [VAR]{B}
		else if pc0 = 1{
			xpos = draw_text_xpos(xpos, ypos, $"{L.procesador_set} VAR_")
			pc[1] = procesador_var(xpos, ypos, pc, 1)
			xpos = draw_text_xpos(xpos + text_x, ypos, " to ")
			procesador_valor(xpos, ypos, pc, 2, 3, false)
		}
		//Set {A} to [sin, cos, tan, random, floor, round, ceil, sqr, sqrt, pi] [VAR]{B}
		else if pc0 = 2{
			var signs = procesador_nombres_1var
			xpos = draw_text_xpos(xpos, ypos, $"{L.procesador_set} VAR_")
			pc[1] = procesador_var(xpos, ypos, pc, 1)
			xpos = draw_text_xpos(xpos + text_x, ypos, $" {L.procesador_to} ")
			pc[2] = draw_boton_text_list(xpos, ypos, pc[2], signs,, 10)
			if not in(signs[pc[2]], "pi"){
				xpos = draw_text_xpos(xpos + text_x, ypos, $" ")
				procesador_valor(xpos, ypos, pc, 3, 4)
			}
		}
		//Set {A} to [VAR]{B} [+, -, *, /, div, mod, or, and, xor, <<, >>, power] [VAR]{C}
		else if pc0 = 3{
			var signs = procesador_nombres_2var
			xpos = draw_text_xpos(xpos, ypos, $"{L.procesador_set} VAR_")
			pc[1] = procesador_var(xpos, ypos, pc, 1)
			xpos = draw_text_xpos(xpos + text_x, ypos, $" {L.procesador_to} ")
			procesador_valor(xpos, ypos, pc, 2, 3)
			xpos += text_x
			pc[4] = draw_boton_text_list(xpos, ypos, pc[4], signs,, 10)
			procesador_valor(xpos + text_x, ypos, pc, 5, 6)
		}
		//If [VAR]{A} [yes, no][<, >, =] [VAR]{B}, jump to [VAR]{C}
		else if pc0 = 4{
			var signs = [" < ", " <= ", " = ", " >= ", " > ", " != "]
			xpos = draw_text_xpos(xpos, ypos, $"{L.procesador_if} ")
			procesador_valor(xpos, ypos, pc, 1, 2, false)
			xpos += text_x
			pc[3] = draw_boton_text_list(xpos, ypos, pc[3], signs,, 10)
			xpos += text_x
			procesador_valor(xpos, ypos, pc, 4, 5, false)
			xpos = draw_text_xpos(xpos + text_x, ypos, $", {L.procesador_jump} ")
			procesador_valor(xpos, ypos, pc, 6, 7, true)
			if not pc[6]
				pc[7] = clamp(pc[7], 0, size)
			xpos += text_x
			var val = 0, flag = true
			if pc[6] = 0{
				if is_real(edificio.variables[pc[7]])
					val = real(edificio.variables[pc[7]])
				else
					flag = false
			}
			else
				val = real(pc[7])
			if draw_sprite_boton(spr_siguiente,, xpos, ypos, 20, 20)
				procesador_link_handle = a
			xpos += 20
			if procesador_link_handle = a{
				draw_set_color(c_white)
				draw_rectangle(xpos, ypos + 8, mouse_x, ypos + 10, false)
				draw_rectangle(mouse_x - 2, ypos + 8, mouse_x, mouse_y, false)
			}
			if flag and a != val{
				draw_set_color(make_color_hsv((49 * param.b) mod 255, 127, 127))
				draw_rectangle(xpos, ypos + 8, xpos + 10 + 10 * ++param.b, ypos + 12, false)
				draw_rectangle(xpos + 8 + 10 * param.b, ypos + 12, xpos + 10 + 10 * param.b, 150 + val * 20, false)
				draw_rectangle(xpos, 148 + val * 20, xpos + 10 + 10 * param.b, 152 + val * 20, false)
				draw_set_color(c_white)
			}
		}
		//Set VAR_{A} to [eneabled, carga, etc...][VAR]{B} from LINK[VAR]{C}
		else if pc0 = 5{
			var signs = procesador_nombres_read_data
			var signs_subindex = [false, true, false, false, false, false, false, false, false, false, false]
			xpos = draw_text_xpos(xpos, ypos, $"{L.procesador_set} VAR_")
			pc[1] = procesador_var(xpos, ypos, pc, 1)
			xpos = draw_text_xpos(xpos + text_x, ypos, $" {L.procesador_to} ")
			pc[2] = draw_boton_text_list(xpos, ypos, pc[2], signs,, 10)
			xpos += text_x
			if signs_subindex[pc[2]]{
				xpos = draw_text_xpos(xpos, ypos, "[")
				procesador_valor(xpos, ypos, pc, 3, 4, true)
				xpos = draw_text_xpos(xpos + text_x, ypos, "]")
			}
			xpos = draw_text_xpos(xpos, ypos, $" {L.procesador_from} LINK_")
			procesador_valor(xpos, ypos, pc, 5, 6, true)
		}
		//Control LINK[VAR]{A} to set [Eneable] to [VAR]{B}
		else if pc0 = 6{
			var signs = ["Eneabled"]
			xpos = draw_text_xpos(xpos, ypos, $"{L.procesador_control} LINK_")
			procesador_valor(xpos, ypos, pc, 1, 2, true)
			xpos = draw_text_xpos(xpos + text_x, ypos, $" {L.procesador_to_set} ")
			if draw_boton(xpos, ypos, signs[pc[3]],,,, false)
				pc[3] = (pc[3] + 1) mod array_length(signs)
			xpos = draw_text_xpos(xpos + text_x, ypos, $" {L.procesador_to} ")
			procesador_valor(xpos, ypos, pc, 4, 5, false)
		}
		//Set VAR_{A} to value of cell [VAR]{B} of LINK[VAR]{C}
		else if pc0 = 7{
			xpos = draw_text_xpos(xpos, ypos, $"{L.procesador_set} VAR_")
			pc[1] = procesador_var(xpos, ypos, pc, 1)
			xpos = draw_text_xpos(xpos + text_x, ypos, $" {L.procesador_to_value_of_cell} ")
			procesador_valor(xpos, ypos, pc, 2, 3, true)
			xpos = draw_text_xpos(xpos + text_x, ypos, $" {L.procesador_from} LINK_")
			procesador_valor(xpos, ypos, pc, 4, 5, true)
		}
		//Write [VAR]{A} into value of cell [VAR]{B} of LINK[VAR]{c}
		else if pc0 = 8{
			xpos = draw_text_xpos(xpos, ypos, $"{L.procesador_write} ")
			procesador_valor(xpos, ypos, pc, 1, 2, false)
			xpos = draw_text_xpos(xpos + text_x, ypos, $" {L.procesador_into_value_of_cell} ")
			procesador_valor(xpos, ypos, pc, 3, 4, true)
			xpos = draw_text_xpos(xpos + text_x, ypos, $" {L.procesador_of} LINK_")
			procesador_valor(xpos, ypos, pc, 5, 6, true)
		}
		//Draw to LINK[VAR]{B} [clear(), color(r, g, b), color(h, s, v), rectangle(x, y, w, h), line(x1, y1, x2, y2), triangle(x1, y1, x2, y2, x3, y3), circle(x, y, radio), draw_flush()]
		else if pc0 = 9{
			var signs = procesador_nombres_draw
			xpos = draw_text_xpos(xpos, ypos, $"{L.procesador_write} {L.procesador_to} LINK_")
			procesador_valor(xpos, ypos, pc, 1, 2, true)
			xpos += text_x
			xpos = draw_text_xpos(xpos, ypos, " ")
			var prev_pc3 = pc[3]
			pc[3] = draw_boton_text_list(xpos, ypos, pc[3], signs,, 10)
			if pc[3] = 7 and prev_pc3 != 7{
				pc[8] = 0
				pc[9] = 0
			}
			if pc[3] = 0
				xpos = draw_text_xpos(xpos + text_x, ypos, "()")
			else if pc[3] = 1{
				xpos = draw_text_xpos(xpos + text_x, ypos, "(R:")
				procesador_valor(xpos, ypos, pc, 4, 5, true)
				xpos = draw_text_xpos(xpos + text_x, ypos, ", G:")
				procesador_valor(xpos, ypos, pc, 6, 7, true)
				xpos = draw_text_xpos(xpos + text_x, ypos, ", B:")
				procesador_valor(xpos, ypos, pc, 8, 9, true)
				xpos = draw_text_xpos(xpos + text_x, ypos, ")")
			}
			else if pc[3] = 2{
				xpos = draw_text_xpos(xpos + text_x, ypos, "(H:")
				procesador_valor(xpos, ypos, pc, 4, 5, true)
				xpos = draw_text_xpos(xpos + text_x, ypos, ", S:")
				procesador_valor(xpos, ypos, pc, 6, 7, true)
				xpos = draw_text_xpos(xpos + text_x, ypos, ", V:")
				procesador_valor(xpos, ypos, pc, 8, 9, true)
				xpos = draw_text_xpos(xpos + text_x, ypos, ")")
			}
			else if pc[3] = 3{
				xpos = draw_text_xpos(xpos + text_x, ypos, "(X:")
				procesador_valor(xpos, ypos, pc, 4, 5, true)
				xpos = draw_text_xpos(xpos + text_x, ypos, ", Y:")
				procesador_valor(xpos, ypos, pc, 6, 7, true)
				xpos = draw_text_xpos(xpos + text_x, ypos, ", width:")
				procesador_valor(xpos, ypos, pc, 8, 9, true)
				xpos = draw_text_xpos(xpos + text_x, ypos, ", height:")
				procesador_valor(xpos, ypos, pc, 10, 11, true)
				xpos = draw_text_xpos(xpos + text_x, ypos, ")")
			}
			else if pc[3] = 4{
				xpos = draw_text_xpos(xpos + text_x, ypos, "(X1:")
				procesador_valor(xpos, ypos, pc, 4, 5, true)
				xpos = draw_text_xpos(xpos + text_x, ypos, ", Y1:")
				procesador_valor(xpos, ypos, pc, 6, 7, true)
				xpos = draw_text_xpos(xpos + text_x, ypos, ", X2:")
				procesador_valor(xpos, ypos, pc, 8, 9, true)
				xpos = draw_text_xpos(xpos + text_x, ypos, ", Y2:")
				procesador_valor(xpos, ypos, pc, 10, 11, true)
				xpos = draw_text_xpos(xpos + text_x, ypos, ")")
			}
			else if pc[3] = 5{
				xpos = draw_text_xpos(xpos + text_x, ypos, "(X1:")
				procesador_valor(xpos, ypos, pc, 4, 5, true)
				xpos = draw_text_xpos(xpos + text_x, ypos, ", Y1:")
				procesador_valor(xpos, ypos, pc, 6, 7, true)
				xpos = draw_text_xpos(xpos + text_x, ypos, ", X2:")
				procesador_valor(xpos, ypos, pc, 8, 9, true)
				xpos = draw_text_xpos(xpos + text_x, ypos, ", Y2:")
				procesador_valor(xpos, ypos, pc, 10, 11, true)
				xpos = draw_text_xpos(xpos + text_x, ypos, ", X3:")
				procesador_valor(xpos, ypos, pc, 12, 13, true)
				xpos = draw_text_xpos(xpos + text_x, ypos, ", Y3:")
				procesador_valor(xpos, ypos, pc, 14, 15, true)
				xpos = draw_text_xpos(xpos + text_x, ypos, ")")
			}
			else if pc[3] = 6{
				xpos = draw_text_xpos(xpos + text_x, ypos, "(X:")
				procesador_valor(xpos, ypos, pc, 4, 5, true)
				xpos = draw_text_xpos(xpos + text_x, ypos, ", Y:")
				procesador_valor(xpos, ypos, pc, 6, 7, true)
				xpos = draw_text_xpos(xpos + text_x, ypos, ", radio:")
				procesador_valor(xpos, ypos, pc, 8, 9, true)
				xpos = draw_text_xpos(xpos + text_x, ypos, ")")
			}
			else if pc[3] = 7{
				xpos = draw_text_xpos(xpos + text_x, ypos, "(X:")
				procesador_valor(xpos, ypos, pc, 4, 5, true)
				xpos = draw_text_xpos(xpos + text_x, ypos, ", Y:")
				procesador_valor(xpos, ypos, pc, 6, 7, true)
				xpos = draw_text_xpos(xpos + text_x, ypos, ", text:")
				procesador_valor(xpos, ypos, pc, 8, 9, false)
				xpos = draw_text_xpos(xpos + text_x, ypos, ")")
			}
			else if pc[3] = 8
				xpos = draw_text_xpos(xpos + text_x, ypos, "()")
		}
		if procesador_link_handle != -1 and mouse_y > ypos and mouse_y < ypos + text_y{
			draw_set_alpha(0.5)
			draw_rectangle(150, ypos, xpos, ypos + text_y, false)
			draw_set_alpha(1)
			if mouse_check_button_released(mb_left){
				array_set(edificio.instruccion[procesador_link_handle], 6, 1)
				array_set(edificio.instruccion[procesador_link_handle], 7, a)
				procesador_link_handle = -1
			}
		}
		param.ypos += editor_item_size
	}
	return - 1
}