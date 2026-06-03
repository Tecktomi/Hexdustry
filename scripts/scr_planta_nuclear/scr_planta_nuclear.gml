function scr_planta_nuclear(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		//Está encendido
		if edificio.fuel > 0{
			edificio.fuel--
			if not in(flujo.liquido, idl_agua, idl_agua_salada){
				if edificio.modulo
					fuel = 0
				draw_set_color(c_yellow)
				var cam_center_x = (camx + room_width * zoom / 2), cam_center_y = (camy + room_height * zoom / 2)
				var angle = arctan2(cam_center_y - edificio.center_x, cam_center_x - edificio.center_y), cosa = cos(angle), sina = sin(angle)
				draw_line(room_width / 2 - 60 * cosa, room_height / 2 - 60 * sina, room_width / 2 - 90 * cosa, room_height / 2 - 90 * sina)
				if (image_index mod 145) = 0
						audio_play_sound(snd_nuclear, 0, false, 0.5)
				if herir_edificio(1, edificio)
					exit
			}
			else{
				if flujo_power < 1{
					if edificio.modulo and edificio.vida < 0.2 * edificio_vida[index]
						fuel = 0
					draw_set_color(c_yellow)
					var cam_center_x = (camx + room_width * zoom / 2), cam_center_y = (camy + room_height * zoom / 2)
					var angle = arctan2(cam_center_y - edificio.center_y, cam_center_x - edificio.center_x), cosa = cos(angle), sina = sin(angle)
					draw_line(room_width / 2 - 60 * cosa, room_height / 2 - 60 * sina, room_width / 2 - 90 * cosa, room_height / 2 - 90 * sina)
					if (image_index mod 145) = 0
						audio_play_sound(snd_nuclear, 0, false, 0.3)
					if herir_edificio(1 - flujo_power, edificio)
						exit
				}
				change_energia(edificio_energia_consumo[index] * flujo_power, edificio)
			}
		}
		else if in(flujo.liquido, idl_agua, idl_agua_salada){
			//Encender
			if edificio.carga[idr_uranio_enriquecido] >= 1 and flujo_power > 0{
				edificio.fuel = 3000
				edificio.carga[idr_uranio_enriquecido]--
				encender_luz(, edificio)
				change_energia(edificio_energia_consumo[index] * flujo_power, edificio)
				change_flujo(edificio_flujo_consumo[index], edificio)
				edificio.carga_total--
				mover_in(edificio)
			}
			//Apagar
			else{
				encender_luz(false, edificio)
				change_energia(0, edificio)
				change_flujo(0, edificio)
			}
		}
	}
}