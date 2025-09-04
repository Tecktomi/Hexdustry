randomize()
window_set_fullscreen(true)
draw_set_font(ft_letra)
xsize = 48
ysize = 96
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
edificio_max = 0
energia_solar = 1
flow = false
pre_build_list = ds_list_create()
ds_list_add(pre_build_list, {a : 0, b : 0})
ds_list_clear(pre_build_list)
for(var a = 0; a < xsize / 24; a++)
	for(var b = 0; b < ysize / 51; b++)
		background[a, b] = spr_hexagono
null_edificio = {
	index : 0,
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
	coordenadas_close : ds_list_create()
}
null_edificio.link = null_edificio
ds_list_add(null_edificio.energia_link, null_edificio)
ds_list_clear(null_edificio.energia_link)
ds_list_add(null_edificio.flujo_link, null_edificio)
ds_list_clear(null_edificio.flujo_link)
ds_grid_clear(null_edificio.coordenadas_dis, 0)
ds_list_add(null_edificio.coordenadas_close, 0)
ds_list_clear(null_edificio.coordenadas_close)
edificios_targeteables = ds_list_create()
null_terreno = {
	hexagono : obj_hexagono,
	terreno : 0,
	ore : -1,
	ore_amount : 0,
	ore_random : 0,
	edificio_bool : false,
	edificio_draw : false,
	edificio : null_edificio
}
bool_unidad = ds_grid_create(xsize, ysize)
ds_grid_clear(bool_unidad, false)
//Crear plantilla de fondo
for(var a = 0; a < xsize; a++)
	for(var b = 0; b < ysize; b++){
		var temp_complex = abtoxy(a, b), temp_hexagono = instance_create_layer(temp_complex.a, temp_complex.b, "instances", obj_hexagono)
		terreno[a, b] = {
			hexagono : temp_hexagono,
			terreno : 1,
			ore : -1,
			ore_amount : 0,
			ore_random : irandom(1),
			edificio_bool : false,
			edificio_draw : false,
			edificio : null_edificio
		}
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
	dis : 0
}
municiones = ds_list_create()
ds_list_add(municiones, null_municion)
ds_list_clear(municiones)
#region Tipos de disparos
	armas = [
		[{recurso : 0, cantidad : 1, dmg : 30}, {recurso : 3, cantidad : 1, dmg : 40}],
		[{recurso : 2, cantidad : 1, dmg : 80}, {recurso : 4, cantidad : 1, dmg : 100}]]
#endregion
//Terrenos
#region Arreglos
	terreno_nombre = []
	terreno_sprite = []
	terreno_recurso_bool = []
	terreno_recurso_id = []
	terreno_caminable = []
#endregion
function def_terreno(nombre, sprite = spr_piedra, recurso = 0, caminable = true){
	array_push(terreno_nombre, string(nombre))
	array_push(terreno_sprite, sprite)
	array_push(terreno_recurso_id, recurso)
	array_push(terreno_recurso_bool, (recurso > 0))
	array_push(terreno_caminable, caminable)
}
#region Definición
	def_terreno("Piedra", spr_piedra, 6)
	def_terreno("Pasto", spr_pasto)
	def_terreno("Agua", spr_agua,, false)
	def_terreno("Arena", spr_arena, 5)
	def_terreno("Agua Profunda", spr_agua_profunda,, false)
	//5
	def_terreno("Petróleo", spr_petroleo,, false)
	def_terreno("Piedra Cúprica", spr_piedra_cobre, 9)
	def_terreno("Piedra Férrica", spr_piedra_hierro, 10)
	def_terreno("Piedra Sulfatada", spr_piedra_azufre, 11)
	def_terreno("Pared de Piedra", spr_pared_piedra,, false)
#endregion
//Ores
#region Arreglos
	ore_sprite = []
	ore_recurso = []
	ore_amount = []
#endregion
function def_ore(recurso, sprite = spr_cobre, cantidad = 50){
	array_push(ore_recurso, real(recurso))
	array_push(ore_sprite, sprite)
	array_push(ore_amount, cantidad)
}
#region Definición
	def_ore(0, spr_cobre, 80)
	def_ore(1, spr_carbon, 60)
	def_ore(3, spr_hierro, 50)
#endregion
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
	def_recurso("Carbón", spr_item_carbon, c_black, 150)
	def_recurso("Bronce", spr_item_bronce, c_red)
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
	def_recurso("Compuesto Incendiario", spr_item_incendiario, make_color_rgb(191, 127, 0), 600)
#endregion
rss_max = array_length(recurso_nombre)
//Liquidos
liquido_nombre = ["Agua", "Ácido", "Petróleo"]
liquido_color = [make_color_rgb(37, 109, 123), make_color_rgb(255, 245, 0), make_color_rgb(0, 10, 10)]
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
	"Utiliza Arena, Piedra y Agua para producir Concreto",
	"Consume Arena y Piedra Sulfatada para producir\nÁcido",
	"Refina el Petróleo para producir Carbón",
	"Defensa de largo alcance que dispara Bronce o\nAcero",
	"Almacena grandes cantidades de líquidos",
	"Genera el líquido a elección a partir de magia",
	"Genera energía a partir de un combustible y Agua",
	"Refina la Piedra Cúprica o Férrica en Cobre o\nHierro usando Ácido",
	"Utiliza Carbón, Arena y Petróleo para producir\nun compuesto combustible de larga duración",
	"Fabrica drones de defensa utilizando Acero, Silicio y bastante energía",
	"Genera recursos a partir de magia",
	"Extrae lentamente Agua por evaporación"
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
	def_edificio("Horno", 2, spr_horno, spr_horno_encendido, "22", 250, 150,, true, [0, 3], [10, 20], 19, true, false, [0, 1, 3, 5], [4, 4, 4, 4], true, false, [2, 4, 7])
	def_edificio("Taladro Eléctrico", 3, spr_taladro_electrico,, "23", 400, 50,,, [0, 2, 4], [20, 10, 10], 20,,,,, true, false, [0, 1, 3, 5, 6, 9, 10, 11], 50, 10, 3)
	def_edificio("Triturador", 2, spr_triturador,, "24", 250, 20,,, [0, 4], [10, 25], 10, true, false, [6, 9, 10, 11], [5, 1, 1, 1], true, false, [5, 9], 30)
	//10
	def_edificio("Generador", 1, spr_generador, spr_generador_encendido, "31", 100,,, true, [0, 3], [20, 5], 20, true, false, [1, 12], [10, 10], false,,, -30)
	def_edificio("Cable", 1, spr_cable,, "32", 30,,,, [0, 3], [5, 1])
	def_edificio("Batería", 1, spr_bateria,, "33", 60,,,, [0, 2], [20, 5])
	def_edificio("Panel Solar", 2, spr_panel_solar,, "34", 150,,,, [0, 4, 7], [10, 10, 5],,,,,,,,, -6)
	def_edificio("Bomba Hidráulica", 2, spr_bomba,, "43", 200, 1,,, [0, 4, 7], [10, 15, 10],,,,,,,,, 25, 60, -40)
	def_edificio("Tubería", 1, spr_tuberia, spr_tuberia_color, "42", 30, 1,,, [0, 4], [1, 1],,,,,,,,,, 10)
	def_edificio("Túnel", 1, spr_tunel_salida,, "A", 60, 10,,, [0, 3], [4, 4], 1,,,,, true, true)
	def_edificio("Energía Infinita", 1, spr_energia_infinita,, "3 ", 100,,,,,,,,,,,,,, -999999)
	def_edificio("Cinta Magnética", 1, spr_cinta_magnetica, spr_cinta_magnetica_diagonal, "16", 60, 10, true,, [2, 4], [1, 1], 1, true,,,, true)
	def_edificio("Torre", 1, spr_torre, spr_torre_2, "51", 300, 60,,, [2, 3], [10, 25], 20, true, false, [0, 3], [10, 10],,,,, 10, 60)
	//20
	def_edificio("Láser", 2, spr_laser,, "52", 400, 1,,, [0, 4, 7], [10, 10, 10],,,,,,,,, 100)
	def_edificio("Muro", 1, spr_hexagono,, "53", 500,,,, [8], [1])
	def_edificio("Fábrica de Concreto", 3, spr_fabrica_de_concreto,, "25", 250, 120,,, [0, 2, 4], [10, 20, 25], 20, true, false, [5, 6, 9, 10, 11], [5, 5, 1, 1, 1], true, false, [8], 20, 30, 60)
	def_edificio("Planta de Ácido", 3, spr_planta_acido,, "26", 200, 30,, true, [0, 4, 7], [20, 40, 20], 12, true, false, [1, 5, 11], [4, 4, 4],,,,, 60, -6)
	def_edificio("Refinería de Petróleo", 2, spr_refineria, spr_refineria_color, "27", 80, 60,,, [0, 2, 7], [10, 20, 10], 10,,,,, true, false, [1], 30, 30, 5)
	def_edificio("Rifle", 2, spr_rifle, spr_rifle_2, "54", 400, 100,,, [2, 4, 8], [10, 10, 5], 20, true, false, [2, 4], [10, 10],,,,, 10, 60)
	def_edificio("Depósito", 3, spr_deposito, spr_deposito_color, "44", 200, 1,,, [4, 7], [20, 30],,,,,,,,,, 300)
	def_edificio("Líquido Infinito", 1, spr_liquido_infinito, spr_tuberia_color, "4 ", 30, 1,,,,,,,,,,,,,, 10, -999999)
	def_edificio("Turbina", 2, spr_turbina,, "35", 160,,, true, [0, 4, 7], [20, 10, 10], 20, true, false, [1, 12], [10, 10], false,,, -150, 30, 40)
	def_edificio("Refinería de Metales", 3, spr_refineria_minerales,, "28", 150, 80,,, [4, 7, 8], [20, 10, 10], 20, true, false, [9, 10], [5, 5], true, false, [0, 3], 80, 60, 60)
	//30
	def_edificio("Fábrica de Compuestos Incendiarios", 2, spr_fabrica_compuesto_incendiario,, "29", 100, 100,,, [2, 3], [5, 20], 13, true, false, [1, 5], [1, 2], true, false, [12], 30, true, 2)
	def_edificio("Fábrica de Drones", 2, spr_fabrica_drones,, "55", 200, 900,,, [2, 4, 7], [20, 20, 15], 20, true, false, [4, 7], [10, 10], false, false,, 120)
	def_edificio("Recurso Infinito", 1, spr_recurso_infinito, spr_selector_color, "1 ", 30, 1,,,,,,,,,, true, true)
	def_edificio("Bomba de Evaporación", 1, spr_bomba_evaporacion, spr_tuberia_color, "41", 30, 1,,, [0, 4], [10, 10],,,,,,,,,, 20, -5)
#endregion
edificio_rotable[6] = true
edificio_input_all[16] = true
edificio_energia[11] = true
edificio_energia[12] = true
size_size = [1, 3, 7, 12, 19]
size_borde = [6, 9, 12, 15, 18, 21]
edificios = ds_list_create()
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
//Metadatos
build_index = 0
build_dir = 0
build_able = false
build_target = null_edificio
last_mx = -1
last_my = -1
build_list = get_size(0, 0, 0, 0)
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
if irandom(1){
	do{
		spawn_x = (xsize - 1) * irandom(1)
		spawn_y = irandom(ysize - 1)
	}
	until not in(terreno_nombre[terreno[spawn_x, spawn_y].terreno], "Agua", "Agua Profunda", "Petróleo")
}
else{
	do{
		spawn_x = irandom(xsize - 1)
		spawn_y = (ysize - 1) * irandom(1)
	}
	until not in(terreno_nombre[terreno[spawn_x, spawn_y].terreno], "Agua", "Agua Profunda", "Petróleo")
}
keyboard_step = 0
//Agua, piedra y petróleo
for(var e = 0; e < 11; e++){
	var a = irandom(xsize - 1), b = irandom(ysize - 1)
	if e <= 4
		var c = 0, f = 20
	else if e <= 6{
		c = 2
		f = 20
	}
	else if e = 7{
		c = 5
		f = 10
	}
	else if e < 11{
		c = 9
		f = 50
	}
	repeat(f){
		if terreno[a, b].terreno != 2
			terreno[a, b].terreno = c
		for(var d = 0; d < 6; d++){
			var temp_complex = next_to(a, b, d)
			var aa = clamp(temp_complex.a, 0, xsize - 1)
			var bb = clamp(temp_complex.b, 0, ysize - 1)
			if terreno[aa, bb].terreno != 2{
				terreno[aa, bb].terreno = c
				if c = 0{
					if random(1) < 0.1
						terreno[aa, bb].terreno = 6
					else if random(1) < 0.1
						terreno[aa, bb].terreno = 7
					else if random(1) < 0.1
						terreno[aa, bb].terreno = 8
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
edificio_cercano = ds_grid_create(xsize, ysize)
ds_grid_clear(edificio_cercano, null_edificio)
edificio_cercano_dis = ds_grid_create(xsize, ysize)
ds_grid_clear(edificio_cercano_dis, infinity)
nucleo = add_edificio(0, 0, floor(xsize / 2), floor(ysize / 2))
nucleo.carga[0] = 75
nucleo.carga_total = 75
for(var a = 0; a < ds_list_size(nucleo.coordenadas); a++){
	var temp_complex = nucleo.coordenadas[|a]
	var aa = temp_complex.a, bb = temp_complex.b
	terreno[aa, bb].terreno = 1
	terreno[aa, bb].ore = -1
}
//Añadir arena / agua profunda
for(var a = 0; a < xsize; a++)
	for(var b = 0; b < ysize; b++){
		//Añadir arena
		if terreno[a, b].terreno = 2 or (terreno[a, b].terreno = 3 and random(1) < 0.2)
			for(var c = 0; c < 6; c++){
				var temp_complex = next_to(a, b, c)
				var aa = temp_complex.a
				var bb = temp_complex.b
				if aa >= 0 and bb >= 0 and aa < xsize and bb < ysize{
					var temp_terreno = terreno[aa, bb]
					if not in(temp_terreno.terreno, 2, 4)
						temp_terreno.terreno = 3
				}
			}
		//Añadir piedra
		if terreno[a, b].terreno = 5
			for(var c = 0; c < 6; c++){
				var temp_complex = next_to(a, b, c)
				var aa = temp_complex.a
				var bb = temp_complex.b
				if aa >= 0 and bb >= 0 and aa < xsize and bb < ysize{
					var temp_terreno = terreno[aa, bb]
					if not in(temp_terreno.terreno, 5)
						temp_terreno.terreno = 0
				}
			}
		//Añadir agua profunda
		if terreno[a, b].terreno = 2{
			var flag = true
			for(var c = 0; c < 6; c++){
				var temp_complex = next_to(a, b, c)
				var aa = temp_complex.a
				var bb = temp_complex.b
				if aa >= 0 and bb >= 0 and aa < xsize and bb < ysize{
					var temp_terreno = terreno[aa, bb]
					if not in(temp_terreno.terreno, 2, 4){
						flag = false
						break
					}
				}
			}
			if flag
				terreno[a, b].terreno = 4
		}
	}
//Natural Ores
for(var e = 0; e < 9; e++){
	var a = min(xsize - 1, irandom_range((e mod 3) * xsize / 3, ((e mod 3) + 1) * xsize / 3))
	var b = irandom(ysize - 1)
	var c = floor(e / 3)
	repeat(15){
		var temp_terreno = terreno[a, b]
		if not in(terreno_nombre[temp_terreno.terreno], "Agua", "Agua Profunda", "Petróleo", "Pared de Piedra"){
			if temp_terreno.ore != c{
				temp_terreno.ore_amount = 0
				if in(temp_terreno.terreno, 0, 6, 7){
					if c = 0
						temp_terreno.terreno = 6
					else if c = 2
						temp_terreno.terreno = 7
				}
			}
			temp_terreno.ore = c
			temp_terreno.ore_amount += floor(random_range(0.3, 1) * ore_amount[c])
		}
		for(var d = 0; d < 6; d++){
			var temp_complex = next_to(a, b, d)
			var aa = clamp(temp_complex.a, 0, xsize - 1)
			var bb = clamp(temp_complex.b, 0, ysize - 1)
			temp_terreno = terreno[aa, bb]
			if not in(terreno_nombre[temp_terreno.terreno], "Agua", "Agua Profunda", "Petróleo", "Pared de Piedra"){
				if temp_terreno.ore != c{
					temp_terreno.ore_amount = 0
					if in(temp_terreno.terreno, 0, 6, 7){
						if c = 0
							temp_terreno.terreno = 6
						else if c = 2
							temp_terreno.terreno = 7
					}
				}
				temp_terreno.ore = c
				temp_terreno.ore_amount += floor(random_range(0.3, 1) * ore_amount[c])
			}
		}
		var d = irandom(5)
		var temp_complex = next_to(a, b, d)
		a = clamp(temp_complex.a, 0, xsize - 1)
		b = clamp(temp_complex.b, 0, ysize - 1)
	}
}