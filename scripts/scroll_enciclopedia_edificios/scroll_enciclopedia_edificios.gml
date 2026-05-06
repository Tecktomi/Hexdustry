function scroll_enciclopedia_edificios(a = 0, param = {xpos : 140, ypos : 0}){
	with control{
		draw_sprite_stretched(edificio_sprite[edi_sort[a]], 0, param.xpos - 20, param.ypos, 18, 18)
		if draw_boton(param.xpos + 10, param.ypos, edificio_nombre[edi_sort[a]],,,, false){
			enciclopedia_item = edi_sort[a]
			enciclopedia = 4
		}
		param.ypos += 20
	}
	return -1
}