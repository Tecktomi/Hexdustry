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
pre_build_list = ds_list_create()
ds_list_add(pre_build_list, {a : 0, b : 0})
ds_list_clear(pre_build_list)
background = spr_hexagono
null_edificio = {
	index : 0,
	dir : 0,
	a : 0,
	b : 0,
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
	energy_link : ds_list_create(),
	flujo : ds_list_create(),
	flujo_link: ds_list_create()
}
null_edificio.link = null_edificio
ds_list_add(null_edificio.energy_link, null_edificio)
ds_list_clear(null_edificio.energy_link)
ds_list_add(null_edificio.flujo_link, null_edificio)
ds_list_clear(null_edificio.flujo_link)
//Crear plantilla de fondo
for(var a = 0; a < xsize; a++)
	for(var b = 0; b < ysize; b++){
		var temp_complex = abtoxy(a, b)
		var temp_hexagono = instance_create_layer(temp_complex.a, temp_complex.b, "instances", obj_hexagono)
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
//Terrenos
#region Arreglos
	terreno_name = []
	terreno_sprite = []
	terreno_rss = []
	terreno_rss_id = []
#endregion
function def_terreno(nombre, sprite = spr_piedra, recurso = 0){
	array_push(terreno_name, string(nombre))
	array_push(terreno_sprite, sprite)
	array_push(terreno_rss_id, recurso)
	array_push(terreno_rss, (recurso > 0))
}
def_terreno("Piedra", spr_piedra, 6)
def_terreno("Pasto", spr_pasto)
def_terreno("Agua", spr_agua)
def_terreno("Arena", spr_arena, 5)
def_terreno("Agua Profunda", spr_agua_profunda)
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
def_ore(0, spr_cobre, 80)
def_ore(1, spr_carbon, 60)
def_ore(3, spr_hierro, 50)
//Recursos
#region Arreglos
	rss_item_sprite = []
	rss_name = []
	rss_item_color = []
	rss_combustion = []
	rss_comb_time = []
#endregion
function def_recurso(name, sprite = spr_item_hierro, color = c_black, combustion = 0){
	array_push(rss_name, string(name))
	array_push(rss_item_sprite, sprite)
	array_push(rss_item_color, color)
	array_push(rss_comb_time, combustion)
	array_push(rss_combustion, (combustion > 0))
}
def_recurso("Cobre", spr_item_cobre, c_orange)
def_recurso("Carbón", spr_item_carbon, c_black, 150)
def_recurso("Bronce", spr_item_bronce, c_red)
def_recurso("Hierro", spr_item_hierro, c_gray)
def_recurso("Acero", spr_item_acero, c_ltgray)
def_recurso("Arena", spr_item_arena, c_yellow)
def_recurso("Piedra", spr_item_piedra, c_gray)
def_recurso("Vidrio", spr_vidrio, c_aqua)
rss_max = array_length(rss_name)
//Liquidos
liquido_nombre =	["Agua"]
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
	edificio_input_index = []
	edificio_input_num = []
	edificio_output_all = []
	edificio_output_index = []
	edificio_rotable = []
	edificio_proceso = []
	edificio_combutable = []
	edificio_camino = []
	edificio_electricidad =	[]
	edificio_elec_consumo = []
	edificio_precio_index = []
	edificio_precio_num = []
	edificio_key = []
	edificio_vida =	[]
	edificio_flujo = []
	edificio_flujo_input_id = []
	edificio_flujo_input_num = []
	edificio_flujo_output_id = []
	edificio_flujo_output_num = []
#endregion
function def_edificio(nombre, size, sprite = spr_base, sprite_2 = spr_base, key = vk_nokey, vida = 100, proceso = 0, camino = false, combustible = false, precio_id = [0], precio_num = [0], carga = 0, receptor = false, in_all = true, in_id = [0], in_num = [0], emisor = false, out_all = true, out_id = [0], electricidad = 0, agua = 0){
	array_push(edificio_nombre, string(nombre))
	array_push(edificio_size, real(size))
	array_push(edificio_sprite, sprite)
	array_push(edificio_sprite_2, (sprite_2 = spr_base) ? sprite : sprite_2)
	array_push(edificio_key, key)
	array_push(edificio_rotable, ((size mod 2) = 0 or camino))
	array_push(edificio_vida, vida)
	array_push(edificio_proceso, proceso)
	array_push(edificio_camino, camino)
	array_push(edificio_combutable, combustible)
	array_push(edificio_precio_index, precio_id)
	array_push(edificio_precio_num, precio_num)
	array_push(edificio_carga_max, carga)
	array_push(edificio_receptor, receptor)
	array_push(edificio_input_all, receptor ? in_all : false)
	if receptor and not in_all{
		array_push(edificio_input_index, in_id)
		array_push(edificio_input_num, in_num)
	}
	else{
		array_push(edificio_input_index, [0])
		array_push(edificio_input_num, [0])
	}
	array_push(edificio_emisor, emisor)
	array_push(edificio_output_all, emisor ? out_all : false)
	if emisor and not out_all
		array_push(edificio_output_index, out_id)
	else
		array_push(edificio_output_index, [0])
	array_push(edificio_electricidad, (electricidad != 0))
	array_push(edificio_elec_consumo, electricidad)
	array_push(edificio_flujo, (agua != 0))
	array_push(edificio_flujo_input_id, [0])
	array_push(edificio_flujo_input_num, [max(0, -agua)])
	array_push(edificio_flujo_output_id, [0])
	array_push(edificio_flujo_output_num, [max(0, agua)])
}
def_edificio("Núcleo", 3, spr_base,,, 1000,,,,,,, true)
def_edificio("Taladro", 2, spr_taladro,, ord("Q"), 100, 100,,, [0], [15], 10,,,,, true, false, [0, 1, 3])
def_edificio("Cinta Transportadora", 1, spr_camino, spr_camino_diagonal, ord(1), 15, 20, true,, [0], [1], 1, true,,,, true)
def_edificio("Enrutador", 1, spr_enrutador, spr_enrutador_2, ord(2), 15, 10, true,, [0], [4], 1, true,,,, true)
def_edificio("Selector", 1, spr_selector, spr_selector_color, ord(3), 15, 10, true,, [0], [4], 1, true,,,, true)
def_edificio("Overflow", 1, spr_overflow,, ord(4), 15, 10, true,, [0], [4], 1, true,,,, true)
def_edificio("Túnel", 1, spr_tunel,, ord(5), 25, 10,,, [0, 3], [4, 4], 1, true, true)
def_edificio("Horno", 2, spr_horno, spr_horno_encendido, ord("W"), 120, 150, false, true, [0, 3], [20, 15], 30, true, false, [0, 1, 3, 5], [4, 2, 8, 16], true, false, [2, 4, 7])
def_edificio("Taladro Eléctrico", 3, spr_taladro_electrico,, ord("E"), 180, 40,,, [0, 2, 4], [20, 10, 25], 20,,,,, true, false, [0, 1, 3, 5, 6], 75)
def_edificio("Triturador", 2, spr_triturador,, ord("R"), 80, 40,,, [0, 4], [10, 25], 10, true, false, [6], [5], true, false, [5], 30)
//10
def_edificio("Generador", 1, spr_generador, spr_generador_encendido, ord("A"), 30,,, true, [0, 3], [20, 5], 10, true, false, [1], [10], false,,, -20)
def_edificio("Cable", 1, spr_cable,, ord("S"), 10,,,, [0, 3], [5, 1],,,,,,,,, 1)
def_edificio("Batería", 1, spr_bateria,, ord("D"), 30,,,, [0, 2], [20, 5],,,,,,,,, 1)
def_edificio("Panel Solar", 2, spr_panel_solar,, ord("F"), 60,,,, [0, 2, 4], [40, 10, 10],,,,,,,,, -5)
def_edificio("Bomba Hidráulica", 2, spr_bomba, spr_bomba_rotor, ord("Z"), 60, 1,,, [0, 4, 7], [10, 20, 10],,,,,,,,, 25, 10)
def_edificio("Tubería", 1, spr_tuberia,, ord("X"), 10, 1,,, [4, 7], [1, 1],,,,,,,,,, 1)
def_edificio("Túnel", 1, spr_tunel_salida,,, 25, 10,,, [0, 3], [4, 4], 1,,,,, true, true)
def_edificio("Energía Infinita", 1, spr_energia_infinita,, ord("M"), 25,,,,,,,,,,,,,, -infinity)
def_edificio("Cinta Magnética", 1, spr_cinta_magnetica, spr_cinta_magnetica_diagonal, ord(6), 30, 10, true,, [2, 4], [1, 1], 1, true,,,, true)
edificio_rotable[6] = true
edificio_input_all[16] = true
edificio_max = array_length(edificio_nombre)
size_size = [1, 3, 7, 12, 19, 27]
size_borde = [6, 9, 12, 15, 18, 21]
edificios = ds_list_create()
//Redes electricas
red_null = {
	edificios : ds_list_create(),
	generacion: 0,
	consumo : 0,
	bateria : 0,
	bateria_max : 0
}
null_edificio.red = red_null
ds_list_add(red_null.edificios, null_edificio)
ds_list_clear(red_null.edificios)
redes = ds_list_create()
ds_list_add(redes, red_null)
ds_list_clear(redes)
//Flujos de líquidos
flujo_null ={
	edificios : ds_list_create(),
	liquido : 0,
	cantidad : 0,
	generacion: 0,
	consumo: 0,
	cantidad_max : 0
}
ds_list_add(null_edificio.flujo, flujo_null)
ds_list_clear(null_edificio.flujo)
ds_list_add(flujo_null.edificios, null_edificio)
ds_list_clear(flujo_null.edificios)
flujos = ds_list_create()
ds_list_add(flujos, flujo_null)
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
cheat = false
info = false
zoom = 1
camx = 0
camy = 0
//Terreno
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
nucleo.carga[0] = 50
nucleo.carga_total = 50
for(var a = 0; a < ds_list_size(nucleo.coordenadas); a++){
	var temp_complex = ds_list_find_value(nucleo.coordenadas, a)
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
	var a = irandom(xsize - 1)
	var b = irandom(ysize - 1)
	var c = 0
	if e < array_length(ore_recurso)
		c = e++
	else
		c = irandom(array_length(ore_recurso) - 1)
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