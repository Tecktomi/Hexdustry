function day_format(){
	var year = string_delete(string(current_year), 0, 2)
	var mes = $"{current_month < 10 ? "0" : ""}{current_month}"
	var dia = $"{current_day < 10 ? "0" : ""}{current_day}"
	var hora = $"{current_hour < 10 ? "0" : ""}{current_hour}"
	var minuto = $"{current_minute < 10 ? "0" : ""}{current_minute}"
	return $"{year}{mes}{dia}_{hora}{minuto}"
}