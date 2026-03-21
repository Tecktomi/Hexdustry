function file_write(file, valor){
	if is_real(valor)
		file_text_write_real(file, real(valor))
	else
		file_text_write_string(file, string(valor))
	file_text_writeln(file)
}