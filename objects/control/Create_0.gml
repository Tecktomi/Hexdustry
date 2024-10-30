randomize()
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
terreno_sprite =	[spr_piedra,	spr_pasto,	spr_agua,	spr_arena,	spr_agua_profunda]
terreno_name =		["Piedra",		"Pasto",	"Agua",		"Arena",	"Agua profunda"]
terreno_rss =		[true,			false,		false,		true,		false]
terreno_rss_id =	[6,				0,			0,			5,			0]
//Ores
ore_sprite =	[spr_cobre,		spr_carbon,		spr_hierro]
ore_recurso =	[0,				1,				3]
ore_amount =	[80,			60,				50]
//RSS
rss_item_sprite =	[spr_item_cobre,	spr_item_carbon,	spr_item_bronce,	spr_item_hierro,	spr_item_acero,	spr_item_arena,	spr_item_piedra,	spr_vidrio]
rss_name =			["Cobre",			"Carbon",			"Bronce",			"Hierro",			"Acero",		"Arena",		"Piedra",			"Vidrio"]
rss_item_color =	[c_orange,			c_black,			c_red,				c_gray,				c_ltgray,		c_yellow,		c_gray,				c_aqua]
rss_combustion =	[false,				true,				false,				false,				false,			false,			false,				false]
rss_comb_time =		[0,					150,				0,					0,					0,				0,				0,					0]
rss_max = array_length(rss_name)
//Liquidos
liquido_nombre =	["Agua"]
//EDIFICIOS
edificio_sprite =			[spr_base,	spr_taladro,	spr_camino,				spr_enrutador,	spr_selector,		spr_overflow,	spr_tunel,	spr_horno,				spr_generador,				spr_cable,	spr_bateria,	spr_taladro_electrico,	spr_panel_solar,	spr_bomba,			spr_tuberia,	spr_triturador,	spr_tunel_salida,	spr_energia_infinita]//Sprite
edificio_sprite_2 =			[spr_base,	spr_taladro,	spr_camino_diagonal,	spr_enrutador_2,spr_selector_color,	spr_overflow,	spr_tunel,	spr_horno_encendido,	spr_generador_encendido,	spr_cable,	spr_bateria,	spr_taladro_electrico,	spr_panel_solar,	spr_bomba_rotor,	spr_tuberia,	spr_triturador,	spr_tunel_salida,	spr_energia_infinita]//Sprite 2
edificio_nombre =			["Nucleo",	"Taladro",		"Cinta transportadora",	"Enrutador",	"Selector",			"Overflow",		"Tunel",	"Horno",				"Generador",				"Cable",	"Bateria",		"Taladro electrico",	"Panel solar",		"Bomba hidraulica",	"Tuberia",		"Triturador",	"Tunel",			"Energia infinita"]//Nombre
edificio_size =				[3,			2,				1,						1,				1,					1,				1,			2,						1,							1,			1,				3,						2,					2,					1,				2,				1,					1]//Size
edificio_receptor =			[true,		false,			true,					true,			true,				true,			true,		true,					true,						false,		false,			false,					false,				false,				false,			true,			false,				false]//Receptor
edificio_emisor =			[false,		true,			true,					true,			true,				true,			false,		true,					false,						false,		false,			true,					false,				false,				false,			true,			true,				false]//Emisor
edificio_carga_max =		[0,			10,				1,						1,				1,					1,				1,			30,						10,							0,			0,				20,						0,					0,					0,				10,				1,					0]//Carga max
edificio_input_all =		[true,		true,			true,					true,			true,				true,			true,		false,					false,						false,		false,			false,					false,				false,				false,			false,			true,				false]//Input: all
edificio_input_index =		[[0],		[0],			[0],					[0],			[0],				[0],			[0],		[0, 1, 3, 5],			[1],						[0],		[0],			[0],					[0],				[0],				[0],			[6],			[0],				[0]]//Input: index
edificio_input_num =		[[0],		[0],			[0],					[0],			[0],				[0],			[0],		[4, 2, 8, 16],			[10],						[0],		[0],			[0],					[0],				[0],				[0],			[5] ,			[0],				[0]]//Input: num
edificio_output_all =		[true,		false,			true,					true,			true,				true,			true,		false,					false,						false,		false,			true,					false,				false,				false,			false,			true,				false]//Output: all
edificio_output_index =		[[0],		[0, 1, 3],		[0],					[0],			[0],				[0],			[0],		[2, 4, 7],				[0],						[0],		[0],			[0, 1, 3, 5, 6],		[0],				[0],				[0],			[5],			[0],				[0]]//Output: index
edificio_rotable =			[false,		true,			true,					true,			true,				true,			true,		true,					false,						false,		false,			false,					true,				true,				false,			true,			true,				false]//Rotable
edificio_proceso =			[0,			100,			20,						20,				20,					20,				20,			150,					0,							0,			0,				40,						0,					1,					1,				40,				20,					0]//Steps proceso
edificio_combutable =		[false,		false,			false,					false,			false,				false,			false,		true,					true,						false,		false,			false,					false,				false,				false,			false,			false,				false]//Combustable
edificio_camino =			[false,		false,			true,					true,			true,				true,			false,		false,					false,						false,		false,			false,					false,				false,				false,			false,			false,				false]//Es camino?
edificio_electricidad =		[false,		false,			false,					false,			false,				false,			false,		false,					true,						true,		true,			true,					true,				true,				false,			true,			false,				true]//Se conecta a la red electrica?
edificio_elec_consumo =		[0,			0,				0,						0,				0,					0,				0,			0,						-20,						1,			0,				75,						-5,					25,					0,				30,				0,					-999999]//Consumo electrico (negativos para generadores)
edificio_precio_index =		[[0],		[0],			[0],					[0],			[0],				[0],			[0, 3],		[0, 3],					[0, 3],						[0, 3],		[0, 2],			[0, 2, 4],				[0, 2, 4],			[0, 4, 7],			[4],			[0, 4],			[0, 3],				[0]]//Edificio_precio: index
edificio_precio_num =		[[0],		[15],			[1],					[2],			[2],				[2],			[4, 4],		[20, 15],				[20, 5],					[5, 1],		[20, 5],		[20, 10, 25],			[40, 10, 10],		[10, 20, 10],		[3],			[10, 25],		[4, 4],				[0]]//Edificio_precio: num
edificio_key =				[0,			ord("Q"),		ord(1),					ord(2),			ord(3),				ord(4),			ord(5),		ord("W"),				ord("A"),					ord("S"),	ord("D"),		ord("E"),				ord("F"),			ord("Z"),			ord("X"),		ord("R"),		0,					ord("M")]//Acceso directo
edificio_flujo =			[false,		false,			false,					false,			false,				false,			false,		false,					false,						false,		false,			false,					false,				true,				true,			false,			false,				false]//Se conecta a cañerias?
edificio_flujo_input_id =	[[0],		[0],			[0],					[0],			[0],				[0],			[0],		[0],					[0],						[0],		[0],			[0],					[0],				[0],				[0],			[0],			[0],				[0]]//flujo_input_id
edificio_flujo_input_num =	[[0],		[0],			[0],					[0],			[0],				[0],			[0],		[0],					[0],						[0],		[0],			[0],					[0],				[0],				[0],			[0],			[0],				[0]]//flujo_input_num
edificio_flujo_output_id =	[[0],		[0],			[0],					[0],			[0],				[0],			[0],		[0],					[0],						[0],		[0],			[0],					[0],				[0],				[0],			[0],			[0],				[0]]//flujo_output_num
edificio_flujo_output_num =	[[0],		[0],			[0],					[0],			[0],				[0],			[0],		[0],					[0],						[0],		[0],			[0],					[0],				[0],				[20],			[0],			[0],				[0]]//flujo_output_num
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
			var aa = min(max(0, temp_complex.a), xsize - 1)
			var bb = min(max(0, temp_complex.b), ysize - 1)
			if terreno[aa, bb].terreno != 2
				terreno[aa, bb].terreno = c
		}
		repeat(2){
			var d = irandom(5)
			var temp_complex = next_to(a, b, d)
			a = min(max(0, temp_complex.a), xsize - 1)
			b = min(max(0, temp_complex.b), ysize - 1)
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
		a = min(max(0, temp_complex.a), xsize - 1)
		b = min(max(0, temp_complex.b), ysize - 1)
	}
}