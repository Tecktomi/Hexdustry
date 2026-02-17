function deselect_drones(){
	with control{
		for(var a = array_length(selected_drones) - 1; a >= 0; a--)
			selected_drones[a].selected = false
		selected_drones = array_create(0, null_dron)
	}
}