function sim_random(n){
    sim_seed[1] = (sim_seed[1] * 1103515245 + 12345) & 0x7FFFFFFF
    return (sim_seed[1] / 0x7FFFFFFF) * n
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