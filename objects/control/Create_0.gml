randomize()
draw_set_font(tf_letra)
xsize = 28
ysize = 51
prev_x = 0
prev_y = 0
prev_change = true
mx_clic = 0
my_clic = 0
show_menu = false
show_menu_build = undefined
show_menu_x = 0
show_menu_y = 0
edificio_max = 0
pre_build_list = ds_list_create()
ds_list_add(pre_build_list, {a : 0, b : 0})
ds_list_clear(pre_build_list)
background = spr_hexagono
null_edificio = {
	index : 0,
	dir : 0,
	a : 0,
	b : 0,
	x : 0,
	y : 0,
	coordenadas : ds_list_create(),
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
	edificio_index : 0
}
null_edificio.link = null_edificio
ds_list_add(null_edificio.energia_link, null_edificio)
ds_list_clear(null_edificio.energia_link)
ds_list_add(null_edificio.flujo_link, null_edificio)
ds_list_clear(null_edificio.flujo_link)
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
	target : null_edificio
}
enemigos = ds_list_create()
ds_list_add(enemigos, null_enemigo)
ds_list_clear(enemigos)
null_edificio.target = null_enemigo
//Terrenos
#region Arreglos
	terreno_nombre = []
	terreno_sprite = []
	terreno_recurso_bool = []
	terreno_recurso_id = []
#endregion
function def_terreno(nombre, sprite = spr_piedra, recurso = 0){
	array_push(terreno_nombre, string(nombre))
	array_push(terreno_sprite, sprite)
	array_push(terreno_recurso_id, recurso)
	array_push(terreno_recurso_bool, (recurso > 0))
}
#region Definición
	def_terreno("Piedra", spr_piedra, 6)
	def_terreno("Pasto", spr_pasto)
	def_terreno("Agua", spr_agua)
	def_terreno("Arena", spr_arena, 5)
	def_terreno("Agua Profunda", spr_agua_profunda)
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
	def_recurso("Explosivo", spr_item_sal, c_red)
#endregion
rss_max = array_length(recurso_nombre)
//Liquidos
liquido_nombre = ["Agua", "Ácido", "Petróleo"]
liquido_color = [c_aqua, c_green, c_black]
lq_max = array_length(liquido_nombre)
//Edificios
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
	edificio_flujo_almacen = []
	edificio_flujo_consumo = []
#endregion
function def_edificio(name, size, sprite = spr_base, sprite_2 = spr_base, key = vk_nokey, vida = 100, proceso = 0, camino = false, comb = false, precio_id = [0], precio_num = [0], carga = 0, receptor = false, in_all = true, in_id = [0], in_num = [0], emisor = false, out_all = true, out_id = [0], energia = 0, agua = 0, agua_consumo = 0){
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
	def_edificio("Taladro", 2, spr_taladro,, ord("Q"), 200, 120,,, [0], [15], 10,,,,, true, false, [0, 1, 3])
	def_edificio("Cinta Transportadora", 1, spr_camino, spr_camino_diagonal, ord(1), 30, 20, true,, [0], [1], 1, true,,,, true)
	def_edificio("Enrutador", 1, spr_enrutador, spr_enrutador_2, ord(2), 60, 10, true,, [0], [4], 1, true,,,, true)
	def_edificio("Selector", 1, spr_selector, spr_selector_color, ord(3), 60, 10, true,, [0], [4], 1, true,,,, true)
	def_edificio("Overflow", 1, spr_overflow,, ord(4), 60, 10, true,, [0], [4], 1, true,,,, true)
	def_edificio("Túnel", 1, spr_tunel,, ord(5), 60, 10,,, [0, 3], [4, 4], 1, true, true,,, true, true)
	def_edificio("Horno", 2, spr_horno, spr_horno_encendido, ord("W"), 250, 150,, true, [0, 3], [20, 15], 19, true, false, [0, 1, 3, 5], [4, 4, 4, 4], true, false, [2, 4, 7])
	def_edificio("Taladro Eléctrico", 3, spr_taladro_electrico,, ord("E"), 400, 50,,, [0, 2, 4], [20, 10, 10], 20,,,,, true, false, [0, 1, 3, 5, 6], 50, 10, 20)
	def_edificio("Triturador", 2, spr_triturador,, ord("R"), 250, 20,,, [0, 4], [10, 25], 10, true, false, [6], [5], true, false, [5, 9], 30)
	//10
	def_edificio("Generador", 1, spr_generador, spr_generador_encendido, ord("A"), 100,,, true, [0, 3], [20, 5], 10, true, false, [1], [10], false,,, -30)
	def_edificio("Cable", 1, spr_cable,, ord("S"), 30,,,, [0, 3], [5, 1])
	def_edificio("Batería", 1, spr_bateria,, ord("D"), 60,,,, [0, 2], [20, 5])
	def_edificio("Panel Solar", 2, spr_panel_solar,, ord("F"), 150,,,, [0, 4, 7], [10, 10, 5],,,,,,,,, -6)
	def_edificio("Bomba Hidráulica", 2, spr_bomba,, ord("Z"), 200, 1,,, [0, 4, 7], [10, 15, 10],,,,,,,,, 25, 30, -30)
	def_edificio("Tubería", 1, spr_tuberia, spr_tuberia_color, ord("X"), 30, 1,,, [4, 7], [1, 1],,,,,,,,,, 10)
	def_edificio("Túnel", 1, spr_tunel_salida,,, 60, 10,,, [0, 3], [4, 4], 1,,,,, true, true)
	def_edificio("Energía Infinita", 1, spr_energia_infinita,, ord("M"), 100,,,,,,,,,,,,,, -999999)
	def_edificio("Cinta Magnética", 1, spr_cinta_magnetica, spr_cinta_magnetica_diagonal, ord(6), 60, 10, true,, [2, 4], [1, 1], 1, true,,,, true)
	def_edificio("Torre", 1, spr_torre, spr_torre_2, ord("L"), 600, 60,,, [2, 3], [10, 25], 30, true, false, [0, 3, 6], [10, 10, 10],,,,, 10, 60)
	//20
	def_edificio("Láser", 2, spr_laser,, ord("K"), 500, 1,,, [0, 4, 7], [10, 10, 10],,,,,,,,, 100)
	def_edificio("Muro", 1, spr_hexagono,, ord("J"), 200,,,, [8], [1])
	def_edificio("Fábrica de Concreto", 3, spr_fabrica_de_concreto,, ord("T"), 300, 120,,, [0, 2, 4], [10, 20, 25], 20, true, false, [5, 6], [5, 5], true, false, [8], 20, 30, 60)
	def_edificio("Planta Química", 3, spr_planta_quimica,, ord("C"), 150, 30,, true, [0, 4, 7], [20, 40, 20], 12, true, false, [1, 5, 7], [4, 4, 4],,,,, 60, -20)
	def_edificio("Fábrica de Explosivos", 3, spr_fabrica_explosivos,, ord("Y"), 100, 80,,, [0, 4, 8], [10, 40, 10], 10, true, false, [1, 6], [2, 2], true, false, [9], 20)
	def_edificio("Rifle", 2, spr_rifle, spr_rifle_2, ord("H"), 600, 100,,, [2, 4, 9], [10, 10, 5], 20, true, false, [2, 4], [10, 10],,,,, 10, 60)
	def_edificio("Depósito", 3, spr_deposito, spr_deposito_color, ord("V"), 200, 1,,, [4, 7], [20, 30],,,,,,,,,, 300)
	def_edificio("Líquido Infinito", 1, spr_liquido_infinito, spr_tuberia_color, ord("N"), 30, 1,,,,,,,,,,,,,, 10, -999999)
	def_edificio("Turbina", 2, spr_turbina,, ord("G"), 160,,, true, [0, 4, 7], [20, 10, 10], 10, true, false, [1], [10], false,,, -150, 30, 30)
#endregion
edificio_rotable[6] = true
edificio_input_all[16] = true
edificio_energia[11] = true
edificio_energia[12] = true
size_size = [1, 3, 7, 12, 19, 27]
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
camx = 0
camy = 0
borde_mapa = []
for(var a = 0; a < xsize; a++){
	array_push(borde_mapa, [a, 0])
	array_push(borde_mapa, [a, ysize - 1])
}
for(var a = 0; a < ysize; a++){
	array_push(borde_mapa, [0, a])
	array_push(borde_mapa, [xsize - 1, a])
}
//Agua y piedra
var e = 0
repeat(4){
	var a = irandom(xsize - 1)
	var b = irandom(ysize - 1)
	var c = 0
	if e <= 1
		c = 2 * e++
	else
		c = choose(0, 2)
	repeat(20){
		if terreno[a, b].terreno != 2
			terreno[a, b].terreno = c
		for(var d = 0; d < 6; d++){
			var temp_complex = next_to(a, b, d)
			var aa = clamp(temp_complex.a, 0, xsize - 1)
			var bb = clamp(temp_complex.b, 0, ysize - 1)
			if terreno[aa, bb].terreno != 2
				terreno[aa, bb].terreno = c
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
e = 0
repeat(6){
	var a = min(xsize - 1, irandom_range((e mod 3) * xsize / 3, ((e mod 3) + 1) * xsize / 3))
	var b = irandom(ysize - 1)
	var c = floor(e++ / 2)
	repeat(15){
		var temp_terreno = terreno[a, b]
		if not in(temp_terreno.terreno, 2, 4){
			if temp_terreno.ore != c
				temp_terreno.ore_amount = 0
			temp_terreno.ore = c
			temp_terreno.ore_amount += floor(random_range(0.3, 1) * ore_amount[c])
		}
		for(var d = 0; d < 6; d++){
			var temp_complex = next_to(a, b, d)
			var aa = temp_complex.a
			var bb = temp_complex.b
			if aa >= 0 and bb >= 0 and aa < xsize and bb < ysize{
				temp_terreno = terreno[aa, bb]
				if not in(temp_terreno.terreno, 2, 4){
					if temp_terreno.ore != c
						temp_terreno.ore_amount = 0
					temp_terreno.ore = c
					temp_terreno.ore_amount += floor(random_range(0.3, 1) * ore_amount[c])
				}
			}
		}
		var d = irandom(5)
		var temp_complex = next_to(a, b, d)
		a = clamp(temp_complex.a, 0, xsize - 1)
		b = clamp(temp_complex.b, 0, ysize - 1)
	}
}