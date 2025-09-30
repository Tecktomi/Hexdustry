randomize()
draw_set_font(ft_letra)
directorio = game_save_id
ini_open(game_save_id + "settings.ini")
ini_write_string("Global", "version", "30_09_2025")
ini_close()
#region Metadatos
	menu = 0
	cursor = cr_arrow
	deslizante_id = -1
	xsize = 48
	ysize = 96
	chunk_width = 12
	chunk_height = 24
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
	tile_animation = true
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
	editor_menu = false
	mision_nombre = array_create(0, "")
	mision_objetivo = array_create(0, 0)
	mision_target_id = array_create(0, 0)
	mision_target_num = array_create(0, 0)
	mision_actual = -1
	mision_counter = 0
	get_keyboard_string = -1
	objetivos_nombre = ["conseguir", "tener almacenado", "construir", "tener construido", "matar"]
	oleadas = true
	oleadas_tiempo_primera = 240
	oleadas_tiempo = 30
	null_efecto = new_efecto()
	efectos = array_create(0, null_efecto)
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
	energy_output : 0,
	energy_storage : 0,
	energia_link : ds_list_create(),
	flujo : undefined,
	flujo_link: ds_list_create(),
	vida : 0,
	target : undefined,
	flujo_consumo : 0,
	energia_consumo : 0,
	edificio_index : 0,
	coordenadas_dis : ds_grid_create(xsize, ysize),
	coordenadas_close : ds_list_create(),
	vivo : false,
	emisor : false,
	receptor : false
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
//Grids
bool_unidad = ds_grid_create(xsize, ysize)
ds_grid_clear(bool_unidad, false)
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
for(var a = 0; a < xsize; a++)
	for(var b = 0; b < ysize; b++){
		var temp_priority = ds_priority_create()
		ds_priority_add(temp_priority, null_edificio, 0)
		ds_priority_delete_max(temp_priority)
		ds_grid_set(edificio_cercano_priority, a, b, temp_priority)
	}
//Crear plantilla de fondo
for(var a = 0; a < xsize; a++)
	for(var b = 0; b < ysize; b++){
		var temp_complex = abtoxy(a, b), temp_hexagono = instance_create_layer(temp_complex.a, temp_complex.b, "instances", obj_hexagono)
		ds_grid_set(ore_random, a, b, random(1))
		temp_hexagono.a = a
		temp_hexagono.b = b
	}
//Enemigos
null_enemigo = {
	a : 0,
	b : 0,
	vida_max : 5,
	vida : 5,
	target : null_edificio,
	target_unit : undefined,
	chunk_x : 0,
	chunk_y : 0
}
null_enemigo.target_unit = null_enemigo
enemigos = ds_list_create()
drones_aliados = ds_list_create()
ds_list_add(enemigos, null_enemigo)
ds_list_clear(enemigos)
null_edificio.target = null_enemigo
chunk_enemigos = ds_grid_create(ceil(xsize / 6), ceil(ysize / 12))
for(var a = 0; a < xsize / 6; a++)
	for(var b = 0; b < ysize / 12; b++){
		var temp_list = ds_list_create()
		ds_list_add(temp_list, null_enemigo)
		ds_list_clear(temp_list)
		ds_grid_set(chunk_enemigos, a, b, temp_list)
	}
//Disparos
null_municion = {
	x : 0,
	y : 0,
	hmove : 0,
	vmove : 0,
	tipo : 0,
	dis : 0,
	dmg : 0,
	target : null_enemigo
}
municiones = array_create(0, null_municion)
#region Tipos de disparos
	armas = [
		[{recurso : 0, cantidad : 1, dmg : 30}, {recurso : 3, cantidad : 1, dmg : 40}],
		[{recurso : 2, cantidad : 1, dmg : 80}, {recurso : 4, cantidad : 1, dmg : 100}],
		[{recurso : 13, cantidad : 1, dmg : 400}]]
#endregion
//Terrenos
#region Arreglos
	terreno_nombre = []
	terreno_sprite = []
	terreno_recurso_bool = []
	terreno_recurso_id = []
	terreno_caminable = []
	terreno_liquido = []
#endregion
function def_terreno(nombre, sprite = spr_piedra, recurso = 0, caminable = true, liquido = false){
	array_push(terreno_nombre, string(nombre))
	array_push(terreno_sprite, sprite)
	array_push(terreno_recurso_id, recurso)
	array_push(terreno_recurso_bool, (recurso > 0))
	array_push(terreno_caminable, caminable)
	array_push(terreno_liquido, liquido)
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
	def_terreno("Pared de Piedra", spr_pared_piedra,, false)
	//10
	def_terreno("Pared de Pasto", spr_pared_pasto,, false)
	def_terreno("Pared de Arena", spr_pared_arena,, false)
	def_terreno("Nieve", spr_nieve)
	def_terreno("Pared de Nieve", spr_pared_nieve,, false)
	def_terreno("Lava", spr_lava,, false, true)
	//15
	def_terreno("Hielo", spr_hielo)
	def_terreno("Basalto", spr_basalto)
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
#endregion
ore_max = array_length(ore_sprite)
//Recursos
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
#endregion
rss_max = array_length(recurso_nombre)
//Liquidos
liquido_nombre = ["Agua", "Ácido", "Petróleo", "Lava"]
liquido_color = [make_color_rgb(37, 109, 123), make_color_rgb(255, 245, 0), make_color_rgb(0, 10, 10), make_color_rgb(251, 175, 93)]
lq_max = array_length(liquido_nombre)
//Edificios
#region Descripciones
	edificio_descripcion = [
	"Es el centro de mando, aquí se almacenan todos\nlos recursos y debes protegerlo a toda costa",
	"Permite minar cobre, hierro y carbón sin coste\nalguno\nPuede mejorarse con Agua",
	"Mueve recursos de un lugar a otro",
	"Distribuye recursos en una dirección",
	"Permite el paso de un recurso específico mientras\ndesvía al resto",
	"Desvía los recursos una vez que la línea esté\nsaturada",
	"Pasa recursos bajo tierra permitiendo construir\nencima",
	"Utiliza combustible para fundir Bronce, Acero y\nSilicio",
	"Taladro mejorado que también extrae piedra y arena\ndel suelo pero consume energía\nPuede mejorarse con Ácido",
	"Tritura la piedra para hacerla arena",
	"Genera energía utlizando conbustible",
	"Conecta edificios cercanos a la red de energía",
	"Almacena el excedente de energía para usarlo más\ntarde",
	"Genera energía limpia del sol",
	"Extrae líquidos del terreno usando energía",
	"Conecta estructuras para llevar líquidos",
	"Pasa recursos bajo tierra permitiendo construir\nencima",
	"Genera energía a partir de magia",
	"Versión mejorada de la Cinta Transportadora que\npermite transportar más cosas",
	"Defensa simple, puede disparar Cobre o Hierro",
	"Dispara un láser cuyo daño depende de la cantidad\nde energía disponible",
	"Distrae a los enemigos mientras tus defensas se\nencargan de ellos",
	"Escoge una receta para producir compuestos\nquímicos",
	"Defensa de largo alcance que dispara Bronce o\nAcero",
	"Almacena grandes cantidades de líquidos",
	"Genera el líquido a elección a partir de magia",
	"Genera energía a partir de un combustible y Agua",
	"Refina la Piedra Cúprica o Férrica en Cobre o\nHierro usando Ácido",
	"Fabrica drones de defensa utilizando Acero, Silicio\ny bastante energía",
	"Genera recursos a partir de magia",
	"Extrae lentamente Agua por evaporación",
	"Similar al horno normal, pero utiliza el calor\nde la lava para cocinar más rápido",
	"Genera energía a partir de evaporar Agua,\ndebe ser construido sobre lava",
	"Utiliza explosivos para extraer un recurso\nde cada terreno minable en su área",
	"Dispara explosivos a largo alcance, devastando\nun área de enemigos"
	]
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
	edificio_combutable = []
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
#endregion
function def_edificio(name, size, sprite = spr_base, sprite_2 = spr_base, key = "", vida = 100, proceso = 0, camino = false, comb = false, precio_id = [0], precio_num = [0], carga = 0, receptor = false, in_all = true, in_id = [0], in_num = [0], emisor = false, out_all = true, out_id = [0], energia = 0, agua = 0, agua_consumo = 0){
	array_push(edificio_nombre, string(name))
	array_push(edificio_size, real(size))
	array_push(edificio_sprite, sprite)
	array_push(edificio_sprite_2, (sprite_2 = spr_base) ? sprite : sprite_2)
	array_push(edificio_key, key)
	array_push(edificio_rotable, ((size mod 2) = 0 or camino))
	array_push(edificio_vida, vida)
	array_push(edificio_proceso, proceso)
	array_push(edificio_camino, camino)
	array_push(edificio_combutable, comb)
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
		array_push(edificio_input_id, [0])
		array_push(edificio_input_num, [0])
	}
	array_push(edificio_emisor, emisor)
	array_push(edificio_output_all, emisor ? out_all : false)
	if emisor and not out_all
		array_push(edificio_output_id, out_id)
	else
		array_push(edificio_output_id, [0])
	array_push(edificio_energia, (energia != 0))
	array_push(edificio_energia_consumo, energia)
	array_push(edificio_flujo, (agua > 0))
	array_push(edificio_flujo_almacen, agua)
	array_push(edificio_flujo_consumo, agua_consumo)
}
#region Definición
	def_edificio("Núcleo", 3, spr_base,,, 1200,,,,,,, true)
	def_edificio("Taladro", 2, spr_taladro,, "21", 200, 120,,, [0], [15], 10,,,,, true, false, [0, 1, 3],, 10, 3)
	def_edificio("Cinta Transportadora", 1, spr_camino, spr_camino_diagonal, "11", 30, 20, true,, [0], [1], 1, true,,,, true)
	def_edificio("Enrutador", 1, spr_enrutador, spr_enrutador_2, "12", 60, 10, true,, [0], [4], 1, true,,,, true)
	def_edificio("Selector", 1, spr_selector, spr_selector_color, "13", 60, 10, true,, [0], [4], 1, true,,,, true)
	def_edificio("Overflow", 1, spr_overflow,, "14", 60, 10, true,, [0], [4], 1, true,,,, true)
	def_edificio("Túnel", 1, spr_tunel,, "15", 60, 10,,, [0, 3], [4, 4], 1, true, true,,, true, true)
	def_edificio("Horno", 2, spr_horno, spr_horno_encendido, "22", 250, 150,, true, [0, 3], [10, 20], 20, true, false, [0, 1, 3, 5, 12], [4, 4, 4, 4, 4], true, false, [2, 4, 7])
	def_edificio("Taladro Eléctrico", 3, spr_taladro_electrico,, "23", 400, 50,,, [0, 2, 4], [20, 10, 10], 20,,,,, true, false, [0, 1, 3, 5, 6, 9, 10, 11], 50, 10, 3)
	def_edificio("Triturador", 2, spr_triturador,, "24", 250, 20,,, [0, 4], [10, 25], 25, true, false, [6, 9, 10, 11], [5, 5, 5, 5], true, false, [5], 30)
	//10
	def_edificio("Generador", 1, spr_generador, spr_generador_encendido, "32", 100,,, true, [0, 3], [20, 5], 20, true, false, [1, 12], [10, 10], false,,, -30)
	def_edificio("Cable", 1, spr_cable,, "31", 30,,,, [0, 3], [5, 1])
	def_edificio("Batería", 1, spr_bateria,, "33", 60,,,, [2, 14], [5, 3])
	def_edificio("Panel Solar", 2, spr_panel_solar,, "34", 150,,,, [0, 4, 7], [10, 10, 5],,,,,,,,, -6)
	def_edificio("Bomba Hidráulica", 2, spr_bomba,, "43", 200, 1,,, [0, 4, 7], [10, 15, 10],,,,,,,,, 25, 60, -40)
	def_edificio("Tubería", 1, spr_tuberia, spr_tuberia_color, "41", 30, 1,,, [0, 4], [1, 1],,,,,,,,,, 10)
	def_edificio("Túnel salida", 1, spr_tunel_salida,, "A", 60, 10,,, [0, 3], [4, 4], 1,,,,, true, true)
	def_edificio("Energía Infinita", 1, spr_energia_infinita,, "3 ", 100,,,,,,,,,,,,,, -999999)
	def_edificio("Cinta Magnética", 1, spr_cinta_magnetica, spr_cinta_magnetica_diagonal, "16", 60, 10, true,, [2, 3], [1, 1], 1, true,,,, true)
	def_edificio("Torre", 1, spr_torre, spr_torre_2, "51", 300, 60,,, [2, 3], [10, 25], 20, true, false, [0, 3], [10, 10],,,,, 10, 60)
	//20
	def_edificio("Láser", 2, spr_laser,, "52", 400, 1,,, [0, 4, 7], [10, 10, 10],,,,,,,,, 100)
	def_edificio("Muro", 1, spr_hexagono,, "53", 500,,,, [8], [1])
	def_edificio("Planta Química", 3, spr_planta_quimica,, "25", 200, 30,, true, [0, 4, 7], [20, 40, 20], 30,,,,,,,, 50, 20)
	def_edificio("Rifle", 2, spr_rifle, spr_rifle_2, "54", 400, 100,,, [2, 4, 8], [10, 10, 5], 20, true, false, [2, 4], [10, 10],,,,, 10, 60)
	def_edificio("Depósito", 3, spr_deposito, spr_deposito_color, "44", 200, 1,,, [4, 7], [20, 30],,,,,,,,,, 300)
	def_edificio("Líquido Infinito", 1, spr_liquido_infinito, spr_tuberia_color, "4 ", 30, 1,,,,,,,,,,,,,, 10, -999999)
	def_edificio("Turbina", 2, spr_turbina,, "35", 160,,, true, [0, 4, 7], [20, 10, 10], 20, true, false, [1, 12], [10, 10], false,,, -150, 30, 40)
	def_edificio("Refinería de Metales", 3, spr_refineria_minerales,, "26", 150, 80,,, [4, 7, 8], [20, 10, 10], 20, true, false, [9, 10], [5, 5], true, false, [0, 3], 80, 60, 60)
	def_edificio("Fábrica de Drones", 2, spr_fabrica_drones,, "55", 200, 900,,, [2, 4, 7], [20, 20, 15], 20, true, false, [4, 7], [10, 10], false, false,, 120)
	def_edificio("Recurso Infinito", 1, spr_recurso_infinito, spr_selector_color, "1 ", 30, 1,,,,,,,,,, true, true)
	//30
	def_edificio("Bomba de Evaporación", 1, spr_bomba_evaporacion, spr_tuberia_color, "42", 30, 1,,, [0, 4], [10, 10],,,,,,,,,, 20, -5)
	def_edificio("Horno de Lava", 2, spr_horno_lava, spr_horno_lava_encendido, "27", 400, 90,,, [4, 8], [10, 10], 15, true, false, [0, 3, 5], [5, 5, 5], true, false, [2, 4, 7],, 10, 0.5)
	def_edificio("Generador Geotérmico", 2, spr_generador_geotermico,, "36", 200, 1,,, [0, 4, 8], [10, 10, 10],,,,,,,,, -120, 30, 30)
	def_edificio("Taladro de Explosión", 3, spr_taladro_explosivo,, "28", 300, 300,,, [2, 4, 8], [40, 40, 30], 40, true, false, [13], [10], true, false, [0, 1, 3, 5, 6, 9, 10, 11])
	def_edificio("Mortero", 3, spr_mortero, spr_mortero_2, "55", 600, 300,,, [4, 8], [50, 30], 10, true, false, [13], [10])
#endregion
categoria_edificios = [[2, 3, 4, 5, 6, 18], [1, 7, 8, 9, 22, 27, 31, 33], [11, 10, 12, 13, 26, 32], [15, 30, 14, 24], [19, 20, 21, 23, 28, 34]]
categoria_nombre = ["Transporte", "Producción", "Electricidad", "Líquidos", "Defensa"]
categoria_sprite = [spr_camino, spr_taladro, spr_bateria, spr_bomba, spr_torre]
planta_quimica_receta = ["Ácido", "Concreto", "Explosivos", "Combustible", "Azufre", "Baterías"]
planta_quimica_descripcion = [	"Consume Arena y Piedra Sulfatada para producir\nÁcido",
								"Utiliza Arena, Piedra y Agua para producir Concreto",
								"Utiliza Carbón y Azufre para producir Explosivos",
								"Utiliza Petróleo para producir compuestos\ncombustibles de larga duración",
								"Extrae el Azufre del Petróleo",
								"Utiliza Ácido, Cobre y Hierro para producir\nBaterías"]
edificio_max = array_length(edificio_nombre)
edificio_rotable[6] = true
edificio_input_all[16] = true
edificio_energia[11] = true
edificio_energia[12] = true
size_size = [1, 3, 7, 12, 19]
size_borde = [6, 9, 12, 15, 18, 21]
edificios = ds_list_create()
edificios_counter = array_create(edificio_max, 0)
edificios_targeteables = ds_list_create()
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
var temp_peso_data = [[0, 20], [2, 20], [5, 10], [9, 50], [14, 15]]
for(var e = 0; e < array_length(temp_peso); e++){
	var a = irandom(xsize - 1), b = irandom(ysize - 1)
	var c = temp_peso_data[temp_peso[e], 0]
	var f = temp_peso_data[temp_peso[e], 1]
	repeat(f){
		if terreno[# a, b] != 2
			ds_grid_set(terreno, a, b, c)
		for(var d = 0; d < 6; d++){
			var temp_complex = next_to(a, b, d)
			var aa = clamp(temp_complex.a, 0, xsize - 1)
			var bb = clamp(temp_complex.b, 0, ysize - 1)
			if terreno[# aa, bb] != 2{
				ds_grid_set(terreno, aa, bb, c)
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
//Crear nucelo
nucleo = add_edificio(0, 0, floor(xsize / 2), floor(ysize / 2))
nucleo.carga[0] = 75
nucleo.carga_total = 75
for(var a = 0; a < ds_list_size(nucleo.coordenadas); a++){
	var temp_complex = nucleo.coordenadas[|a]
	var aa = temp_complex.a, bb = temp_complex.b
	ds_grid_set(terreno, aa, bb, 1)
	ds_grid_set(ore, aa, bb, -1)
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
//Natural Ores
for(var e = 0; e < 9; e++){
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