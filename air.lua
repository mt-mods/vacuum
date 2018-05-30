-- buffer air (for pump)

minetest.register_node("vacuum:air", {
	description = "Airpump buffer air",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drawtype = "glasslike",
	tiles = {"vacuum_air.png"},
	groups = {not_in_creative_inventory=0},
	paramtype = "light",
	sunlight_propagates = true,
	on_timer = function(pos,elapsed)
		minetest.set_node(pos, {name="air"})
	end
})
