randomize()
draw_set_font(ft_letra)
ini_open("settings.ini")
sonido = bool(ini_read_real("", "sonido", 1))
ini_write_string("Global", "version", "04_01_2026")
ini_close()
save_files = (os_browser == browser_not_a_browser) ? scan_files("*.txt", fa_none) : []
if os_browser == browser_not_a_browser{
	for(var a = array_length(save_files) - 1; a >= 0; a--){
		save_file = save_files[a]
		var temp_text = string_delete(save_file, string_pos(".", save_file), 4)
		if file_exists(temp_text + ".png")
			var temp_image = sprite_add(temp_text + ".png", 1, false, false, 0, 0)
		else
			temp_image = spr_null_image
		save_files_png[a] = temp_image
	}
}
else
	game_set_speed(30, gamespeed_fps)
save_codes = (os_browser == browser_not_a_browser) ? scan_files("*.code", fa_none) : []
idiomas = (os_browser == browser_not_a_browser) ? scan_files("*.json", fa_none) : ["en.json", "es.json", "ru.json"]
for(var a = array_length(idiomas) - 1; a >= 0; a--)
	idioma_name[a] = string_delete(idiomas[a], string_pos(".", idiomas[a]), 5)
idioma = 1
set_idioma(idiomas[idioma], false)
#region Metadatos
	menu = 0
	cursor = cr_arrow
	deslizante_id = -1
	xsize = 48
	ysize = 96
	chunk_width = 4
	chunk_height = 12
	chunk_xsize = ceil(xsize / chunk_width)
	chunk_ysize = ceil(ysize / chunk_height)
	prev_x = 0
	prev_y = 0
	prev_change = true
	mx_clic = 0
	my_clic = 0
	show_menu = false
	show_menu_build = undefined
	pausa = 0
	show_menu_x = 0
	show_menu_y = 0
	edificio_count = 0
	energia_solar = 1
	flow = 0
	build_index = -1
	build_size = 1
	build_dir = 0
	build_dir_camino = 0
	build_able = false
	editor_herramienta = 0
	last_mx = -1
	last_my = -1
	build_list = get_size(0, 0, 0, 0)
	build_list_arround = get_size(0, 0, 0, 0)
	build_menu = 0
	menu_x = 0
	menu_y = 0
	clicked = false
	menu_array = []
	cheat = false
	info = false
	zoom = 1
	camx = (xsize * 48 - room_width) / 2
	camy = (ysize * 14 - room_height) / 2
	oleada_count = 0
	keyboard_step = 0
	angle_dir = [pi / 6, pi / 2, 5 * pi / 6, 7 * pi / 6, 3 * pi / 2, 11 * pi / 6]
	for(var a = 0; a < 6; a++){
		cos_angle_dir[a] = cos(angle_dir[a])
		sin_angle_dir[a] = sin(angle_dir[a])
	}
	pre_build_list = array_create(0, {a : 0, b : 0})
	background = ds_grid_create(chunk_xsize, chunk_ysize)
	for(var a = 0; a < chunk_xsize; a++)
		for(var b = 0; b < chunk_ysize; b++)
			ds_grid_set(background, a, b, spr_hexagono)
	sprite_boton_text = ""
	editor_menu = 0
	mision_nombre = array_create(0, "")
	mision_objetivo = array_create(0, 0)
	mision_target_id = array_create(0, 0)
	mision_target_num = array_create(0, 0)
	mision_tiempo = array_create(0, 0)
	mision_tiempo_edit = array_create(0, false)
	mision_tiempo_victoria = array_create(0, false)
	mision_tiempo_show = array_create(0, true)
	mision_texto = array_create(0, array_create(0, {x : 0, y : 0, texto : ""}))
	mision_camara_move = array_create(0, false)
	mision_camara_x = array_create(0, 0)
	mision_camara_y = array_create(0, 0)
	mision_camara_step = 0
	mision_camara_x_start = 0
	mision_camara_y_start = 0
	mision_texto_victoria = "Todos los objetivos cumplidos"
	mision_actual = -1
	mision_counter = 0
	mision_current_tiempo = 0
	mision_choosing_coord = false
	mision_choosing_coord_tipo = 0
	mision_choosing_coord_i = 0
	mision_switch_oleadas = array_create(0, false)
	get_keyboard_string = -1
	get_keyboard_cursor = 0
	get_keyboard_text = ""
	get_keyboard_string_text = ""
	objetivos_nombre = ["conseguir", "tener almacenado", "construir", "tener construido", "sobrevivir oleadas", "sin objetivo", "apretar ADWS", "cargar edificio"]
	objetivos_nombre_display = []
	array_copy(objetivos_nombre_display, 0, objetivos_nombre, 0, array_length(objetivos_nombre))
	oleadas = true
	oleadas_tiempo_primera = 210
	oleadas_tiempo = 75
	null_efecto = add_efecto()
	efectos = array_create(0, null_efecto)
	grafic_tile_animation = true
	grafic_luz = false
	grafic_pared = true
	grafic_humo = true
	grafic_hideui = false
	text_x = 0
	text_y = 0
	enciclopedia = 0
	enciclopedia_item = 0
	null_humo = add_humo(0, 0, 0, 0, 0, 0, 0)
	humos = array_create(0, null_humo)
	direccion_viento = random(2 * pi)
	null_fuego = add_fuego(0, 0, 0, 0, 0, 0, 0)
	fuegos = array_create(0, null_fuego)
	mina = 0
	minb = 0
	maxa = 0
	maxb = 0
	sonidos = [snd_motor, snd_maquina, snd_horno]
	sonidos_max = array_length(sonidos)
	musica = [snd_musica, snd_theme_2]
	volumen = array_create(sonidos_max, 0)
	sonido_id = array_create(sonidos_max)
	for(var a = 0; a < sonidos_max; a++){
		sonido_id[a] = audio_play_sound(sonidos[a], 1, true)
		audio_pause_sound(sonido_id[a])
	}
	procesador_instrucciones_length = [1, 4, 5, 7, 9, 7, 6, 6, 7, 16]
	procesador_instrucciones_nombre = [
		"Continuar",
		"Asignar variable",
		"Operaciones de una variable",
		"Operaciones de dos variables",
		"Saltar a línea",
		"Leer información de edificio",
		"Controlar edificio",
		"Leer datos de Memoria",
		"Escribir datos a Memoria",
		"Dibujar a Pantalla"]
	procesador_instrucciones_nombre_display = []
	array_copy(procesador_instrucciones_nombre_display, 0, procesador_instrucciones_nombre, 0, array_length(procesador_instrucciones_nombre))
	procesador_add = false
	procesador_move = -1
	input_layer = 0
	show_smoke = true
	oleadas_timer = 0
	multiplicador_vida_enemigos = 100
	save_file = ""
	editor_seed = random_get_seed()
	editor_fondo = 0
	editor_instrucciones = array_create(0, array_create(4, 0))
	draw_boton_text_counter = 0
	editor_xpos = 0
	editor_ypos = 0
	editor_array_name = array_create(0, "")
	editor_array = array_create(0, 0)
	editor_max_height = 25
	editor_list = false
	nuclear_x = 0
	nuclear_y = 0
	nuclear_step = 0
	win = 0
	win_step = 0
	timer = 0
	edificios_construidos = 0
	drones_construidos = 0
	enemigos_eliminados = 0
	tecnologias_estudiadas = 0
	misiones_pasadas = 0
	tutorial = 0
	get_file = 0
	tecnologia = true
	tecnologia_precio_multiplicador = 1
	chunk_update = true
	LOGIC_DT = 1 / 60
	acumulator = 0
	deslizante = array_create(1, 0)
	modo_misiones = false
#endregion
#region UI
	ui_fondo = #282828
	ui_panel_secundario = #383838
	ui_borde = #606060
	ui_sombra = #141414
	ui_texto = #E9E9E9
	ui_texto_secundario = #B3B3B3
	ui_texto_inhabilitado = #7F7F7F
	ui_boton_verde = #448A20
	ui_boton_azul = #4169E1
	ui_boton_gris = #606060
	ui_boton_rojo = #A00000
#endregion
null_edificio = {
	index : -1,
	dir : 0,
	a : 0,
	b : 0,
	x : 0,
	y : 0,
	coordenadas : ds_list_create(),
	bordes : ds_list_create(),
	inputs : [],
	input_index : 0,
	outputs : [],
	output_index : 0,
	proceso : 0,
	carga : [0],
	carga_max : [0],
	carga_output : [false],
	carga_id : 0,
	carga_total : 0,
	fuel : 0,
	select : -1,
	mode : false,
	waiting : false,
	idle : false,
	link : undefined,
	red : undefined,
	energia_link : [],
	flujo : undefined,
	flujo_link: [],
	vida : 0,
	target : undefined,
	flujo_consumo : 0,
	flujo_consumo_max : 0,
	energia_consumo : 0,
	energia_consumo_max : 0,
	edificio_index : 0,
	coordenadas_dis : ds_grid_create(xsize, ysize),
	coordenadas_close : ds_list_create(),
	vivo : false,
	emisor : false,
	receptor : false,
	luz : false,
	instruccion : array_create(0, array_create(1, 0)),
	variables : [],
	pointer : -1,
	procesador_link : undefined,
	eliminar : false,
	agregar : false,
	chunk_x : 0,
	chunk_y : 0,
	chunk_pointer : 0,
	target_chunks : array_create(0, {a : 0, b : 0}),
	target_pointer : 0,
	array_real : array_create(0, 0),
	xscale : 1,
	yscale : 1,
	draw_rot : 0,
	edificios_cercanos : [],
	edificios_cercanos_heridos : [],
	reparadores_cercanos : [],
	imagen : spr_hexagono,
}
null_edificio.link = null_edificio
ds_list_add(null_edificio.coordenadas, {a : 0, b : 0})
ds_list_clear(null_edificio.coordenadas)
ds_list_add(null_edificio.bordes, {a : 0, b : 0})
ds_list_clear(null_edificio.bordes)
null_edificio.energia_link = array_create(0, null_edificio)
null_edificio.flujo_link = array_create(0, null_edificio)
ds_grid_clear(null_edificio.coordenadas_dis, 0)
ds_list_add(null_edificio.coordenadas_close, {a : 0, b : 0})
ds_list_clear(null_edificio.coordenadas_close)
null_edificio.edificios_cercanos = array_create(0, null_edificio)
null_edificio.edificios_cercanos_heridos = array_create(0, null_edificio)
null_edificio.reparadores_cercanos = array_create(0, null_edificio)
build_target = null_edificio
edificios_activos = array_create(0, null_edificio)
procesador_select = null_edificio
null_edificio.procesador_link = array_create(0, null_edificio)
edificios_pendientes = array_create(0, null_edificio)
//Puertos de Carga
puerto_carga_bool = false
puerto_carga_link = null_edificio
puerto_carga_array = array_create(0, null_edificio)
puerto_carga_atended = 0
#region GRIDS
	edificio_bool = ds_grid_create(xsize, ysize)
	ds_grid_clear(edificio_bool, false)
	edificio_id = ds_grid_create(xsize, ysize)
	ds_grid_clear(edificio_id, null_edificio)
	edificio_draw = ds_grid_create(xsize, ysize)
	ds_grid_clear(edificio_draw, false)
	ore = ds_grid_create(xsize, ysize)
	ds_grid_clear(ore, -1)
	ore_amount = ds_grid_create(xsize, ysize)
	ds_grid_clear(ore_amount, 0)
	ore_random = ds_grid_create(xsize, ysize)
	ds_grid_clear(ore_random, 0)
	terreno = ds_grid_create(xsize, ysize)
	ds_grid_clear(terreno, 1)
	edificio_cercano = ds_grid_create(xsize, ysize)
	ds_grid_clear(edificio_cercano, null_edificio)
	edificio_cercano_dis = ds_grid_create(xsize, ysize)
	ds_grid_clear(edificio_cercano_dis, infinity)
	edificio_cercano_dir = ds_grid_create(xsize, ysize)
	ds_grid_clear(edificio_cercano_dir, -1)
	edificio_cercano_priority = ds_grid_create(xsize, ysize)
	pre_abtoxy = ds_grid_create(xsize + 2, ysize + 2)
	ds_grid_clear(pre_abtoxy, {a : 0, b : 0})
	for(var a = 0; a < xsize; a++){
		ds_grid_set(pre_abtoxy, a, 0, {
			a : real(a + 0.5) * 48 + 16,
			b : 0
		})
		ds_grid_set(pre_abtoxy, a, ysize + 1, {
			a : real(a + 0.5) * 48 + 16,
			b : (ysize + 2) * 14
		})
		for(var b = 0; b < ysize; b++){
			var temp_priority = ds_priority_create()
			ds_priority_add(temp_priority, null_edificio, 0)
			ds_priority_delete_max(temp_priority)
			ds_grid_set(edificio_cercano_priority, a, b, temp_priority)
			var temp_complex = {
				a : real(a + (b mod 2) / 2) * 48 + 16,
				b : real(b + 1) * 14
			}
			var temp_hexagono = instance_create_layer(temp_complex.a, temp_complex.b, "instances", obj_hexagono)
			ds_grid_set(pre_abtoxy, a + 1, b + 1, temp_complex)
			ds_grid_set(ore_random, a, b, random(1))
			temp_hexagono.a = a
			temp_hexagono.b = b
		}
	}
	for(var b = 0; b < ysize; b++){
		ds_grid_set(pre_abtoxy, 0, b, {
			a : real((b mod 2) / 2) * 48 + 16,
			b : real(b + 1) * 14
		})
		ds_grid_set(pre_abtoxy, xsize + 1, b, {
			a : real(xsize + 1 + (b mod 2) / 2) * 48 + 16,
			b : real(b + 1) * 14
		})
	}
	luz = ds_grid_create(xsize, ysize)
	ds_grid_clear(luz, 0)
	terreno_pared_index = ds_grid_create(xsize, ysize)
	ds_grid_clear(terreno_pared_index, 0)
	repair_id = ds_grid_create(xsize, ysize)
	ds_grid_clear(repair_id, -1)
	repair_dir = ds_grid_create(xsize, ysize)
	ds_grid_clear(repair_dir, 0)
	background_bool = ds_grid_create(chunk_xsize, chunk_ysize)
	ds_grid_clear(background_bool, false)
#endregion
//Enemigos
efectos_nombre = ["Shock", "Fuego", "Deslizando"]
efectos_max = array_length(efectos_nombre)
null_enemigo = {
	a : 0,
	b : 0,
	index : 0,
	vida : 5,
	vida_max : 5,
	target : null_edificio,
	temp_target : null_edificio,
	chunk_x : 0,
	chunk_y : 0,
	chunk_pointer : 0,
	carga : [0],
	carga_total : 0,
	modo : 0,
	pointer : 0,
	torres : array_create(0, null_edificio),
	dir : 0,
	dir_move : 0,
	step : 0,
	efecto : array_create(efectos_max, 0),
	array_real : array_create(0, 0),
	oleada : 0,
	random_int : random(1)
}
enemigos = array_create(0, null_enemigo)
drones_aliados = array_create(0, null_enemigo)
null_edificio.target = null_enemigo
chunk_enemigos = ds_grid_create(chunk_xsize, chunk_ysize)
chunk_edificios = ds_grid_create(chunk_xsize, chunk_ysize)
for(var a = chunk_xsize - 1; a >= 0; a--)
	for(var b = chunk_ysize - 1; b >= 0; b--){
		ds_grid_set(chunk_enemigos, a, b, array_create(0, null_enemigo))
		ds_grid_set(chunk_edificios, a, b, array_create(0, null_edificio))
	}
selected_dron = null_enemigo
//Recursos
#region Definición
	recurso_descripcion = [
		"Recurso básico, escencial para los primeros edificios. Puede ser refinado para obtener Bronce",
		"Combustible básico, útil para el funcionamiento de Hornos y Generadores",
		"Recurso útil para la construcción de infrastructura intermedia",
		"Recurso básico, escencial para los primeros edificios",
		"Recurso útil para la construcción de infrastructura intermedia",
		"Recurso necesario para la producción de bienes refinados como Silicio o Concreto",
		"Recurso necesario para la producción de Concreto. Puede ser transformado en Arena en un Triturador",
		"Recurso útil en la producción de Paneles Solares, Drones y Circuitos",
		"Recurso útil para la construcción de infrastructura intermedia",
		"Puede ser utilizada como Piedra normal o purificada para obtener Cobre",
		//10
		"Puede ser utilizada como Piedra normal o porificada para obtener Hierro",
		"Puede ser utilizada como Piedra normal. Pero es escencial en la producción de bienes más refinados",
		"Combustible avanzado, más eficiente y dduradero que el Carbón",
		"Munición avanzada para Morteros y necesario para el funcionamiento de Taladros de Explosión",
		"Recurso necesario para la producción de todo tipo de Drones",
		"Material ligero, útil en la producción de Drones",
		"Circuito básico, necesario para la producción de todo tipo de Drones y edificios eléctricos avanzados",
		"Uranio sin refinar, útil como munición. Puede ser refinado para dividir el Uranio Empobrecido del Enriquecido",
		"Uranio 235, útil para la generación de energía en Plantas Nucleares",
		"Uranio 238, necesario para acompañar la producción de energía en Plantas Nucleares. Y útil como munición",
		//20
		"Recurso útil para mejorar otros procesos industriales como la planta química, refinería de petróleo y producción de Silicio",
		"Barril con Agua, útil para almacenarla y distribuirla",
		"Barril con Ácido, útil para almacenarlo y distribuirlo",
		"Barril con Petróleo, útil para almacenarlo y distribuirlo",
		"Barril con Lava, útil para almacenarla y distribuirla",
		"Barril con Agua salada, útil para almacenarla y distribuirla"
	]
	for(var a = array_length(recurso_descripcion) - 1; a >= 0; a--)
		recurso_descripcion[a] = text_wrap(recurso_descripcion[a], 400)
#endregion
#region Arreglos
	recurso_sprite = []
	recurso_nombre = []
	recurso_nombre_display = []
	recurso_color = []
	recurso_combustion = []
	recurso_combustion_time = []
	recurso_tier = []
#endregion
function def_recurso(name, sprite = spr_item_hierro, color = c_black, combustion = 0, tier = 0){
	array_push(recurso_nombre, string(name))
	array_push(recurso_nombre_display, string(name))
	array_push(recurso_sprite, sprite)
	array_push(recurso_color, color)
	array_push(recurso_combustion_time, combustion)
	array_push(recurso_combustion, (combustion > 0))
	array_push(recurso_tier, tier)
	return array_length(recurso_nombre) - 1
}
#region Definición
	id_cobre = def_recurso("Cobre", spr_item_cobre, #C06A2C,, 0)
	id_carbon = def_recurso("Carbón", spr_item_carbon, #2B2B2B, 300, 0)
	id_bronce = def_recurso("Bronce", spr_item_bronce, #8C6A3D,, 1)
	id_hierro = def_recurso("Hierro", spr_item_hierro, #7A4A3A,, 0)
	id_acero = def_recurso("Acero", spr_item_acero, #5F6A72,, 1)
	id_arena = def_recurso("Arena", spr_item_arena, #D2B48C,, 2)
	id_piedra = def_recurso("Piedra", spr_item_piedra, #7A7A74,, 2)
	id_silicio = def_recurso("Silicio", spr_item_vidrio, #A0A4A8,, 2)
	id_concreto = def_recurso("Concreto", spr_item_concreto, #9A9A94,, 3)
	id_piedra_cuprica = def_recurso("Piedra Cúprica", spr_item_piedra_cobre, #8A5A32, 2)
	//10
	id_piedra_ferrica = def_recurso("Piedra Férrica", spr_item_piedra_hierro, #6B4B3A,, 2)
	id_piedra_sulfatada = def_recurso("Piedra Sulfatada", spr_item_piedra_azufre, #8E8A6A,, 2)
	id_combustible = def_recurso("Compuesto Incendiario", spr_item_combustible, #A63D2D, 900, 3)
	id_explosivo = def_recurso("Explosivo", spr_item_explosivos, #C7A12E,, 3)
	id_baterias = def_recurso("Batería", spr_item_bateria, #5B5F3A,, 4)
	id_plastico = def_recurso("Plástico", spr_item_plastico, #B8C2CC,, 3)
	id_electronico = def_recurso("Electrónicos", spr_item_chip, #3F6F5A,, 3)
	id_uranio_bruto = def_recurso("Uranio Bruto", spr_item_uranio, #6E8F3A,, 4)
	id_uranio_enriquecido = def_recurso("Uranio Enriquecido", spr_item_uranio_235, #9DBB3C,, 4)
	id_uranio_empobrecido = def_recurso("Uranio Empobrecido", spr_item_uranio_238, #4F5F32,, 4)
	//20
	id_sal = def_recurso("Sal", spr_item_sal, #D8D6CF,, 2)
	id_barril_agua = def_recurso("Barril con Agua", spr_item_barril_agua, #5FC8F0,, 2)
	id_barril_acido = def_recurso("Barril con Ácido", spr_item_barril_acido, #FFEF00,, 3)
	id_barril_petroleo = def_recurso("Barril con Petróleo", spr_item_barril_petroleo, #000707,, 3)
	id_barril_lava = def_recurso("Barril con Lava", spr_item_barril_lava, #FBAF5D,, 3)
	id_barril_agua_salada = def_recurso("Barril con Agua salada", spr_item_barril_agua_salada, #3F6E85,, 2)
#endregion
rss_max = array_length(recurso_nombre)
sort_recursos()
//Disparos
null_municion = add_municion()
municiones = array_create(0, null_municion)
#region Tipos de disparos
	armas = [
		[{recurso : id_cobre, cantidad : 0.2, dmg : 20}, {recurso : id_hierro, cantidad : 0.2, dmg : 30}, {recurso : id_plastico, cantidad : 0.2, dmg : 40}],
		[{recurso : id_bronce, cantidad : 0.5, dmg : 60}, {recurso : id_acero, cantidad : 0.5, dmg : 70}, {recurso : id_uranio_bruto, cantidad : 1, dmg : 100}],
		[{recurso : id_explosivo, cantidad : 1, dmg : 500}, {recurso : id_uranio_bruto, cantidad : 1, dmg : 400}],
		[{recurso : id_carbon, cantidad : 0.03, dmg : 2}, {recurso : id_combustible, cantidad : 0.03, dmg : 5}]]
#endregion
//Terrenos
#region Arreglos
	terreno_nombre = []
	terreno_nombre_display = []
	terreno_sprite = []
	terreno_recurso_bool = []
	terreno_recurso_id = []
	terreno_caminable = []
	terreno_liquido = []
	terreno_pared = []
	terreno_color = []
#endregion
function def_terreno(nombre, sprite = spr_piedra, recurso = 0, caminable = true, liquido = false, pared = false, color = c_black){
	array_push(terreno_nombre, string(nombre))
	array_push(terreno_nombre_display, string(nombre))
	array_push(terreno_sprite, sprite)
	array_push(terreno_recurso_id, recurso)
	array_push(terreno_recurso_bool, (recurso > 0))
	array_push(terreno_caminable, caminable)
	array_push(terreno_liquido, liquido)
	array_push(terreno_pared, pared)
	array_push(terreno_color, color)
	return array_length(terreno_nombre) - 1
}
#region Definición
	idt_piedra = def_terreno("Piedra", spr_piedra, id_piedra,,,, #808080)
	idt_pasto = def_terreno("Pasto", spr_pasto,,,,, #ACD473)
	idt_agua = def_terreno("Agua", spr_agua,, false, true,, #5FC8F0)
	idt_arena = def_terreno("Arena", spr_arena, id_arena,,,, #F7DFB1)
	idt_agua_profunda = def_terreno("Agua Profunda", spr_agua_profunda,, false, true,, #238BB2)
	idt_petroleo = def_terreno("Petróleo", spr_petroleo,, false, true,, #000707)
	idt_piedra_cuprica = def_terreno("Piedra Cúprica", spr_piedra_cobre, id_piedra_cuprica,,,, #667F66)
	idt_piedra_ferrica = def_terreno("Piedra Férrica", spr_piedra_hierro, id_piedra_ferrica,,,, #806666)
	idt_basalto_sulfatado = def_terreno("Basalto Sulfatado", spr_basalto_azufre, id_piedra_sulfatada,,,, #555541)
	idt_pared_piedra = def_terreno("Pared de Piedra", spr_pared_piedra,, false,, true, #707070)
	//10
	idt_pared_pasto = def_terreno("Pared de Pasto", spr_pared_pasto,, false,, true, #ABA000)
	idt_pared_arena = def_terreno("Pared de Arena", spr_pared_arena,, false,, true, #F7DFB1)
	idt_nieve = def_terreno("Nieve", spr_nieve,,,,, #E5FFFF)
	idt_pared_nieve = def_terreno("Pared de Nieve", spr_pared_nieve,, false,, true, #CEE5E5)
	idt_lava = def_terreno("Lava", spr_lava,, false, true,, #FBAF5D)
	idt_hielo = def_terreno("Hielo", spr_hielo,,,, true, #9DD2D5)
	idt_basalto = def_terreno("Basalto", spr_basalto,,,,, #555555)
	idt_ceniza = def_terreno("Ceniza", spr_ceniza,,,, true, #191919)
	idt_agua_salada = def_terreno("Agua Salada", spr_agua_salada,,, true,, #3F6E85)
	idt_agua_salada_profunda = def_terreno("Agua Salada Profunda", spr_agua_salada_profunda,,, true,, #274B5C)
#endregion
terreno_max = array_length(terreno_nombre)
//Ores
#region Arreglos
	ore_sprite = []
	ore_recurso = []
	ore_size = []
#endregion
function def_ore(recurso, sprite = spr_cobre, cantidad = 50){
	array_push(ore_recurso, real(recurso))
	array_push(ore_sprite, sprite)
	array_push(ore_size, cantidad)
}
#region Definición
	def_ore(id_cobre, spr_cobre, 80)
	def_ore(id_carbon, spr_carbon, 60)
	def_ore(id_hierro, spr_hierro, 50)
	def_ore(id_uranio_bruto, spr_uranio, 30)
#endregion
ore_max = array_length(ore_sprite)
//Drones
#region Descripción
	dron_descripcion = [
			"Dispara a los enemigos cercanos",
			"Transporta recursos entre Puertos de Carga",
			"Repara los edificios dañados",
			"Se acerca a su objetivo y explota infilgiendo daño",
			"Unidad de asedio superior, dispara explosivos alargo alcance dañando todo a su alrededor",
			"Unidad aerea superior, dispara a distancia"
		]
	for(var a = array_length(dron_descripcion) - 1; a >= 0; a--)
		dron_descripcion[a] = text_wrap(dron_descripcion[a], 400)
#endregion
#region Arreglos
	dron_nombre = array_create(0, "")
	dron_nombre_display = array_create(0, "")
	dron_sprite = array_create(0, spr_hexagono)
	dron_sprite_color = array_create(0, spr_hexagono)
	dron_vida_max = array_create(0, 0)
	dron_size = array_create(0, 0)
	dron_alcance = array_create(0, 0)
	dron_alcance_chunk_x = array_create(0, 0)
	dron_alcance_chunk_y = array_create(0, 0)
	dron_precio_id = array_create(0, array_create(0, 0))
	dron_precio_num = array_create(0, array_create(0, 0))
	dron_aereo = array_create(0, false)
	dron_time = array_create(0, 0)
#endregion
function def_dron(nombre, sprite = spr_arana, sprite_color = spr_arana_color, vida = 0, size = 0, alcance = 0, precio_id = array_create(0, 0), precio_num = array_create(0, 0), time = 0, aereo = false){
	array_push(dron_nombre, string(nombre))
	array_push(dron_nombre_display, string(nombre))
	array_push(dron_sprite, sprite)
	array_push(dron_sprite_color, sprite_color)
	array_push(dron_vida_max, vida)
	array_push(dron_size, size)
	array_push(dron_alcance, alcance)
	var alcance_sqrt = sqrt(alcance)
	array_push(dron_alcance_chunk_x, ceil(alcance_sqrt / chunk_width / 48))
	array_push(dron_alcance_chunk_y, ceil(alcance_sqrt / chunk_height / 14))
	array_push(dron_precio_id, precio_id)
	array_push(dron_precio_num, precio_num)
	array_push(dron_aereo, aereo)
	array_push(dron_time, time)
}
#region definicion
	def_dron("Araña", spr_arana,, 100, 400, 6400, [id_bronce, id_baterias, id_electronico], [6, 1, 3], 600)
	def_dron("Dron", spr_dron,, 40, 400, 100, [id_cobre, id_baterias, id_electronico], [10, 1, 3], 900, true)
	def_dron("Reparador", spr_reparador,, 60, 400, 2500, [id_silicio, id_baterias, id_plastico, id_electronico], [10, 1, 5, 3], 1200, true)
	def_dron("Explosivo", spr_dron_explosivo,, 50, 400, 400, [id_hierro, id_explosivo, id_electronico], [6, 2, 2], 450, true)
	def_dron("Tanque", spr_tanque, spr_tanque_2, 750, 1600, 90_000, [id_bronce, id_acero, id_electronico], [15, 25, 10], 1800)
	def_dron("Helicoptero", spr_helicoptero, spr_helicoptero_2, 400, 1600, 40_000, [id_bronce, id_acero, id_electronico], [10, 15, 15], 1800, true)
	def_dron("Titán", spr_titan, spr_titan_leg, 1500, 2500, 160_000, [id_bronce, id_acero, id_electronico, id_uranio_bruto], [30, 40, 40, 75], 3000)
#endregion
dron_max = array_length(dron_nombre)
//Liquidos
liquido_nombre = ["Agua", "Ácido", "Petróleo", "Lava", "Agua salada"]
liquido_color = [ #5FC8F0, #FFEF00, #000707, #FBAF5D, #3F6E85]
lq_max = array_length(liquido_nombre)
for(var a = 0; a < lq_max; a++)
	liquido_nombre_display[a] = liquido_nombre[a]
//Edificios
#region Descripciones
	edificio_descripcion = [
		"Es el centro de mando, aquí se almacenan todos los recursos y debes protegerlo a toda costa",
		"Permite minar cobre, hierro y carbón sin coste alguno.    Puede potenciarse con Agua",
		"Mueve recursos de un lugar a otro",
		"Distribuye recursos en una dirección",
		"Permite el paso de un recurso específico mientras desvía al resto",
		"Desvía los recursos una vez que la línea esté saturada",
		"Pasa recursos bajo tierra permitiendo construir encima",
		"Utiliza combustible para fundir Bronce, Acero y Silicio",
		"Taladro mejorado que también extrae piedra y arena del suelo pero consume energía. Puede potenciarse con Agua",
		"Tritura la piedra para hacerla arena",
		//10
		"Genera energía utlizando combustible",
		"Conecta edificios cercanos a la red de energía",
		"Almacena el excedente de energía para usarlo más tarde",
		"Genera energía limpia del sol",
		"Extrae líquidos del terreno usando energía",
		"Conecta estructuras para llevar líquidos",
		"Pasa recursos bajo tierra permitiendo construir encima",
		"Genera energía a partir de magia",
		"Versión mejorada de la Cinta Transportadora que permite transportar más cosas",
		"Defensa simple, puede disparar Cobre o Hierro",
		//20
		"Defensa de largo alcance que dispara Bronce, Acero o Uranio",
		"Utiliza recursos combustibles para quemar a los enemigos. Puede ser potenciado con Petróleo",
		"Produce y procesa varios recursos relacionados al Ácido",
		"Dispara un láser constante cuyo daño depende de la cantidad de energía disponible",
		"Almacena grandes cantidades de líquidos",
		"Genera el líquido a elección a partir de magia",
		"Genera energía a partir de un combustible y Agua",
		"Refina la Piedra Cúprica o Férrica en Cobre o Hierro usando Ácido",
		"Fabrica drones de transporte utilizando Silicio, Baterías y bastante energía",
		"Genera recursos a partir de magia",
		//30
		"Extrae lentamente Agua por evaporación",
		"Similar al horno normal, pero utiliza el calor de la lava para cocinar más rápido",
		"Genera energía a partir de evaporar Agua, debe ser construido sobre lava",
		"Utiliza explosivos para extraer un recurso de cada terreno minable en su área",
		"Distrae a los enemigos mientras tus defensas se encargan de ellos",
		"Conceta Puertos de Carga para que tus drones muevan recursos entre ellos",
		"Utiliza Cobre y Silicio para producir electrónicos",
		"Consume 1 parte de Uranio Enriquecido por 20 partes de Uranio Empobrecido y mucha Agua para generar mucha energía",
		"Conecta redes eléctricas a través de largas distancias",
		"Produce petróleo a alto coste en cualquier lugar",
		//40
		"Dispara explosivos a largo alcance, devastando un área de enemigos",
		"Procesa instrucciones lógicas",
		"Permite escribir mensajes",
		"Permite almacenar hasta 128 datos",
		"Proyecta un láser de reparación a los edificios cercanos usando energía",
		"Conecta líneas de líquidos por debajo tierra",
		"Carga y libera una gran onda de choque que daña y ralentiza a todos los enemigos en su rango",
		"Versión mejorada del muro, más duro y mejor",
		"Aquí se puede construir un misíl nuclear usándo acero, explosivos, petróleo y uranio enriquecido al 90%",
		"Permite reciclar el uranio consumiendo grandes cantidades de agua y energía de manera constante",
		//50
		"Almacena recursos para usarlos más tarde",
		"Fabrica concreto a partir de Arena, Piedra y Agua",
		"Permite dibujar imágenes enviadas desde un procesador",
		"Mediante la destilación fraccionada permite extraer Plástico, Combustible y Azufre del Petróleo",
		"Permite reciclar parte de los recursos de los enemigos destruidos cercanos",
		"Purifica el Agua Salada para extraer la Sal y el Agua dulce",
		"Llena y vacía barriles con líquidos"
	]
	for(var a = array_length(edificio_descripcion) - 1; a >= 0; a--)
		edificio_descripcion[a] = text_wrap(edificio_descripcion[a], 400)
#endregion
#region Arreglos
	edificio_sprite = []
	edificio_sprite_2 = []
	edificio_nombre = []
	edificio_nombre_display = []
	edificio_size = []
	edificio_receptor = []
	edificio_emisor = []
	edificio_carga_max = []
	edificio_input_all = []
	edificio_input_id = []
	edificio_input_num = []
	edificio_output_all = []
	edificio_output_id = []
	edificio_rotable = []
	edificio_proceso = []
	edificio_script = []
	edificio_camino = []
	edificio_energia =	[]
	edificio_energia_consumo = []
	edificio_precio_id = []
	edificio_precio_num = []
	edificio_key = []
	edificio_vida =	[]
	edificio_flujo = []
	edificio_flujo_liquidos = []
	edificio_flujo_liquido = []
	edificio_flujo_almacen = []
	edificio_flujo_consumo = []
	edificio_arma = []
	edificio_alcance = []
	edificio_alcance_sqr = []
	edificio_armas = []
	edificio_inerte = []
	edificio_index = ds_map_create()
	edificio_precio = array_create(0, 0)
#endregion
function def_edificio(name, size, sprite = spr_base, sprite_2 = spr_base, vida = 100, proceso = 0, accion = scr_null, camino = false, precio_id = array_create(0, 0), precio_num = array_create(0, 0), carga = 0, receptor = false, in_all = true, in_id = array_create(0, 0), in_num = array_create(0, 0), emisor = false, out_all = true, out_id = array_create(0, 0)){
	array_push(edificio_nombre, string(name))
	array_push(edificio_nombre_display, string(name))
	array_push(edificio_size, real(size))
	array_push(edificio_sprite, sprite)
	array_push(edificio_sprite_2, (sprite_2 = spr_base) ? sprite : sprite_2)
	array_push(edificio_key, "")
	array_push(edificio_rotable, (((size mod 2) = 0) or camino))
	array_push(edificio_vida, vida)
	array_push(edificio_proceso, proceso)
	array_push(edificio_script, accion)
	array_push(edificio_camino, camino)
	array_push(edificio_precio_id, precio_id)
	array_push(edificio_precio_num, precio_num)
	array_push(edificio_carga_max, carga)
	array_push(edificio_receptor, receptor)
	array_push(edificio_input_all, receptor ? in_all : false)
	if receptor and not in_all{
		array_push(edificio_input_id, in_id)
		array_push(edificio_input_num, in_num)
	}
	else{
		array_push(edificio_input_id, array_create(0, 0))
		array_push(edificio_input_num, array_create(0, 0))
	}
	array_push(edificio_emisor, emisor)
	array_push(edificio_output_all, emisor ? out_all : false)
	if emisor and not out_all
		array_push(edificio_output_id, out_id)
	else
		array_push(edificio_output_id, array_create(0, 0))
	ds_map_add(edificio_index, string_lower(name), array_length(edificio_energia))
	return array_length(edificio_energia)
}
function def_edificio_2(energia = 0, agua = 0, agua_consumo = 0, agua_tipo = -1, arma = -1, alcance = 0, inerte = false){
	array_push(edificio_energia, (energia != 0))
	array_push(edificio_energia_consumo, energia)
	array_push(edificio_flujo, (agua > 0))
	array_push(edificio_flujo_almacen, agua)
	array_push(edificio_flujo_consumo, agua_consumo)
	array_push(edificio_flujo_liquido, agua_tipo)
	array_push(edificio_arma, arma)
	array_push(edificio_alcance, alcance)
	array_push(edificio_alcance_sqr, sqr(alcance))
	array_push(edificio_armas, bool(alcance > 0))
	array_push(edificio_inerte, inerte)
}
#region Definición
	id_nucleo = def_edificio("Núcleo", 3, spr_base,, 1200,,,,,,, true); def_edificio_2(,,,,,, true)
	id_taladro = def_edificio("Taladro", 2, spr_taladro,, 200, 120, scr_taladro,, [id_cobre], [15], 10,,,,, true, false, [id_cobre, id_carbon, id_hierro]); def_edificio_2(, 10, 5, 0)
	id_cinta_transportadora = def_edificio("Cinta Transportadora", 1, spr_camino, spr_camino_diagonal, 30, 20, scr_caminos, true, [id_cobre], [1], 1, true,,,, true); def_edificio_2()
	id_enrutador = def_edificio("Enrutador", 1, spr_enrutador, spr_enrutador_2, 60, 10, scr_caminos, true, [id_cobre], [4], 1, true,,,, true); def_edificio_2()
	id_selector = def_edificio("Selector", 1, spr_selector, spr_selector_color, 60, 10, scr_caminos, true, [id_cobre], [4], 1, true,,,, true); def_edificio_2()
	id_overflow = def_edificio("Overflow", 1, spr_overflow,, 60, 10, scr_caminos, true, [id_cobre], [4], 1, true,,,, true); def_edificio_2()
	id_tunel = def_edificio("Túnel", 1, spr_tunel,, 60, 10, scr_caminos,, [id_cobre, id_hierro], [4, 4], 1, true, true,,, true, true); def_edificio_2()
	id_horno = def_edificio("Horno", 2, spr_horno, spr_horno_encendido, 250, 150, scr_horno,, [id_cobre, id_hierro], [10, 20], 90, true, false, [id_cobre, id_carbon, id_hierro, id_arena, id_combustible, id_sal], [10, 10, 10, 10, 10, 10], true, false, [id_bronce, id_acero, id_silicio]); def_edificio_2()
	id_taladro_electrico = def_edificio("Taladro Eléctrico", 3, spr_taladro_electrico,, 400, 45, scr_taladro,, [id_bronce, id_acero], [20, 10], 20,,,,, true, false, [id_cobre, id_carbon, id_hierro, id_arena, id_piedra, id_piedra_cuprica, id_piedra_ferrica, id_piedra_sulfatada]); def_edificio_2(50, 10, 10, 1)
	id_triturador = def_edificio("Triturador", 2, spr_triturador,, 250, 20, scr_triturador,, [id_bronce, id_acero], [10, 25], 50, true, false, [id_piedra, id_piedra_cuprica, id_piedra_ferrica, id_piedra_sulfatada], [10, 10, 10, 10], true, false, [id_arena]); def_edificio_2(30)
	//10
	id_generador = def_edificio("Generador", 1, spr_generador, spr_generador_encendido, 100,, scr_generador,, [id_cobre, id_hierro], [20, 5], 20, true, false, [id_carbon, id_combustible], [10, 10], false); def_edificio_2(-30)
	id_cable = def_edificio("Cable", 1, spr_cable,, 30,,,, [id_cobre, id_hierro], [5, 1]); def_edificio_2(,,,,,, true)
	id_bateria = def_edificio("Batería", 1, spr_bateria,, 60,,,, [id_bronce, id_baterias], [5, 3]); def_edificio_2(,,,,,, true)
	id_panel_solar = def_edificio("Panel Solar", 2, spr_panel_solar,, 150,, scr_panel_solar,, [id_cobre, id_bronce, id_silicio], [10, 10, 5]); def_edificio_2(-10)
	id_bomba_hidraulica = def_edificio("Bomba Hidráulica", 2, spr_bomba,, 200,, scr_bomba_hidraulica,, [id_cobre, id_bronce, id_hierro], [10, 25, 10]); def_edificio_2(40, 60, -80)
	id_tuberia = def_edificio("Tubería", 1, spr_tuberia, spr_tuberia_color, 30,,,, [id_bronce], [1]); def_edificio_2(, 10,,,,, true)
	id_tunel_salida = def_edificio("Túnel salida", 1, spr_tunel_salida,, 60, 10, scr_caminos,, [id_cobre, id_hierro], [4, 4], 1,,,,, true, true); def_edificio_2()
	id_energia_infinita = def_edificio("Energía Infinita", 1, spr_energia_infinita,, 100); def_edificio_2(-999_999,,,,,, true)
	id_cinta_magnetica = def_edificio("Cinta Magnética", 1, spr_cinta_magnetica, spr_cinta_magnetica_diagonal, 60, 10, scr_caminos, true, [id_bronce, id_hierro], [1, 1], 1, true,,,, true); def_edificio_2()
	id_torre_basica = def_edificio("Torre básica", 1, spr_torre, spr_torre_2, 300, 20, scr_torres_basicas,, [id_cobre, id_hierro], [10, 25], 30, true, false, [id_cobre, id_hierro, id_plastico], [10, 10, 10]); def_edificio_2(, 10, 20, 0, 0, 180)
	//20
	id_rifle = def_edificio("Rifle", 2, spr_rifle, spr_rifle_2, 400, 45, scr_torres_basicas,, [id_cobre, id_hierro, id_acero], [10, 10, 10], 30, true, false, [id_bronce, id_acero, id_uranio_bruto, id_uranio_enriquecido, id_uranio_empobrecido], [10, 10, 10, 10, 10]); def_edificio_2(, 10, 30, 0, 1, 300)
	id_lanzallamas = def_edificio("Lanzallamas", 2, spr_lanzallamas, spr_lanzallamas_2, 400, 1, scr_torres_basicas,, [id_cobre, id_bronce, id_hierro], [15, 15, 10], 20, true, false, [id_carbon, id_combustible], [10, 10]); def_edificio_2(, 10, 30, 2, 3, 130)
	id_planta_quimica = def_edificio("Planta Química", 3, spr_planta_quimica,, 200, 60, scr_planta_quimica,, [id_cobre, id_bronce, id_hierro, id_silicio], [20, 10, 20, 10], 30, true, false, [id_cobre, id_piedra_sulfatada, id_combustible, id_sal], [0, 0, 0, 10], true, false, [id_explosivo, id_baterias]); def_edificio_2(50, 10,, 1)
	id_laser = def_edificio("Láser", 2, spr_laser, spr_laser_2, 400, 1, scr_laser,, [id_cobre, id_acero, id_electronico], [10, 10, 5]); def_edificio_2(90,,,, 0, 220)
	id_deposito = def_edificio("Depósito", 3, spr_deposito, spr_deposito_color, 200,,,, [id_bronce, id_acero], [20, 10]); def_edificio_2(, 1000,,,,, true)
	id_liquido_infinito = def_edificio("Líquido Infinito", 1, spr_liquido_infinito, spr_tuberia_color, 30); def_edificio_2(, 10, -999_999,,,, true)
	id_turbina = def_edificio("Turbina", 2, spr_turbina,, 160,, scr_turbina,, [id_cobre, id_bronce, id_acero], [10, 10, 10], 20, true, false, [id_carbon, id_combustible], [10, 10]); def_edificio_2(-120, 10, 50, 0)
	id_refineria_de_metales = def_edificio("Refinería de Metales", 3, spr_refineria_minerales,, 150, 80, scr_refineria_metales,, [id_bronce, id_acero, id_silicio], [15, 15, 10], 30, true, false, [id_piedra_cuprica, id_piedra_ferrica, id_uranio_bruto], [5, 5, 10], true, false, [id_cobre, id_hierro, id_uranio_enriquecido, id_uranio_empobrecido]); def_edificio_2(50, 10, 20, 1)
	id_fabrica_de_drones = def_edificio("Fábrica de Drones", 2, spr_fabrica_drones,, 200,, scr_fabrica_drones,, [id_cobre, id_acero, id_electronico], [20, 15, 10], 20, true, false, [], []); def_edificio_2(120)
	id_recurso_infinito = def_edificio("Recurso Infinito", 1, spr_recurso_infinito, spr_selector_color, 30,, scr_recurso_infinito,,,,,,,,, true, true); def_edificio_2()
	//30
	id_bomba_de_evaporacion = def_edificio("Bomba de Evaporación", 1, spr_bomba_evaporacion, spr_tuberia_color, 30,, scr_bomba_evaporacion,, [id_bronce, id_hierro], [10, 5]); def_edificio_2(, 10, -5, 0)
	id_horno_de_lava = def_edificio("Horno de Lava", 2, spr_horno_lava, spr_horno_lava_encendido, 400, 90, scr_horno_lava,, [id_acero, id_concreto], [15, 10], 70, true, false, [id_cobre, id_hierro, id_arena, id_sal], [10, 10, 10], true, false, [id_bronce, id_acero, id_silicio]); def_edificio_2(, 10, 15, 3)
	id_generador_geotermico = def_edificio("Generador Geotérmico", 2, spr_generador_geotermico,, 200,, scr_generador_geotermico,, [id_cobre, id_acero, id_concreto], [10, 10, 10]); def_edificio_2(-90, 10, 30, 0)
	id_taladro_de_explosion = def_edificio("Taladro de Explosión", 3, spr_taladro_explosivo,, 300, 300, scr_taladro_explosion,, [id_hierro, id_acero, id_concreto], [40, 40, 30], 40, true, false, [13], [10], true, false, [id_cobre, id_carbon, id_bronce, id_piedra, id_arena, id_piedra_cuprica, id_piedra_ferrica, id_piedra_sulfatada, id_uranio_bruto]); def_edificio_2()
	id_muro = def_edificio("Muro", 1, spr_hexagono,, 500,,,, [8], [1]); def_edificio_2(,,,,,, true)
	id_puerto_de_carga = def_edificio("Puerto de Carga", 2, spr_punto_carga,, 150,, scr_puerto_carga,, [id_cobre, id_bronce, id_electronico], [10, 10, 1], 25,, true,,,, true); def_edificio_2()
	id_ensambladora = def_edificio("Ensambladora", 3, spr_ensambladora,, 400, 150, scr_ensambladora,, [id_hierro, id_bronce, id_acero, id_silicio], [10, 20, 10, 10], 20, true, false, [id_cobre, id_silicio], [5, 5], true, false, [id_electronico]); def_edificio_2(100)
	id_planta_nuclear = def_edificio("Planta Nuclear", 4, spr_planta_nuclear,, 500,, scr_planta_nuclear,, [id_cobre, id_acero, id_concreto, id_electronico], [100, 80, 50, 20], 21, true, false, [id_uranio_enriquecido, id_uranio_empobrecido], [1, 20]); def_edificio_2(-800, 150, 200, 0)
	id_torre_de_alta_tension = def_edificio("Torre de Alta Tensión", 2, spr_cable_tension,, 100,,,, [id_cobre, id_acero, id_electronico], [10, 5, 1]); def_edificio_2(5,,,,,, true)
	id_perforadora_de_petroleo = def_edificio("Perforadora de Petróleo", 3, spr_perforadora,, 200,, scr_perforadora_petroleo,, [id_hierro, id_acero, id_concreto], [10, 15, 10]); def_edificio_2(120, 10, -20, 2)
	//40
	id_mortero = def_edificio("Mortero", 3, spr_mortero, spr_mortero_2, 600, 180, scr_torres_basicas,, [id_acero, id_concreto], [50, 30], 20, true, false, [id_explosivo, id_uranio_bruto, id_uranio_enriquecido, id_uranio_empobrecido], [10, 10, 10, 10]); def_edificio_2(,,,, 2, 600)
	id_procesador = def_edificio("Procesador", 2, spr_procesador,, 80,, scr_procesador,, [id_cobre, id_plastico, id_electronico], [20, 40, 20]); def_edificio_2(10)
	id_mensaje = def_edificio("Mensaje", 1, spr_mensaje,, 50,,,, [id_cobre, id_electronico], [10, 3]); def_edificio_2(,,,,,, true)
	id_memoria = def_edificio("Memoria", 1, spr_memoria,, 50,,,, [id_cobre, id_electronico], [10, 3]); def_edificio_2(,,,,,, true)
	id_torre_reparadora = def_edificio("Torre Reparadora", 2, spr_torre_reparadora, spr_torre_reparadora_2, 100,, scr_torre_reparadora,, [id_hierro, id_bronce, id_silicio], [10, 15, 15]); def_edificio_2(40,,,, 0, 200)
	id_tuberia_subterranea = def_edificio("Tubería Subterránea", 1, spr_tuberia_subterranea,, 30,,,, [id_hierro, id_bronce], [5, 5]); def_edificio_2(, 10,,,,, true)
	id_onda_de_choque = def_edificio("Onda de Choque", 2, spr_onda_de_choque,, 800, 150, scr_onda_choque,, [id_cobre, id_baterias, id_electronico], [20, 10, 10]); def_edificio_2(300,,,, 0, 100)
	id_muro_reforzado = def_edificio("Muro Reforzado", 2, spr_muro_reforzado,, 2400,,,, [id_acero, id_concreto, id_uranio_bruto], [2, 3, 1]); def_edificio_2(,,,,,, true)
	id_silo_de_misiles = def_edificio("Silo de Misiles", 4, spr_silo_de_misiles,, 1600, 1200, scr_silo_misiles,, [id_bronce, id_concreto, id_electronico], [200, 100, 50], 200, true, false, [id_acero, id_explosivo, id_uranio_enriquecido, id_uranio_empobrecido], [120, 30, 45, 5]); def_edificio_2(300, 10, 50, 2)
	id_planta_de_enriquecimiento = def_edificio("Planta de Enriquecimiento", 4, spr_planta_breeding,, 600, 600, scr_planta_enriquecimiento,, [id_cobre, id_acero, id_concreto, id_electronico, id_uranio_bruto], [30, 80, 40, 50, 100], 21, true, false, [id_uranio_enriquecido, id_uranio_empobrecido], [20, 1], true, false, [18]); def_edificio_2(200, 10, 150, 4)
	//50
	id_almacen = def_edificio("Almacén", 2, spr_almacen,, 400,, scr_almacen,, [id_acero], [10], 100, true, true,,, true, true); def_edificio_2()
	id_fabrica_de_concreto = def_edificio("Fábrica de Concreto", 3, spr_fabrica_de_concreto,, 300, 60, scr_fabrica_de_concreto,, [id_bronce, id_acero, id_silicio], [10, 5, 10], 60, true, false, [id_arena, id_piedra, id_piedra_cuprica, id_piedra_ferrica, id_piedra_sulfatada], [10, 10, 10, 10, 10], true, false, [id_concreto]); def_edificio_2(, 10, 30, 0)
	id_pantalla = def_edificio("Pantalla", 3, spr_pantalla,, 100,,,, [id_cobre, id_silicio, id_plastico, id_electronico], [15, 15, 10, 20]); def_edificio_2()
	id_refineria_de_petroleo = def_edificio("Refinería de Petróleo", 4, spr_refineria_de_petroleo,, 400, 50, scr_refineria_petroleo,, [id_bronce, id_acero, id_concreto, id_electronico], [30, 20, 40, 20], 40, true, false, [id_sal], [10], true, false, [id_piedra_sulfatada, id_combustible, id_plastico]); def_edificio_2(240, 10, 125, 2)
	id_planta_de_reciclaje = def_edificio("Planta de Reciclaje", 3, spr_planta_de_reciclaje,, 300,, scr_planta_de_reciclaje,, [id_bronce, id_silicio, id_concreto], [20, 15, 15],,,,,, true, false); def_edificio_2(60, 10, 20, 1)
	id_planta_desalinizadora = def_edificio("Planta Desalinizadora", 2, spr_planta_desalinizadora,, 200, 60, scr_planta_desalinizadora,, [id_cobre, id_bronce, id_silicio], [20, 15, 15], 20,,,,, true, false, [id_sal, id_barril_agua]); def_edificio_2(40, 10, 20, 4)
	id_embotelladora = def_edificio("Embotelladora", 2, spr_embotelladora,, 120, 10, scr_embotelladora,, [id_bronce, id_silicio], [15, 15], 50, false, false, [id_barril_agua, id_barril_acido, id_barril_petroleo, id_barril_lava, id_barril_agua_salada], [10, 10, 10, 10, 10], true, false, [id_barril_agua, id_barril_acido, id_barril_petroleo, id_barril_lava, id_barril_agua_salada]); def_edificio_2(, 10, -120)
#endregion
categoria_edificios = [
	[id_cinta_transportadora, id_cinta_magnetica, id_enrutador, id_selector, id_overflow, id_tunel, id_almacen, id_fabrica_de_drones, id_puerto_de_carga],
	[id_taladro, id_taladro_electrico, id_taladro_de_explosion, id_perforadora_de_petroleo],
	[id_horno, id_triturador, id_fabrica_de_concreto, id_ensambladora, id_planta_quimica, id_refineria_de_petroleo, id_refineria_de_metales, id_horno_de_lava, id_planta_de_reciclaje, id_planta_de_enriquecimiento],
	[id_cable, id_torre_de_alta_tension, id_bateria, id_generador, id_turbina, id_panel_solar, id_generador_geotermico, id_planta_nuclear],
	[id_tuberia, id_tuberia_subterranea, id_bomba_de_evaporacion, id_bomba_hidraulica, id_deposito, id_planta_desalinizadora, id_embotelladora],
	[id_torre_basica, id_rifle, id_lanzallamas, id_laser, id_mortero, id_onda_de_choque, id_torre_reparadora, id_muro, id_muro_reforzado, id_silo_de_misiles],
	[id_procesador, id_mensaje, id_memoria, id_pantalla]]
for(var a = 0; a < array_length(categoria_edificios); a++)
	for(var b = 0; b < array_length(categoria_edificios[a]); b++)
		edificio_key[categoria_edificios[a, b]] = $"{a + 1}{(b + 1) mod 10}"
categoria_nombre = ["Transporte", "Extracción", "Producción", "Electricidad", "Líquidos", "Defensa", "Lógica"]
categoria_nombre_display = []
array_copy(categoria_nombre_display, 0, categoria_nombre, 0, array_length(categoria_nombre))
#region planta quimica
	planta_quimica_receta = ["Ácido", "Explosivos", "Baterías"]
	planta_quimica_sprite = [spr_item_acido, spr_item_explosivos, spr_item_bateria]
	planta_quimica_descripcion = [
		"Consume Piedra Sulfatada y energía para producir Ácido",
		"Utiliza Compuesto explosivo y Ácido para producir Explosivos",
		"Utiliza Ácido, Hierro y energía para producir Baterías"]
	for(var a = array_length(planta_quimica_descripcion) - 1; a >= 0; a--)
		planta_quimica_descripcion[a] = text_wrap(planta_quimica_descripcion[a], 300)
#endregion
edificio_max = array_length(edificio_nombre)
edificio_construible = array_create(edificio_max, true)
edificio_tecnologia = array_create(edificio_max, false)
edificio_tecnologia_desbloqueable = array_create(edificio_max, false)
mision_edificios = array_create(edificio_max, true)
edificio_rotable[id_tunel] = true
edificio_input_all[id_tunel_salida] = true
edificio_energia[id_cable] = true
edificio_energia[id_bateria] = true
edificio_input_all[id_puerto_de_carga] = true
edificio_output_all[id_puerto_de_carga] = true
edificio_energia[id_torre_de_alta_tension] = true
edificio_construible[id_nucleo] = false
edificio_construible[id_tunel_salida] = false
edificio_construible[id_energia_infinita] = false
edificio_construible[id_liquido_infinito] = false
edificio_construible[id_recurso_infinito] = false
edificio_key[id_energia_infinita] = "4 "
edificio_key[id_liquido_infinito] = "5 "
edificio_key[id_recurso_infinito] = "1 "
var flag_rss = array_create(rss_max, false)
for(var a = 0; a < dron_max; a++){
	var c = 0
	for(var b = array_length(dron_precio_id[a]) - 1; b >= 0; b--){
		c += dron_precio_num[a, b]
		flag_rss[dron_precio_id[a, b]] = true
	}
	edificio_carga_max[id_fabrica_de_drones] = max(edificio_carga_max[id_fabrica_de_drones], 2 * c)
}
for(var a = 0; a < rss_max; a++){
	if flag_rss[a]
		array_push(edificio_output_id[id_planta_de_reciclaje], a)
	edificio_carga_max[id_planta_de_reciclaje] += 10
}
for(var a = 0; a < edificio_max; a++){
	edificio_precio[a] = 0
	if edificio_construible[a]
		for(var b = 0; b < array_length(edificio_precio_id[a]); b++)
			edificio_precio[a] += edificio_precio_num[a, b] * (1 + recurso_tier[edificio_precio_id[a, b]])
}
size_size = [1, 3, 7, 12, 19]
size_borde = [6, 9, 12, 15, 18, 21]
size_fx = [fx_construir_1, fx_construir_2, fx_construir_3, fx_construir_4, spr_hexagono_5]
edificios_construibles = array_create(0, 0)
for(var a = 0; a < array_length(categoria_nombre); a++)
	edificios_construibles = array_concat(edificios_construibles, categoria_edificios[a])
edificios = array_create(0, null_edificio)
torres_reparadoras = array_create(0, null_edificio)
edificios_counter = array_create(edificio_max, 0)
nucleos = array_create(0, null_edificio)
edificios_targeteables = array_create(0, null_edificio)
torres_de_tension = array_create(0, null_edificio)
plantas_de_reciclaje = array_create(0, null_edificio)
edi_sort = array_create(edificio_max, 0)
sort_edificios()
#region Caminos
	#region Camino 0
		camino_0 = array_create(64, spr_camino_0_in)
		camino_0[2] = spr_camino_0_in_2
		camino_0[4] = spr_camino_0_in_4
		camino_0[6] = spr_camino_0_in_6
		camino_0[16] = spr_camino_0_in_16
		camino_0[18] = spr_camino_0_in_18
		camino_0[20] = spr_camino_0_in_20
		camino_0[22] = spr_camino_0_in_22
		camino_0[32] = spr_camino_0_in_32
		camino_0[34] = spr_camino_0_in_34
		camino_0[36] = spr_camino_0_in_36
		camino_0[38] = spr_camino_0_in_38
		camino_0[48] = spr_camino_0_in_48
		camino_0[50] = spr_camino_0_in_50
		camino_0[52] = spr_camino_0_in_52
		camino_0[54] = spr_camino_0_in_54
	#endregion
	#region Camino 1
		camino_1 = array_create(64, spr_camino)
		camino_1[1] = spr_camino_1_in_1
		camino_1[4] = spr_camino_1_in_4
		camino_1[5] = spr_camino_1_in_5
		camino_1[8] = spr_camino_1_in_8
		camino_1[9] = spr_camino_1_in_9
		camino_1[12] = spr_camino_1_in_12
		camino_1[13] = spr_camino_1_in_13
		camino_1[32] = spr_camino_1_in_32
		camino_1[33] = spr_camino_1_in_33
		camino_1[36] = spr_camino_1_in_36
		camino_1[37] = spr_camino_1_in_37
		camino_1[40] = spr_camino_1_in_40
		camino_1[41] = spr_camino_1_in_41
		camino_1[44] = spr_camino_1_in_44
		camino_1[45] = spr_camino_1_in_45
	#endregion
	#region Camino 2
		camino_2 = array_create(64, spr_camino_2_in)
		camino_2[1] = spr_camino_2_in_1
		camino_2[2] = spr_camino_2_in_2
		camino_2[3] = spr_camino_2_in_3
		camino_2[8] = spr_camino_2_in_8
		camino_2[9] = spr_camino_2_in_9
		camino_2[10] = spr_camino_2_in_10
		camino_2[11] = spr_camino_2_in_11
		camino_2[16] = spr_camino_2_in_16
		camino_2[17] = spr_camino_2_in_17
		camino_2[18] = spr_camino_2_in_18
		camino_2[19] = spr_camino_2_in_19
		camino_2[24] = spr_camino_2_in_24
		camino_2[25] = spr_camino_2_in_25
		camino_2[26] = spr_camino_2_in_26
		camino_2[27] = spr_camino_2_in_27
	#endregion
	#region Camino 3
		camino_3 = array_create(64, spr_camino_3_in)
		camino_3[2] = spr_camino_3_in_2
		camino_3[4] = spr_camino_3_in_4
		camino_3[6] = spr_camino_3_in_6
		camino_3[16] = spr_camino_3_in_16
		camino_3[18] = spr_camino_3_in_18
		camino_3[20] = spr_camino_3_in_20
		camino_3[22] = spr_camino_3_in_22
		camino_3[32] = spr_camino_3_in_32
		camino_3[34] = spr_camino_3_in_34
		camino_3[36] = spr_camino_3_in_36
		camino_3[38] = spr_camino_3_in_38
		camino_3[48] = spr_camino_3_in_48
		camino_3[50] = spr_camino_3_in_50
		camino_3[52] = spr_camino_3_in_52
		camino_3[54] = spr_camino_3_in_54
	#endregion
	#region Camino 4
		camino_4 = array_create(64, spr_camino_4_in)
		camino_4[1] = spr_camino_4_in_1
		camino_4[4] = spr_camino_4_in_4
		camino_4[5] = spr_camino_4_in_5
		camino_4[8] = spr_camino_4_in_8
		camino_4[9] = spr_camino_4_in_9
		camino_4[12] = spr_camino_4_in_12
		camino_4[13] = spr_camino_4_in_13
		camino_4[32] = spr_camino_4_in_32
		camino_4[33] = spr_camino_4_in_33
		camino_4[36] = spr_camino_4_in_36
		camino_4[37] = spr_camino_4_in_37
		camino_4[40] = spr_camino_4_in_40
		camino_4[41] = spr_camino_4_in_41
		camino_4[44] = spr_camino_4_in_44
		camino_4[45] = spr_camino_4_in_45
	#endregion
	#region Camino 5
		camino_5 = array_create(64, spr_camino_5_in)
		camino_5[1] = spr_camino_5_in_1
		camino_5[2] = spr_camino_5_in_2
		camino_5[3] = spr_camino_5_in_3
		camino_5[8] = spr_camino_5_in_8
		camino_5[9] = spr_camino_5_in_9
		camino_5[10] = spr_camino_5_in_10
		camino_5[11] = spr_camino_5_in_11
		camino_5[16] = spr_camino_5_in_16
		camino_5[17] = spr_camino_5_in_17
		camino_5[18] = spr_camino_5_in_18
		camino_5[19] = spr_camino_5_in_19
		camino_5[24] = spr_camino_5_in_24
		camino_5[25] = spr_camino_5_in_25
		camino_5[26] = spr_camino_5_in_26
		camino_5[27] = spr_camino_5_in_27
	#endregion
	camino_general = [camino_0, camino_1, camino_2, camino_3, camino_4, camino_5]
#endregion
olas = [spr_agua_salada, spr_olas_1, spr_olas_2, spr_olas_3, spr_olas_4, spr_olas_5, spr_olas_6, spr_olas_7,
		spr_olas_8, spr_olas_9, spr_olas_10, spr_olas_11, spr_olas_12, spr_olas_13, spr_olas_14, spr_olas_15,
		spr_olas_16, spr_olas_17, spr_olas_18, spr_olas_19, spr_olas_20, spr_olas_21, spr_olas_22, spr_olas_23,
		spr_olas_24, spr_olas_25, spr_olas_26, spr_olas_27, spr_olas_28, spr_olas_29, spr_olas_30, spr_olas_31,
		spr_olas_32, spr_olas_33, spr_olas_34, spr_olas_35, spr_olas_36, spr_olas_37, spr_olas_38, spr_olas_39,
		spr_olas_40, spr_olas_41, spr_olas_42, spr_olas_43, spr_olas_44, spr_olas_45, spr_olas_46, spr_olas_47,
		spr_olas_48, spr_olas_49, spr_olas_50, spr_olas_51, spr_olas_52, spr_olas_53, spr_olas_54, spr_olas_55,
		spr_olas_56, spr_olas_57, spr_olas_58, spr_olas_59, spr_olas_60, spr_olas_61, spr_olas_62, spr_olas_63]
#region Tecnologia
	edificio_tecnologia_prev = array_create(edificio_max)
	edificio_tecnologia_next = array_create(edificio_max)
	edificio_tecnologia_precio = array_create(edificio_max)
	for(var a = 0; a < edificio_max; a++){
		edificio_tecnologia_prev[a] = array_create(0, 0)
		edificio_tecnologia_next[a] = array_create(0, 0)
	}
	function def_tecnologia(edificio){
		var b = edificio_index[? string_lower(edificio)]
		edificio_tecnologia_precio[b] = []
		for(var a = 0; a < array_length(edificio_precio_id[b]); a++)
			array_push(edificio_tecnologia_precio[b], {
				id: edificio_precio_id[b, a],
				num : round(tecnologia_precio_multiplicador * (5 + edificio_precio_num[b, a]))
			})
		for(var a = 1; a < argument_count; a++){
			var temp_edificio = edificio_index[? string_lower(argument[a])]
			array_push(edificio_tecnologia_prev[b], temp_edificio)
			array_push(edificio_tecnologia_next[temp_edificio], b)
		}
	}
	def_tecnologia("enrutador", "cinta transportadora")
	def_tecnologia("selector", "enrutador")
	def_tecnologia("overflow", "enrutador")
	def_tecnologia("túnel", "enrutador")
	def_tecnologia("horno", "taladro")
	def_tecnologia("generador", "horno")
	def_tecnologia("taladro eléctrico", "generador", "taladro")
	def_tecnologia("triturador", "taladro eléctrico")
	def_tecnologia("cable", "generador")
	def_tecnologia("batería", "planta química")
	def_tecnologia("panel solar", "generador")
	def_tecnologia("bomba hidráulica", "bomba de evaporación", "generador")
	def_tecnologia("tubería", "bomba de evaporación")
	def_tecnologia("cinta magnética", "cinta transportadora")
	def_tecnologia("rifle", "torre básica")
	def_tecnologia("lanzallamas", "torre básica")
	def_tecnologia("planta química", "horno", "bomba hidráulica", "generador")
	def_tecnologia("láser", "generador", "torre básica")
	def_tecnologia("depósito", "tubería")
	def_tecnologia("turbina", "generador", "bomba hidráulica")
	def_tecnologia("refinería de metales", "planta química")
	def_tecnologia("fábrica de drones", "planta química", "ensambladora")
	def_tecnologia("bomba de evaporación", "horno")
	def_tecnologia("horno de lava", "horno", "bomba hidráulica", "fábrica de concreto")
	def_tecnologia("generador geotérmico", "horno de lava", "turbina")
	def_tecnologia("taladro de explosión", "taladro eléctrico", "planta química")
	def_tecnologia("muro", "rifle", "fábrica de concreto")
	def_tecnologia("puerto de carga", "fábrica de drones", "cinta magnética")
	def_tecnologia("ensambladora", "taladro eléctrico", "horno")
	def_tecnologia("planta nuclear", "horno de lava", "taladro de explosión", "refinería de metales")
	def_tecnologia("torre de alta tensión", "cable")
	def_tecnologia("perforadora de petróleo", "bomba hidráulica", "fábrica de concreto")
	def_tecnologia("mortero", "rifle", "planta química", "fábrica de concreto")
	def_tecnologia("procesador", "refinería de petróleo", "ensambladora")
	def_tecnologia("mensaje", "procesador")
	def_tecnologia("memoria", "procesador")
	def_tecnologia("torre reparadora", "torre básica", "generador")
	def_tecnologia("tubería subterránea", "tubería")
	def_tecnologia("onda de choque", "láser", "batería", "ensambladora")
	def_tecnologia("muro reforzado", "muro")
	def_tecnologia("silo de misiles", "planta nuclear", "procesador", "mortero", "fábrica de drones")
	def_tecnologia("planta de enriquecimiento", "planta nuclear", "procesador")
	def_tecnologia("almacén", "cinta magnética")
	def_tecnologia("fábrica de concreto", "horno", "bomba hidráulica")
	def_tecnologia("pantalla", "procesador", "refinería de petróleo")
	def_tecnologia("refinería de petróleo", "fábrica de concreto", "ensambladora")
	def_tecnologia("planta de reciclaje", "refinería de metales", "horno de lava")
	def_tecnologia("planta desalinizadora", "bomba de evaporación", "generador")
	def_tecnologia("embotelladora", "tubería")
	edificio_tecnologia_nivel = array_create(edificio_max, -1)
	tecnologia_nivel_edificios = [array_create(0, 0)]
	var edi_count = 0
	for(var a = 0; a < edificio_max; a++)
		if edificio_construible[a]{
			if array_length(edificio_tecnologia_prev[a]) = 0{
				edi_count++
				edificio_tecnologia_nivel[a] = 0
				array_push(tecnologia_nivel_edificios[0], a)
				edificio_tecnologia[a] = true
			}
		}
		else
			edi_count++
	while edi_count < edificio_max{
		var stable = true
		array_push(tecnologia_nivel_edificios, array_create(0, 0))
		for(var b = 0; b < edificio_max; b++)
			if edificio_construible[b] and edificio_tecnologia_nivel[b] = -1{
				var flag = true
				for(var c = 0; c < array_length(edificio_tecnologia_prev[b]); c++)
					if edificio_tecnologia_nivel[edificio_tecnologia_prev[b, c]] = -1 or edificio_tecnologia_nivel[edificio_tecnologia_prev[b, c]] = array_length(tecnologia_nivel_edificios){
						flag = false
						break
					}
				if flag{
					stable = false
					edi_count++
					edificio_tecnologia_nivel[b] = array_length(tecnologia_nivel_edificios)
					array_push(tecnologia_nivel_edificios[array_length(tecnologia_nivel_edificios) - 1], b)
				}
			}
		if stable{
			show_debug_message("Hay ciclos imposibles")
			break
		}
	}
	for(var a = 0; a < array_length(tecnologia_nivel_edificios[1]); a++){
		var b = tecnologia_nivel_edificios[1, a], flag = true
		for(var c = 0; c < array_length(edificio_tecnologia_prev[b]); c++)
			if not edificio_tecnologia[edificio_tecnologia_prev[b, c]]{
				flag = false
				break
			}
		if flag
			edificio_tecnologia_desbloqueable[b] = true
	}
#endregion
//Redes electricas
null_red = {
	edificios : array_create(0, null_edificio),
	generacion: 0,
	consumo : 0,
	bateria : 0,
	bateria_max : 0,
	eficiencia : 0
}
null_edificio.red = null_red
redes = array_create(0, null_red)
//Flujos de líquidos
null_flujo ={
	edificios : array_create(0, null_edificio),
	liquido : 0,
	generacion: 0,
	consumo: 0,
	almacen : 0,
	almacen_max : 0,
	eficiencia : 0
}
null_edificio.flujo = null_flujo
flujos = array_create(0, null_flujo)
//Agua, piedra, petróleo y lava
var temp_peso = [0, 0, 0, 0, 0, 1, 1, 2, 3, 3, 3, 4, 5]
var temp_peso_data = [[idt_piedra, 20], [idt_agua, 20], [idt_petroleo, 10], [idt_pared_piedra, 50], [idt_lava, 15], [idt_agua_salada, 20]], size = array_length(temp_peso)
for(var e = 0; e < size; e++){
	var a = irandom(xsize - 1), b = irandom(ysize - 1)
	var c = temp_peso_data[temp_peso[e], 0]
	var f = temp_peso_data[temp_peso[e], 1]
	repeat(f){
		if terreno[# a, b] != idt_agua
			set_terreno(a, b, c)
		for(var d = 0; d < 6; d++){
			var temp_complex = next_to(a, b, d), aa = temp_complex.a, bb = temp_complex.b
			if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
				continue
			if terreno[# aa, bb] != idt_agua{
				set_terreno(aa, bb, c)
				if c = idt_piedra{
					if random(1) < 0.1
						ds_grid_set(terreno, aa, bb, idt_piedra_cuprica)
					else if random(1) < 0.1
						ds_grid_set(terreno, aa, bb, idt_piedra_ferrica)
				}
			}
		}
		repeat(2){
			var d = irandom(5)
			var temp_complex = next_to(a, b, d)
			a = clamp(temp_complex.a, 0, xsize - 1)
			b = clamp(temp_complex.b, 0, ysize - 1)
		}
	}
}
//Añadir arena / agua profunda
for(var a = 0; a < xsize; a++)
	for(var b = 0; b < ysize; b++){
		//Añadir arena
		if in(terreno[# a, b], idt_agua, idt_agua_salada)
			for(var c = 0; c < 6; c++){
				var temp_complex = next_to(a, b, c), aa = temp_complex.a, bb = temp_complex.b
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
					continue
				if not in(terreno[# aa, bb], idt_agua, idt_agua_profunda, idt_agua_salada, idt_agua_salada_profunda)
					ds_grid_set(terreno, aa, bb, idt_arena)
				if brandom(){
					temp_complex = next_to(aa, bb, c)
					aa = temp_complex.a
					bb = temp_complex.b
					if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
						continue
					if not in(terreno[# aa, bb], idt_agua, idt_agua_profunda, idt_agua_salada, idt_agua_salada_profunda)
						ds_grid_set(terreno, aa, bb, idt_arena)
				}
			}
		//Piedra al rededor de Petróleo
		else if terreno[# a, b] = idt_petroleo
			for(var c = 0; c < 6; c++){
				var temp_complex = next_to(a, b, c), aa = temp_complex.a, bb = temp_complex.b
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
					continue
				if terreno[# aa, bb] != idt_petroleo
					terreno[# aa, bb] = idt_piedra
			}
		//Basalto al rededor de la Lava
		else if terreno[# a, b] = idt_lava
			for(var c = 0; c < 6; c++){
				var temp_complex = next_to(a, b, c), aa = temp_complex.a, bb = temp_complex.b
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
					continue
				if terreno[# aa, bb] != idt_lava{
					if random(1) < 0.9
						ds_grid_set(terreno, aa, bb, idt_basalto)
					else
						ds_grid_set(terreno, aa, bb, idt_basalto_sulfatado)
				}
				if brandom(){
					temp_complex = next_to(aa, bb, irandom(5))
					aa = temp_complex.a
					bb = temp_complex.b
					if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
						continue
					if terreno[# aa, bb] != idt_lava{
						if random(1) < 0.9
							ds_grid_set(terreno, aa, bb, idt_basalto)
						else
							ds_grid_set(terreno, aa, bb, idt_basalto_sulfatado)
					}
				}
			}
		//Añadir agua profunda
		if in(terreno[# a, b], idt_agua, idt_agua_salada){
			var flag = true
			for(var c = 0; c < 6; c++){
				var temp_complex = next_to(a, b, c), aa = temp_complex.a, bb = temp_complex.b
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
					continue
				if not in(terreno[# aa, bb], idt_agua, idt_agua_profunda, idt_agua_salada, idt_agua_salada_profunda){
					flag = false
					break
				}
			}
			if flag
				if terreno[# a, b] = idt_agua
					ds_grid_set(terreno, a, b, idt_agua_profunda)
				else if terreno[# a, b] = idt_agua_salada
					ds_grid_set(terreno, a, b, idt_agua_salada_profunda)
		}
		
	}
//Crear nucelo
var temp_list = get_size(floor(xsize / 2), floor(ysize / 2), 0, 7)
for(var a = ds_list_size(temp_list) - 1; a >= 0; a--){
	var temp_complex = temp_list[|a], aa = temp_complex.a, bb = temp_complex.b
	if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
		continue
	if not terreno_caminable[terreno[# aa, bb]]{
		if in(terreno[# aa, bb], idt_pared_arena, idt_agua, idt_agua_salada)
			set_terreno(aa, bb, idt_arena)
		else if in(terreno[# aa, bb], idt_pared_piedra, idt_agua_profunda, idt_agua_salada_profunda, idt_petroleo)
			set_terreno(aa, bb, idt_piedra)
		else if in(terreno[# aa, bb], idt_pared_nieve, idt_hielo)
			set_terreno(aa, bb, idt_nieve)
		else if terreno[# aa, bb] = idt_pared_pasto
			set_terreno(aa, bb, idt_pasto)
		else if terreno[# aa, bb] = idt_lava
			set_terreno(aa, bb, idt_basalto)
		else
			set_terreno(aa, bb, idt_pasto)
	}
	ds_grid_set(ore, aa, bb, -1)
	ds_grid_set(ore_amount, aa, bb, 0)
}
nucleo = add_edificio(0, 0, floor(xsize / 2), floor(ysize / 2))
nucleo.carga[id_cobre] = 100
nucleo.carga_total = 100
carga_inicial = array_create(rss_max, 0)
array_copy(carga_inicial, 0, nucleo.carga, 0, rss_max)
//Natural Ores
for(var e = 0; e < 10; e++){
	var a = min(xsize - 1, irandom_range((e mod 3) * xsize / 3, ((e mod 3) + 1) * xsize / 3))
	var b = irandom(ysize - 1)
	var c = floor(e / 3)
	repeat(15){
		if terreno_caminable[terreno[# a, b]]{
			if ore[# a, b] != c{
				ds_grid_set(ore_amount, a, b, 0)
				if in(terreno[# a, b], idt_piedra, idt_piedra_cuprica, idt_piedra_ferrica){
					if c = id_cobre
						ds_grid_set(terreno, a, b, idt_piedra_cuprica)
					else if c = id_hierro
						ds_grid_set(terreno, a, b, idt_piedra_ferrica)
				}
			}
			ds_grid_set(ore, a, b, c)
			ds_grid_add(ore_amount, a, b, floor(random_range(0.3, 1) * ore_size[c]))
		}
		for(var d = 0; d < 6; d++){
			var temp_complex = next_to(a, b, d), aa = temp_complex.a, bb = temp_complex.b
			if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
				continue
			if terreno_caminable[terreno[# aa, bb]]{
				if ore[# aa, bb] != c{
					ds_grid_set(ore_amount, aa, bb, 0)
					if in(terreno[# aa, bb], idt_piedra, idt_piedra_cuprica, idt_piedra_ferrica){
						if c = id_cobre
							ds_grid_set(terreno, aa, bb, idt_piedra_cuprica)
						else if c = id_hierro
							ds_grid_set(terreno, aa, bb, idt_piedra_ferrica)
					}
				}
				ds_grid_set(ore, aa, bb, c)
				ds_grid_add(ore_amount, aa, bb, floor(random_range(0.3, 1) * ore_size[c]))
			}
		}
		var d = irandom(5)
		var temp_complex = next_to(a, b, d)
		a = clamp(temp_complex.a, 0, xsize - 1)
		b = clamp(temp_complex.b, 0, ysize - 1)
	}
}
//Spawn point
do{
	if irandom(1){
		spawn_x = (xsize - 1) * irandom(1)
		spawn_y = irandom(ysize - 1)
	}
	else{
		spawn_x = irandom(xsize - 1)
		spawn_y = 1 + (ysize - 3) * irandom(1)
	}
}
until terreno_caminable[terreno[# spawn_x, spawn_y]]
