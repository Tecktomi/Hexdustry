function procesador_var(xpos, ypos, pc, a){
	return clamp(floor(draw_boton_text(xpos, ypos, pc[a], true)), 0, 15)
}