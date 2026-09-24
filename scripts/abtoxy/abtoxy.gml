function abtoxy(a, b){
	return ds_grid_get(control.pre_abtoxy, clamp(a + 1, 0, control.xsizeplus), clamp(b + 1, 0, control.ysizeplus))
}