function draw_path_find(){
	with control{
		var mina = floor(camx / zoom / 48), minb = floor(camy / zoom / 14), maxa = ceil((camx + room_width) / zoom / 48), maxb = ceil((camy + room_height) / zoom / 14)
		for(var a = mina; a < maxa; a++)
			for(var b = minb; b < maxb; b++){
				var temp_terreno = terreno[a, b]
				if not in(terreno_nombre[temp_terreno.terreno], "Agua", "Agua Profunda", "Petróleo", "Pared de Piedra"){
					var temp_complex = abtoxy(a, b), aa = temp_complex.a, bb = temp_complex.b, temp_edificio = edificio_cercano[# a, b]
					var aaa = temp_edificio.x, bbb = temp_edificio.y, dis = sqrt(sqr(aa - aaa) + sqr(bb - bbb)) / 10
					draw_arrow_off(aa, bb, aa + (aaa - aa) / dis, bb + (bbb - bb) / dis, 4)
				}
			}
	}
}