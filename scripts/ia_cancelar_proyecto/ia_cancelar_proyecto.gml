function ia_cancelar_proyecto(){
	with control{
		ia_build_pos = 0
		array_resize(ia_build_queue, 0)
		if ++ia_queue_count = array_length(ia_queue)
			IA = false
	}
}