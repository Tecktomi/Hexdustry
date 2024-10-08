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
	waiting : false,
	idle : false
}
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
terreno_sprite = [spr_hexagono, spr_pasto, spr_agua, spr_arena]
terreno_name = ["Piedra", "Pasto", "Agua", "Arena"]
ore_sprite = [spr_cobre, spr_carbon, spr_hierro]
ore_recurso = [0, 1, 3]
ore_item_sprite = [spr_item_cobre, spr_item_carbon, spr_item_bronce, spr_item_hierro, spr_item_acero]
ore_item_color = [c_orange, c_black, c_red, c_gray, c_ltgray]
ore_name = ["Cobre", "Carbon", "Bronce", "Hierro", "Acero"]
ore_max = array_length(ore_name)
edificio_sprite = [spr_base, spr_taladro, spr_camino, spr_enrutador, spr_selector, spr_horno, spr_invernadero, spr_silo]
edificio_sprite_2 = [spr_base, spr_taladro, spr_camino, spr_enrutador, spr_selector_color, spr_horno_encendido, spr_invernadero, spr_silo]
edificio_nombre = ["Nucleo", "Taladro", "Cinta transportadora", "Enrutador", "Selector", "Horno", "Invernadero", "Silo"]
edificio_size = [3, 2, 1, 1, 1, 2, 4, 5]
edificio_receptor = [true, false, true, true, true, true, false, true]
edificio_emisor = [false, true, true, true, true, true, true, false]
edificio_carga_max = [0, 10, 1, 1, 1, 10, 20, 100]
edificio_input_all = [true, true, true, true, true, false, true, true]
edificio_input_index = [[0], [0], [0], [0], [0], [0, 1, 3], [0], [0]]
edificio_input_num = [[0], [0], [0], [0], [0], [2, 2, 2], [0], [0]]
edificio_output_all = [true, true, true, true, true, false, true, true]
edificio_output_index = [[0], [0], [0], [0], [0], [2, 4], [0], [0]]
edificio_proceso = [0, 100, 20, 20, 20, 150, 120, 0]
edificio_combutable = [false, false, false, false, false, true, false, false]
edificio_combustion = [0, 0, 0, 0, 0, 360, 0, 0]
size_size = [1, 3, 7, 12, 19, 27]
size_borde = [6, 9, 12, 15, 18, 21]
carga_max = [0, 10, 3, 20, 100]
edificios = ds_list_create()
build_index = 0
build_dir = 0
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
		if terreno[a, b].terreno != 2{
			if terreno[a, b].ore != c
				terreno[a, b].ore_amount = 0
			terreno[a, b].ore = c
			terreno[a, b].ore_amount += irandom_range(20, 50)
			var d = irandom(5)
			var temp_complex = next_to(a, b, d)
			a = min(max(0, temp_complex.a), xsize - 1)
			b = min(max(0, temp_complex.b), ysize - 1)
		}
	}
}
var temp_edificio = add_edificio(0, 0, floor(xsize / 2), floor(ysize / 2))
for(var a = 0; a < ds_list_size(temp_edificio.coordenadas); a++){
	var temp_complex = temp_edificio.coordenadas[|a]
	terreno[temp_complex.a, temp_complex.b].terreno = 0
}