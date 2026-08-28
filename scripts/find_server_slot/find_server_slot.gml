function find_server_slot(){
	with control{
		for(var i = 1; i < MAX_JUGADORES; i++)
		    if server_jugadores[i] = -1
		        return i
		return -1
	}
}