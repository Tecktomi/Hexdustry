function scan_files_save(){
	with control{
		save_files = scan_files("Scenarios/*.txt", fa_none)
		var a, temp_text, temp_image
		for(a = array_length(save_files) - 1; a >= 0; a--){
			if a < array_length(save_files_png) and save_files_png[a] != spr_null_image
				sprite_delete(save_files_png[a])
			temp_text = "Scenarios/" + file_format(save_files[a])
			temp_image = (file_exists(temp_text + ".png") ? sprite_add(temp_text + ".png", 1, false, false, 0, 0): spr_null_image)
			save_files_png[a] = temp_image
		}
	}
}