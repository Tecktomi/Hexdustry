function exit_keyboard_input(){
	with control{
		if keyboard_check_pressed(vk_enter) or keyboard_check_pressed(vk_escape) or mouse_check_button_pressed(mb_any){
			keyboard_clear(vk_escape)
			keyboard_clear(vk_enter)
			mouse_clear(mouse_lastbutton)
			get_keyboard_string = -1
			get_keyboard_cursor = 0
			input_layer = 0
			editor_list = false
		}
	}
}