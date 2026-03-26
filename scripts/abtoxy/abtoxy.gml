function abtoxy(a, b){
	var temp_complex = ds_grid_get(control.pre_abtoxy, clamp(a + 1, 0, xsize + 1), clamp(b + 1, 0, ysize + 1))
	return temp_complex
}