


minetest.register_craftitem("vacuum:air_bottle", {
	description = "Air Bottle",
	inventory_image = vacuum.air_bottle_image
})

minetest.register_craft({
	output = "vacuum:air_bottle",
	recipe = {
		{"vessels:steel_bottle", "vessels:steel_bottle", "vessels:steel_bottle"},
		{"", "wool:blue", ""},
		{"", "", ""}
	}
})