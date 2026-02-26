function set_idioma(){
	with control{
		//English
		if idioma = 0{
			//Recursos
			recurso_nombre[idr_acero] = "Steel"
			recurso_nombre[idr_arena] = "Sand"
			recurso_nombre[idr_bateria] = "Batery"
			recurso_nombre[idr_barril_con_agua] = "Barrel with Water"
			recurso_nombre[idr_barril_con_agua_salada] = "Barrel with Salt Water"
			recurso_nombre[idr_barril_con_lava] = "Barrel with Lava"
			recurso_nombre[idr_barril_con_petroleo] = "Barrel with Oil"
			recurso_nombre[idr_barril_con_acido] = "Barrel with Acid"
			recurso_nombre[idr_bronce] = "Bronze"
			recurso_nombre[idr_carbon] = "Coal"
			recurso_nombre[idr_cobre] = "Copper"
			recurso_nombre[idr_compuesto_incendiario] = "Incendiary Compound"
			recurso_nombre[idr_concreto] = "Concrete"
			recurso_nombre[idr_electronicos] = "Electronics"
			recurso_nombre[idr_explosivo] = "Explosive"
			recurso_nombre[idr_hierro] = "Iron"
			recurso_nombre[idr_modulos] = "Modules"
			recurso_nombre[idr_piedra] = "Stone"
			recurso_nombre[idr_piedra_cuprica] = "Cupric Stone"
			recurso_nombre[idr_piedra_ferrica] = "Ferric Stone"
			recurso_nombre[idr_piedra_sulfatada] = "Sulfated Stone"
			recurso_nombre[idr_plastico] = "Plastic"
			recurso_nombre[idr_sal] = "Salt"
			recurso_nombre[idr_silicio] = "Silicon"
			recurso_nombre[idr_uranio_bruto] = "Raw Uranium"
			recurso_nombre[idr_uranio_empobrecido] = "Depleted Uranium"
			recurso_nombre[idr_uranio_enriquecido] = "Enriched Uranium"
			//Categorias
			categoria_nombre[0] = "Transport"
			categoria_nombre[1] = "Extraction"
			categoria_nombre[2] = "Production"
			categoria_nombre[3] = "Electricity"
			categoria_nombre[4] = "Liquids"
			categoria_nombre[5] = "Defense"
			categoria_nombre[6] = "Logic"
			categoria_nombre[7] = "Drons"
			//Terrenos
			terreno_nombre[idt_agua] = "Water"
			terreno_nombre[idt_agua_profunda] = "Deep Water"
			terreno_nombre[idt_agua_salada] = "Salt Water"
			terreno_nombre[idt_agua_salada_profunda] = "Deep Salt Water"
			terreno_nombre[idt_arena] = "Sand"
			terreno_nombre[idt_basalto] = "Basalt"
			terreno_nombre[idt_basalto_sulfatado] = "Sulfated Basalt"
			terreno_nombre[idt_ceniza] = "Ash"
			terreno_nombre[idt_hielo] = "Ice"
			terreno_nombre[idt_lava] = "Lava"
			terreno_nombre[idt_nieve] = "Snow"
			terreno_nombre[idt_pared_de_arena] = "Sand Wall"
			terreno_nombre[idt_pared_de_nieve] = "Snow Wall"
			terreno_nombre[idt_pared_de_pasto] = "Grass Wall"
			terreno_nombre[idt_pared_de_piedra] = "Stone Wall"
			terreno_nombre[idt_pasto] = "Grass"
			terreno_nombre[idt_petroleo] = "Oil"
			terreno_nombre[idt_piedra] = "Stone"
			terreno_nombre[idt_piedra_cuprica] = "Cupric stone"
			terreno_nombre[idt_piedra_ferrica] = "Ferric stone"
			terreno_nombre[idt_salar] = "Salt flat"
			//
			edificio_nombre[id_almacen] = "Warehouse"
			dron_nombre[idd_arana] = "Spider"
			edificio_nombre[id_bateria] = "Battery"
			edificio_nombre[id_bomba_hidraulica] = "Hydraulic Pump"
			edificio_nombre[id_bomba_de_evaporacion] = "Evaporation Pump"
			dron_nombre[idd_bombardero] = "Bomber"
			edificio_nombre[id_cable] = "Cable"
			edificio_nombre[id_cinta_grande] = "Large Conveyor"
			edificio_nombre[id_cinta_magnetica] = "Magnetic Belt"
			edificio_nombre[id_cinta_transportadora] = "Conveyor Belt"
			edificio_nombre[id_cruce] = "Crossing"
			edificio_nombre[id_deposito] = "Storage"
			dron_nombre[idd_dron] = "Drone"
			edificio_nombre[id_embotelladora] = "Bottling Plant"
			edificio_nombre[id_energia_infinita] = "Infinite Energy"
			edificio_nombre[id_enrutador] = "Router"
			edificio_nombre[id_ensambladora] = "Assembler"
			dron_nombre[idd_explosivo] = "Explosive"
			edificio_nombre[id_extractor_atmosferico] = "Atmospheric Extractor"
			edificio_nombre[id_fabrica_de_concreto] = "Concrete Factory"
			edificio_nombre[id_fabrica_de_drones] = "Drone Factory"
			edificio_nombre[id_fabrica_de_drones_grande] = "Large Drone Factory"
			edificio_nombre[id_generador] = "Generator"
			edificio_nombre[id_generador_geotermico] = "Geothermal Generator"
			dron_nombre[idd_helicoptero] = "Helicopter"
			edificio_nombre[id_horno] = "Furnace"
			edificio_nombre[id_horno_de_lava] = "Lava Furnace"
			edificio_nombre[id_lanzallamas] = "Flamethrower"
			edificio_nombre[id_laser] = "Laser"
			edificio_nombre[id_liquido_infinito] = "Infinite Liquid"
			edificio_nombre[id_memoria] = "Memory"
			edificio_nombre[id_mensaje] = "Message"
			edificio_nombre[id_mortero] = "Mortar"
			edificio_nombre[id_muro] = "Wall"
			edificio_nombre[id_muro_reforzado] = "Reinforced Wall"
			edificio_nombre[id_modulo] = "Module"
			edificio_nombre[id_nucleo] = "Nucleus"
			edificio_nombre[id_onda_de_choque] = "Shockwave"
			edificio_nombre[id_overflow] = "Overflow"
			edificio_nombre[id_panel_solar] = "Solar Panel"
			edificio_nombre[id_pantalla] = "Display"
			edificio_nombre[id_perforadora_de_petroleo] = "Oil Driller"
			edificio_nombre[id_planta_desalinizadora] = "Desalination Plant"
			edificio_nombre[id_planta_nuclear] = "Nuclear Plant"
			edificio_nombre[id_planta_quimica] = "Chemical Plant"
			edificio_nombre[id_planta_de_enriquecimiento] = "Enrichment Plant"
			edificio_nombre[id_planta_de_reciclaje] = "Recycling Plant"
			edificio_nombre[id_procesador] = "Processor"
			edificio_nombre[id_puerto_de_carga] = "Charging Port"
			edificio_nombre[id_recurso_infinito] = "Infinite Resource"
			edificio_nombre[id_refineria_de_metales] = "Metal Refinery"
			edificio_nombre[id_refineria_de_petroleo] = "Oil Refinery"
			dron_nombre[idd_reparador] = "Repair Unit"
			edificio_nombre[id_rifle] = "Rifle"
			edificio_nombre[id_selector] = "Sorter"
			edificio_nombre[id_silo_de_misiles] = "Missile Silo"
			edificio_nombre[id_taladro] = "Drill"
			edificio_nombre[id_taladro_electrico] = "Electric Drill"
			edificio_nombre[id_taladro_de_explosion] = "Explosion Drill"
			dron_nombre[idd_tanque] = "Tank"
			dron_nombre[idd_titan] = "Titan"
			edificio_nombre[id_torre_reparadora] = "Repair Tower"
			edificio_nombre[id_torre_basica] = "Basic Tower"
			edificio_nombre[id_torre_de_alta_tension] = "High Voltage Tower"
			edificio_nombre[id_triturador] = "Crusher"
			edificio_nombre[id_tuberia] = "Pipe"
			edificio_nombre[id_tuberia_subterranea] = "Underground Pipe"
			edificio_nombre[id_turbina] = "Turbine"
			edificio_nombre[id_tunel] = "Tunnel"
			edificio_nombre[id_tunel_salida] = "Tunnel Exit"
			variable_struct_set(L, "activado", "Enabled")
			variable_struct_set(L, "activar", "Activate")
			variable_struct_set(L, "almacen_acepta", "Accepts")
			variable_struct_set(L, "almacen_acepta_todo", "Accepts all")
			variable_struct_set(L, "almacen_almacen", "Storage")
			variable_struct_set(L, "almacen_combustion", "Combustion")
			variable_struct_set(L, "almacen_consumiendo", "Consuming")
			variable_struct_set(L, "almacen_de_su_capacidad", "of its capacity")
			variable_struct_set(L, "almacen_entrega", "Delivers")
			variable_struct_set(L, "almacen_entrega_todo", "Delivers all")
			variable_struct_set(L, "almacen_funcionando_al", "Operating at")
			variable_struct_set(L, "almacen_proceso", "Process")
			variable_struct_set(L, "almacen_produciendo", "Producing")
			variable_struct_set(L, "almacen_recursos_disponibles", "Available resources")
			variable_struct_set(L, "almacen_sin_receta", "No Recipe")
			variable_struct_set(L, "almacen_sin_recursos", "No resources")
			variable_struct_set(L, "almacen_total", "Total")
			variable_struct_set(L, "cancelar", "Cancel")
			variable_struct_set(L, "construir_combinar_liquidos", "Cannot mix liquids")
			variable_struct_set(L, "construir_enemigos_cerca", "Enemies too close!")
			variable_struct_set(L, "construir_ocupado", "Occupied terrain")
			variable_struct_set(L, "construir_recursos_insuficientes", "Insufficient resources")
			variable_struct_set(L, "construir_sobre_agua", "Must be built over water")
			variable_struct_set(L, "construir_sobre_agua_lava", "Must be built over water, oil, or lava")
			variable_struct_set(L, "construir_sobre_lava", "Must be built over lava")
			variable_struct_set(L, "construir_sobre_minerales", "Must be built over minerals")
			variable_struct_set(L, "construir_sobre_minerales_piedra", "Must be built over minerals, stone, or sand")
			variable_struct_set(L, "construir_sobre_salar", "Cannot be built on a salt flat")
			variable_struct_set(L, "construir_terreno_hielo", "Terrain is too unstable")
			variable_struct_set(L, "construir_terreno_invalido", "Invalid terrain")
			variable_struct_set(L, "construir_zona_enemigos", "Enemy spawn zone")
			variable_struct_set(L, "cuevas", "Caves")
			variable_struct_set(L, "desactivado", "Disabled")
			variable_struct_set(L, "desactivar", "Deactivate")
			recurso_descripcion[idr_acero] = "Useful resource for constructing mid-tier infrastructure"
			edificio_descripcion[id_almacen] = "Stores resources for later use"
			dron_descripcion[idd_arana] = "Fires a laser at nearby enemies"
			recurso_descripcion[idr_arena] = "Resource required for producing refined goods such as Silicon or Concrete"
			recurso_descripcion[idr_barril_con_agua] = "Barrel with Water, useful for storing and distributing water"
			recurso_descripcion[idr_barril_con_agua_salada] = "Barrel with Salt Water, useful for storing and distributing it"
			recurso_descripcion[idr_barril_con_lava] = "Barrel with Lava, useful for storing and distributing it"
			recurso_descripcion[idr_barril_con_petroleo] = "Barrel with Oil, useful for storing and distributing it"
			recurso_descripcion[idr_barril_con_acido] = "Barrel with Acid, useful for storing and distributing it"
			edificio_descripcion[id_bateria] = "Resource required for producing all types of Drones"
			edificio_descripcion[id_bomba_hidraulica] = "Extracts liquids from the ground using energy."
			edificio_descripcion[id_bomba_de_evaporacion] = "Slowly extracts Water through evaporation."
			dron_descripcion[idd_bombardero] = "Flies over its enemies, dropping devastating explosives in a straight line"
			recurso_descripcion[idr_bronce] = "Useful resource for constructing mid-tier infrastructure"
			edificio_descripcion[id_cable] = "Connects nearby buildings to the power grid."
			recurso_descripcion[idr_carbon] = "Basic fuel, useful for operating Furnaces and Generators"
			edificio_descripcion[id_cinta_grande] = "Transports drones between factories"
			edificio_descripcion[id_cinta_magnetica] = "Improved version of the Conveyor Belt that transports more items."
			edificio_descripcion[id_cinta_transportadora] = "Moves resources from one place to another."
			recurso_descripcion[idr_cobre] = "Basic resource, essential for early buildings. Can be refined to obtain Bronze"
			recurso_descripcion[idr_compuesto_incendiario] = "Advanced fuel, more efficient and durable than Coal"
			recurso_descripcion[idr_concreto] = "Resource used for building mid-tier infrastructure"
			edificio_descripcion[id_cruce] = "Allows conveyor belt connections to cross"
			edificio_descripcion[id_deposito] = "Stores large amounts of liquid."
			dron_descripcion[idd_dron] = "Transports resources between Cargo Ports"
			edificio_descripcion[id_embotelladora] = "Fills and empties barrels with liquids"
			edificio_descripcion[id_energia_infinita] = "Generates energy using magic."
			edificio_descripcion[id_enrutador] = "Distributes resources in a chosen direction."
			edificio_descripcion[id_ensambladora] = "Uses Copper and Silicon to produce components."
			recurso_descripcion[idr_explosivo] = "Approaches its target and explodes, dealing damage"
			edificio_descripcion[id_extractor_atmosferico] = "Extracts water from the atmosphere, ideal for terrains where it is difficult to obtain"
			edificio_descripcion[id_fabrica_de_concreto] = "Produces concrete from Sand, Stone, and Water"
			edificio_descripcion[id_fabrica_de_drones] = "Produces transport drones using Silicon, Batteries, and a large amount of energy."
			edificio_descripcion[id_fabrica_de_drones_grande] = "Allows the production of larger drones using Acid"
			edificio_descripcion[id_generador] = "Generates energy using fuel."
			edificio_descripcion[id_generador_geotermico] = "Generates energy by evaporating Water; must be built on lava."
			recurso_descripcion[idr_hierro] = "Basic resource, essential for early buildings"
			edificio_descripcion[id_horno] = "Uses fuel to smelt Bronze, Steel, and Silicon."
			edificio_descripcion[id_horno_de_lava] = "Similar to a normal furnace but uses the heat of lava to smelt faster."
			edificio_descripcion[id_lanzallamas] = "Uses combustible resources to burn enemies. Can be boosted with Oil."
			edificio_descripcion[id_laser] = "Fires a constant laser whose damage depends on available energy."
			edificio_descripcion[id_liquido_infinito] = "Generates any liquid of choice using magic."
			edificio_descripcion[id_memoria] = "Stores up to 128 data values."
			edificio_descripcion[id_mensaje] = "Allows writing messages."
			edificio_descripcion[id_mortero] = "Fires long-range explosives, devastating groups of enemies."
			edificio_descripcion[id_muro] = "Distracts enemies while your defenses deal with them."
			edificio_descripcion[id_muro_reforzado] = "An improved version of the wall, harder and better"
			edificio_descripcion[id_modulo] = "Improves the characteristics of a building"
			recurso_descripcion[idr_modulos] = "Research Modules and build two Assemblers next to each other to start producing them"
			edificio_descripcion[id_nucleo] = "It is the command center. All resources are stored here, and you must protect it at all costs."
			edificio_descripcion[id_onda_de_choque] = "Charges and releases a powerful shockwave that damages and slows all enemies within its range."
			edificio_descripcion[id_overflow] = "Diverts resources once the line becomes saturated."
			edificio_descripcion[id_panel_solar] = "Generates clean energy from sunlight."
			edificio_descripcion[id_pantalla] = "Allows drawing images sent from a processor"
			edificio_descripcion[id_perforadora_de_petroleo] = "Produces oil at high cost anywhere on the map."
			recurso_descripcion[idr_piedra] = "Resource required for producing Concrete. Can be transformed into Sand in a Crusher"
			recurso_descripcion[idr_piedra_cuprica] = "Can be used as normal Stone or purified to obtain Copper"
			recurso_descripcion[idr_piedra_ferrica] = "Can be used as normal Stone or purified to obtain Iron"
			recurso_descripcion[idr_piedra_sulfatada] = "Can be used as normal Stone, but is essential for producing more refined goods"
			edificio_descripcion[id_planta_desalinizadora] = "Purifies salt water to extract Salt and fresh Water"
			edificio_descripcion[id_planta_nuclear] = "Consumes 1 part Enriched Uranium and 20 parts Depleted Uranium along with large amounts of Water to generate massive energy."
			edificio_descripcion[id_planta_quimica] = "Allows selecting a recipe to produce chemical compounds."
			edificio_descripcion[id_planta_de_enriquecimiento] = "Allows recycling uranium by consuming large amounts of water and energy continuously"
			edificio_descripcion[id_planta_de_reciclaje] = "Allows recycling part of the resources from nearby destroyed enemies"
			recurso_descripcion[idr_plastico] = "Lightweight material, useful for Drone production"
			edificio_descripcion[id_procesador] = "Processes logical instructions."
			edificio_descripcion[id_puerto_de_carga] = "Connects Cargo Ports so your drones can move resources between them."
			edificio_descripcion[id_recurso_infinito] = "Generates resources using magic."
			edificio_descripcion[id_refineria_de_metales] = "Refines Copper Stone or Iron Stone into Copper or Iron using Acid."
			edificio_descripcion[id_refineria_de_petroleo] = "Uses fractional distillation to extract Plastic, Fuel, and Sulfur from Oil"
			dron_descripcion[idd_reparador] = "Repairs damaged buildings"
			edificio_descripcion[id_rifle] = "Long-range defense turret that fires Bronze, Steel, or Uranium."
			recurso_descripcion[idr_sal] = "Useful resource for improving other industrial processes such as the chemical plant, oil refinery, and silicon production"
			edificio_descripcion[id_selector] = "Allows only one specific resource to pass while diverting the rest."
			recurso_descripcion[idr_silicio] = "Resource useful for producing Solar Panels, Drones, and Circuits"
			edificio_descripcion[id_silo_de_misiles] = "Here you can build a nuclear missile using steel, explosives, oil, and enriched uranium."
			edificio_descripcion[id_taladro] = "Mines copper, iron, and coal at no cost. Can be boosted with Water."
			edificio_descripcion[id_taladro_electrico] = "Improved drill that also extracts stone and sand from the ground but consumes energy. Can be boosted with Water"
			edificio_descripcion[id_taladro_de_explosion] = "Uses explosives to extract one resource from every minable tile in its area."
			dron_descripcion[idd_tanque] = "Heavy siege unit that fires explosives, damaging everything around it"
			dron_descripcion[idd_titan] = "Ultimate ground unit that fires a long-range explosive barrage"
			edificio_descripcion[id_torre_reparadora] = "Projects a repair laser onto nearby buildings using energy."
			edificio_descripcion[id_torre_basica] = "Simple defense turret; can shoot Copper or Iron."
			edificio_descripcion[id_torre_de_alta_tension] = "Connects power grids across long distances."
			edificio_descripcion[id_triturador] = "Crushes stone into sand."
			edificio_descripcion[id_tuberia] = "Connects structures to transport liquids."
			edificio_descripcion[id_tuberia_subterranea] = "Connects liquid pipelines underground."
			edificio_descripcion[id_turbina] = "Generates energy using a fuel and Water."
			edificio_descripcion[id_tunel] = "Sends resources underground so other structures can be built above."
			edificio_descripcion[id_tunel_salida] = "Sends resources underground so other structures can be built above."
			recurso_descripcion[idr_uranio_bruto] = "Unrefined uranium, useful as ammunition. Can be refined to separate Depleted Uranium from Enriched Uranium"
			recurso_descripcion[idr_uranio_empobrecido] = "Uranium-238, required to support energy production in Nuclear Plants and useful as ammunition"
			recurso_descripcion[idr_uranio_enriquecido] = "Uranium-235, useful for power generation in Nuclear Plants"
			variable_struct_set(L, "desierto", "Desert")
			variable_struct_set(L, "dificil", "Hard")
			variable_struct_set(L, "dificultad", "Difficulty")
			variable_struct_set(L, "editor_Reemplazar", "Replace")
			variable_struct_set(L, "editor_activar_oleadas", "Activate waves")
			variable_struct_set(L, "editor_add", "Add")
			variable_struct_set(L, "editor_add_text", "Add text")
			variable_struct_set(L, "editor_al_rededor", "Around")
			variable_struct_set(L, "editor_borde", "Borders")
			variable_struct_set(L, "editor_cambiar_base", "Change base position")
			variable_struct_set(L, "editor_cambiar_oleadas", "Enable / Disable waves")
			variable_struct_set(L, "editor_cambiar_zona", "Change enemy spawn zone")
			variable_struct_set(L, "editor_carga_inicial", "Initial load")
			variable_struct_set(L, "editor_cargar", "Load map")
			variable_struct_set(L, "editor_clic", "Left click to")
			variable_struct_set(L, "editor_clic_aplicar", "Click to apply")
			variable_struct_set(L, "editor_con", "with")
			variable_struct_set(L, "editor_configuracion", "Configuration")
			variable_struct_set(L, "editor_cualquiera", "any")
			variable_struct_set(L, "editor_de", "of")
			variable_struct_set(L, "editor_del_tiempo", "of the time")
			variable_struct_set(L, "editor_desactivar_oleadas", "Deactivate waves")
			variable_struct_set(L, "editor_deshabilitar", "Disable timer")
			variable_struct_set(L, "editor_edificios_disponibles", "Buildings availables")
			variable_struct_set(L, "editor_editar_mapa", "Edit map")
			variable_struct_set(L, "editor_el", "the")
			variable_struct_set(L, "editor_eliminar_mena", "Delete resource vein")
			variable_struct_set(L, "editor_eliminar_objetivo", "Delete objective")
			variable_struct_set(L, "editor_enemigos", "enemies")
			variable_struct_set(L, "editor_generar_terreno", "Generate terrain")
			variable_struct_set(L, "editor_guardar", "Save map")
			variable_struct_set(L, "editor_habilitar", "Enable timer")
			variable_struct_set(L, "editor_info", "View information")
			variable_struct_set(L, "editor_luego_de", "after")
			variable_struct_set(L, "editor_manchas", "Terrain patches")
			variable_struct_set(L, "editor_menas", "Resource veins")
			variable_struct_set(L, "editor_mostrar", "show")
			variable_struct_set(L, "editor_mover_a", "Move to")
			variable_struct_set(L, "editor_mover_camara", "Move camera")
			variable_struct_set(L, "editor_multiplicador_vida", "Enemy health multiplier")
			variable_struct_set(L, "editor_no", "No")
			variable_struct_set(L, "editor_nuevo_objetivo", "Objective name")
			variable_struct_set(L, "editor_objetivo", "Objective")
			variable_struct_set(L, "editor_objetivos", "Objectives")
			variable_struct_set(L, "editor_ocultar", "hide")
			variable_struct_set(L, "editor_on", "on")
			variable_struct_set(L, "editor_primera_ronda", "First wave time")
			variable_struct_set(L, "editor_reemplazar", "replace")
			variable_struct_set(L, "editor_ruido", "Noise")
			variable_struct_set(L, "editor_seed", "Seed")
			variable_struct_set(L, "editor_siguiente_ronda", "Time between waves")
			variable_struct_set(L, "editor_size", "of size")
			variable_struct_set(L, "editor_size_map", "Map size")
			variable_struct_set(L, "editor_terreno_base", "Base terrain")
			variable_struct_set(L, "editor_texto_victoria", "Victory text")
			variable_struct_set(L, "editor_veces", "times")
			variable_struct_set(L, "enciclopedia_aerea", "Air unit")
			variable_struct_set(L, "enciclopedia_combustible", "Combustable for")
			variable_struct_set(L, "enciclopedia_construir", "Build")
			variable_struct_set(L, "enciclopedia_consume", "Consumes")
			variable_struct_set(L, "enciclopedia_coste_construccion", "Construction cost")
			variable_struct_set(L, "enciclopedia_edificios", "Buildings")
			variable_struct_set(L, "enciclopedia_inutil", "Not useful in the core")
			variable_struct_set(L, "enciclopedia_investigar", "Investigate")
			variable_struct_set(L, "enciclopedia_necesario_para_construir", "Required to build")
			variable_struct_set(L, "enciclopedia_necesario_para_producir", "Required to produce")
			variable_struct_set(L, "enciclopedia_produce", "Produces")
			variable_struct_set(L, "enciclopedia_producido_en", "Produced in")
			variable_struct_set(L, "enciclopedia_recursos", "Resources")
			variable_struct_set(L, "enciclopedia_size", "Size")
			variable_struct_set(L, "enciclopedia_tecnologia", "Technology")
			variable_struct_set(L, "enciclopedia_unidades", "Units")
			variable_struct_set(L, "enciclopedia_usado_en", "Used in")
			variable_struct_set(L, "enciclopedia_vida", "Max health")
			variable_struct_set(L, "energia_consumida", "Energy consumed")
			variable_struct_set(L, "energia_perdida", "Energy lost")
			variable_struct_set(L, "energia_producida", "Energy produced")
			variable_struct_set(L, "facil", "Easy")
			variable_struct_set(L, "flujo_almacenado", "Stored")
			variable_struct_set(L, "flujo_consumo", "Consumption")
			variable_struct_set(L, "flujo_flujo", "Pipeline")
			variable_struct_set(L, "flujo_generacion", "Generation")
			variable_struct_set(L, "flujo_liquido", "líquid")
			variable_struct_set(L, "flujo_sin_liquido", "No liquids")
			variable_struct_set(L, "game_activar", "Activate")
			variable_struct_set(L, "game_creando_dron", "Creating")
			variable_struct_set(L, "game_enciclopedia", "Encyclopedia")
			variable_struct_set(L, "game_first_wave", "for the first wave")
			variable_struct_set(L, "game_limite_dron", "Drone limit reached")
			variable_struct_set(L, "game_next_wave", "for the next wave")
			variable_struct_set(L, "game_producira", "Will produce")
			variable_struct_set(L, "game_puerto_carga", "Connects to another Cargo Port")
			variable_struct_set(L, "game_vincular_procesador", "Links with any building")
			variable_struct_set(L, "islas", "Islands")
			variable_struct_set(L, "liquido_Agua", "Water")
			variable_struct_set(L, "liquido_Agua salada", "Salt Water")
			variable_struct_set(L, "liquido_Lava", "Lava")
			variable_struct_set(L, "liquido_Petróleo", "Oil")
			variable_struct_set(L, "liquido_Ácido", "Acid")
			variable_struct_set(L, "marcar_objetivo", "Set objetive")
			variable_struct_set(L, "medio", "Medium")
			variable_struct_set(L, "menu_cargar_escenario", "Load Map")
			variable_struct_set(L, "menu_claves", "Sandbox")
			variable_struct_set(L, "menu_editor", "Editor")
			variable_struct_set(L, "menu_hexdustry", "HEXDUSTRY")
			variable_struct_set(L, "menu_html", "Reduced performance in HTML5")
			variable_struct_set(L, "menu_juego_rapido", "Quick Game")
			variable_struct_set(L, "menu_modo_infinito", "Infinite mode")
			variable_struct_set(L, "menu_modo_misiones", "Mission mode")
			variable_struct_set(L, "menu_modo_oleadas", "Wave mode")
			variable_struct_set(L, "menu_numero_oleadas", "Number of waves")
			variable_struct_set(L, "menu_precio_tecnologia", "Technology Price")
			variable_struct_set(L, "menu_sin_archivos", "No scenarios yet")
			variable_struct_set(L, "menu_tutorial", "Tutorial")
			variable_struct_set(L, "mision_enemigos", "enemies")
			variable_struct_set(L, "mision_tiempo", "Time remaining")
			variable_struct_set(L, "modulo_aturdir", "33% longer stun duration")
			variable_struct_set(L, "modulo_cadencia", "30% higher fire rate")
			variable_struct_set(L, "modulo_canalizar", "Channels 50% faster")
			variable_struct_set(L, "modulo_dmg", "30% more damage")
			variable_struct_set(L, "modulo_edificio_con_modulo", "This building already has a module")
			variable_struct_set(L, "modulo_edificio_sin_modulo", "This building does not accept modules")
			variable_struct_set(L, "modulo_extraccion", "40% faster extraction speed")
			variable_struct_set(L, "modulo_mas_liquido", "Produces 20% more")
			variable_struct_set(L, "modulo_menos_electricidad", "25% less power consumption")
			variable_struct_set(L, "modulo_menos_liquido", "25% less consumption of")
			variable_struct_set(L, "modulo_nuclear", "Automatically shuts down the plant if it runs out of water")
			variable_struct_set(L, "modulo_nucleo", "Increases the maximum number of allied drones by 2")
			variable_struct_set(L, "modulo_produccion", "Produces 30% faster")
			variable_struct_set(L, "modulo_reparadora", "Repairs 20% faster")
			variable_struct_set(L, "modulo_sal", "Extracts 50% more")
			variable_struct_set(L, "modulo_sin_edificio", "Requires a building")
			variable_struct_set(L, "nieve", "Snow")
			variable_struct_set(L, "nuevo_archivo", "New file")
			objetivos_nombre[0] = "obtain"
			objetivos_nombre[1] = "have stored"
			objetivos_nombre[2] = "build"
			objetivos_nombre[3] = "have built"
			objetivos_nombre[4] = "survive waves"
			objetivos_nombre[5] = "no objective"
			objetivos_nombre[6] = "press ADWS"
			objetivos_nombre[7] = "load building"
			objetivos_nombre[8] = "destroy building"
			variable_struct_set(L, "pausa", "P A U S E")
			variable_struct_set(L, "pausa_UI", "UI")
			variable_struct_set(L, "pausa_activar", "Enable")
			variable_struct_set(L, "pausa_animacion", "terrain animations")
			variable_struct_set(L, "pausa_continuar", "Press Esc to continue")
			variable_struct_set(L, "pausa_desactivar", "Disable")
			variable_struct_set(L, "pausa_enciclopedia", "\"Y\" to open the encyclopedia")
			variable_struct_set(L, "pausa_humo", "smoke")
			variable_struct_set(L, "pausa_iluminacion", "lighting")
			variable_struct_set(L, "pausa_info", "additional information")
			variable_struct_set(L, "pausa_liquido", "\"I\" to view the liquid networks")
			variable_struct_set(L, "pausa_paredes", "wall textures")
			variable_struct_set(L, "pausa_red", "\"O\" to view the power grid")
			variable_struct_set(L, "pausa_reparar", "\"Q\" rebuild structures")
			variable_struct_set(L, "pausa_sonido", "sound")
			variable_struct_set(L, "personalizado", "Custom")
			planta_quimica_descripcion[0] = "Consumes Sulfated Stone and energy to produce Acid"
			planta_quimica_descripcion[1] = "Uses Incendiary Compound and Acid to produce Explosives"
			planta_quimica_descripcion[2] = "Uses Acid, Copper, and energy to produce Batteries"
			planta_quimica_receta[0] = "Acid"
			planta_quimica_receta[1] = "Explosives"
			planta_quimica_receta[2] = "Batteries"
			variable_struct_set(L, "praderas", "Grasslands")
			variable_struct_set(L, "procesador_cargar", "Load code")
			variable_struct_set(L, "procesador_guardar", "Save code")
			variable_struct_set(L, "procesador_next_step", "Next instruction")
			variable_struct_set(L, "procesador_add", "Add")
			variable_struct_set(L, "procesador_subir", "Move up")
			variable_struct_set(L, "procesador_clonar", "Clone")
			variable_struct_set(L, "procesador_borrar", "Delete")
			variable_struct_set(L, "procesador_vincular", "Link buildings")
			variable_struct_set(L, "procesador_continue", "Continue")
			variable_struct_set(L, "procesador_set", "Set")
			variable_struct_set(L, "procesador_random", "Randomize")
			variable_struct_set(L, "procesador_to", "to")
			variable_struct_set(L, "procesador_if", "If")
			variable_struct_set(L, "procesador_is", "is")
			variable_struct_set(L, "procesador_is_not", "is not")
			variable_struct_set(L, "procesador_jump", "jump to line")
			variable_struct_set(L, "procesador_control", "Control")
			variable_struct_set(L, "procesador_to_set", "to set")
			variable_struct_set(L, "procesador_from", "from")
			variable_struct_set(L, "procesador_write", "Write")
			variable_struct_set(L, "procesador_to_value_of_cell", "to the value in the cell")
			variable_struct_set(L, "procesador_into_value_of_cell", "into the value in the cell")
			variable_struct_set(L, "procesador_of", "of")
			procesador_instrucciones_nombre[0] = "Continue"
			procesador_instrucciones_nombre[1] = "Assign variable"
			procesador_instrucciones_nombre[2] = "Single-variable operations"
			procesador_instrucciones_nombre[3] = "Two-variable operations"
			procesador_instrucciones_nombre[4] = "Jump to line"
			procesador_instrucciones_nombre[5] = "Read building information"
			procesador_instrucciones_nombre[6] = "Control building"
			procesador_instrucciones_nombre[7] = "Read memory data"
			procesador_instrucciones_nombre[8] = "Write memory data"
			procesador_instrucciones_nombre[9] = "Draw to screen"
			variable_struct_set(L, "recursos_obtenidos", "Resources obtained")
			variable_struct_set(L, "red_bateria", "Battery")
			variable_struct_set(L, "red_consumo", "Consumption")
			variable_struct_set(L, "red_energia", "energy")
			variable_struct_set(L, "red_generacion", "Generation")
			variable_struct_set(L, "red_red", "Grid")
			variable_struct_set(L, "salir", "Exit")
			variable_struct_set(L, "show_menu_invertir", "Invert")
			variable_struct_set(L, "show_menu_ningun_liquido", "No liquid")
			variable_struct_set(L, "show_menu_no_disponible", "Not available yet")
			variable_struct_set(L, "show_menu_receta", "Recipe")
			variable_struct_set(L, "show_menu_unidad", "Unit")
			variable_struct_set(L, "tiempo", "Time")
			variable_struct_set(L, "volver", "Back")
			variable_struct_set(L, "win_derrota", "Defeat")
			variable_struct_set(L, "win_dmg_causado", "Damage dealt")
			variable_struct_set(L, "win_dmg_curado", "Damage healed")
			variable_struct_set(L, "win_dmg_recibido", "Damage taken")
			variable_struct_set(L, "win_drones", "Drones built")
			variable_struct_set(L, "win_drones_perdidos", "Drones lost")
			variable_struct_set(L, "win_edificios", "Buildings constructed")
			variable_struct_set(L, "win_edificios_destruidos", "Buildings destroyed")
			variable_struct_set(L, "win_edificios_perdidos", "Buildings lost")
			variable_struct_set(L, "win_enemigos", "Enemies eliminated")
			variable_struct_set(L, "win_militar", "Military")
			variable_struct_set(L, "win_misiones", "Objectives completed")
			variable_struct_set(L, "win_reintentar", "Retry")
			variable_struct_set(L, "win_salir", "Return to menu")
			variable_struct_set(L, "win_seguir_jugando", "Continue playing?")
			variable_struct_set(L, "win_siguiente_mision", "Next mission")
			variable_struct_set(L, "win_tecnologias", "Technologies researched")
			variable_struct_set(L, "win_tiempo", "Time")
			variable_struct_set(L, "win_victoria", "Victory")
			variable_struct_set(L, "editar_desde_adentro", "Edit from inside")
		}
		//Español
		else if idioma = 1{
			terreno_nombre[idt_arena] = "Arena"
			terreno_nombre[idt_piedra] = "Piedra"
			terreno_nombre[idt_piedra_cuprica] = "Piedra Cúprica"
			terreno_nombre[idt_piedra_ferrica] = "Piedra Férrica"
			terreno_nombre[idt_salar] = "Salar"
			
			recurso_nombre[idr_acero] = "Acero"
			terreno_nombre[idt_agua] = "Agua"
			recurso_nombre[idr_bateria] = "Batería"
			terreno_nombre[idt_agua_profunda] = "Agua Profunda"
			terreno_nombre[idt_agua_salada] = "Agua Salada"
			terreno_nombre[idt_agua_salada_profunda] = "Agua Salada Profunda"
			edificio_nombre[id_almacen] = "Almacén"
			dron_nombre[idd_arana] = "Araña"
			recurso_nombre[idr_arena] = "Arena"
			recurso_nombre[idr_barril_con_agua] = "Barril con Agua"
			recurso_nombre[idr_barril_con_agua_salada] = "Barril con Agua salada"
			recurso_nombre[idr_barril_con_lava] = "Barril con Lava"
			recurso_nombre[idr_barril_con_petroleo] = "Barril con Petróleo"
			recurso_nombre[idr_barril_con_acido] = "Barril con Ácido"
			terreno_nombre[idt_basalto] = "Basalto"
			terreno_nombre[idt_basalto_sulfatado] = "Basalto Sulfatado"
			edificio_nombre[id_bateria] = "Batería"
			edificio_nombre[id_bomba_hidraulica] = "Bomba Hidráulica"
			edificio_nombre[id_bomba_de_evaporacion] = "Bomba de Evaporación"
			dron_nombre[idd_bombardero] = "Bombardero"
			recurso_nombre[idr_bronce] = "Bronce"
			edificio_nombre[id_cable] = "Cable"
			recurso_nombre[idr_carbon] = "Carbón"
			terreno_nombre[idt_ceniza] = "Ceniza"
			edificio_nombre[id_cinta_grande] = "Cinta Grande"
			edificio_nombre[id_cinta_magnetica] = "Cinta Magnética"
			edificio_nombre[id_cinta_transportadora] = "Cinta Transportadora"
			recurso_nombre[idr_cobre] = "Cobre"
			recurso_nombre[idr_compuesto_incendiario] = "Compuesto Incendiario"
			recurso_nombre[idr_concreto] = "Concreto"
			edificio_nombre[id_cruce] = "Cruce"
			categoria_nombre[5] = "Defensa"
			edificio_nombre[id_deposito] = "Depósito"
			dron_nombre[idd_dron] = "Dron"
			categoria_nombre[7] = "Drones"
			categoria_nombre[3] = "Electricidad"
			recurso_nombre[idr_electronicos] = "Electrónicos"
			edificio_nombre[id_embotelladora] = "Embotelladora"
			edificio_nombre[id_energia_infinita] = "Energía Infinita"
			edificio_nombre[id_enrutador] = "Enrutador"
			edificio_nombre[id_ensambladora] = "Ensambladora"
			recurso_nombre[idr_explosivo] = "Explosivo"
			dron_nombre[idd_explosivo] = "Explosivo"
			categoria_nombre[1] = "Extracción"
			edificio_nombre[id_extractor_atmosferico] = "Extractor Atmosférico"
			edificio_nombre[id_fabrica_de_concreto] = "Fábrica de Concreto"
			edificio_nombre[id_fabrica_de_drones] = "Fábrica de Drones"
			edificio_nombre[id_fabrica_de_drones_grande] = "Fábrica de Drones Grande"
			edificio_nombre[id_generador] = "Generador"
			edificio_nombre[id_generador_geotermico] = "Generador Geotérmico"
			dron_nombre[idd_helicoptero] = "Helicóptero"
			terreno_nombre[idt_hielo] = "Hielo"
			recurso_nombre[idr_hierro] = "Hierro"
			edificio_nombre[id_horno] = "Horno"
			edificio_nombre[id_horno_de_lava] = "Horno de Lava"
			edificio_nombre[id_lanzallamas] = "Lanzallamas"
			terreno_nombre[idt_lava] = "Lava"
			edificio_nombre[id_laser] = "Láser"
			edificio_nombre[id_liquido_infinito] = "Líquido Infinito"
			categoria_nombre[4] = "Líquidos"
			categoria_nombre[6] = "Lógica"
			edificio_nombre[id_memoria] = "Memoria"
			edificio_nombre[id_mensaje] = "Mensaje"
			edificio_nombre[id_mortero] = "Mortero"
			edificio_nombre[id_muro] = "Muro"
			edificio_nombre[id_muro_reforzado] = "Muro Reforzado"
			edificio_nombre[id_modulo] = "Módulo"
			recurso_nombre[idr_modulos] = "Módulos"
			terreno_nombre[idt_nieve] = "Nieve"
			edificio_nombre[id_nucleo] = "Núcleo"
			edificio_nombre[id_onda_de_choque] = "Onda de Choque"
			edificio_nombre[id_overflow] = "Overflow"
			edificio_nombre[id_panel_solar] = "Panel Solar"
			edificio_nombre[id_pantalla] = "Pantalla"
			terreno_nombre[idt_pared_de_arena] = "Pared de Arena"
			terreno_nombre[idt_pared_de_nieve] = "Pared de Nieve"
			terreno_nombre[idt_pared_de_pasto] = "Pared de Pasto"
			terreno_nombre[idt_pared_de_piedra] = "Pared de Piedra"
			terreno_nombre[idt_pasto] = "Pasto"
			edificio_nombre[id_perforadora_de_petroleo] = "Perforadora de Petróleo"
			terreno_nombre[idt_petroleo] = "Petróleo"
			recurso_nombre[idr_piedra] = "Piedra"
			recurso_nombre[idr_piedra_cuprica] = "Piedra Cúprica"
			recurso_nombre[idr_piedra_ferrica] = "Piedra Férrica"
			recurso_nombre[idr_piedra_sulfatada] = "Piedra Sulfatada"
			edificio_nombre[id_planta_desalinizadora] = "Planta Desalinizadora"
			edificio_nombre[id_planta_nuclear] = "Planta Nuclear"
			edificio_nombre[id_planta_quimica] = "Planta Química"
			edificio_nombre[id_planta_de_enriquecimiento] = "Planta de Enriquecimiento"
			edificio_nombre[id_planta_de_reciclaje] = "Planta de Reciclaje"
			recurso_nombre[idr_plastico] = "Plástico"
			edificio_nombre[id_procesador] = "Procesador"
			categoria_nombre[2] = "Producción"
			edificio_nombre[id_puerto_de_carga] = "Puerto de Carga"
			edificio_nombre[id_recurso_infinito] = "Recurso Infinito"
			edificio_nombre[id_refineria_de_metales] = "Refinería de Metales"
			edificio_nombre[id_refineria_de_petroleo] = "Refinería de Petróleo"
			dron_nombre[idd_reparador] = "Reparador"
			edificio_nombre[id_rifle] = "Rifle"
			recurso_nombre[idr_sal] = "Sal"
			edificio_nombre[id_selector] = "Selector"
			recurso_nombre[idr_silicio] = "Silicio"
			edificio_nombre[id_silo_de_misiles] = "Silo de Misiles"
			edificio_nombre[id_taladro] = "Taladro"
			edificio_nombre[id_taladro_electrico] = "Taladro Eléctrico"
			edificio_nombre[id_taladro_de_explosion] = "Taladro de Explosión"
			dron_nombre[idd_tanque] = "Tanque"
			dron_nombre[idd_titan] = "Titán"
			edificio_nombre[id_torre_reparadora] = "Torre Reparadora"
			edificio_nombre[id_torre_basica] = "Torre básica"
			edificio_nombre[id_torre_de_alta_tension] = "Torre de Alta Tensión"
			categoria_nombre[0] = "Transporte"
			edificio_nombre[id_triturador] = "Triturador"
			edificio_nombre[id_tuberia] = "Tubería"
			edificio_nombre[id_tuberia_subterranea] = "Tubería Subterránea"
			edificio_nombre[id_turbina] = "Turbina"
			edificio_nombre[id_tunel] = "Túnel"
			edificio_nombre[id_tunel_salida] = "Túnel salida"
			recurso_nombre[idr_uranio_bruto] = "Uranio Bruto"
			recurso_nombre[idr_uranio_empobrecido] = "Uranio Empobrecido"
			recurso_nombre[idr_uranio_enriquecido] = "Uranio Enriquecido"
			variable_struct_set(L, "activado", "Activado")
			variable_struct_set(L, "activar", "Activar")
			variable_struct_set(L, "almacen_acepta", "Acepta")
			variable_struct_set(L, "almacen_acepta_todo", "Acepta todo")
			variable_struct_set(L, "almacen_almacen", "Almacen")
			variable_struct_set(L, "almacen_combustion", "Combustión")
			variable_struct_set(L, "almacen_consumiendo", "Consumiendo")
			variable_struct_set(L, "almacen_de_su_capacidad", "de su capacidad")
			variable_struct_set(L, "almacen_entrega", "Entrega")
			variable_struct_set(L, "almacen_entrega_todo", "Entrega todo")
			variable_struct_set(L, "almacen_funcionando_al", "Funcionando al")
			variable_struct_set(L, "almacen_proceso", "Proceso")
			variable_struct_set(L, "almacen_produciendo", "Produciendo")
			variable_struct_set(L, "almacen_recursos_disponibles", "Recursos disponibles")
			variable_struct_set(L, "almacen_sin_receta", "Sin Receta")
			variable_struct_set(L, "almacen_sin_recursos", "Sin recursos")
			variable_struct_set(L, "almacen_total", "Total")
			variable_struct_set(L, "cancelar", "Cancelar")
			variable_struct_set(L, "construir_combinar_liquidos", "No se puede combinar líquidos")
			variable_struct_set(L, "construir_enemigos_cerca", "¡Hay enemigos demasiado cerca!")
			variable_struct_set(L, "construir_ocupado", "Terreno ocupado")
			variable_struct_set(L, "construir_recursos_insuficientes", "Recursos insuficientes")
			variable_struct_set(L, "construir_sobre_agua", "Necesita ser construido sobre agua")
			variable_struct_set(L, "construir_sobre_agua_lava", "Necesita ser construido sobre agua, petróleo o lava")
			variable_struct_set(L, "construir_sobre_lava", "Necesita ser construido sobre lava")
			variable_struct_set(L, "construir_sobre_minerales", "Necesita ser construido sobre minerales")
			variable_struct_set(L, "construir_sobre_minerales_piedra", "Necesita ser construido sobre minerales, piedra o arena")
			variable_struct_set(L, "construir_sobre_salar", "No puede ser construido sobre un salar")
			variable_struct_set(L, "construir_terreno_hielo", "Terreno demasiado inestable")
			variable_struct_set(L, "construir_terreno_invalido", "Terreno inválido")
			variable_struct_set(L, "construir_zona_enemigos", "Zona de generación de enemigos")
			variable_struct_set(L, "cuevas", "Cuevas")
			variable_struct_set(L, "desactivado", "Desactivado")
			variable_struct_set(L, "desactivar", "Desactivar")
			recurso_descripcion[idr_acero] = "Recurso útil para la construcción de infrastructura intermedia"
			edificio_descripcion[id_almacen] = "Almacena recursos para usarlos más tarde"
			dron_descripcion[idd_arana] = "Dispara un láser a los enemigos cercanos"
			recurso_descripcion[idr_arena] = "Recurso necesario para la producción de bienes refinados como Silicio o Concreto"
			recurso_descripcion[idr_barril_con_agua] = "Barril con Agua, útil para almacenarla y distribuirla"
			recurso_descripcion[idr_barril_con_agua_salada] = "Barril con Agua salada, útil para almacenarla y distribuirla"
			recurso_descripcion[idr_barril_con_lava] = "Barril con Lava, útil para almacenarla y distribuirla"
			recurso_descripcion[idr_barril_con_petroleo] = "Barril con Petróleo, útil para almacenarlo y distribuirlo"
			recurso_descripcion[idr_barril_con_acido] = "Barril con Ácido, útil para almacenarlo y distribuirlo"
			edificio_descripcion[id_bateria] = "Recurso necesario para la producción de todo tipo de Drones"
			edificio_descripcion[id_bomba_hidraulica] = "Extrae líquidos del terreno usando energía"
			edificio_descripcion[id_bomba_de_evaporacion] = "Extrae lentamente Agua por evaporación"
			dron_descripcion[idd_bombardero] = "Vuela sobre sus enemigos soltando devastadores explosivos en línea recta"
			recurso_descripcion[idr_bronce] = "Recurso útil para la construcción de infrastructura intermedia"
			edificio_descripcion[id_cable] = "Conecta edificios cercanos a la red de energía"
			recurso_descripcion[idr_carbon] = "Combustible básico, útil para el funcionamiento de Hornos y Generadores"
			edificio_descripcion[id_cinta_grande] = "Transporta drones entre fábricas"
			edificio_descripcion[id_cinta_magnetica] = "Versión mejorada de la Cinta Transportadora que permite transportar más cosas"
			edificio_descripcion[id_cinta_transportadora] = "Mueve recursos de un lugar a otro"
			recurso_descripcion[idr_cobre] = "Recurso básico, escencial para los primeros edificios. Puede ser refinado para obtener Bronce"
			recurso_descripcion[idr_compuesto_incendiario] = "Combustible avanzado, más eficiente y dduradero que el Carbón"
			recurso_descripcion[idr_concreto] = "Recurso útil para la construcción de infrastructura intermedia"
			edificio_descripcion[id_cruce] = "Permite realizar conexiones de cintas transportadoras que se curcen"
			edificio_descripcion[id_deposito] = "Almacena grandes cantidades de líquidos"
			dron_descripcion[idd_dron] = "Transporta recursos entre Puertos de Carga"
			edificio_descripcion[id_embotelladora] = "Llena y vacía barriles con líquidos"
			edificio_descripcion[id_energia_infinita] = "Genera energía a partir de magia"
			edificio_descripcion[id_enrutador] = "Distribuye recursos en una dirección"
			edificio_descripcion[id_ensambladora] = "Utiliza Cobre y Silicio para producir componentes"
			recurso_descripcion[idr_explosivo] = "Se acerca a su objetivo y explota infilgiendo daño"
			edificio_descripcion[id_extractor_atmosferico] = "Extrae agua de la atmósfera, ideal para terrenos donde no es fácil obtenerla"
			edificio_descripcion[id_fabrica_de_concreto] = "Fabrica concreto a partir de Arena, Piedra y Agua"
			edificio_descripcion[id_fabrica_de_drones] = "Fabrica drones de transporte utilizando Silicio, Baterías y bastante energía"
			edificio_descripcion[id_fabrica_de_drones_grande] = "Permite fabricar drones más grandes usando Ácido"
			edificio_descripcion[id_generador] = "Genera energía utlizando combustible"
			edificio_descripcion[id_generador_geotermico] = "Genera energía a partir de evaporar Agua, debe ser construido sobre lava"
			dron_descripcion[idd_helicoptero] = "Unidad aerea superior, dispara a distancia"
			recurso_descripcion[idr_hierro] = "Recurso básico, escencial para los primeros edificios"
			edificio_descripcion[id_horno] = "Utiliza combustible para fundir Bronce, Acero y Silicio"
			edificio_descripcion[id_horno_de_lava] = "Similar al horno normal, pero utiliza el calor de la lava para cocinar más rápido"
			edificio_descripcion[id_lanzallamas] = "Utiliza recursos combustibles para quemar a los enemigos. Puede ser potenciado con Petróleo"
			edificio_descripcion[id_laser] = "Dispara un láser constante cuyo daño depende de la cantidad de energía disponible"
			edificio_descripcion[id_liquido_infinito] = "Genera el líquido a elección a partir de magia"
			edificio_descripcion[id_memoria] = "Permite almacenar hasta 128 datos"
			edificio_descripcion[id_mensaje] = "Permite escribir mensajes"
			edificio_descripcion[id_mortero] = "Dispara explosivos a largo alcance, devastando un área de enemigos"
			edificio_descripcion[id_muro] = "Distrae a los enemigos mientras tus defensas se encargan de ellos"
			edificio_descripcion[id_muro_reforzado] = "Versión mejorada del muro, más duro y mejor"
			edificio_descripcion[id_modulo] = "Mejora las características de algún edificio"
			recurso_descripcion[idr_modulos] = "Investiga los Módulos y construye dos Ensambladores juntos para empezar a producirlos"
			edificio_descripcion[id_nucleo] = "Es el centro de mando, aquí se almacenan todos los recursos y debes protegerlo a toda costa"
			edificio_descripcion[id_onda_de_choque] = "Carga y libera una gran onda de choque que daña y ralentiza a todos los enemigos en su rango"
			edificio_descripcion[id_overflow] = "Desvía los recursos una vez que la línea esté saturada"
			edificio_descripcion[id_panel_solar] = "Genera energía limpia del sol"
			edificio_descripcion[id_pantalla] = "Permite dibujar imágenes enviadas desde un procesador"
			edificio_descripcion[id_perforadora_de_petroleo] = "Produce petróleo a alto coste en cualquier lugar"
			recurso_descripcion[idr_piedra] = "Recurso necesario para la producción de Concreto. Puede ser transformado en Arena en un Triturador"
			recurso_descripcion[idr_piedra_cuprica] = "Puede ser utilizada como Piedra normal o purificada para obtener Cobre"
			recurso_descripcion[idr_piedra_ferrica] = "Puede ser utilizada como Piedra normal o porificada para obtener Hierro"
			recurso_descripcion[idr_piedra_sulfatada] = "Puede ser utilizada como Piedra normal. Pero es escencial en la producción de bienes más refinados"
			edificio_descripcion[id_planta_desalinizadora] = "Purifica el Agua Salada para extraer la Sal y el Agua dulce"
			edificio_descripcion[id_planta_nuclear] = "Consume 1 parte de Uranio Enriquecido por 20 partes de Uranio Empobrecido y mucha Agua para generar mucha energía"
			edificio_descripcion[id_planta_quimica] = "Escoge una receta para producir compuestos químicos"
			edificio_descripcion[id_planta_de_enriquecimiento] = "Permite reciclar el uranio consumiendo grandes cantidades de agua y energía de manera constante"
			edificio_descripcion[id_planta_de_reciclaje] = "Permite reciclar parte de los recursos de los enemigos destruidos cercanos"
			recurso_descripcion[idr_plastico] = "Material ligero, útil en la producción de Drones"
			edificio_descripcion[id_procesador] = "Procesa instrucciones lógicas"
			edificio_descripcion[id_puerto_de_carga] = "Conceta Puertos de Carga para que tus drones muevan recursos entre ellos"
			edificio_descripcion[id_recurso_infinito] = "Genera recursos a partir de magia"
			edificio_descripcion[id_refineria_de_metales] = "Refina la Piedra Cúprica o Férrica en Cobre o Hierro usando Ácido"
			edificio_descripcion[id_refineria_de_petroleo] = "Mediante la destilación fraccionada permite extraer Plástico, Combustible y Azufre del Petróleo"
			dron_descripcion[idd_reparador] = "Repara los edificios dañados"
			edificio_descripcion[id_rifle] = "Defensa de largo alcance que dispara Bronce, Acero o Uranio"
			recurso_descripcion[idr_sal] = "Recurso útil para mejorar otros procesos industriales como la planta química, refinería de petróleo y producción de Silicio"
			edificio_descripcion[id_selector] = "Permite el paso de un recurso específico mientras desvía al resto"
			recurso_descripcion[idr_silicio] = "Recurso útil en la producción de Paneles Solares, Drones y Circuitos"
			edificio_descripcion[id_silo_de_misiles] = "Aquí se puede construir un misíl nuclear usándo acero, explosivos, petróleo y uranio enriquecido"
			edificio_descripcion[id_taladro] = "Permite minar cobre, hierro y carbón sin coste alguno.    Puede potenciarse con Agua"
			edificio_descripcion[id_taladro_electrico] = "Taladro mejorado que también extrae piedra y arena del suelo pero consume energía. Puede potenciarse con Agua"
			edificio_descripcion[id_taladro_de_explosion] = "Utiliza explosivos para extraer un recurso de cada terreno minable en su área"
			dron_descripcion[idd_tanque] = "Unidad de asedio superior, dispara explosivos dañando todo a su alrededor"
			dron_descripcion[idd_titan] = "Unidad terrestre máxima, dispara una ráfaga de explosivos de largo alcance"
			edificio_descripcion[id_torre_reparadora] = "Proyecta un láser de reparación a los edificios cercanos usando energía"
			edificio_descripcion[id_torre_basica] = "Defensa simple, puede disparar Cobre o Hierro"
			edificio_descripcion[id_torre_de_alta_tension] = "Conecta redes eléctricas a través de largas distancias"
			edificio_descripcion[id_triturador] = "Tritura la piedra para hacerla arena"
			edificio_descripcion[id_tuberia] = "Conecta estructuras para llevar líquidos"
			edificio_descripcion[id_tuberia_subterranea] = "Conecta líneas de líquidos por debajo tierra"
			edificio_descripcion[id_turbina] = "Genera energía a partir de un combustible y Agua"
			edificio_descripcion[id_tunel] = "Pasa recursos bajo tierra permitiendo construir encima"
			edificio_descripcion[id_tunel_salida] = "Pasa recursos bajo tierra permitiendo construir encima"
			recurso_descripcion[idr_uranio_bruto] = "Uranio sin refinar, útil como munición. Puede ser refinado para dividir el Uranio Empobrecido del Enriquecido"
			recurso_descripcion[idr_uranio_empobrecido] = "Uranio 238, necesario para acompañar la producción de energía en Plantas Nucleares. Y útil como munición"
			recurso_descripcion[idr_uranio_enriquecido] = "Uranio 235, útil para la generación de energía en Plantas Nucleares"
			variable_struct_set(L, "desierto", "Desierto")
			variable_struct_set(L, "dificil", "Difícil")
			variable_struct_set(L, "dificultad", "Dificultad")
			variable_struct_set(L, "editor_Reemplazar", "Reemplazar")
			variable_struct_set(L, "editor_activar_oleadas", "Activar oleadas")
			variable_struct_set(L, "editor_add", "Añadir")
			variable_struct_set(L, "editor_add_text", "Añadir texto")
			variable_struct_set(L, "editor_al_rededor", "Al rededor de")
			variable_struct_set(L, "editor_borde", "Bordes")
			variable_struct_set(L, "editor_cambiar_base", "Cambiar posición de la base")
			variable_struct_set(L, "editor_cambiar_oleadas", "Activar / Desactivar oleadas")
			variable_struct_set(L, "editor_cambiar_zona", "Cambia zona de aparición de enemigos")
			variable_struct_set(L, "editor_carga_inicial", "Carga inicial")
			variable_struct_set(L, "editor_cargar", "Cargar escenario")
			variable_struct_set(L, "editor_clic", "Clic izquierdo para")
			variable_struct_set(L, "editor_clic_aplicar", "Clic para aplicar")
			variable_struct_set(L, "editor_con", "con")
			variable_struct_set(L, "editor_configuracion", "Configuración")
			variable_struct_set(L, "editor_cualquiera", "cualquiera")
			variable_struct_set(L, "editor_de", "de")
			variable_struct_set(L, "editor_del_tiempo", "del tiempo")
			variable_struct_set(L, "editor_desactivar_oleadas", "Desactivar oleadas")
			variable_struct_set(L, "editor_deshabilitar", "Deshabilitar cronómetro")
			variable_struct_set(L, "editor_edificios_disponibles", "Edificios disponibles")
			variable_struct_set(L, "editor_editar_mapa", "Editar mapa")
			variable_struct_set(L, "editor_el", "el")
			variable_struct_set(L, "editor_eliminar_mena", "Elimiar mena de recursos")
			variable_struct_set(L, "editor_eliminar_objetivo", "Eliminar objetivo")
			variable_struct_set(L, "editor_enemigos", "enemigos")
			variable_struct_set(L, "editor_generar_terreno", "Generar terreno")
			variable_struct_set(L, "editor_guardar", "Guardar escenario")
			variable_struct_set(L, "editor_habilitar", "Habilitar cronómetro")
			variable_struct_set(L, "editor_info", "Ver información")
			variable_struct_set(L, "editor_luego_de", "luego de")
			variable_struct_set(L, "editor_manchas", "Manchas de Terreno")
			variable_struct_set(L, "editor_menas", "Menas de recursos")
			variable_struct_set(L, "editor_mostrar", "mostrar")
			variable_struct_set(L, "editor_mover_a", "Mover a")
			variable_struct_set(L, "editor_mover_camara", "Mover cámara")
			variable_struct_set(L, "editor_multiplicador_vida", "Multiplicador de vida de los enemigos")
			variable_struct_set(L, "editor_no", "No")
			variable_struct_set(L, "editor_nuevo_objetivo", "Nombre objetivo")
			variable_struct_set(L, "editor_objetivo", "Objetivo")
			variable_struct_set(L, "editor_objetivos", "Objetivos")
			variable_struct_set(L, "editor_ocultar", "ocultar")
			variable_struct_set(L, "editor_on", "en")
			variable_struct_set(L, "editor_primera_ronda", "Tiempo primera ronda")
			variable_struct_set(L, "editor_reemplazar", "reemplazar")
			variable_struct_set(L, "editor_ruido", "Ruido")
			variable_struct_set(L, "editor_seed", "Semilla")
			variable_struct_set(L, "editor_siguiente_ronda", "Tiempo entre rondas")
			variable_struct_set(L, "editor_size", "de tamaño")
			variable_struct_set(L, "editor_size_map", "Tamaño del mapa")
			variable_struct_set(L, "editor_terreno_base", "Terreno base")
			variable_struct_set(L, "editor_texto_victoria", "Text de victoria")
			variable_struct_set(L, "editor_veces", "veces")
			variable_struct_set(L, "enciclopedia_aerea", "Unidad aérea")
			variable_struct_set(L, "enciclopedia_combustible", "Combustible por")
			variable_struct_set(L, "enciclopedia_construir", "Construir")
			variable_struct_set(L, "enciclopedia_consume", "Consume")
			variable_struct_set(L, "enciclopedia_coste_construccion", "Coste de construcción")
			variable_struct_set(L, "enciclopedia_edificios", "Edificios")
			variable_struct_set(L, "enciclopedia_inutil", "No es útil en el núcleo")
			variable_struct_set(L, "enciclopedia_investigar", "Investigar")
			variable_struct_set(L, "enciclopedia_necesario_para_construir", "Necesario para construir")
			variable_struct_set(L, "enciclopedia_necesario_para_producir", "Necesario para producir")
			variable_struct_set(L, "enciclopedia_produce", "Produce")
			variable_struct_set(L, "enciclopedia_producido_en", "Producido en")
			variable_struct_set(L, "enciclopedia_recursos", "Recursos")
			variable_struct_set(L, "enciclopedia_size", "Tamaño")
			variable_struct_set(L, "enciclopedia_tecnologia", "Tecnología")
			variable_struct_set(L, "enciclopedia_unidades", "Unidades")
			variable_struct_set(L, "enciclopedia_usado_en", "Usado en")
			variable_struct_set(L, "enciclopedia_vida", "Vida máxima")
			variable_struct_set(L, "energia_consumida", "Energía consumida")
			variable_struct_set(L, "energia_perdida", "Energía perdida")
			variable_struct_set(L, "energia_producida", "Energía producida")
			variable_struct_set(L, "facil", "Fácil")
			variable_struct_set(L, "flujo_almacenado", "Almacenado")
			variable_struct_set(L, "flujo_consumo", "Consumo")
			variable_struct_set(L, "flujo_flujo", "Tubería")
			variable_struct_set(L, "flujo_generacion", "Generación")
			variable_struct_set(L, "flujo_liquido", "líquido")
			variable_struct_set(L, "flujo_sin_liquido", "Sin líquidos")
			variable_struct_set(L, "game_activar", "Activar")
			variable_struct_set(L, "game_creando_dron", "Creando")
			variable_struct_set(L, "game_enciclopedia", "Enciclopedia")
			variable_struct_set(L, "game_first_wave", "para la primera oleada")
			variable_struct_set(L, "game_limite_dron", "Límite de Drones alcanzado")
			variable_struct_set(L, "game_next_wave", "para la siguiente oleada")
			variable_struct_set(L, "game_producira", "Producirá")
			variable_struct_set(L, "game_puerto_carga", "Conecta con otro Puerto de Carga")
			variable_struct_set(L, "game_vincular_procesador", "Vincula con cualquier edificio")
			variable_struct_set(L, "islas", "Islas")
			variable_struct_set(L, "liquido_Agua", "Agua")
			variable_struct_set(L, "liquido_Agua salada", "Agua salada")
			variable_struct_set(L, "liquido_Lava", "Lava")
			variable_struct_set(L, "liquido_Petróleo", "Petróleo")
			variable_struct_set(L, "liquido_Ácido", "Ácido")
			variable_struct_set(L, "marcar_objetivo", "Marcar Objetivo")
			variable_struct_set(L, "medio", "Medio")
			variable_struct_set(L, "menu_cargar_escenario", "Cargar Escenario")
			variable_struct_set(L, "menu_claves", "Sandbox")
			variable_struct_set(L, "menu_editor", "Editor")
			variable_struct_set(L, "menu_hexdustry", "HEXDUSTRY")
			variable_struct_set(L, "menu_html", "Rendimiento reducido por HTML5")
			variable_struct_set(L, "menu_juego_rapido", "Juego Rápido")
			variable_struct_set(L, "menu_modo_infinito", "Modo infinito")
			variable_struct_set(L, "menu_modo_misiones", "Modo misiones")
			variable_struct_set(L, "menu_modo_oleadas", "Modo oleadas")
			variable_struct_set(L, "menu_numero_oleadas", "Número de oleadas")
			variable_struct_set(L, "menu_precio_tecnologia", "Precio Tecnología")
			variable_struct_set(L, "menu_sin_archivos", "Sin escenarios aún")
			variable_struct_set(L, "menu_tutorial", "Tutorial")
			variable_struct_set(L, "mision_enemigos", "enemigos")
			variable_struct_set(L, "mision_tiempo", "Tiempo restante")
			variable_struct_set(L, "modulo_aturdir", "33% más duración de aturdimiento")
			variable_struct_set(L, "modulo_cadencia", "30% más cadencia de fuego")
			variable_struct_set(L, "modulo_canalizar", "Canaliza 50% más rápido")
			variable_struct_set(L, "modulo_dmg", "30% más daño")
			variable_struct_set(L, "modulo_edificio_con_modulo", "Este edificio ya tiene un módulo")
			variable_struct_set(L, "modulo_edificio_sin_modulo", "Este edificio no acepta módulos")
			variable_struct_set(L, "modulo_extraccion", "40% más velocidad de extracción")
			variable_struct_set(L, "modulo_mas_liquido", "Produce 20% más")
			variable_struct_set(L, "modulo_menos_electricidad", "25% menos consumo eléctrico")
			variable_struct_set(L, "modulo_menos_liquido", "25% menos consumo de")
			variable_struct_set(L, "modulo_nuclear", "Corta automáticamente la planta si se queda sin agua")
			variable_struct_set(L, "modulo_nucleo", "Aumenta en 2 el máximo de drones aliados")
			variable_struct_set(L, "modulo_produccion", "Produce 30% más rápido")
			variable_struct_set(L, "modulo_reparadora", "Repara 20% más rápido")
			variable_struct_set(L, "modulo_sal", "Extrae 50% más")
			variable_struct_set(L, "modulo_sin_edificio", "Necesita un edificio")
			variable_struct_set(L, "nieve", "Nieve")
			variable_struct_set(L, "nuevo_archivo", "Nuevo archivo")
			objetivos_nombre[0] = "conseguir"
			objetivos_nombre[1] = "tener almacenado"
			objetivos_nombre[2] = "construir"
			objetivos_nombre[3] = "tener construido"
			objetivos_nombre[4] = "sobrevivir oleadas"
			objetivos_nombre[5] = "sin objetivo"
			objetivos_nombre[6] = "apretar ADWS"
			objetivos_nombre[7] = "cargar edificio"
			objetivos_nombre[8] = "destruir edificio"
			variable_struct_set(L, "pausa", "P A U S A")
			variable_struct_set(L, "pausa_UI", "UI")
			variable_struct_set(L, "pausa_activar", "Activar")
			variable_struct_set(L, "pausa_animacion", "animaciones del terreno")
			variable_struct_set(L, "pausa_continuar", "Presiona Esc para continuar")
			variable_struct_set(L, "pausa_desactivar", "Desactivar")
			variable_struct_set(L, "pausa_enciclopedia", "\"Y\" para abrir la enciclopedia")
			variable_struct_set(L, "pausa_humo", "humo")
			variable_struct_set(L, "pausa_iluminacion", "la iluminación")
			variable_struct_set(L, "pausa_info", "información adicional")
			variable_struct_set(L, "pausa_liquido", "\"I\" para ver las redes de líquidos")
			variable_struct_set(L, "pausa_paredes", "texturas de paredes")
			variable_struct_set(L, "pausa_red", "\"O\" para ver las redes eléctricas")
			variable_struct_set(L, "pausa_reparar", "\"Q\" para reconstruir edificios")
			variable_struct_set(L, "pausa_sonido", "sonido")
			variable_struct_set(L, "personalizado", "Personalizado")
			planta_quimica_descripcion[0] = "Consume Piedra Sulfatada y energía para producir Ácido"
			planta_quimica_descripcion[1] = "Utiliza Compuesto Incendiario y Ácido para producir Explosivos"
			planta_quimica_descripcion[2] = "Utiliza Ácido, Cobre y energía para producir Baterías"
			planta_quimica_receta[0] = "Ácido"
			planta_quimica_receta[1] = "Explosivos"
			planta_quimica_receta[2] = "Baterías"
			variable_struct_set(L, "praderas", "Praderas")
			variable_struct_set(L, "procesador_cargar", "Cargar código")
			variable_struct_set(L, "procesador_guardar", "Guardar código")
			variable_struct_set(L, "procesador_next_step", "Siguiente instrucción")
			variable_struct_set(L, "procesador_add", "Añadir")
			variable_struct_set(L, "procesador_subir", "Subir")
			variable_struct_set(L, "procesador_clonar", "Clonar")
			variable_struct_set(L, "procesador_borrar", "Borrar")
			variable_struct_set(L, "procesador_vincular", "Vincular edificios")
			variable_struct_set(L, "procesador_continue", "Continuar")
			variable_struct_set(L, "procesador_set", "Asignar")
			variable_struct_set(L, "procesador_random", "Aleatorizar")
			variable_struct_set(L, "procesador_to", "a")
			variable_struct_set(L, "procesador_if", "si")
			variable_struct_set(L, "procesador_is", "es")
			variable_struct_set(L, "procesador_is_not", "no es")
			variable_struct_set(L, "procesador_jump", "salta a la línea")
			variable_struct_set(L, "procesador_control", "Controlar")
			variable_struct_set(L, "procesador_to_set", "para asignar")
			variable_struct_set(L, "procesador_from", "desde")
			variable_struct_set(L, "procesador_write", "Write")
			variable_struct_set(L, "procesador_to_value_of_cell", "al valor en la celda")
			variable_struct_set(L, "procesador_into_value_of_cell", "al valor en la celda")
			variable_struct_set(L, "procesador_of", "de")
			procesador_instrucciones_nombre[0] = "Continuar"
			procesador_instrucciones_nombre[1] = "Asignar variable"
			procesador_instrucciones_nombre[2] = "Operaciones de una variable"
			procesador_instrucciones_nombre[3] = "Operaciones de dos variables"
			procesador_instrucciones_nombre[4] = "Saltar a línea"
			procesador_instrucciones_nombre[5] = "Leer información de edificio"
			procesador_instrucciones_nombre[6] = "Controlar edificio"
			procesador_instrucciones_nombre[7] = "Leer datos de Memoria"
			procesador_instrucciones_nombre[8] = "Escribir datos a Memoria"
			procesador_instrucciones_nombre[9] = "Dibujar a Pantalla"
			variable_struct_set(L, "recursos_obtenidos", "Recursos obtenidos")
			variable_struct_set(L, "red_bateria", "Batería")
			variable_struct_set(L, "red_consumo", "Consumo")
			variable_struct_set(L, "red_energia", "energía")
			variable_struct_set(L, "red_generacion", "Generación")
			variable_struct_set(L, "red_red", "Red")
			variable_struct_set(L, "salir", "Salir")
			variable_struct_set(L, "show_menu_invertir", "Invertir")
			variable_struct_set(L, "show_menu_ningun_liquido", "Ningún líquido")
			variable_struct_set(L, "show_menu_no_disponible", "No disponible de momento")
			variable_struct_set(L, "show_menu_receta", "Receta")
			variable_struct_set(L, "show_menu_unidad", "Unidad")
			variable_struct_set(L, "tiempo", "Tiempo")
			variable_struct_set(L, "volver", "Volver")
			variable_struct_set(L, "win_derrota", "Derrota")
			variable_struct_set(L, "win_dmg_causado", "Daño causado")
			variable_struct_set(L, "win_dmg_curado", "Daño curado")
			variable_struct_set(L, "win_dmg_recibido", "Daño recibido")
			variable_struct_set(L, "win_drones", "Drones construidos")
			variable_struct_set(L, "win_drones_perdidos", "Drones perdidos")
			variable_struct_set(L, "win_edificios", "Edificios construidos")
			variable_struct_set(L, "win_edificios_destruidos", "Edificios destruidos")
			variable_struct_set(L, "win_edificios_perdidos", "Edificios perdidos")
			variable_struct_set(L, "win_enemigos", "Enemigos eliminados")
			variable_struct_set(L, "win_militar", "Militar")
			variable_struct_set(L, "win_misiones", "Objetivos cumplidos")
			variable_struct_set(L, "win_reintentar", "Intentar de nuevo")
			variable_struct_set(L, "win_salir", "Salir al menú")
			variable_struct_set(L, "win_seguir_jugando", "¿Seguir jugando?")
			variable_struct_set(L, "win_siguiente_mision", "Siguiente misión")
			variable_struct_set(L, "win_tecnologias", "Tecnologías estudiadas")
			variable_struct_set(L, "win_tiempo", "Tiempo")
			variable_struct_set(L, "win_victoria", "Victoria")
			variable_struct_set(L, "editar_desde_adentro", "Editar desde adentro")
		}
		//Русский
		else if idioma = 2{
			terreno_nombre[idt_arena] = "Паук"
			terreno_nombre[idt_piedra] = "Камень"
			terreno_nombre[idt_piedra_cuprica] = "Медная порода"
			terreno_nombre[idt_piedra_ferrica] = "Железный камень"
			terreno_nombre[idt_salar] = "Солончак"
			
			recurso_nombre[idr_acero] = "Сталь"
			terreno_nombre[idt_agua] = "Вода"
			recurso_nombre[idr_bateria] = "Батарея"
			terreno_nombre[idt_agua_profunda] = "Глубокая вода"
			terreno_nombre[idt_agua_salada] = "Солёная вода"
			terreno_nombre[idt_agua_salada_profunda] = "Глубокая солёная вода"
			edificio_nombre[id_almacen] = "Склад"
			dron_nombre[idd_arana] = "Паук"
			recurso_nombre[idr_arena] = "Песок"
			recurso_nombre[idr_barril_con_agua] = "Бочка с водой"
			recurso_nombre[idr_barril_con_agua_salada] = "Бочка с солёной водой"
			recurso_nombre[idr_barril_con_lava] = "Бочка с лавой"
			recurso_nombre[idr_barril_con_petroleo] = "Бочка с нефтью"
			recurso_nombre[idr_barril_con_acido] = "Бочка с кислотой"
			terreno_nombre[idt_basalto] = "Базальт"
			terreno_nombre[idt_basalto_sulfatado] = "Сульфатный базальт"
			edificio_nombre[id_bateria] = "Батарея"
			edificio_nombre[id_bomba_hidraulica] = "Гидравлический насос"
			edificio_nombre[id_bomba_de_evaporacion] = "Испаряющий насос"
			dron_nombre[idd_bombardero] = "Бомбардировщик"
			recurso_nombre[idr_bronce] = "Бронза"
			edificio_nombre[id_cable] = "Кабель"
			recurso_nombre[idr_carbon] = "Уголь"
			terreno_nombre[idt_ceniza] = "Пепел"
			edificio_nombre[id_cinta_grande] = "Крупный конвейер"
			edificio_nombre[id_cinta_magnetica] = "Магнитный конвейер"
			edificio_nombre[id_cinta_transportadora] = "Конвейер"
			recurso_nombre[idr_cobre] = "Медь"
			recurso_nombre[idr_compuesto_incendiario] = "Зажигательная смесь"
			recurso_nombre[idr_concreto] = "Бетон"
			edificio_nombre[id_cruce] = "Перекрёсток"
			categoria_nombre[5] = "Оборона"
			edificio_nombre[id_deposito] = "Хранилище"
			dron_nombre[idd_dron] = "Дрон"
			categoria_nombre[7] = "Дронов"
			categoria_nombre[3] = "Энергия"
			recurso_nombre[idr_electronicos] = "Компонент"
			edificio_nombre[id_embotelladora] = "Линия розлива"
			edificio_nombre[id_energia_infinita] = "Бесконечная энергия"
			edificio_nombre[id_enrutador] = "Распределитель"
			edificio_nombre[id_ensambladora] = "Сборщик"
			recurso_nombre[idr_explosivo] = "Взрывник"
			dron_nombre[idd_explosivo] = "Взрывник"
			categoria_nombre[1] = "Добыча"
			edificio_nombre[id_extractor_atmosferico] = "Атмосферный экстрактор"
			edificio_nombre[id_fabrica_de_concreto] = "Бетонный завод"
			edificio_nombre[id_fabrica_de_drones] = "Фабрика дронов"
			edificio_nombre[id_fabrica_de_drones_grande] = "Крупный завод дронов"
			edificio_nombre[id_generador] = "Генератор"
			edificio_nombre[id_generador_geotermico] = "Геотермальный генератор"
			dron_nombre[idd_helicoptero] = "Вертолёт"
			terreno_nombre[idt_hielo] = "Лёд"
			recurso_nombre[idr_hierro] = "Железо"
			edificio_nombre[id_horno] = "Печь"
			edificio_nombre[id_horno_de_lava] = "Лавовая печь"
			edificio_nombre[id_lanzallamas] = "Огнемёт"
			terreno_nombre[idt_lava] = "Лава"
			edificio_nombre[id_laser] = "Лазер"
			edificio_nombre[id_liquido_infinito] = "Бесконечная жидкость"
			categoria_nombre[4] = "Жидкости"
			categoria_nombre[6] = "Логика"
			edificio_nombre[id_memoria] = "Память"
			edificio_nombre[id_mensaje] = "Сообщение"
			edificio_nombre[id_mortero] = "Миномёт"
			edificio_nombre[id_muro] = "Стена"
			edificio_nombre[id_muro_reforzado] = "Укреплённая стена"
			edificio_nombre[id_modulo] = "Модуль"
			recurso_nombre[idr_modulos] = "Модули"
			terreno_nombre[idt_nieve] = "Снег"
			edificio_nombre[id_nucleo] = "Ядро"
			edificio_nombre[id_onda_de_choque] = "Ударная волна"
			edificio_nombre[id_overflow] = "Переполнение"
			edificio_nombre[id_panel_solar] = "Солнечная панель"
			edificio_nombre[id_pantalla] = "Экран"
			terreno_nombre[idt_pared_de_arena] = "Песчаная стена"
			terreno_nombre[idt_pared_de_nieve] = "Снежная стена"
			terreno_nombre[idt_pared_de_pasto] = "Травяная стена"
			terreno_nombre[idt_pared_de_piedra] = "Каменная стена"
			terreno_nombre[idt_pasto] = "Трава"
			edificio_nombre[id_perforadora_de_petroleo] = "Нефтяная буровая"
			terreno_nombre[idt_petroleo] = "Нефть"
			recurso_nombre[idr_piedra] = "Камень"
			recurso_nombre[idr_piedra_cuprica] = "Медная порода"
			recurso_nombre[idr_piedra_ferrica] = "Железная порода"
			recurso_nombre[idr_piedra_sulfatada] = "Сульфатная порода"
			edificio_nombre[id_planta_desalinizadora] = "Опреснительная установка"
			edificio_nombre[id_planta_nuclear] = "Атомная станция"
			edificio_nombre[id_planta_quimica] = "Химический завод"
			edificio_nombre[id_planta_de_enriquecimiento] = "Завод Обогащения"
			edificio_nombre[id_planta_de_reciclaje] = "Перерабатывающий завод"
			recurso_nombre[idr_plastico] = "Пластик"
			edificio_nombre[id_procesador] = "Процессор"
			categoria_nombre[2] = "Производство"
			edificio_nombre[id_puerto_de_carga] = "Порт погрузки"
			edificio_nombre[id_recurso_infinito] = "Бесконечный ресурс"
			edificio_nombre[id_refineria_de_metales] = "Металлургический завод"
			edificio_nombre[id_refineria_de_petroleo] = "Нефтеперерабатывающий завод"
			dron_nombre[idd_reparador] = "Ремонтный дрон"
			edificio_nombre[id_rifle] = "Винтовка"
			recurso_nombre[idr_sal] = "Соль"
			edificio_nombre[id_selector] = "Селектор"
			recurso_nombre[idr_silicio] = "Кремний"
			edificio_nombre[id_silo_de_misiles] = "Ракетный Силос"
			edificio_nombre[id_taladro] = "Бур"
			edificio_nombre[id_taladro_electrico] = "Электрический бур"
			edificio_nombre[id_taladro_de_explosion] = "Взрывной бур"
			dron_nombre[idd_tanque] = "Танк"
			dron_nombre[idd_titan] = "Титан"
			edificio_nombre[id_torre_reparadora] = "Ремонтная башня"
			edificio_nombre[id_torre_basica] = "Базовая турель"
			edificio_nombre[id_torre_de_alta_tension] = "Высоковольтная башня"
			categoria_nombre[0] = "Транспорт"
			edificio_nombre[id_triturador] = "Дробитель"
			edificio_nombre[id_tuberia] = "Труба"
			edificio_nombre[id_tuberia_subterranea] = "Подземная труба"
			edificio_nombre[id_turbina] = "Турбина"
			edificio_nombre[id_tunel] = "Тоннель"
			edificio_nombre[id_tunel_salida] = "Выход тоннеля"
			recurso_nombre[idr_uranio_bruto] = "Необработанный уран"
			recurso_nombre[idr_uranio_empobrecido] = "Обеднённый уран"
			recurso_nombre[idr_uranio_enriquecido] = "Обогащённый уран"
			variable_struct_set(L, "activado", "Включено")
			variable_struct_set(L, "activar", "Активировать")
			variable_struct_set(L, "almacen_acepta", "Принимает")
			variable_struct_set(L, "almacen_acepta_todo", "Принимает всё")
			variable_struct_set(L, "almacen_almacen", "Хранилище")
			variable_struct_set(L, "almacen_combustion", "Сгорание")
			variable_struct_set(L, "almacen_consumiendo", "Потребляет")
			variable_struct_set(L, "almacen_de_su_capacidad", "своей мощности")
			variable_struct_set(L, "almacen_entrega", "Выдаёт")
			variable_struct_set(L, "almacen_entrega_todo", "Выдаёт всё")
			variable_struct_set(L, "almacen_funcionando_al", "Работает на")
			variable_struct_set(L, "almacen_proceso", "Процесс")
			variable_struct_set(L, "almacen_produciendo", "Производит")
			variable_struct_set(L, "almacen_recursos_disponibles", "Доступные ресурсы")
			variable_struct_set(L, "almacen_sin_receta", "Нет рецепта")
			variable_struct_set(L, "almacen_sin_recursos", "Нет ресурсов")
			variable_struct_set(L, "almacen_total", "Всего")
			variable_struct_set(L, "cancelar", "Отмена")
			variable_struct_set(L, "construir_combinar_liquidos", "Нельзя смешивать жидкости")
			variable_struct_set(L, "construir_enemigos_cerca", "Слишком близко враги!")
			variable_struct_set(L, "construir_ocupado", "Участок занят")
			variable_struct_set(L, "construir_recursos_insuficientes", "Недостаточно ресурсов")
			variable_struct_set(L, "construir_sobre_agua", "Должно быть построено на воде")
			variable_struct_set(L, "construir_sobre_agua_lava", "Должно быть построено на воде, нефти или лаве")
			variable_struct_set(L, "construir_sobre_lava", "Должно быть построено на лаве")
			variable_struct_set(L, "construir_sobre_minerales", "Должно быть построено на минералах")
			variable_struct_set(L, "construir_sobre_minerales_piedra", "Должно быть построено на минералах, камне или песке")
			variable_struct_set(L, "construir_sobre_salar", "Нельзя построить на солончаке")
			variable_struct_set(L, "construir_terreno_hielo", "Слишком нестабильная поверхность")
			variable_struct_set(L, "construir_terreno_invalido", "Непригодный участок")
			variable_struct_set(L, "construir_zona_enemigos", "Зона появления врагов")
			variable_struct_set(L, "cuevas", "Пещеры")
			variable_struct_set(L, "desactivado", "Выключено")
			variable_struct_set(L, "desactivar", "Деактивировать")
			recurso_descripcion[idr_acero] = "Полезный ресурс для строительства средней инфраструктуры."
			edificio_descripcion[id_almacen] = "Хранит ресурсы для последующего использования"
			dron_descripcion[idd_arana] = "Стреляет лазером по ближайшим врагам"
			recurso_descripcion[idr_arena] = "Необходима для производства кремния и бетона."
			recurso_descripcion[idr_barril_con_agua] = "Бочка с водой, полезна для хранения и распределения воды"
			recurso_descripcion[idr_barril_con_agua_salada] = "Бочка с солёной водой, полезна для хранения y распределения"
			recurso_descripcion[idr_barril_con_lava] = "Бочка с лавой, полезна для хранения и распределения"
			recurso_descripcion[idr_barril_con_petroleo] = "Бочка с нефтью, полезна для хранения и распределения"
			recurso_descripcion[idr_barril_con_acido] = "Бочка с кислотой, полезна для хранения и распределения"
			edificio_descripcion[id_bateria] = "Необходима для производства всех типов дронов."
			edificio_descripcion[id_bomba_hidraulica] = "Добывает жидкости из-под земли, используя энергию."
			edificio_descripcion[id_bomba_de_evaporacion] = "Медленно добывает воду через испарение."
			dron_descripcion[idd_bombardero] = "Пролетает над врагами, сбрасывая разрушительные взрывчатые вещества по прямой линии"
			recurso_descripcion[idr_bronce] = "Полезный ресурс для строительства средней инфраструктуры."
			edificio_descripcion[id_cable] = "Соединяет здания с энергосетью."
			recurso_descripcion[idr_carbon] = "Базовое топливо. Используется в печах и генераторах."
			edificio_descripcion[id_cinta_grande] = "Перевозит дроны между заводами"
			edificio_descripcion[id_cinta_magnetica] = "Улучшенный конвейер, перевозящий больше предметов."
			edificio_descripcion[id_cinta_transportadora] = "Перемещает ресурсы из одного места в другое."
			recurso_descripcion[idr_cobre] = "Базовый ресурс, необходимый для первых зданий. Может быть переработан в бронзу."
			recurso_descripcion[idr_compuesto_incendiario] = "Продвинутое топливо, эффективнее и долговечнее угля."
			recurso_descripcion[idr_concreto] = "Используется для строительства средней инфраструктуры."
			edificio_descripcion[id_cruce] = "Позволяет конвейерным лентам пересекаться"
			edificio_descripcion[id_deposito] = "Хранит большое количество жидкости."
			dron_descripcion[idd_dron] = "Перевозит ресурсы между грузовыми портами"
			edificio_descripcion[id_embotelladora] = "Наполняет и опустошает бочки с жидкостями"
			edificio_descripcion[id_energia_infinita] = "Производит энергию с помощью магии."
			edificio_descripcion[id_enrutador] = "Распределяет ресурсы в выбранном направлении."
			edificio_descripcion[id_ensambladora] = "Использует медь и кремний для производства компонентов."
			recurso_descripcion[idr_explosivo] = "Приближается к цели и взрывается, нанося урон"
			edificio_descripcion[id_extractor_atmosferico] = "Извлекает воду из атмосферы, идеально подходит для мест, где её сложно получить"
			edificio_descripcion[id_fabrica_de_concreto] = "Производит бетон из песка, камня и воды"
			edificio_descripcion[id_fabrica_de_drones] = "Производит транспортные дроны. Нужно много энергии, кремния и батарей."
			edificio_descripcion[id_fabrica_de_drones_grande] = "Позволяет производить более крупные дроны с использованием кислоты"
			edificio_descripcion[id_generador] = "Производит энергию, используя топливо."
			edificio_descripcion[id_generador_geotermico] = "Производит энергию, испаряя воду. Должен стоять на лаве."
			recurso_descripcion[idr_hierro] = "Базовый ресурс, необходимый для ранних зданий."
			edificio_descripcion[id_horno] = "Использует топливо для выплавки бронзы, стали и кремния."
			edificio_descripcion[id_horno_de_lava] = "Плавит быстрее, используя тепло лавы."
			edificio_descripcion[id_lanzallamas] = "Использует горючие ресурсы, чтобы поджигать врагов. Может быть усилен нефтью."
			edificio_descripcion[id_laser] = "Испускает постоянный лазер. Урон зависит от доступной энергии."
			edificio_descripcion[id_liquido_infinito] = "Создаёт выбранную жидкость с помощью магии."
			edificio_descripcion[id_memoria] = "Хранит до 128 значений."
			edificio_descripcion[id_mensaje] = "Позволяет писать сообщения."
			edificio_descripcion[id_mortero] = "Стреляет взрывными снарядами по дальним целям."
			edificio_descripcion[id_muro] = "Отвлекает врагов, пока оборона уничтожает их."
			edificio_descripcion[id_muro_reforzado] = "Улучшенная версия стены — прочнее и лучше"
			edificio_descripcion[id_modulo] = "Улучшает характеристики здания"
			recurso_descripcion[idr_modulos] = "Исследуйте модули и постройте два сборщика рядом, чтобы начать их производство"
			edificio_descripcion[id_nucleo] = "Командный центр. Все ресурсы хранятся здесь. Его необходимо защищать любой ценой."
			edificio_descripcion[id_onda_de_choque] = "Заряжает и выпускает мощную ударную волну, которая наносит урон и замедляет всех врагов в радиусе действия."
			edificio_descripcion[id_overflow] = "Перенаправляет ресурсы, когда линия переполнена."
			edificio_descripcion[id_panel_solar] = "Производит чистую энергию от солнца."
			edificio_descripcion[id_pantalla] = "Позволяет отображать изображения, переданные процессором"
			edificio_descripcion[id_perforadora_de_petroleo] = "Производит нефть в любом месте карты за высокую цену."
			recurso_descripcion[idr_piedra] = "Необходима для производства бетона. Может быть измельчена в песок."
			recurso_descripcion[idr_piedra_cuprica] = "Можно использовать как обычный камень или очистить для получения меди."
			recurso_descripcion[idr_piedra_ferrica] = "Можно использовать как камень или очистить для получения железа."
			recurso_descripcion[idr_piedra_sulfatada] = "Можно использовать как камень, но незаменима в продвинутом производстве."
			edificio_descripcion[id_planta_desalinizadora] = "Очищает солёную воду, извлекая соль и пресную воду"
			edificio_descripcion[id_planta_nuclear] = "Потребляет 1 часть обогащённого и 20 частей обеднённого урана, а также воду, создавая огромную энергию."
			edificio_descripcion[id_planta_quimica] = "Позволяет выбирать рецепты для производства химических материалов."
			edificio_descripcion[id_planta_de_enriquecimiento] = "Позволяет перерабатывать уран, постоянно потребляя большие объёмы воды и энергии"
			edificio_descripcion[id_planta_de_reciclaje] = "Позволяет перерабатывать часть ресурсов от уничтоженных поблизости врагов"
			recurso_descripcion[idr_plastico] = "Лёгкий материал, используется в производстве дронов."
			edificio_descripcion[id_procesador] = "Обрабатывает логические инструкции."
			edificio_descripcion[id_puerto_de_carga] = "Соединяет порты, позволяя дронам переносить ресурсы."
			edificio_descripcion[id_recurso_infinito] = "Создаёт ресурсы с помощью магии."
			edificio_descripcion[id_refineria_de_metales] = "Очищает медную или железную руду с помощью кислоты."
			edificio_descripcion[id_refineria_de_petroleo] = "С помощью фракционной перегонки извлекает пластик, топливо и серу из нефти"
			dron_descripcion[idd_reparador] = "Ремонтирует повреждённые здания"
			edificio_descripcion[id_rifle] = "Дальнобойная турель. Стреляет бронзой, сталью или ураном."
			recurso_descripcion[idr_sal] = "Полезный ресурс для улучшения других промышленных процессов, таких как химический завод, нефтепереработка и производство кремния"
			edificio_descripcion[id_selector] = "Пропускает только один выбранный ресурс, перенаправляя остальные."
			recurso_descripcion[idr_silicio] = "Используется для солнечных панелей, дронов и микросхем."
			edificio_descripcion[id_silo_de_misiles] = "Здесь можно создать ядерную ракету, используя сталь, взрывчатку, нефть и уран, обогащённый"
			edificio_descripcion[id_taladro] = "Добывает медь, железо и уголь бесплатно. Может быть усилен водой."
			edificio_descripcion[id_taladro_electrico] = "Улучшенный бур, который также добывает камень и песок из земли, но потребляет энергию. Может быть усилен водой"
			edificio_descripcion[id_taladro_de_explosion] = "Использует взрывчатку для добычи одного ресурса с каждой клетки в области."
			dron_descripcion[idd_tanque] = "Тяжёлая осадная единица, стреляющая взрывчаткой и наносящая урон вокруг себя"
			dron_descripcion[idd_titan] = "Максимальная наземная единица, ведущая дальнобойный взрывной обстрел"
			edificio_descripcion[id_torre_reparadora] = "Использует энергию для ремонта зданий лазером."
			edificio_descripcion[id_torre_basica] = "Простая оборонная турель; стреляет медью или железом."
			edificio_descripcion[id_torre_de_alta_tension] = "Передаёт энергию на большие расстояния."
			edificio_descripcion[id_triturador] = "Дробит камень в песок."
			edificio_descripcion[id_tuberia] = "Перемещает жидкости между зданиями."
			edificio_descripcion[id_tuberia_subterranea] = "Проводит жидкости под землёй."
			edificio_descripcion[id_turbina] = "Производит энергию, используя топливо и воду."
			edificio_descripcion[id_tunel] = "Пропускает ресурсы под землёй, позволяя строить сверху."
			edificio_descripcion[id_tunel_salida] = "Пропускает ресурсы под землёй, позволяя строить сверху."
			recurso_descripcion[idr_uranio_bruto] = "Необработанный уран. Можно переработать на обогащённый и обеднённый."
			recurso_descripcion[idr_uranio_empobrecido] = "Уран-238. Используется на АЭС и как боеприпас."
			recurso_descripcion[idr_uranio_enriquecido] = "Уран-235. Используется для производства энергии на АЭС."
			variable_struct_set(L, "desierto", "Пустыня")
			variable_struct_set(L, "dificil", "Сложная")
			variable_struct_set(L, "dificultad", "Сложность")
			variable_struct_set(L, "editor_Reemplazar", "Заменить")
			variable_struct_set(L, "editor_activar_oleadas", "Активировать волны")
			variable_struct_set(L, "editor_add", "Добавить")
			variable_struct_set(L, "editor_add_text", "Добавить текст")
			variable_struct_set(L, "editor_al_rededor", "Вокруг")
			variable_struct_set(L, "editor_borde", "Границы")
			variable_struct_set(L, "editor_cambiar_base", "Изменить позицию базы")
			variable_struct_set(L, "editor_cambiar_oleadas", "Включить / Выключить волны")
			variable_struct_set(L, "editor_cambiar_zona", "Изменить зону появления врагов")
			variable_struct_set(L, "editor_carga_inicial", "Начальная загрузка")
			variable_struct_set(L, "editor_cargar", "Загрузить карту")
			variable_struct_set(L, "editor_clic", "ЛКМ чтобы")
			variable_struct_set(L, "editor_clic_aplicar", "Клик для применения")
			variable_struct_set(L, "editor_con", "на")
			variable_struct_set(L, "editor_configuracion", "Настройки")
			variable_struct_set(L, "editor_cualquiera", "любой")
			variable_struct_set(L, "editor_de", "из")
			variable_struct_set(L, "editor_del_tiempo", "времени")
			variable_struct_set(L, "editor_desactivar_oleadas", "Деактивировать волны")
			variable_struct_set(L, "editor_deshabilitar", "Выключить таймер")
			variable_struct_set(L, "editor_edificios_disponibles", "доступные здания")
			variable_struct_set(L, "editor_editar_mapa", "Редактировать карту")
			variable_struct_set(L, "editor_el", "")
			variable_struct_set(L, "editor_eliminar_mena", "Удалить жилу ресурсов")
			variable_struct_set(L, "editor_eliminar_objetivo", "Удалить цель")
			variable_struct_set(L, "editor_enemigos", "врагов")
			variable_struct_set(L, "editor_generar_terreno", "Сгенерировать ландшафт")
			variable_struct_set(L, "editor_guardar", "Сохранить карту")
			variable_struct_set(L, "editor_habilitar", "Включить таймер")
			variable_struct_set(L, "editor_info", "Просмотреть информацию")
			variable_struct_set(L, "editor_luego_de", "после")
			variable_struct_set(L, "editor_manchas", "Пятна ландшафта")
			variable_struct_set(L, "editor_menas", "Жилы ресурсов")
			variable_struct_set(L, "editor_mostrar", "показать")
			variable_struct_set(L, "editor_mover_a", "Переместить в")
			variable_struct_set(L, "editor_mover_camara", "Переместить камеру")
			variable_struct_set(L, "editor_multiplicador_vida", "Множитель здоровья врагов")
			variable_struct_set(L, "editor_no", "Нет")
			variable_struct_set(L, "editor_nuevo_objetivo", "Название цели")
			variable_struct_set(L, "editor_objetivo", "Цель")
			variable_struct_set(L, "editor_objetivos", "Цели")
			variable_struct_set(L, "editor_ocultar", "скрыть")
			variable_struct_set(L, "editor_on", "на")
			variable_struct_set(L, "editor_primera_ronda", "Время первой волны")
			variable_struct_set(L, "editor_reemplazar", "заменить")
			variable_struct_set(L, "editor_ruido", "Шум")
			variable_struct_set(L, "editor_seed", "Сид")
			variable_struct_set(L, "editor_siguiente_ronda", "Время между волнами")
			variable_struct_set(L, "editor_size", "размером")
			variable_struct_set(L, "editor_size_map", "Размер карты")
			variable_struct_set(L, "editor_terreno_base", "Базовый ландшафт")
			variable_struct_set(L, "editor_texto_victoria", "Текст победы")
			variable_struct_set(L, "editor_veces", "раз")
			variable_struct_set(L, "enciclopedia_aerea", "Воздушная единица")
			variable_struct_set(L, "enciclopedia_combustible", "Топливо для")
			variable_struct_set(L, "enciclopedia_construir", "Построить")
			variable_struct_set(L, "enciclopedia_consume", "Потребляет")
			variable_struct_set(L, "enciclopedia_coste_construccion", "Стоимость строительства")
			variable_struct_set(L, "enciclopedia_edificios", "Здания")
			variable_struct_set(L, "enciclopedia_inutil", "Не используется в ядре")
			variable_struct_set(L, "enciclopedia_investigar", "Расследовать")
			variable_struct_set(L, "enciclopedia_necesario_para_construir", "Необходимо для строительства")
			variable_struct_set(L, "enciclopedia_necesario_para_producir", "Необходимо для производства")
			variable_struct_set(L, "enciclopedia_produce", "Производит")
			variable_struct_set(L, "enciclopedia_producido_en", "Производится в")
			variable_struct_set(L, "enciclopedia_recursos", "Ресурсы")
			variable_struct_set(L, "enciclopedia_size", "Размер")
			variable_struct_set(L, "enciclopedia_tecnologia", "технология")
			variable_struct_set(L, "enciclopedia_unidades", "Юниты")
			variable_struct_set(L, "enciclopedia_usado_en", "Используется в")
			variable_struct_set(L, "enciclopedia_vida", "Макс. здоровье")
			variable_struct_set(L, "energia_consumida", "Потреблённая энергия")
			variable_struct_set(L, "energia_perdida", "Потерянная энергия")
			variable_struct_set(L, "energia_producida", "Произведённая энергия")
			variable_struct_set(L, "facil", "Лёгкая")
			variable_struct_set(L, "flujo_almacenado", "Запасено")
			variable_struct_set(L, "flujo_consumo", "Потребление")
			variable_struct_set(L, "flujo_flujo", "Поток")
			variable_struct_set(L, "flujo_generacion", "Генерация")
			variable_struct_set(L, "flujo_liquido", "жидкость")
			variable_struct_set(L, "flujo_sin_liquido", "Нет жидкости")
			variable_struct_set(L, "game_activar", "Активировать")
			variable_struct_set(L, "game_creando_dron", "Создание")
			variable_struct_set(L, "game_enciclopedia", "Энциклопедия")
			variable_struct_set(L, "game_first_wave", "для первой волны")
			variable_struct_set(L, "game_limite_dron", "Лимит дронов достигнут")
			variable_struct_set(L, "game_next_wave", "для следующей волны")
			variable_struct_set(L, "game_producira", "Будет производить")
			variable_struct_set(L, "game_puerto_carga", "Соединяется с другим портом погрузки")
			variable_struct_set(L, "game_vincular_procesador", "Связывается с любым зданием")
			variable_struct_set(L, "islas", "Острова")
			variable_struct_set(L, "liquido_Agua", "Вода")
			variable_struct_set(L, "liquido_Agua salada", "Солёная вода")
			variable_struct_set(L, "liquido_Lava", "Лава")
			variable_struct_set(L, "liquido_Petróleo", "Нефть")
			variable_struct_set(L, "liquido_Ácido", "Кислота")
			variable_struct_set(L, "marcar_objetivo", "Установить цель")
			variable_struct_set(L, "medio", "Средняя")
			variable_struct_set(L, "menu_cargar_escenario", "Загрузить карту")
			variable_struct_set(L, "menu_claves", "Песочница")
			variable_struct_set(L, "menu_editor", "Редактор")
			variable_struct_set(L, "menu_hexdustry", "HEXDUSTRY")
			variable_struct_set(L, "menu_html", "Сниженная производительность в HTML5")
			variable_struct_set(L, "menu_juego_rapido", "Быстрая игра")
			variable_struct_set(L, "menu_modo_infinito", "Бесконечный режим")
			variable_struct_set(L, "menu_modo_misiones", "Режим миссий")
			variable_struct_set(L, "menu_modo_oleadas", "Режим волн")
			variable_struct_set(L, "menu_numero_oleadas", "Количество волн")
			variable_struct_set(L, "menu_precio_tecnologia", "Цена Технологии")
			variable_struct_set(L, "menu_sin_archivos", "Сценариев пока нет")
			variable_struct_set(L, "menu_tutorial", "Обучение")
			variable_struct_set(L, "mision_enemigos", "врагов")
			variable_struct_set(L, "mision_tiempo", "Осталось времени")
			variable_struct_set(L, "modulo_aturdir", "Длительность оглушения увеличена на 33")
			variable_struct_set(L, "modulo_cadencia", "Скорострельность увеличена на 30")
			variable_struct_set(L, "modulo_canalizar", "Каналы работают на 50%")
			variable_struct_set(L, "modulo_dmg", "Урон увеличен на 30")
			variable_struct_set(L, "modulo_edificio_con_modulo", "В этом здании уже установлен")
			variable_struct_set(L, "modulo_edificio_sin_modulo", "Это здание не поддерживает")
			variable_struct_set(L, "modulo_extraccion", "Скорость добычи увеличена на 40")
			variable_struct_set(L, "modulo_mas_liquido", "Производит на 20% больше")
			variable_struct_set(L, "modulo_menos_electricidad", "Потребление энергии снижено на 25")
			variable_struct_set(L, "modulo_menos_liquido", "Потребление снижено на 25%")
			variable_struct_set(L, "modulo_nuclear", "Автоматически отключает установку при отсутствии")
			variable_struct_set(L, "modulo_nucleo", "Увеличивает максимальное количество союзных дронов на 2")
			variable_struct_set(L, "modulo_produccion", "Производит на 30% быстрее")
			variable_struct_set(L, "modulo_reparadora", "Ремонтирует на 20% быстрее")
			variable_struct_set(L, "modulo_sal", "Добывает на 50% больше")
			variable_struct_set(L, "modulo_sin_edificio", "Требуется здание")
			variable_struct_set(L, "nieve", "Снег")
			variable_struct_set(L, "nuevo_archivo", "Новый файл")
			objetivos_nombre[0] = "получить"
			objetivos_nombre[1] = "иметь на складе"
			objetivos_nombre[2] = "построить"
			objetivos_nombre[3] = "иметь построенным"
			objetivos_nombre[4] = "убить"
			objetivos_nombre[5] = "без цели"
			objetivos_nombre[6] = "нажать ADWS"
			objetivos_nombre[7] = "загрузить здание"
			objetivos_nombre[8] = "уничтожить здание"
			variable_struct_set(L, "pausa", "П А У З А")
			variable_struct_set(L, "pausa_UI", "Интерфейс")
			variable_struct_set(L, "pausa_activar", "Включить")
			variable_struct_set(L, "pausa_animacion", "анимации местности")
			variable_struct_set(L, "pausa_continuar", "Нажмите Esc чтобы продолжить")
			variable_struct_set(L, "pausa_desactivar", "Выключить")
			variable_struct_set(L, "pausa_enciclopedia", "\"Y\" чтобы открыть энциклопедию")
			variable_struct_set(L, "pausa_humo", "дым")
			variable_struct_set(L, "pausa_iluminacion", "освещение")
			variable_struct_set(L, "pausa_info", "дополнительная информация")
			variable_struct_set(L, "pausa_liquido", "\"I\" чтобы увидеть сети жидкости")
			variable_struct_set(L, "pausa_paredes", "текстуры стен")
			variable_struct_set(L, "pausa_red", "\"O\" чтобы увидеть энергосеть")
			variable_struct_set(L, "pausa_reparar", "\"Q\" для восстановления зданий")
			variable_struct_set(L, "pausa_sonido", "звук")
			variable_struct_set(L, "personalizado", "Пользовательская")
			planta_quimica_descripcion[0] = "Потребляет сульфатированный камень и энергию для производства кислоты"
			planta_quimica_descripcion[1] = "Использует зажигательный состав и кислоту для производства взрывчатки"
			planta_quimica_descripcion[2] = "Использует кислоту, медь и энергию для производства батарей"
			planta_quimica_receta[0] = "Кислота"
			planta_quimica_receta[1] = "Взрывчатка"
			planta_quimica_receta[2] = "Батареи"
			variable_struct_set(L, "praderas", "Луга")
			variable_struct_set(L, "procesador_cargar", "Загрузить код")
			variable_struct_set(L, "procesador_guardar", "Сохранить код")
			variable_struct_set(L, "procesador_next_step", "Следующая инструкция")
			variable_struct_set(L, "procesador_add", "Добавить")
			variable_struct_set(L, "procesador_subir", "Вверх")
			variable_struct_set(L, "procesador_clonar", "Клонировать")
			variable_struct_set(L, "procesador_borrar", "Удалить")
			variable_struct_set(L, "procesador_vincular", "Связать здания")
			variable_struct_set(L, "procesador_continue", "Продолжить")
			variable_struct_set(L, "procesador_set", "Установить")
			variable_struct_set(L, "procesador_random", "Случайное значение")
			variable_struct_set(L, "procesador_to", "в")
			variable_struct_set(L, "procesador_if", "Если")
			variable_struct_set(L, "procesador_is", "равно")
			variable_struct_set(L, "procesador_is_not", "не равно")
			variable_struct_set(L, "procesador_jump", "переход на строку")
			variable_struct_set(L, "procesador_control", "Управление")
			variable_struct_set(L, "procesador_to_set", "для установки")
			variable_struct_set(L, "procesador_from", "из")
			variable_struct_set(L, "procesador_write", "Записать")
			variable_struct_set(L, "procesador_to_value_of_cell", "в значение ячейки")
			variable_struct_set(L, "procesador_into_value_of_cell", "в значение ячейки")
			variable_struct_set(L, "procesador_of", "из")
			procesador_instrucciones_nombre[0] = "Продолжить"
			procesador_instrucciones_nombre[1] = "Назначить переменную"
			procesador_instrucciones_nombre[2] = "Операции с одной переменной"
			procesador_instrucciones_nombre[3] = "Операции с двумя переменными"
			procesador_instrucciones_nombre[4] = "Перейти к строке"
			procesador_instrucciones_nombre[5] = "Чтение информации о здании"
			procesador_instrucciones_nombre[6] = "Управление зданием"
			procesador_instrucciones_nombre[7] = "Чтение данных из памяти"
			procesador_instrucciones_nombre[8] = "Запись данных в память"
			procesador_instrucciones_nombre[9] = "Отрисовка на экран"
			variable_struct_set(L, "recursos_obtenidos", "Полученные ресурсы")
			variable_struct_set(L, "red_bateria", "Батарея")
			variable_struct_set(L, "red_consumo", "Потребление")
			variable_struct_set(L, "red_energia", "энергия")
			variable_struct_set(L, "red_generacion", "Генерация")
			variable_struct_set(L, "red_red", "Сеть")
			variable_struct_set(L, "salir", "Выходить")
			variable_struct_set(L, "show_menu_invertir", "Инвертировать")
			variable_struct_set(L, "show_menu_ningun_liquido", "Нет жидкости")
			variable_struct_set(L, "show_menu_no_disponible", "Пока недоступно")
			variable_struct_set(L, "show_menu_receta", "Рецепт")
			variable_struct_set(L, "show_menu_unidad", "Юнит")
			variable_struct_set(L, "tiempo", "Время")
			variable_struct_set(L, "volver", "Назад")
			variable_struct_set(L, "win_derrota", "Поражение")
			variable_struct_set(L, "win_dmg_causado", "Нанесённый урон")
			variable_struct_set(L, "win_dmg_curado", "Восстановленный урон")
			variable_struct_set(L, "win_dmg_recibido", "Полученный урон")
			variable_struct_set(L, "win_drones", "Созданные дроны")
			variable_struct_set(L, "win_drones_perdidos", "Потерянные дроны")
			variable_struct_set(L, "win_edificios", "Построенные здания")
			variable_struct_set(L, "win_edificios_destruidos", "Уничтоженные здания")
			variable_struct_set(L, "win_edificios_perdidos", "Потерянные здания")
			variable_struct_set(L, "win_enemigos", "Уничтоженные враги")
			variable_struct_set(L, "win_militar", "Военные")
			variable_struct_set(L, "win_misiones", "Выполненные цели")
			variable_struct_set(L, "win_reintentar", "Повторить")
			variable_struct_set(L, "win_salir", "В меню")
			variable_struct_set(L, "win_seguir_jugando", "Продолжить игру?")
			variable_struct_set(L, "win_siguiente_mision", "Следующая миссия")
			variable_struct_set(L, "win_tecnologias", "Изученные технологии")
			variable_struct_set(L, "win_tiempo", "Время")
			variable_struct_set(L, "win_victoria", "Победа")
			variable_struct_set(L, "editar_desde_adentro", "Редактировать изнутри")
		}
		if 3 = 3
			exit
		function format(a){
			a = string_lower(string_replace_all(a, " ", "_"))
			a = string_replace_all(a, "á", "a")
			a = string_replace_all(a, "é", "e")
			a = string_replace_all(a, "í", "i")
			a = string_replace_all(a, "ó", "o")
			a = string_replace_all(a, "ú", "u")
			a = string_replace_all(a, "ü", "u")
			a = string_replace_all(a, "ñ", "n")
			return a
		}
		var variables = struct_get_names(L), len = array_length(variables), abba = string_length("descripcion_"), abba2 = string_length("objetivo_"), abba3 = string_length("procesador_"), cc = 0, co = 0, cp = 0, cq = 0, cq2 = 0
		array_sort(variables, function(elm1, elm2){return elm1 < elm2 ? -1 : 1})
		for(var a = 0; a < len; a++){
			var this_variable = variables[a]
			if string_starts_with(this_variable, "descripcion_"){
				this_variable = string_delete(this_variable, 0, abba)
				if array_contains(edificio_nombre, this_variable)
					show_debug_message($"edificio_descripcion[id_{format(this_variable)}] = \"{variable_struct_get(L, variables[a])}\"")
				else if array_contains(recurso_nombre, this_variable)
					show_debug_message($"recurso_descripcion[idr_{format(this_variable)}] = \"{variable_struct_get(L, variables[a])}\"")
				else if array_contains(dron_nombre, this_variable)
					show_debug_message($"dron_descripcion[idd_{format(this_variable)}] = \"{variable_struct_get(L, variables[a])}\"")
			}
			else if string_starts_with(this_variable, "objetivo_"){
				this_variable = string_delete(this_variable, 0, abba2)
				if array_contains(objetivos_nombre, this_variable)
					show_debug_message($"objetivos_nombre[{co++}] = \"{variable_struct_get(L, variables[a])}\"")
			}
			else if string_starts_with(this_variable, "procesador_"){
				this_variable = string_delete(this_variable, 0, abba3)
				if array_contains(procesador_instrucciones_nombre, this_variable)
					show_debug_message($"procesador_instrucciones_nombre[{cp++}] = \"{variable_struct_get(L, variables[a])}\"")
			}
			else if string_starts_with(this_variable, "planta_quimica_receta "){
				this_variable = string_delete(this_variable, 0, string_length("planta_quimica_receta "))
				show_debug_message($"planta_quimica_receta[{real(this_variable)}] = \"{variable_struct_get(L, variables[a])}\"")
			}
			else if string_starts_with(this_variable, "planta_quimica_descripcion "){
				this_variable = string_delete(this_variable, 0, string_length("planta_quimica_descripcion "))
				show_debug_message($"planta_quimica_descripcion[{real(this_variable)}] = \"{variable_struct_get(L, variables[a])}\"")
			}
			else{
				if array_contains(edificio_nombre, this_variable)
					show_debug_message($"edificio_nombre[id_{format(this_variable)}] = \"{variable_struct_get(L, variables[a])}\"")
				else if array_contains(recurso_nombre, this_variable)
					show_debug_message($"recurso_nombre[idr_{format(this_variable)}] = \"{variable_struct_get(L, variables[a])}\"")
				else if array_contains(terreno_nombre, this_variable)
					show_debug_message($"terreno_nombre[idt_{format(this_variable)}] = \"{variable_struct_get(L, variables[a])}\"")
				else if array_contains(dron_nombre, this_variable)
					show_debug_message($"dron_nombre[idd_{format(this_variable)}] = \"{variable_struct_get(L, variables[a])}\"")
				else if array_contains(liquido_nombre, this_variable)
					show_debug_message($"liquido_nombre[idl_{string_lower(this_variable)}] = \"{variable_struct_get(L, variables[a])}\"")
				else if array_contains(categoria_nombre, this_variable)
					show_debug_message($"categoria_nombre[{cc++}] = \"{variable_struct_get(L, variables[a])}\"")
				else
					show_debug_message($"variable_struct_set(L, \"{this_variable}\", \"{variable_struct_get(L, variables[a])}\")")
			}
		}
	}
}