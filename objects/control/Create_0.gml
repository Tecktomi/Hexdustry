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
	energy_input : 0,
	energy_storage : 0,
	energy_link : ds_list_create()
}
null_edificio.link = null_edificio
ds_list_add(null_edificio.energy_link, null_edificio)
ds_list_clear(null_edificio.energy_link)
//Crear plantilla de fondo
for(var a = 0; a < xsize; a++)
	for(var b = 0; b < ysize; b++){
		var temp_complex = abtoxy(a, b)
		var temp_hexagono = instance_create_layer(temp_complex.a, temp_complex.b, "instances", obj_hexagono)
		terreno[a, b] = {
			hexagono : temp_hexagono,
			terreno : 0,
			ore : -1,
			ore_amount : 0,
			edificio_bool : false,
			edificio_draw : false,
			edificio : null_edificio
		}
		temp_hexagono.a = a
		temp_hexagono.b = b
	}
//Data
terreno_sprite =	[spr_piedra,	spr_pasto,	spr_agua,	spr_arena]
terreno_name =		["Piedra",		"Pasto",	"Agua",		"Arena"]
ore_sprite =	[spr_cobre,		spr_carbon,		spr_hierro]
ore_recurso =	[0,				1,				3]
ore_amount =	[80,			60,				50]
//RSS
rss_item_sprite =	[spr_item_cobre,	spr_item_carbon,	spr_item_bronce,	spr_item_hierro,	spr_item_acero]
rss_name =			["Cobre",			"Carbon",			"Bronce",			"Hierro",			"Acero"]
rss_item_color =	[c_orange,			c_black,			c_red,				c_gray,				c_ltgray]
rss_combustion =	[false,				true,				false,				false,				false]
rss_comb_time =		[0,					300,				0,					0,					0]
rss_max = array_length(rss_name)
//EDIFICIOS
edificio_sprite =		[spr_base,	spr_taladro,	spr_camino,				spr_enrutador,	spr_selector,		spr_overflow,	spr_tunel,	spr_horno,				spr_generador,				spr_cable,	spr_bateria,	spr_taladro_electrico,	spr_tunel_salida]//Sprite
edificio_sprite_2 =		[spr_base,	spr_taladro,	spr_camino,				spr_enrutador,	spr_selector_color,	spr_overflow,	spr_tunel,	spr_horno_encendido,	spr_generador_encendido,	spr_cable,	spr_bateria,	spr_taladro_electrico,	spr_tunel_salida]//Sprite 2
edificio_nombre =		["Nucleo",	"Taladro",		"Cinta transportadora",	"Enrutador",	"Selector",			"Overflow",		"Tunel",	"Horno",				"Generador",				"Cable",	"Bateria",		"Taladro electrico",	"Tunel"]//Nombre
edificio_size =			[3,			2,				1,						1,				1,					1,				1,			2,						1,							1,			1,				3,						1]//Size
edificio_receptor =		[true,		false,			true,					true,			true,				true,			true,		true,					true,						false,		false,			false,					false]//Receptor
edificio_emisor =		[false,		true,			true,					true,			true,				true,			false,		true,					false,						false,		false,			true,					true]//Emisor
edificio_carga_max =	[0,			10,				1,						1,				1,					1,				1,			10,						10,							0,			0,				20,						1]//Carga max
edificio_input_all =	[true,		true,			true,					true,			true,				true,			true,		false,					false,						false,		false,			false,					false]//Input: all
edificio_input_index =	[[0],		[0],			[0],					[0],			[0],				[0],			[0],		[0, 1, 3],				[1],						[0],		[0],			[0],					[0]]//Input: index
edificio_input_num =	[[0],		[0],			[0],					[0],			[0],				[0],			[0],		[2, 2, 2],				[10],						[0],		[0],			[0],					[0]]//Input: num
edificio_output_all =	[true,		false,			true,					true,			true,				true,			false,		false,					false,						false,		false,			true,					true]//Output: all
edificio_output_index = [[0],		[0, 1, 3],		[0],					[0],			[0],				[0],			[0],		[2, 4],					[0],						[0],		[0],			[0, 1, 3],				[0]]//Output: index
edificio_rotable =		[false,		true,			true,					true,			true,				true,			true,		true,					false,						false,		false,			false,					true]//Rotable
edificio_proceso =		[0,			100,			20,						20,				20,					20,				20,			150,					0,							0,			0,				60,						20]//Steps proceso
edificio_combutable =	[false,		false,			false,					false,			false,				false,			false,		true,					true,						false,		false,			false,					false]//Combustable
edificio_camino =		[false,		false,			true,					true,			true,				true,			false,		false,					false,						false,		false,			false,					false]//Es camino?
edificio_electricidad = [false,		false,			false,					false,			false,				false,			false,		false,					true,						true,		true,			true,					false]//Se conecta a la red electrica?
edificio_elec_consumo = [0,			0,				0,						0,				0,					0,				0,			0,						-60,						1,			0,				200,					0]//Consumo electrico (negativos para generadores)
edificio_max = array_length(edificio_nombre)
size_size = [1, 3, 7, 12, 19, 27]
size_borde = [6, 9, 12, 15, 18, 21]
carga_max = [0, 10, 3, 20, 100]
edificios_cable = ds_list_create()
edificios = ds_list_create()
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
build_index = 0
build_dir = 0
build_able = false
build_target = null_edificio
last_mx = -1
last_my = -1
build_list = get_size(0, 0, 0, 0)
//Pasto
repeat(4){
	var a = irandom(xsize - 1)
	var b = irandom(ysize - 1)
	var e = irandom_range(1, 2)
	repeat(20){
		if terreno[a, b] != 2
			terreno[a, b].terreno = e
		for(var d = 0; d < 6; d++){
			var temp_complex = next_to(a, b, d)
			var aa = min(max(0, temp_complex.a), xsize - 1)
			var bb = min(max(0, temp_complex.b), ysize - 1)
			if terreno[aa, bb] != 2
				terreno[aa, bb].terreno = e
		}
		repeat(2){
			var c = irandom(5)
			var temp_complex = next_to(a, b, c)
			a = min(max(0, temp_complex.a), xsize - 1)
			b = min(max(0, temp_complex.b), ysize - 1)
		}
	}
}
//Natural Ores
repeat(5){
	var a = irandom(xsize - 1)
	var b = irandom(ysize - 1)
	var c = irandom(2)
	repeat(15){
		var temp_terreno = terreno[a, b]
		if temp_terreno.terreno != 2{
			if temp_terreno.ore != c
				temp_terreno.ore_amount = 0
			temp_terreno.ore = c
			temp_terreno.ore_amount += floor(random_range(0.3, 1) * ore_amount[c])
		}
		for(var d = 0; d < 6; d++){
			var temp_complex = next_to(a, b, d)
			var aa = temp_complex.a
			var bb = temp_complex.b
			if aa > 0 and bb > 0 and aa < xsize - 1 and bb < ysize - 1{
				temp_terreno = terreno[aa, bb]
				if temp_terreno.terreno != 2{
					if temp_terreno.ore != c
						temp_terreno.ore_amount = 0
					temp_terreno.ore = c
					temp_terreno.ore_amount += irandom_range(20, 50)
				}
			}
		}
		var d = irandom(5)
		var temp_complex = next_to(a, b, d)
		a = min(max(0, temp_complex.a), xsize - 1)
		b = min(max(0, temp_complex.b), ysize - 1)
	}
}
var temp_edificio = add_edificio(0, 0, floor(xsize / 2), floor(ysize / 2))
for(var a = 0; a < ds_list_size(temp_edificio.coordenadas); a++){
	var temp_complex = temp_edificio.coordenadas[|a]
	terreno[temp_complex.a, temp_complex.b].terreno = 0
}