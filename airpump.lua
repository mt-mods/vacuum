
minetest.register_node("vacuum:airpump", {
	description = "Air pump",
	tiles = {"vacuum_airpump.png"},
	paramtype = "light",
	groups = {cracky=3,oddly_breakable_by_hand=3},
	sounds = default.node_sound_glass_defaults()
})