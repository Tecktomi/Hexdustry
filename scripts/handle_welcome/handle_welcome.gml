function handle_welcome(buffer){
	with control{
		online = true
		seed = buffer_read(buffer, buffer_u32)
		biome_seed = buffer_read(buffer, buffer_u8)
		generar_bioma(biome_seed)
		game_start()
	}
}