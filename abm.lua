

-- air nodes near vacuum get depressurized immediately (vacuum:vacuum)

minetest.register_abm({
        label = "space vacuum",
	nodenames = {"air"},
	neighbors = {"vacuum:vacuum"},
	interval = 5,
	chance = 1,
	action = function(pos)
		if pos.y < vacuum.space_height + 40 then
			return
		end

		minetest.set_node(pos, {name = "vacuum:vacuum"})
	end
})

function pressurize(pos, i)
	-- search for existing air
	local node = minetest.find_node_near(pos, 1, {"vacuum:vacuum"})
	if node ~= nil and i > 0 then
		-- air found, pressurize around it
		minetest.set_node(node, {name = "air"})
		pressurize(node, i-1)
	end
end

minetest.register_abm({
        label = "space air pump",
	nodenames = {"vacuum:airpump"},
	interval = 1,
	chance = 1,
	action = function(pos)
		pressurize(pos, 20)
	end
})

