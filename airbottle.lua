


minetest.register_node("vacuum:air_bottle", {
	description = "Air Bottle",
	drawtype = "plantlike",
	tiles = {"vessels_steel_bottle.png^[colorize:#0000FFAA"},
	inventory_image = "vessels_steel_bottle.png^[colorize:#0000FFAA",
	wield_image = "vessels_steel_bottle.png^[colorize:#0000FFAA",
	paramtype = "light",
	is_ground_content = false,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.3, 0.25}
	},
	groups = {vessel = 1, dig_immediate = 3, attached_node = 1},
	sounds = default.node_sound_defaults(),
})