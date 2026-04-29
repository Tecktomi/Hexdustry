function save_setting(_section, _key, _valor, _isreal = true){
	ini_open("settings.ini")
	if _isreal
		ini_write_real(_section, _key, real(_valor))
	else
		ini_write_string(_section, _key, string(_valor))
	ini_close()
}