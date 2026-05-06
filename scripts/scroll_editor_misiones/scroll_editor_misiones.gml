function scroll_editor_misiones(a = 0, param = {xpos : 0, ypos : 0}){
	with control{
		if a > 0 and draw_sprite_boton(spr_flecha,, param.xpos, param.ypos){
			var	temp_string = string(mision_nombre[a - 1])
			mision_nombre[a - 1] = mision_nombre[a]
			mision_nombre[a] = temp_string
			var	temp_real = real(mision_objetivo[a - 1])
			mision_objetivo[a - 1] = mision_objetivo[a]
			mision_objetivo[a] = temp_real
			temp_real = real(mision_target_id[a - 1])
			mision_target_id[a - 1] = mision_target_id[a]
			mision_target_id[a] = temp_real
			temp_real = real(mision_target_num[a - 1])
			mision_target_num[a - 1] = mision_target_num[a]
			mision_target_num[a] = temp_real
			temp_real = real(mision_tiempo[a - 1])
			mision_tiempo[a - 1] = mision_tiempo[a]
			mision_tiempo[a] = temp_real
			var temp_bool = bool(mision_tiempo_edit[a - 1])
			mision_tiempo_edit[a - 1] = mision_tiempo_edit[a]
			mision_tiempo_edit[a] = temp_real
			temp_real = real(mision_tiempo_victoria[a - 1])
			mision_tiempo_victoria[a - 1] = mision_tiempo_victoria[a]
			mision_tiempo_victoria[a] = temp_real
			temp_real = real(mision_tiempo_show[a - 1])
			mision_tiempo_show[a - 1] = mision_tiempo_show[a]
			mision_tiempo_show[a] = temp_real
			temp_bool = bool(mision_camara_move[a - 1])
			mision_camara_move[a - 1] = mision_camara_move[a]
			mision_camara_move[a] = temp_bool
			temp_real = real(mision_camara_x[a - 1])
			mision_camara_x[a - 1] = mision_camara_x[a]
			mision_camara_x[a] = temp_real
			temp_real = real(mision_camara_y[a - 1])
			mision_camara_y[a - 1] = mision_camara_y[a]
			mision_camara_y[a] = temp_real
			var temp_array = mision_texto[a - 1]
			mision_texto[a - 1] = mision_texto[a]
			mision_texto[a] = temp_array
			temp_bool = bool(mision_switch_oleadas[a - 1])
			mision_switch_oleadas[a - 1] = mision_switch_oleadas[a]
			mision_switch_oleadas[a] = temp_bool
		}
		if draw_boton(param.xpos + 20, param.ypos, $"'{mision_nombre[a]}'")
			mision_actual = a
		param.ypos += 30
	}
	return -1
}