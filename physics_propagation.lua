local has_monitoring = minetest.get_modpath("monitoring")

local metric_space_vacuum_abm

if has_monitoring then
  metric_space_vacuum_abm = monitoring.counter("vacuum_abm_count", "number of space vacuum abm calls")
end

-- vacuum/air propagation
minetest.register_abm({
  label = "space vacuum",
	nodenames = {"air"},
	neighbors = {"vacuum:vacuum"},
	interval = 1,
	chance = 1,
	action = vacuum.throttle(1000, function(pos)

		if metric_space_vacuum_abm ~= nil then metric_space_vacuum_abm.inc() end

		if vacuum.no_vacuum_abm(pos) then
			return
		end

		if not vacuum.is_pos_in_space(pos) or vacuum.near_powered_airpump(pos) then
			-- on earth or near a powered airpump
			local node = minetest.find_node_near(pos, 1, {"vacuum:vacuum"})

			if node ~= nil then
				minetest.set_node(node, {name = "air"})
			end
		else
			-- in space, evacuate air
			minetest.set_node(pos, {name = "vacuum:vacuum"})
		end
	end)
})
