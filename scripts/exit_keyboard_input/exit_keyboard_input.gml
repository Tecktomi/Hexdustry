function exit_keyboard_input(){
	if keyboard_check_pressed(vk_enter) or keyboard_check_pressed(vk_escape) or mouse_check_button_pressed(mb_any){
		keyboard_clear(vk_escape)
		keyboard_clear(vk_enter)
		mouse_clear(mouse_lastbutton)
		control.get_keyboard_string = -1
		control.input_layer = 0
		control.editor_list = false
	}
}