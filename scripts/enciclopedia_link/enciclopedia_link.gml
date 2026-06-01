function enciclopedia_link(seccion, item){
	with control{
		deslizante[0] = 0
		deslizante[1] = 0
		if is_struct(seccion){
			enciclopedia = real(seccion.a)
			enciclopedia_item = real(seccion.b)
		}
		else{
			enciclopedia = real(seccion)
			enciclopedia_item = real(item)
		}
	}
}