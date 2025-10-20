function get_var_real(xpos, ypos, pc, a, b){
	with control{
		if draw_boton(xpos, ypos, (pc[a] ? "VAR_" : "") + string(pc[b]),,, mb_any, false){
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
			else
				pc[b] = get_input("", pc[b])
		}
	}
}