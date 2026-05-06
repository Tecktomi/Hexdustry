function scroll_enciclopedia_drones(a = 0, param = {xpos : 140, ypos : 0}){
	with control{
		if draw_boton(param.xpos, param.ypos, dron_nombre[a],,,, false){
			enciclopedia_item = a
			enciclopedia = 6
		}
		param.ypos += 20
	}
	return -1
}