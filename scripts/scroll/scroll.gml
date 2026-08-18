function scroll(xpos, ypos, variable, cantidad_elementos, altura, funcion = null_function_scroll, param = {}, _deslizante = 0){
	with control{
		if DEVISE{
			if variable > cantidad_elementos
				deslizante[_deslizante] = floor(draw_deslizante_vertical(xpos, ypos, ypos + cantidad_elementos * altura, deslizante[_deslizante], 0, variable - cantidad_elementos, 0))
			if deslizante[_deslizante] + cantidad_elementos < variable and mouse_wheel_down()
				deslizante[_deslizante]++
			if deslizante[_deslizante] > 0 and mouse_wheel_up()
				deslizante[_deslizante]--
		}
		var out = -1
		for(var a = deslizante[_deslizante]; a < min(deslizante[_deslizante] + cantidad_elementos, variable); a++){
			out = max(out, funcion(a, param))
			if out = infinity
				break
		}
		//Android
		if not DEVISE and mouse_x > xpos and mouse_y > ypos and mouse_y < ypos + cantidad_elementos * altura and variable > cantidad_elementos{
			if mouse_check_button_pressed(mb_left){
				android_mouse_y = mouse_y
				android_camy = real(deslizante[_deslizante])
				android_hovering = true
			}
			if mouse_check_button(mb_left) and android_hovering
				deslizante[_deslizante] = clamp(floor(android_camy + (android_mouse_y - mouse_y) / altura), 0, variable - cantidad_elementos)
			if mouse_check_button_released(mb_left)
				android_hovering = false
		}
		if out != -1
			return out
	}
}