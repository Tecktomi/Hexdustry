function save_escenario(save_file = ""){
	with control{
		if save_file = ""
			save_file = get_open_filename("*.txt", "save.txt")
		if save_file != ""{
			ini_open(save_file)
			ini_write_real("Global", "xsize", xsize)
			ini_write_real("Global", "ysize", ysize)
			ini_write_real("Global", "spawn_x", spawn_x)
			ini_write_real("Global", "spawn_y", spawn_y)
			ini_write_real("Global", "nucleo_x", nucleo.a)
			ini_write_real("Global", "nucleo_y", nucleo.b)
			for(var a = 0; a < rss_max; a++)
				ini_write_real("Carga inicial", a, carga_inicial[a])
			ini_write_real("Global", "oleadas", oleadas)
			ini_write_real("Global", "tiempo primera oleada", oleadas_tiempo_primera)
			ini_write_real("Global", "tiempo entre oleadas", oleadas_tiempo)
			ini_write_real("Global", "objetivos", array_length(mision_nombre))
			if array_length(mision_nombre) > 0
				ini_write_string("Global", "texto victoria", mision_texto_victoria)
			for(var a = 0; a < array_length(mision_nombre); a++){
				ini_write_string($"Objetivo {a}", "nombre", mision_nombre[a])
				for(var b = array_length(idiomas) - 1; b >= 0; b--)
					if idioma_name[b] != "es" and not ini_key_exists($"Objetivo {a}", $"nombre_{idioma_name[b]}")
						ini_write_string($"Objetivo {a}", $"nombre_{idioma_name[b]}", mision_nombre[a])
				ini_write_real($"Objetivo {a}", "objetivo", mision_objetivo[a])
				ini_write_real($"Objetivo {a}", "target_id", mision_target_id[a])
				ini_write_real($"Objetivo {a}", "target_num", mision_target_num[a])
				ini_write_real($"Objetivo {a}", "tiempo", mision_tiempo[a])
				ini_write_real($"Objetivo {a}", "tiempo victoria", real(mision_tiempo_victoria[a]))
				ini_write_real($"Objetivo {a}", "tiempo show", real(mision_tiempo_show[a]))
				ini_write_real($"Objetivo {a}", "camara move", real(mision_camara_move[a]))
				ini_write_real($"Objetivo {a}", "camara x", mision_camara_x[a])
				ini_write_real($"Objetivo {a}", "camara y", mision_camara_y[a])
				var textos = array_length(mision_texto[a])
				ini_write_real($"Objetivo {a}", "textos", textos)
				for(var b = 0; b < textos; b++){
					var texto = mision_texto[a, b]
					ini_write_real($"Objetivo {a}", $"x {b}", texto.x)
					ini_write_real($"Objetivo {a}", $"y {b}", texto.y)
					ini_write_string($"Objetivo {a}", $"texto {b}", texto.texto)
					for(var c = array_length(idiomas) - 1; c >= 0; c--)
						if idioma_name[c] != "es" and not ini_key_exists($"Objetivo {a}", $"texto {b}_{idioma_name[c]}")
							ini_write_string($"Objetivo {a}", $"texto {b}_{idioma_name[c]}", texto.texto)
				}
				ini_write_real($"Objetivo {a}", "switch oleadas", real(mision_switch_oleadas[a]))
			}
			for(var a = 0; a < edificio_max; a++)
				ini_write_real("Edificios", a, mision_edificios[a])
			ini_write_real("Global", "Multiplicador vida enemigos", multiplicador_vida_enemigos)
			var temp_array = array_create(terreno_max, 0), max_index = 0
			for(var a = 0; a < xsize; a++)
				for(var b = 0; b < ysize; b++)
					temp_array[terreno[# a, b]]++
			for(var a = 1; a < terreno_max; a++)
				if temp_array[a] > temp_array[max_index]
					max_index = a
			ini_write_real("Terreno", "Fondo", max_index)
			for(var a = 0; a < xsize; a++)
				for(var b = 0; b < ysize; b++){
					var temp_terreno = terreno[# a, b]
					if temp_terreno = max_index
						ini_key_delete("Terreno", $"{a},{b}")
					else
						ini_write_real("Terreno", $"{a},{b}", temp_terreno)
					if ore[# a, b] = -1{
						ini_key_delete("Ore", $"{a},{b}")
						ini_key_delete("Ore amount", $"{a},{b}")
					}
					else{
						ini_write_real("Ore", $"{a},{b}", ore[# a, b])
						ini_write_real("Ore amount", $"{a},{b}", ore_amount[# a, b])
					}
				}
			ini_close()
			ini_open("settings.ini")
			ini_write_real("Saves", save_file, current_day)
			ini_close()
			input_layer = 0
			get_file = 0
			var b = array_get_index(save_files, save_file), temp_text = string_delete(save_file, string_pos(".", save_file), 4)
			save_file = temp_text
			var temp_sprite = minimapa(terreno)
			sprite_save(temp_sprite, 0, temp_text + ".png")
			if b = -1
				array_push(save_files_png, temp_sprite)
		}
	}
}