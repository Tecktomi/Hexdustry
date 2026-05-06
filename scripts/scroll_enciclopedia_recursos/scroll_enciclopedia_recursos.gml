function scroll_enciclopedia_recursos(a = 0, param = {xpos : 140, ypos : 0}){
	with control{
		draw_sprite(recurso_sprite[rss_sort[a]], 0, param.xpos - 20, param.ypos + 10)
		if draw_boton(param.xpos, param.ypos, recurso_nombre[rss_sort[a]],,,, false){
			enciclopedia_item = rss_sort[a]
			enciclopedia = 3
		}
		param.ypos += 20
	}
	return -1
}