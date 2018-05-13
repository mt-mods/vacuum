

minetest.register_abm({
        label = "space air pump",
	nodenames = {"vacuum:airpump"},
	neighbors = {"vacuum:vacuum"},
	interval = 1,
	chance = 1,
	action = function(pos)
		minetest.set_node(pos, {name = "air"})
	end
})

minetest.register_abm({
        label = "space vacuum",
	nodenames = {"air"},
	neighbors = {"vacuum:vacuum"},
	interval = 1,
	chance = 1,
	action = function(pos)
		if pos.y < vacuum.space_height + 40 then
			return
		end

		minetest.set_node(pos, {name = "vacuum:vacuum"})
	end
})
