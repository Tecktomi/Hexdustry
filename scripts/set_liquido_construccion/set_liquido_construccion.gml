function set_liquido_construccion(liquido){
	with control{
		if liquido = -1
			array_resize(liquido_choose_array, 0)
		else
			liquido_choose_array = array_create(2, real(liquido))
		liquido_choose = 0
	}
}