function abtoxy(a, b){
	return ds_grid_get(control.pre_abtoxy, clamp(a + 1, 0, control.xsize + 1), clamp(b + 1, 0, control.ysize + 1))
}