
minetest.register_craftitem("vacuum:air_bottle", {
	description = "Air Bottle",
	inventory_image = vacuum.air_bottle_image
})

if minetest.get_modpath("unified_inventory") then
	unified_inventory.register_craft_type("filling", {
		description = "Filling",
		icon = "vacuum_airpump_front.png",
		width = 1,
		height = 1,
	})
	unified_inventory.register_craft({
		type = "filling",
		output = "vacuum:air_bottle",
		items = {"vessels:steel_bottle"},
		width = 0,
	})
end
