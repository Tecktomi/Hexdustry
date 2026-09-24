function herir_dron(dmg, dron = control.null_dron){
	with control{
		var a = min(dron.vida, dmg)
		if dron.jugador != jugador
			dmg_causado += a
		else
			dmg_recibido += a
		dron.vida -= dmg
		if dron.vida <= 0{
			delete_dron(dron)
			return true
		}
		return false
	}
}