function scan_files_save(){
	with control{
		save_files = scan_files(game_save_id + "*.txt", fa_none)
		for(var a = array_length(save_files) - 1; a >= 0; a--){
			if save_files_png[a] != spr_null_image
				sprite_delete(save_files_png[a])
			var temp_text = string_delete(save_files[a], string_pos(".", save_files[a]), 4)
			if file_exists(temp_text + ".png")
				var temp_image = sprite_add(temp_text + ".png", 1, false, false, 0, 0)
			else
				temp_image = spr_null_image
			save_files_png[a] = temp_image
		}
	}
}