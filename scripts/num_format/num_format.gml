function num_format(numero){
	if numero < 1000
		return $"{numero}"
	else if numero < 1_000_000
		return $"{floor(numero / 1000)}k"
	else if numero < 1_000_000_000
		return $"{floor(numero / 1_000_000)}m"
	else
		return $"{floor(numero / 1_000_000_000)}b"
}