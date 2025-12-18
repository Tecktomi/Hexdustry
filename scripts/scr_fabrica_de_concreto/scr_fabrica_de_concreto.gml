function scr_fabrica_de_concreto(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		if flujo.liquido = 0 and edificio.carga[id_arena] > 1 and (edificio.carga[id_piedra] > 0 or edificio.carga[id_piedra_cuprica] > 0 or edificio.carga[id_piedra_ferrica] > 0 or edificio.carga[id_piedra_sulfatada] > 0) and edificio.carga[id_concreto] < 10{
			//Encender
			if edificio.proceso < 0{
				change_flujo(edificio_flujo_consumo[index], edificio)
				edificio.proceso++
			}
			edificio.proceso += flujo_power
			//Producir / Apagar
			if edificio.proceso >= edificio_proceso[index]{
				edificio.carga[id_arena] -= 2
				if edificio.carga[id_piedra] > 0
					edificio.carga[id_piedra]--
				else if edificio.carga[id_piedra_cuprica] > 0
					edificio.carga[id_piedra_cuprica]--
				else if edificio.carga[id_piedra_ferrica] > 0
					edificio.carga[id_piedra_ferrica]--
				else if edificio.carga[id_piedra_sulfatada] > 0
					edificio.carga[id_piedra_sulfatada]--
				edificio.carga[id_concreto]++
				edificio.carga_total -= 2
				edificio.proceso = -1
				edificio.waiting = not mover(edificio.a, edificio.b)
				change_flujo(0, edificio)
			}
		}
	}
}