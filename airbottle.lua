
minetest.register_tool("vacuum:airbottle", {
	description = "Compressed air bottle",
	inventory_image = "vessels_steel_bottle.png",
	groups = { vessel = 1 }
})

minetest.register_node("vacuum:airbottle_empty", {
	description = "Compressed air bottle (empty)",
	inventory_image = "vessels_steel_bottle.png",
	groups = { vessel = 1 }
})


minetest.register_craft({
	output = "vacuum:airbottle",
	type = "shapeless",
	recipe = {"vessels:steel_bottle", "group:leaves"}
})

minetest.register_craft({
	output = "vacuum:airbottle",
	type = "shapeless",
	recipe = {"vacuum:airbottle_empty", "group:leaves"}
})