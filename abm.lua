

local depressurizable_nodes = {
	"group:door", "group:wool"
}

local is_pos_in_space = function(pos)
	return pos.y > vacuum.space_height + 40
end

function pressurize(pos, i)
	if i <= 0 then
		return
	end

	local node = minetest.find_node_near(pos, 1, {"vacuum:vacuum"})
	if node ~= nil then
		-- vacuum found, pressurize it
		minetest.set_node(node, {name = "air"})
		pressurize(node, i - 1)
	else
		-- no vacuum found, search for not airthight nodes
		node = minetest.find_node_near(pos, 1, depressurizable_nodes)
		if node ~= nil then
			-- pressurize around it
			pressurize(node, i - 1)
		end
	end
end

minetest.register_abm({
        label = "space air pump",
	nodenames = {"vacuum:airpump"},
	neighbors = {"vacuum:vacuum"},
	interval = 3,
	chance = 1,
	action = function(pos)
		-- TODO: check if enabled
		-- TODO: check height?
		minetest.after(0, function()
			pressurize(pos, 30)
		end)
	end
})


minetest.register_abm({
        label = "space vacuum",
	nodenames = {"air"},
	neighbors = {"vacuum:vacuum"},
	interval = 1,
	chance = 3,
	action = function(pos)
		if not is_pos_in_space(pos) then
			-- not in space
			return
		end

		minetest.set_node(pos, {name = "vacuum:vacuum"})
	end
})



minetest.register_abm({
        label = "space vacuum depressurize",
	nodenames = depressurizable_nodes,
	neighbors = {"vacuum:vacuum"},
	interval = 1,
	chance = 2,
	action = function(pos)
		if not is_pos_in_space(pos) then
			-- on earth: TODO: replace vacuum with air
			return
		end

		-- in space: replace air with vacuum
		local node = minetest.find_node_near(pos, 1, {"air"})

		if node ~= nil then
			minetest.set_node(node, {name = "vacuum:vacuum"})
		end
	end
})


