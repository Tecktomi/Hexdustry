function herir_dron(dmg, dron = control.null_dron){
	var a = min(dron.vida, dmg)
	if dron.enemigo
		control.dmg_causado += a
	else
		control.dmg_recibido += a
	dron.vida -= dmg
	if dron.vida <= 0{
		delete_dron(dron)
		return true
	}
	return false
}