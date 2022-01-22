
-- spacesuit repair recipes
local function repair_recipe(partname)
	minetest.register_craft({
		type = "shapeless",
		output = partname,
		recipe = {
			"vacuum:air_bottle",
			partname
		},
		replacements = {
			{"vacuum:air_bottle", "vessels:steel_bottle"}
		}
	})
end

repair_recipe("spacesuit:helmet")
repair_recipe("spacesuit:chestplate")
repair_recipe("spacesuit:pants")
repair_recipe("spacesuit:boots")

if minetest.get_modpath("unified_inventory") then
	unified_inventory.register_craft({
		type = "filling",
		output = "spacesuit:helmet 1 1",
		items = {"spacesuit:helmet 1 60000"},
		width = 0,
	})
	unified_inventory.register_craft({
		type = "filling",
		output = "spacesuit:chestplate 1 1",
		items = {"spacesuit:chestplate 1 60000"},
		width = 0,
	})
	unified_inventory.register_craft({
		type = "filling",
		output = "spacesuit:pants 1 1",
		items = {"spacesuit:pants 1 60000"},
		width = 0,
	})
	unified_inventory.register_craft({
		type = "filling",
		output = "spacesuit:boots 1 1",
		items = {"spacesuit:boots 1 60000"},
		width = 0,
	})
end
