function test(){
	var tries = 25, rep = 10000
	var abba = array_create(100, 3), a, b
	var t, best = infinity, abba2 = ds_grid_create(100, 100), ab3 = 100, abba3 = ds_grid_create(ab3, 1)
	ds_grid_clear(abba2, 10)
	for(a = 0; a < 100; a++)
		abba[a] = irandom(100)
	for(a = 0; a < 100; a++)
		abba3[# a, 0] = irandom(100)
	#region abba[a] = c
		repeat(tries){
			t = get_timer()
			repeat(rep)
				abba[3] = 10
			best = min(best, get_timer() - t)
		}
		show_debug_message(best)
	#endregion
	#region array_set()
		best = infinity
		repeat(tries){
			t = get_timer()
			repeat(rep)
				array_set(abba, 3, 10)
			best = min(best, get_timer() - t)
		}
		show_debug_message(best)
	#endregion
	#region c = abba[# a, b]
		best = infinity
		repeat(tries){
			t = get_timer()
			repeat(rep)
				a = abba2[# 3, 4]
			best = min(best, get_timer() - t)
		}
		show_debug_message(best)
	#endregion
	#region ds_grid_get()
		best = infinity
		repeat(tries){
			t = get_timer()
			repeat(rep)
				a = ds_grid_get(abba2, 3, 4)
			best = min(best, get_timer() - t)
		}
		show_debug_message(best)
	#endregion
	#region abba[# a, b] = c
		best = infinity
		repeat(tries){
			t = get_timer()
			repeat(rep)
				abba2[# 3, 4] = 7
			best = min(best, get_timer() - t)
		}
		show_debug_message(best)
	#endregion
	#region ds_grid_set()
		best = infinity
		repeat(tries){
			t = get_timer()
			repeat(rep)
				ds_grid_set(abba2, 3, 4, 19)
			best = min(best, get_timer() - t)
		}
		show_debug_message(best)
	#endregion
	#region min_array
		best = infinity
		repeat(tries){
			t = get_timer()
			repeat(rep)
				for(b = 0; b < ab3; b++)
					a = max(a, abba[b])
			best = min(best, get_timer() - t)
		}
		show_debug_message(best)
	#endregion
	#region min_grid
		best = infinity
		repeat(tries){
			t = get_timer()
			repeat(rep)
				a = ds_grid_get_max(abba3, 0, 0, ab3, 1)
			best = min(best, get_timer() - t)
		}
		show_debug_message(best)
	#endregion
	#region sum_array
		best = infinity
		repeat(tries){
			t = get_timer()
			repeat(rep)
				for(b = 0; b < ab3; b++)
					abba[b] += 10
			best = min(best, get_timer() - t)
		}
		show_debug_message(best)
	#endregion
	#region grid_sum
		best = infinity
		repeat(tries){
			t = get_timer()
			repeat(rep)
				ds_grid_add_region(abba3, 0, 0, ab3, 1, 10)
			best = min(best, get_timer() - t)
		}
		show_debug_message(best)
	#endregion
}