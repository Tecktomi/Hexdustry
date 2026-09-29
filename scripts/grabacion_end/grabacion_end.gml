function grabacion_end(filename){
	with control{
		if GRABANDO and timer > 0 and not REPRODUCIENDO
		    buffer_save_ext(buffer_grabacion, filename, 0, buffer_tell(buffer_grabacion))
		buffer_seek(buffer_grabacion, buffer_seek_start, 0)
		grabacion_pos = 0
		REPRODUCIENDO = false
	}
}