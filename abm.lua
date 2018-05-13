

-- air nodes near vacuum get depressurized immediately (vacuum:vacuum)
-- vacuum near air-pump gets replaced with vacuum:air


--[[
minetest.register_abm({
        label = "space air distribution",
	nodenames = {"vacuum:vacuum"},
	neighbors = {"vacuum:generated_air"},
	interval = 3,
	chance = 1,
	action = function(pos)
		local np=minetest.find_node_near(pos, 1,{"vacuum:generated_air"})
		local n
		if np~=nil then n=minetest.get_node(np) end
		if n and n.name=="vacuum:generated_air" then
			local r=minetest.get_meta(np):get_int("pressure")
			if r>0 and r<21 then
				minetest.set_node(pos, {name = "vacuum:generated_air"})
				minetest.get_meta(pos):set_int("pressure",r+1)
			end
		end
	end,
})
--]]

minetest.register_abm({
        label = "space air pump",
	nodenames = {"vacuum:airpump"},
	neighbors = {"vacuum:vacuum"},
	interval = 1,
	chance = 1,
	action = function(pos)
		local node = minetest.find_node_near(pos, 1,{"vacuum:vacuum"})
		if node ~= nil then
			minetest.set_node(node, {name = "vacuum:generated_air"})
		end
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
