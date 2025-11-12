randomize()
draw_set_font(ft_letra)
directorio = game_save_id
ini_open(game_save_id + "settings.ini")
ini_write_string("Global", "version", "11_11_2025")
ini_close()
#region Metadatos
	menu = 0
	cursor = cr_arrow
	deslizante_id = -1
	xsize = 48
	ysize = 96
	chunk_width = 4
	chunk_height = 12
	prev_x = 0
	prev_y = 0
	prev_change = true
	mx_clic = 0
	my_clic = 0
	show_menu = false
	show_menu_build = undefined
	pausa = false
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
	enemigos_spawned = 3
	keyboard_step = 0
	angle_dir = [pi / 6, pi / 2, 5 * pi / 6, 7 * pi / 6, 3 * pi / 2, 11 * pi / 6]
	for(var a = 0; a < 6; a++){
		cos_angle_dir[a] = cos(angle_dir[a])
		sin_angle_dir[a] = sin(angle_dir[a])
	}
	pre_build_list = ds_list_create()
	ds_list_add(pre_build_list, {a : 0, b : 0})
	ds_list_clear(pre_build_list)
	for(var a = 0; a < xsize / chunk_width; a++)
		for(var b = 0; b < ysize / chunk_height; b++)
			background[a, b] = spr_hexagono
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
	objetivos_nombre = ["conseguir", "tener almacenado", "construir", "tener construido", "matar", "sin objetivo", "apretar ADWS", "cargar edificio"]
	oleadas = true
	oleadas_tiempo_primera = 240
	oleadas_tiempo = 45
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
	deslizante = 0
	null_humo = add_humo(0, 0, 0, 0, 0, 0, 0, 0, 0)
	humos = array_create(0, null_humo)
	direccion_viento = random(2 * pi)
	null_fuego = add_fuego(0, 0, 0, 0, 0, 0, 0)
	fuegos = array_create(0, null_fuego)
	mina = 0
	minb = 0
	maxa = 0
	maxb = 0
	sonido = true
	sonidos = [snd_motor, snd_maquina, snd_horno]
	sonidos_max = array_length(sonidos)
	volumen = array_create(sonidos_max, 0)
	sonido_id = array_create(sonidos_max)
	for(var a = 0; a < sonidos_max; a++){
		sonido_id[a] = audio_play_sound(sonidos[a], 1, true)
		audio_pause_sound(sonido_id[a])
	}
	procesador_instrucciones_length = [1, 4, 2, 7, 9, 6, 7, 5, 6, 7]
	procesador_instrucciones_nombre = [
		"Continuar",
		"Asignar variable",
		"Variable aleatoria",
		"Operaciones",
		"Saltar a línea",
		"Controlar edificio",
		"Leer información de edificio",
		"Escribir texto a Mensaje",
		"Leer datos de Memoria",
		"Escribir datos a Memoria"]
	procesador_add = false
	input_layer = 0
	show_smoke = true
	oleadas_timer = 0
	multiplicador_vida_enemigos = 1
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
	tutorial = 0
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
	inputs : ds_list_create(),
	input_index : 0,
	outputs : ds_list_create(),
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
	energia_link : ds_list_create(),
	flujo : undefined,
	flujo_link: ds_list_create(),
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
	array_real : array_create(0, 0)
}
null_edificio.link = null_edificio
ds_list_add(null_edificio.coordenadas, {a : 0, b : 0})
ds_list_clear(null_edificio.coordenadas)
ds_list_add(null_edificio.bordes, {a : 0, b : 0})
ds_list_clear(null_edificio.bordes)
ds_list_add(null_edificio.energia_link, null_edificio)
ds_list_clear(null_edificio.energia_link)
ds_list_add(null_edificio.flujo_link, null_edificio)
ds_list_clear(null_edificio.flujo_link)
ds_grid_clear(null_edificio.coordenadas_dis, 0)
ds_list_add(null_edificio.coordenadas_close, {a : 0, b : 0})
ds_list_clear(null_edificio.coordenadas_close)
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
#endregion
//Enemigos
null_enemigo = {
	a : 0,
	b : 0,
	index : 0,
	vida : 5,
	target : null_edificio,
	temp_target : null_edificio,
	chunk_x : 0,
	chunk_y : 0,
	chunk_pointer : 0,
	carga : [0],
	carga_total : 0,
	modo : 0,
	pointer : 0,
	torres : array_create(0, null_edificio)
}
enemigos = array_create(0, null_enemigo)
drones_aliados = array_create(0, null_enemigo)
null_edificio.target = null_enemigo
chunk_enemigos = ds_grid_create(ceil(xsize / chunk_width), ceil(ysize / chunk_height))
chunk_edificios = ds_grid_create(ceil(xsize / chunk_width), ceil(ysize / chunk_height))
for(var a = ds_grid_width(chunk_enemigos); a > 0; a--)
	for(var b = ds_grid_height(chunk_enemigos); b > 0; b--){
		ds_grid_set(chunk_enemigos, a - 1, b - 1, array_create(0, null_enemigo))
		ds_grid_set(chunk_edificios, a - 1, b - 1, array_create(0, null_edificio))
	}
//Disparos
null_municion = add_municion()
municiones = array_create(0, null_municion)
#region Tipos de disparos
	armas = [
		[{recurso : 0, cantidad : 0.3, dmg : 30}, {recurso : 3, cantidad : 0.3, dmg : 40}],
		[{recurso : 2, cantidad : 0.5, dmg : 80}, {recurso : 4, cantidad : 0.5, dmg : 100}, {recurso: 17, cantidad : 1, dmg : 180}, {recurso: 19, cantidad : 1, dmg : 180}],
		[{recurso : 13, cantidad : 1, dmg : 400}],
		[{recurso : 1, cantidad : 0.03, dmg : 2}, {recurso : 12, cantidad : 0.03, dmg : 5}]]
#endregion
//Drones
#region Descripción
	dron_descripcion = [
			"Dispara a los enemigos cercanos",
			"Transporta recursos entre Puertos de Carga",
			"Repara los edificios dañados",
			"Se acerca a su objetivo y explota infilgiendo daño",
			"Unidad de asedio superior, dispara explosivos alargo alcance dañando todo a su alrededor"
		]
	for(var a = array_length(dron_descripcion); a > 0; a--)
		dron_descripcion[a - 1] = text_wrap(dron_descripcion[a - 1], 400)
#endregion
dron_nombre = ["Araña", "Dron", "Reparador", "Explosivo", "Tanque"]
dron_sprite = [spr_arana, spr_dron, spr_reparador, spr_dron_explosivo, spr_tanque]
dron_sprite_color = [spr_arana_color, spr_arana_color, spr_arana_color, spr_arana_color, spr_tanque_2]
dron_vida_max = [100, 40, 60, 50, 750]
dron_size = [400, 400, 400, 400, 1600]
dron_alcance = [6400, 100, 2500, 1600, 160_000]
dron_precio_id = [[2, 14, 16], [14, 15, 16], [7, 14, 15, 16], [13, 14, 16], [2, 4, 16]]
dron_precio_num = [[3, 1, 1], [1, 3, 1], [10, 1, 3, 1], [2, 1, 1], [15, 25, 10]]
dron_max = array_length(dron_nombre)
//Terrenos
#region Arreglos
	terreno_nombre = []
	terreno_sprite = []
	terreno_recurso_bool = []
	terreno_recurso_id = []
	terreno_caminable = []
	terreno_liquido = []
	terreno_pared = []
#endregion
function def_terreno(nombre, sprite = spr_piedra, recurso = 0, caminable = true, liquido = false, pared = false){
	array_push(terreno_nombre, string(nombre))
	array_push(terreno_sprite, sprite)
	array_push(terreno_recurso_id, recurso)
	array_push(terreno_recurso_bool, (recurso > 0))
	array_push(terreno_caminable, caminable)
	array_push(terreno_liquido, liquido)
	array_push(terreno_pared, pared)
}
#region Definición
	def_terreno("Piedra", spr_piedra, 6)
	def_terreno("Pasto", spr_pasto)
	def_terreno("Agua", spr_agua,, false, true)
	def_terreno("Arena", spr_arena, 5)
	def_terreno("Agua Profunda", spr_agua_profunda,, false, true)
	//5
	def_terreno("Petróleo", spr_petroleo,, false, true)
	def_terreno("Piedra Cúprica", spr_piedra_cobre, 9)
	def_terreno("Piedra Férrica", spr_piedra_hierro, 10)
	def_terreno("Basalto Sulfatado", spr_basalto_azufre, 11)
	def_terreno("Pared de Piedra", spr_pared_piedra,, false,, true)
	//10
	def_terreno("Pared de Pasto", spr_pared_pasto,, false,, true)
	def_terreno("Pared de Arena", spr_pared_arena,, false,, true)
	def_terreno("Nieve", spr_nieve)
	def_terreno("Pared de Nieve", spr_pared_nieve,, false,, true)
	def_terreno("Lava", spr_lava,, false, true)
	//15
	def_terreno("Hielo", spr_hielo)
	def_terreno("Basalto", spr_basalto)
	def_terreno("Ceniza", spr_ceniza)
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
	def_ore(0, spr_cobre, 80)
	def_ore(1, spr_carbon, 60)
	def_ore(3, spr_hierro, 50)
	def_ore(17, spr_uranio, 30)
#endregion
ore_max = array_length(ore_sprite)
//Recursos
#region Definición
	recurso_descripcion = [
		"Recurso básico, escencial para los primeros edificios\nPuede ser refinado para obtener Bronce",
		"Combustible básico, útil para el funcionamiento de Hornos y Generadores",
		"Recurso útil para la construcción de infrastructura intermedia",
		"Recurso básico, escencial para los primeros edificios",
		"Recurso útil para la construcción de infrastructura intermedia",
		"Recurso necesario para la producción de bienes refinados como Silicio o Concreto",
		"Recurso necesario para la producción de Concreto\nPuede ser transformado en Arena en un Triturador",
		"Recurso útil en la producción de Paneles Solares, Drones y Circuitos",
		"Recurso útil para la construcción de infrastructura intermedia",
		"Puede ser utilizada como Piedra normal o purificada para obtener Cobre",
		"Puede ser utilizada como Piedra normal o porificada para obtener Hierro",
		"Puede ser utilizada como Piedra normal\nPero es escencial en la producción de bienes más refinados",
		"Combustible avanzado, más eficiente y dduradero que el Carbón",
		"Munición avanzada para Morteros y necesario para el funcionamiento de Taladros de Explosión",
		"Recurso necesario para la producción de todo tipo de Drones",
		"Material ligero, útil en la producción de Drones",
		"Circuito básico, necesario para la producción de todo tipo de Drones y edificios eléctricos avanzados",
		"Uranio sin refinar, útil como munición\nPuede ser refinado para ddividir el Uranio Empobrecido del Enriquecido",
		"Uranio 235, útil para la generación de energía en Plantas Nucleares",
		"Uranio 238, necesario para acompañar la producción de energía en Plantas Nucleares\nY útil como munición"
	]
#endregion
#region Arreglos
	recurso_sprite = []
	recurso_nombre = []
	recurso_color = []
	recurso_combustion = []
	recurso_combustion_time = []
#endregion
function def_recurso(name, sprite = spr_item_hierro, color = c_black, combustion = 0){
	array_push(recurso_nombre, string(name))
	array_push(recurso_sprite, sprite)
	array_push(recurso_color, color)
	array_push(recurso_combustion_time, combustion)
	array_push(recurso_combustion, (combustion > 0))
}
#region Definición
	def_recurso("Cobre", spr_item_cobre, c_orange)
	def_recurso("Carbón", spr_item_carbon, c_black, 300)
	def_recurso("Bronce", spr_item_bronce, make_color_rgb(228, 148, 29))
	def_recurso("Hierro", spr_item_hierro, c_gray)
	def_recurso("Acero", spr_item_acero, c_dkgray)
	//5
	def_recurso("Arena", spr_item_arena, c_yellow)
	def_recurso("Piedra", spr_item_piedra, c_dkgray)
	def_recurso("Silicio", spr_item_vidrio, c_aqua)
	def_recurso("Concreto", spr_item_concreto, c_ltgray)
	def_recurso("Piedra Cúprica", spr_item_piedra_cobre, make_color_hsv(90, 100, 127))
	//10
	def_recurso("Piedra Férrica", spr_item_piedra_hierro, make_color_hsv(0, 100, 127))
	def_recurso("Piedra Sulfatada", spr_item_piedra_azufre, make_color_hsv(42, 100, 127))
	def_recurso("Compuesto Incendiario", spr_item_incendiario, make_color_rgb(191, 127, 0), 900)
	def_recurso("Explosivo", spr_item_explosivos, c_red)
	def_recurso("Batería", spr_item_bateria, make_color_rgb(163, 98, 10))
	//15
	def_recurso("Plástico", spr_item_plastico, c_blue)
	def_recurso("Componente", spr_item_chip, make_color_rgb(33, 94, 35))
	def_recurso("Uranio Bruto", spr_item_uranio, make_color_rgb(153, 178, 88))
	def_recurso("Uranio Enriquecido", spr_item_uranio_235, make_color_rgb(0, 255, 0))
	def_recurso("Uranio Empobrecido", spr_item_uranio_238, make_color_rgb(0, 127, 0))
#endregion
rss_max = array_length(recurso_nombre)
rss_sort = array_create(rss_max, 0)
var temp_rss_sort = array_create(rss_max)
for(var a = 0; a < rss_max; a++)
	temp_rss_sort[a] = {
		name : recurso_nombre[a],
		index : a
	}
array_sort(temp_rss_sort, function(elm1, elm2){return elm1.name < elm2.name ? -1 : 1})
for(var a = 0; a < rss_max; a++)
	rss_sort[a] = temp_rss_sort[a].index
//Liquidos
liquido_nombre = ["Agua", "Ácido", "Petróleo", "Lava"]
liquido_color = [make_color_rgb(37, 109, 123), make_color_rgb(255, 245, 0), make_color_rgb(0, 10, 10), make_color_rgb(251, 175, 93)]
lq_max = array_length(liquido_nombre)
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
		"Taladro mejorado que también extrae piedra y arena del suelo pero consume energía. Puede potenciarse con Ácido",
		"Tritura la piedra para hacerla arena",
		//10
		"Genera energía utlizando conbustible",
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
		"Escoge una receta para producir compuestos químicos",
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
		"Utiliza Cobre y Silicio para producir componentes",
		"Consume 1 parte de Uranio Enriquecido por 20 partes de Uranio Empobrecido y mucha Agua para generar mucha energía",
		"Conecta redes eléctricas a través de largas distancias",
		"Produce petróleo a alto coste en cualquier lugar",
		//40
		"Dispara explosivos a largo alcance, devastando un área de enemigos",
		"Procesa instrucciones lógicas",
		"Permite escribir mensajes",
		"Permite almacenar hasta 128 datos",
		"Proyecta un láser de reparación a los edificios cercanos usando energía"
	]
	for(var a = array_length(edificio_descripcion) - 1; a >= 0; a--)
		edificio_descripcion[a] = text_wrap(edificio_descripcion[a], 400)
#endregion
#region Arreglos
	edificio_sprite = []
	edificio_sprite_2 = []
	edificio_nombre = []
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
	edificio_camino = []
	edificio_energia =	[]
	edificio_energia_consumo = []
	edificio_precio_id = []
	edificio_precio_num = []
	edificio_key = []
	edificio_vida =	[]
	edificio_flujo = []
	edificio_flujo_liquidos = []
	edificio_flujo_almacen = []
	edificio_flujo_consumo = []
	edificio_arma = []
	edificio_alcance = []
	edificio_alcance_sqr = []
	edificio_armas = []
	edificio_inerte = []
#endregion
function def_edificio(name, size, sprite = spr_base, sprite_2 = spr_base, key = "", vida = 100, proceso = 0, camino = false, precio_id = array_create(0, 0), precio_num = array_create(0, 0), carga = 0, receptor = false, in_all = true, in_id = array_create(0, 0), in_num = array_create(0, 0), emisor = false, out_all = true, out_id = array_create(0, 0)){
	array_push(edificio_nombre, string(name))
	array_push(edificio_size, real(size))
	array_push(edificio_sprite, sprite)
	array_push(edificio_sprite_2, (sprite_2 = spr_base) ? sprite : sprite_2)
	array_push(edificio_key, key)
	array_push(edificio_rotable, ((size mod 2) = 0 or camino))
	array_push(edificio_vida, vida)
	array_push(edificio_proceso, proceso)
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
}
function def_edificio_2(energia = 0, agua = 0, agua_consumo = 0, arma = -1, alcance = 0, inerte = false){
	array_push(edificio_energia, (energia != 0))
	array_push(edificio_energia_consumo, energia)
	array_push(edificio_flujo, (agua > 0))
	array_push(edificio_flujo_almacen, agua)
	array_push(edificio_flujo_consumo, agua_consumo)
	array_push(edificio_arma, arma)
	array_push(edificio_alcance, alcance)
	array_push(edificio_alcance_sqr, sqr(alcance))
	array_push(edificio_armas, bool(alcance > 0))
	array_push(edificio_inerte, inerte)
}
#region Definición
	def_edificio("Núcleo", 3, spr_base,,, 1200,,,,,, true); def_edificio_2(,,,,, true)
	def_edificio("Taladro", 2, spr_taladro,, "21", 200, 120,, [0], [15], 10,,,,, true, false, [0, 1, 3]); def_edificio_2(, 10, 3)
	def_edificio("Cinta Transportadora", 1, spr_camino, spr_camino_diagonal, "11", 30, 20, true, [0], [1], 1, true,,,, true); def_edificio_2()
	def_edificio("Enrutador", 1, spr_enrutador, spr_enrutador_2, "12", 60, 10, true, [0], [4], 1, true,,,, true); def_edificio_2()
	def_edificio("Selector", 1, spr_selector, spr_selector_color, "13", 60, 10, true, [0], [4], 1, true,,,, true); def_edificio_2()
	def_edificio("Overflow", 1, spr_overflow,, "14", 60, 10, true, [0], [4], 1, true,,,, true); def_edificio_2()
	def_edificio("Túnel", 1, spr_tunel,, "15", 60, 10,, [0, 3], [4, 4], 1, true, true,,, true, true); def_edificio_2()
	def_edificio("Horno", 2, spr_horno, spr_horno_encendido, "22", 250, 150,, [0, 3], [10, 20], 20, true, false, [0, 1, 3, 5, 12], [4, 4, 4, 4, 4], true, false, [2, 4, 7]); def_edificio_2()
	def_edificio("Taladro Eléctrico", 3, spr_taladro_electrico,, "23", 400, 45,, [2, 4], [20, 10], 20,,,,, true, false, [0, 1, 3, 5, 6, 9, 10, 11]); def_edificio_2(50, 10, 3)
	def_edificio("Triturador", 2, spr_triturador,, "24", 250, 20,, [2, 4], [10, 25], 25, true, false, [6, 9, 10, 11], [5, 5, 5, 5], true, false, [5]); def_edificio_2(30)
	//10
	def_edificio("Generador", 1, spr_generador, spr_generador_encendido, "32", 100,,, [0, 3], [20, 5], 20, true, false, [1, 12], [10, 10], false); def_edificio_2(-30)
	def_edificio("Cable", 1, spr_cable,, "31", 30,,, [0, 3], [5, 1]); def_edificio_2(,,,,, true)
	def_edificio("Batería", 1, spr_bateria,, "33", 60,,, [2, 14], [5, 3]); def_edificio_2(,,,,, true)
	def_edificio("Panel Solar", 2, spr_panel_solar,, "34", 150,,, [0, 2, 7], [10, 10, 5]); def_edificio_2(-6)
	def_edificio("Bomba Hidráulica", 2, spr_bomba,, "43", 200, 1,, [0, 2, 3], [10, 25, 10]); def_edificio_2(25, 60, -40)
	def_edificio("Tubería", 1, spr_tuberia, spr_tuberia_color, "41", 30, 1,, [2], [1]); def_edificio_2(, 10,,,, true)
	def_edificio("Túnel salida", 1, spr_tunel_salida,, "", 60, 10,, [0, 3], [4, 4], 1,,,,, true, true); def_edificio_2()
	def_edificio("Energía Infinita", 1, spr_energia_infinita,, "3 ", 100); def_edificio_2(-999_999,,,,, true)
	def_edificio("Cinta Magnética", 1, spr_cinta_magnetica, spr_cinta_magnetica_diagonal, "16", 60, 10, true, [2, 3], [1, 1], 1, true,,,, true); def_edificio_2()
	def_edificio("Torre básica", 1, spr_torre, spr_torre_2, "51", 300, 30,, [0, 3], [10, 25], 20, true, false, [0, 3], [10, 10]); def_edificio_2(, 10, 60, 0, 180)
	//20
	def_edificio("Rifle", 2, spr_rifle, spr_rifle_2, "52", 400, 45,, [0, 3, 4], [10, 10, 10], 20, true, false, [2, 4, 17, 19], [10, 10, 10, 10]); def_edificio_2(, 10, 60, 1, 300)
	def_edificio("Lanzallamas", 2, spr_lanzallamas, spr_lanzallamas_2, "53", 400, 1,, [0, 2, 3], [15, 15, 10], 20, true, false, [1, 12], [10, 10]); def_edificio_2(, 10, 4, 3, 130)
	def_edificio("Planta Química", 3, spr_planta_quimica,, "25", 200, 60,, [0, 2, 3, 7], [20, 10, 20, 10], 30, true, false, [0, 1, 3, 5, 6, 9, 10, 11], [0, 0, 0, 0, 0, 0, 0, 0], true, false, [8, 11, 12, 13, 14, 15]); def_edificio_2(50, 10)
	def_edificio("Láser", 2, spr_laser, spr_laser_2, "54", 400, 1,, [0, 4, 7], [10, 10, 5]); def_edificio_2(120,,, 0, 220)
	def_edificio("Depósito", 3, spr_deposito, spr_deposito_color, "44", 200, 1,, [2, 4], [20, 10]); def_edificio_2(, 300,,,, true)
	def_edificio("Líquido Infinito", 1, spr_liquido_infinito, spr_tuberia_color, "4 ", 30, 1); def_edificio_2(, 10, -999_999,,, true)
	def_edificio("Turbina", 2, spr_turbina,, "35", 160,,, [0, 2, 4], [10, 10, 10], 20, true, false, [1, 12], [10, 10]); def_edificio_2(-150, 10, 40)
	def_edificio("Refinería de Metales", 3, spr_refineria_minerales,, "27", 150, 80,, [2, 4, 8], [15, 15, 10], 30, true, false, [9, 10, 17], [5, 5, 10], true, false, [0, 3, 18, 19]); def_edificio_2(80, 10, 2)
	def_edificio("Fábrica de Drones", 2, spr_fabrica_drones,, "17", 200, 900,, [0, 4, 16], [20, 15, 10], 20, true, false, [14, 15, 16], [1, 3, 1]); def_edificio_2(120)
	def_edificio("Recurso Infinito", 1, spr_recurso_infinito, spr_selector_color, "1 ", 30, 1,,,,,,,,, true, true); def_edificio_2()
	//30
	def_edificio("Bomba de Evaporación", 1, spr_bomba_evaporacion, spr_tuberia_color, "42", 30, 1,, [2], [15]); def_edificio_2(, 10, -5)
	def_edificio("Horno de Lava", 2, spr_horno_lava, spr_horno_lava_encendido, "28", 400, 90,, [4, 8], [15, 10], 15, true, false, [0, 3, 5], [5, 5, 5], true, false, [2, 4, 7]); def_edificio_2(, 10, 1)
	def_edificio("Generador Geotérmico", 2, spr_generador_geotermico,, "36", 200, 1,, [0, 4, 8], [10, 10, 10]); def_edificio_2(-120, 10, 30)
	def_edificio("Taladro de Explosión", 3, spr_taladro_explosivo,, "29", 300, 300,, [2, 4, 8], [40, 40, 30], 40, true, false, [13], [10], true, false, [0, 1, 3, 5, 6, 9, 10, 11, 17]); def_edificio_2()
	def_edificio("Muro", 1, spr_hexagono,, "56", 500,,, [8], [1]); def_edificio_2(,,,,, true)
	def_edificio("Puerto de Carga", 2, spr_punto_carga,, "18", 150,,, [0, 3, 16], [10, 10, 1], 25,, true,,,, true); def_edificio_2()
	def_edificio("Ensambladora", 3, spr_ensambladora,, "26", 400, 150,, [2, 3, 4, 7], [10, 20, 10, 10], 20, true, false, [0, 7], [5, 5], true, false, [16]); def_edificio_2(100)
	def_edificio("Planta Nuclear", 4, spr_planta_nuclear,, "37", 500,,, [0, 4, 8, 16], [100, 80, 50, 20], 21, true, false, [18, 19], [1, 20]); def_edificio_2(-900, 150, 300)
	def_edificio("Torre de Alta Tensión", 2, spr_cable_tension,, "38", 100,,, [0, 4, 16], [30, 10, 2]); def_edificio_2(5,,,,, true)
	def_edificio("Perforadora de Petróleo", 3, spr_perforadora,, "20", 200, 1,, [2, 4, 8], [10, 15, 10]); def_edificio_2(120, 10, -2)
	//40
	def_edificio("Mortero", 3, spr_mortero, spr_mortero_2, "55", 600, 180,, [4, 8], [50, 30], 10, true, false, [13], [10]); def_edificio_2(,,, 2, 600)
	def_edificio("Procesador", 2, spr_procesador,, "61", 80, 1,, [0, 15, 16], [20, 40, 20]); def_edificio_2(5)
	def_edificio("Mensaje", 1, spr_mensaje,, "62", 50,,, [0, 16], [10, 3]); def_edificio_2(,,,,, true)
	def_edificio("Memoria", 1, spr_memoria,, "63", 50,,, [0, 16], [10, 3]); def_edificio_2(,,,,, true)
	def_edificio("Torre Reparadora", 2, spr_torre_reparadora, spr_torre_reparadora_2, "57", 100, 1,, [2, 3, 15], [10, 15, 5]); def_edificio_2(40,,, 0, 200)
#endregion
categoria_edificios = [[2, 3, 4, 5, 6, 18, 28, 35], [1, 7, 8, 9, 22, 36, 27, 31, 33, 39], [11, 10, 12, 13, 26, 32, 37, 38], [15, 30, 14, 24], [19, 20, 21, 23, 34, 40, 44], [41, 42, 43]]
categoria_nombre = ["Transporte", "Producción", "Electricidad", "Líquidos", "Defensa", "Lógica"]
#region planta quimica
	planta_quimica_receta = ["Ácido", "Concreto", "Explosivos", "Combustible", "Azufre", "Baterías", "Plástico"]
	planta_quimica_descripcion = [
		"Consume Arena y Piedra Sulfatada para producir\nÁcido",
		"Utiliza Arena, Piedra y Agua para producir Concreto",
		"Utiliza Carbón y Azufre para producir Explosivos",
		"Utiliza Petróleo para producir compuestos\ncombustibles de larga duración",
		"Extrae el Azufre del Petróleo",
		"Utiliza Ácido, Cobre y Hierro para producir\nBaterías",
		"Utiliza Petróleo para producir Plástico"]
#endregion
edificio_max = array_length(edificio_nombre)
edificio_rotable[6] = true
edificio_input_all[16] = true
edificio_energia[11] = true
edificio_energia[12] = true
edificio_input_all[35] = true
edificio_output_all[35] = true
edificio_energia[38] = true
size_size = [1, 3, 7, 12, 19]
size_borde = [6, 9, 12, 15, 18, 21]
size_fx = [fx_construir_1, fx_construir_2, fx_construir_3, fx_construir_4, spr_hexagono_5]
edificios_construibles = array_create(0, 0)
for(var a = 0; a < array_length(categoria_nombre); a++)
	edificios_construibles = array_concat(edificios_construibles, categoria_edificios[a])
edificios = ds_list_create()
edificios_counter = array_create(edificio_max, 0)
nucleos = array_create(0, null_edificio)
edificios_targeteables = ds_list_create()
torres_de_tension = array_create(0, null_edificio)
edi_sort = array_create(edificio_max, 0)
var temp_edi_sort = array_create(edificio_max)
for(var a = 0; a < edificio_max; a++)
	temp_edi_sort[a] = {
		name : edificio_nombre[a],
		index : a
	}
array_sort(temp_edi_sort, function(elm1, elm2){return elm1.name < elm2.name ? -1 : 1})
for(var a = 0; a < edificio_max; a++)
	edi_sort[a] = temp_edi_sort[a].index
//Redes electricas
null_red = {
	edificios : ds_list_create(),
	generacion: 0,
	consumo : 0,
	bateria : 0,
	bateria_max : 0,
	eficiencia : 0
}
null_edificio.red = null_red
ds_list_add(null_red.edificios, null_edificio)
ds_list_clear(null_red.edificios)
redes = ds_list_create()
ds_list_add(redes, null_red)
ds_list_clear(redes)
//Flujos de líquidos
null_flujo ={
	edificios : ds_list_create(),
	liquido : 0,
	generacion: 0,
	consumo: 0,
	almacen : 0,
	almacen_max : 0
}
null_edificio.flujo = null_flujo
ds_list_add(null_flujo.edificios, null_edificio)
ds_list_clear(null_flujo.edificios)
flujos = ds_list_create()
ds_list_add(flujos, null_flujo)
ds_list_clear(flujos)
//Agua, piedra, petróleo y lava
var temp_peso = [0, 0, 0, 0, 0, 1, 1, 2, 3, 3, 3, 4]
var temp_peso_data = [[0, 20], [2, 20], [5, 10], [9, 50], [14, 15]], size = array_length(temp_peso)
for(var e = 0; e < size; e++){
	var a = irandom(xsize - 1), b = irandom(ysize - 1)
	var c = temp_peso_data[temp_peso[e], 0]
	var f = temp_peso_data[temp_peso[e], 1]
	repeat(f){
		if terreno[# a, b] != 2
			set_terreno(a, b, c)
		var temp_list = get_arround(a, b, 0, 1), size_2 = ds_list_size(temp_list)
		for(var d = 0; d < size_2; d++){
			var temp_complex = temp_list[|d], aa = temp_complex.a, bb = temp_complex.b
			if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
				continue
			if terreno[# aa, bb] != 2{
				set_terreno(aa, bb, c)
				if c = 0{
					if random(1) < 0.1
						ds_grid_set(terreno, aa, bb, 6)
					else if random(1) < 0.1
						ds_grid_set(terreno, aa, bb, 7)
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
		if terreno[# a, b] = 2
			for(var c = 0; c < 6; c++){
				var temp_complex = next_to(a, b, c), aa = temp_complex.a, bb = temp_complex.b
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
					continue
				if not in(terreno[# aa, bb], 2, 4)
					ds_grid_set(terreno, aa, bb, 3)
				if brandom(){
					temp_complex = next_to(aa, bb, 5)
					aa = temp_complex.a
					bb = temp_complex.b
					if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
						continue
					if not in(terreno[# aa, bb], 2, 4)
						ds_grid_set(terreno, aa, bb, 3)
				}
			}
		//Piedra al rededor de Petróleo
		else if terreno[# a, b] = 5
			for(var c = 0; c < 6; c++){
				var temp_complex = next_to(a, b, c), aa = temp_complex.a, bb = temp_complex.b
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
					continue
				if terreno[# aa, bb] != 5
					terreno[# aa, bb] = 0
			}
		//Basalto al rededor de la Lava
		else if terreno[# a, b] = 14
			for(var c = 0; c < 6; c++){
				var temp_complex = next_to(a, b, c), aa = temp_complex.a, bb = temp_complex.b
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
					continue
				if terreno[# aa, bb] != 14{
					if random(1) < 0.9
						ds_grid_set(terreno, aa, bb, 16)
					else
						ds_grid_set(terreno, aa, bb, 8)
				}
				if brandom(){
					temp_complex = next_to(aa, bb, irandom(5))
					aa = temp_complex.a
					bb = temp_complex.b
					if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
						continue
					if terreno[# aa, bb] != 14{
						if random(1) < 0.9
							ds_grid_set(terreno, aa, bb, 16)
						else
							ds_grid_set(terreno, aa, bb, 8)
					}
				}
			}
		//Añadir agua profunda
		if terreno[# a, b] = 2{
			var flag = true
			for(var c = 0; c < 6; c++){
				var temp_complex = next_to(a, b, c), aa = temp_complex.a, bb = temp_complex.b
				if aa < 0 or bb < 0 or aa >= xsize or bb >= ysize
					continue
				if not in(terreno[# aa, bb], 2, 4){
					flag = false
					break
				}
			}
			if flag
				ds_grid_set(terreno, a, b, 4)
		}
	}
//Crear nucelo
var temp_list = get_size(floor(xsize / 2), floor(ysize / 2), 0, 7)
size = ds_list_size(temp_list)
for(var a = 0; a < size; a++){
	var temp_complex = temp_list[|a], aa = temp_complex.a, bb = temp_complex.b
	if not terreno_caminable[terreno[# aa, bb]]
		ds_grid_set(terreno, aa, bb, 1)
	ds_grid_set(ore, aa, bb, -1)
	ds_grid_set(ore_amount, aa, bb, 0)
}
nucleo = add_edificio(0, 0, floor(xsize / 2), floor(ysize / 2))
nucleo.carga[0] = 90
nucleo.carga_total = 90
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
				if in(terreno[# a, b], 0, 6, 7){
					if c = 0
						ds_grid_set(terreno, a, b, 6)
					else if c = 2
						ds_grid_set(terreno, a, b, 7)
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
					if in(terreno[# aa, bb], 0, 6, 7){
						if c = 0
							ds_grid_set(terreno, aa, bb, 6)
						else if c = 2
							ds_grid_set(terreno, aa, bb, 7)
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
		spawn_y = (ysize - 1) * irandom(1)
	}
}
until terreno_caminable[terreno[# spawn_x, spawn_y]]
