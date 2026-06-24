--[[
local has_monitoring = minetest.get_modpath("monitoring")

local metric_space_vacuum_abm

if has_monitoring then
	metric_space_vacuum_abm = monitoring.counter("vacuum_abm_count", "number of space vacuum abm calls")
end

-- vacuum propagation
minetest.register_abm({
  label = "air -> vacuum replacement",
	nodenames = {"air"},
	neighbors = {"vacuum:vacuum"},
	interval = 1,
	chance = 1,
	min_y = vacuum.space_height,
	action = vacuum.throttle(1000, function(pos)
		-- update metrics
		if metric_space_vacuum_abm ~= nil then metric_space_vacuum_abm.inc() end

		if vacuum.is_pos_in_space(pos) and not vacuum.near_powered_airpump(pos) then
			-- in space, evacuate air
			minetest.set_node(pos, {name = "vacuum:vacuum"})
		end
	end)
})

-- air propagation
-- works slower than vacuum abm
minetest.register_abm({
  label = "vacuum -> air replacement",
	nodenames = {"vacuum:vacuum"},
	neighbors = {"air"},
	interval = 1,
	chance = 2,
	action = vacuum.throttle(1000, function(pos)

		-- update metrics
		if metric_space_vacuum_abm ~= nil then metric_space_vacuum_abm.inc() end

		if not vacuum.is_pos_in_space(pos) or vacuum.near_powered_airpump(pos) then
			-- on earth or near a powered airpump
			minetest.set_node(pos, {name = "air"})
		end
	end)
})
--]]

minetest.register_chatcommand("test", {
	func = function(name)
		local player = minetest.get_player_by_name(name)
		local pos = player:get_pos()
		local radius = 20

		local t0 = minetest.get_us_time()
		vacuum.propagate_vacuum(pos, radius)
		local t1 = minetest.get_us_time()
		local us = t1 - t0
		return true, "Propagation with radius of " .. radius .. " took " .. us .. " us"
	end
})

local c_air = minetest.get_content_id("air")
local c_vacuum = minetest.get_content_id("vacuum:vacuum")

local directions = {
	{ x=1, y=0, z=0 },
	{ x=-1, y=0, z=0 },
	{ x=0, y=1, z=0 },
	{ x=0, y=-1, z=0 },
	{ x=0, y=0, z=1 },
	{ x=0, y=0, z=-1 },
}

function vacuum.propagate_vacuum(center_pos, radius)
	local pos1 = vector.subtract(center_pos, radius)
	local pos2 = vector.add(center_pos, radius)

	-- inner positions (1 node margin)
	local ipos1 = vector.add(pos1, 1)
	local ipos2 = vector.subtract(pos2, 1)

	local manip = minetest.get_voxel_manip()
	local e1, e2 = manip:read_from_map(pos1, pos2)
	local area = VoxelArea:new({MinEdge=e1, MaxEdge=e2})
	local node_ids = manip:get_data()

	for z=ipos1.z, ipos2.z do
	for y=ipos1.y, ipos2.y do
	for x=ipos1.x, ipos2.x do
		local pos = { x=x, y=y, z=z }
		local index = area:indexp(pos)
		if node_ids[index] == c_air then
			for _, dir in ipairs(directions) do
				-- other neighboring pos
				local opos = vector.add(pos, dir)
				local oindex = area:indexp(opos)
				if node_ids[oindex] == c_vacuum then
					-- propagate
					node_ids[index] = c_vacuum
					break
				end
			end
		end
	end
	end
	end

	manip:set_data(node_ids)
	manip:write_to_map()
end