

local leaky_nodes = {
	"group:door", "group:wool", "group:wood",
	"group:tree", "group:soil",
	"group:pipe", "group:tube",
	"group:technic_lv_cable", "group:technic_mv_cable", "group:technic_hv_cable"
}

-- returns true, if in space (with safety margin for abm)
local is_pos_in_space = function(pos)
	return pos.y > vacuum.space_height + 40
end

local is_pos_on_earth = function(pos)
	return pos.y < vacuum.space_height - 40
end


-- vacuum propagation
minetest.register_abm({
        label = "space vacuum",
	nodenames = {"air"},
	neighbors = {"vacuum:vacuum"},
	interval = 1,
	chance = 3,
	action = function(pos)
		if is_pos_on_earth(pos) then
			-- not in space, pressurize
			local node = minetest.find_node_near(pos, 1, {"vacuum:vacuum"})

			if node ~= nil then
				minetest.set_node(node, {name = "air"})
			end
		elseif is_pos_in_space(pos) then
			-- in space, evacuate air
			minetest.set_node(pos, {name = "vacuum:vacuum"})
		end
	end
})

-- soil in vacuum
minetest.register_abm({
        label = "space vacuum soil dry",
	nodenames = {"group:soil"},
	neighbors = {"vacuum:vacuum"},
	interval = 1,
	chance = 2,
	action = function(pos)
		minetest.set_node(pos, {name = "default:gravel"})
	end
})

-- plants in vacuum
minetest.register_abm({
        label = "space vacuum plants",
	nodenames = {"group:sapling", "group:flora", "group:flower", "group:leafdecay"},
	neighbors = {"vacuum:vacuum"},
	interval = 1,
	chance = 2,
	action = function(pos)
		minetest.set_node(pos, {name = "default:dry_shrub"})
	end
})



-- sublimate nodes in vacuum
minetest.register_abm({
        label = "space vacuum sublimate",
	nodenames = {"group:snowy", "group:leaves", "group:water"},
	neighbors = {"vacuum:vacuum"},
	interval = 1,
	chance = 2,
	action = function(pos)
		minetest.set_node(pos, {name = "vacuum:vacuum"})
	end
})



-- depressurize through leaky nodes
minetest.register_abm({
        label = "space vacuum depressurize",
	nodenames = leaky_nodes,
	neighbors = {"vacuum:vacuum"},
	interval = 1,
	chance = 2,
	action = function(pos)
		if is_pos_on_earth(pos) then
			-- on earth: TODO: replace vacuum with air
			return
		elseif is_pos_in_space(pos) then
			local node = minetest.get_node(pos)

			if node.name == "pipeworks:entry_panel_empty" or node.name == "pipeworks:entry_panel_loaded" then
				-- air thight pipes
				return
			end

			-- TODO check n nodes down (multiple simple door airlock hack)
			-- in space: replace air with vacuum
			local surrounding_node = minetest.find_node_near(pos, 1, {"air"})

			if surrounding_node ~= nil then
				minetest.set_node(surrounding_node, {name = "vacuum:vacuum"})
			end
		end
	end
})


