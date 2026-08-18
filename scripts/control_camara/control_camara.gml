function control_camara(min_camx = 0){
	with control{
		//WINDOWS
		if DEVISE{
			var cam_vel = 8
			if keyboard_check(vk_lcontrol) and mouse_wheel_up() and zoom < 4{
				camx -= xsize * 48 * zoom / 2
				camy -= ysize * 14 * zoom / 2
				zoom *= power(2, 0.2)
				camx += xsize * 48 * zoom / 2
				camy += ysize * 14 * zoom / 2
			}
			if keyboard_check(vk_lcontrol) and mouse_wheel_down() and zoom > 1{
				camx -= xsize * 48 * zoom / 2
				camy -= ysize * 14 * zoom / 2
				zoom /= power(2, 0.2)
				camx = clamp(camx + xsize * 48 * zoom / 2, min_camx, xsize * 48 * zoom - room_width)
				camy = clamp(camy + ysize * 14 * zoom / 2, min_camx, ysize * 14 * zoom - room_height)
			}
			if keyboard_check(CONTROL_RIGHT)
				camx = min(camx + cam_vel * (1 + 1.5 * keyboard_check(vk_lshift)), xsize * 48 * zoom - room_width)
			if keyboard_check(CONTROL_DOWN)
				camy = min(camy + cam_vel * (1 + 1.5 * keyboard_check(vk_lshift)), ysize * 14 * zoom - room_height)
			if camx > min_camx and keyboard_check(CONTROL_LEFT)
				camx = max(camx - cam_vel * (1 + 1.5 * keyboard_check(vk_lshift)), min_camx)
			if camy > 0 and keyboard_check(CONTROL_UP)
				camy = max(camy - cam_vel * (1 + 1.5 * keyboard_check(vk_lshift)), 0)
		}
		//ANDROID
		else{
			//ZOOM
			if (device_mouse_check_button(0, mb_left) and device_mouse_check_button(1, mb_left)){
				if (device_mouse_check_button(0, mb_left) and device_mouse_check_button_pressed(1, mb_left)){
					android_mouse_dis = distance(device_mouse_x(0), device_mouse_y(0), device_mouse_x(1), device_mouse_y(1))
					android_zoom = zoom
					android_hovering = true
					android_zooming = true
				}
				if android_hovering{
					camx -= xsize * 48 * zoom / 2
					camy -= ysize * 14 * zoom / 2
					zoom = clamp(android_zoom + 0.01 * (distance(device_mouse_x(0), device_mouse_y(0), device_mouse_x(1), device_mouse_y(1)) - android_mouse_dis), 1, 4)
					camx = clamp(camx + xsize * 48 * zoom / 2, min_camx, xsize * 48 * zoom - room_width)
					camy = clamp(camy + ysize * 14 * zoom / 2, min_camx, ysize * 14 * zoom - room_height)
				}
				if device_mouse_check_button(0, mb_left) and device_mouse_check_button_released(1, mb_left)
					android_hovering = false
			}
			//Movimiento
			else if not android_zooming{
				if mouse_check_button_pressed(mb_left){
					android_mouse_x = mouse_x
					android_mouse_y = mouse_y
					android_camx = camx
					android_camy = camy
					android_hovering = true
				}
				if mouse_check_button(mb_left) and android_hovering{
					camx = clamp(android_camx - mouse_x + android_mouse_x, min_camx, xsize * 40 * zoom - room_width)
					camy = clamp(android_camy - mouse_y + android_mouse_y, 0, ysize * 14 * zoom - room_height)
				}
				if mouse_check_button_released(mb_left)
					android_hovering = false
			}
			if android_zooming and device_mouse_check_button_released(0, mb_left)
				android_zooming = false
		}
	}
}