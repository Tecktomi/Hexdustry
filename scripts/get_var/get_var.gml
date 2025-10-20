function get_var(xpos, ypos, pc, a, b){
	with control{
		if draw_boton(xpos, ypos, (pc[a] ? $"VAR_{pc[b]}" : (is_real(pc[b]) ? string(pc[b]) : $"'{pc[b]}'")),,, mb_any, false){
			if mouse_lastbutton = mb_right{
				pc[a] = not pc[a]
				if pc[a]{
					if is_real(pc[b])
						pc[b] = clamp(pc[b], 0, 15)
					else
						pc[b] = 0
				}
			}
			else if pc[a]
				pc[b] = clamp(floor(get_input("", pc[b])), 0, 15)
			else{
				var c = get_input_string("", string(pc[b]))
				if string_digits(c) = c or c = ""
					pc[b] = real(c)
				else
					pc[b] = string(c)
			}
		}
	}
}