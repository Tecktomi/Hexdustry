function scr_planta_nuclear(edificio = control.null_edificio){
	with control{
		var index = edificio.index
		if edificio_flujo[index]
			var flujo = edificio.flujo, flujo_power = flujo.eficiencia
		//Está encendido
		if edificio.fuel > 0{
			edificio.fuel--
			if not in(flujo.liquido, 0, 4){
				if edificio_herir(edificio, 4)
					exit
			}
			else{
				if flujo_power < 1 and edificio_herir(edificio, 1 - flujo_power)
					exit
				change_energia(edificio_energia_consumo[index] * flujo_power, edificio)
			}
		}
		if edificio.fuel = 0 and in(flujo.liquido, 0, 4){
			//Encender
			if edificio.carga[id_uranio_enriquecido] > 0 and edificio.carga[id_uranio_empobrecido] > 0 and flujo_power > 0{
				edificio.fuel = 300
				edificio.carga[id_uranio_enriquecido] -= 0.1
				edificio.carga[id_uranio_empobrecido]--
				encender_luz(2, edificio)
				change_energia(edificio_energia_consumo[index] * flujo_power, edificio)
				change_flujo(edificio_flujo_consumo[index], edificio)
				edificio.carga_total -= 1.1
				mover_in(edificio)
			}
			//Apagar
			else{
				encender_luz(-2, edificio)
				change_energia(0, edificio)
				change_flujo(0, edificio)
			}
		}
	}
}