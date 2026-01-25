function herir_dron(dmg, dron = control.null_dron){
	if dron.enemigo
		control.dmg_causado += min(dron.vida, dmg)
	else
		control.dmg_recibido += min(dron.vida, dmg)
	dron.vida -= dmg
	if dron.vida <= 0{
		delete_dron(dron)
		return true
	}
	return false
}