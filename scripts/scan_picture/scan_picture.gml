function scan_picture(){
	draw_sprite(spr_china, 0, 0, 0)
	var c = c_black, f = 0
	ini_open("test.code")
	for(var a = 0; a < 60; a++){
		var e = 0
		for(var  b = 0; b < 50; b++){
			var d = draw_getpixel(a, b)
			if d != c or b = 49{
				var rr = color_get_red(c), gg = color_get_green(c), bb = color_get_blue(c)
				ini_write_real("Largo", f, 9)
				ini_write_real(f, 0, 9)
				ini_write_real(f, 1, 2)
				ini_write_real(f, 2, 1)
				ini_write_real(f, 3, 1)
				ini_write_real(f, 4, 1)
				ini_write_real(f, 5, rr)
				ini_write_real(f, 6, 1)
				ini_write_real(f, 7, gg)
				ini_write_real(f, 8, 1)
				ini_write_real(f++, 9, bb)
				ini_write_real("Largo", f, 9)
				ini_write_real(f, 0, 9)
				ini_write_real(f, 2, 1)
				ini_write_real(f, 3, 1)
				ini_write_real(f, 4, 1)
				ini_write_real(f, 5, a)
				ini_write_real(f, 6, 1)
				ini_write_real(f, 7, e)
				ini_write_real(f, 8, 1)
				ini_write_real(f, 9, a)
				ini_write_real(f, 10, 1)
				ini_write_real(f++, 11, b)
				c = d
				e = b
			}
		}
	}
	ini_write_real("Largo", "", --f)
	ini_close()
}