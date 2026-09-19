function scr_fabrica_de_lubricante(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		var red = edificio.red, red_power = red.eficiencia
		var flujo = edificio.flujo, flujo_power = flujo.eficiencia, flujo_2 = edificio.flujo_2
		if flujo.liquido = idl_petroleo and flujo_2.liquido = idl_lubricante and red_power > 0 and flujo_power > 0{
			change_flujo(edificio.flujo_consumo_max * red_power, edificio)
			//Encender
			if not edificio.start{
				edificio_encender(edificio)
				edificio.start = true
			}
			var consumo_real = edificio.flujo_consumo * flujo_power
			var a = -consumo_real - edificio.flujo_2_consumo
			edificio.flujo_2_consumo = -consumo_real
			flujo_2.generacion -= a
			edificio.proceso += consumo_real / edificio.flujo_consumo_max
			edificio.draw_rot += consumo_real / edificio.flujo_consumo_max
			//Producir / Apagar
			if edificio.proceso >= edificio_proceso[index]{
				edificio.proceso -= edificio_proceso[index]
				edificio.start = false
				edificio.waiting = not mover(edificio)
				edificio_encender(edificio, false)
			}
		}
		//Apagar
		else{
			edificio_encender(edificio, false)
			flujo_2.generacion += edificio.flujo_2_consumo
			edificio.flujo_2_consumo = 0
			edificio.start = false
		}
		if edificio.carga_total > 0
			edificio.waiting = not mover(edificio)
	}
}