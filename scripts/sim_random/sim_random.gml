function sim_random(n, seed = 1){
    sim_seed[seed] = (int64(sim_seed[seed]) * 1103515245 + 12345) & 0x7FFFFFFF
    return (sim_seed[seed] / 0x7FFFFFFF) * n
}
function sim_irandom(n){
    return floor(sim_random(n))
}
function sim_random_range(n1, n2){
	return n1 + sim_random(n2 - n1)
}
function sim_irandom_range(n1, n2){
	return floor(sim_random_range(n1, n2))
}