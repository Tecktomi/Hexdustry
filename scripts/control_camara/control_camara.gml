function control_camara(min_camx = 0){
	with control{
		var cam_vel = 8
		if keyboard_check_pressed(vk_f4)
			window_set_fullscreen(not window_get_fullscreen())
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
			camy = clamp(camy + ysize * 14 * zoom/ 2, min_camx, ysize * 14 * zoom - room_height)
		}
		if keyboard_check(ord("D"))
			camx = min(camx + cam_vel * (1 + 1.5 * keyboard_check(vk_lshift)), xsize * 48 * zoom - room_width)
		if keyboard_check(ord("S"))
			camy = min(camy + cam_vel * (1 + 1.5 * keyboard_check(vk_lshift)), ysize * 14 * zoom - room_height)
		if camx > min_camx and keyboard_check(ord("A"))
			camx = max(camx - cam_vel * (1 + 1.5 * keyboard_check(vk_lshift)), min_camx)
		if camy > 0 and keyboard_check(ord("W"))
			camy = max(camy - cam_vel * (1 + 1.5 * keyboard_check(vk_lshift)), 0)
	}
}