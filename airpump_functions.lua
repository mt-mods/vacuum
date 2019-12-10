
-- common airpump functions

vacuum.has_full_air_bottle = function(inv)
	return inv:contains_item("main", {name="vacuum:air_bottle", count=1})
end

vacuum.has_empty_air_bottle = function(inv)
	return inv:contains_item("main", {name="vessels:steel_bottle", count=1})
end


vacuum.do_empty_bottle = function(inv)
	if not vacuum.has_full_air_bottle(inv) then
		return false
	end

	local new_stack = ItemStack("vessels:steel_bottle")
	inv:remove_item("main", {name="vacuum:air_bottle", count=1})

	if inv:room_for_item("main", new_stack) then
		inv:add_item("main", new_stack)
		return true
	end

	return false
end


vacuum.do_fill_bottle = function(inv)
	if not vacuum.has_empty_air_bottle(inv) then
		return false
	end

	local new_stack = ItemStack("vacuum:air_bottle")
	inv:remove_item("main", {name="vessels:steel_bottle", count=1})

	if inv:room_for_item("main", new_stack) then
		inv:add_item("main", new_stack)
		return true
	end

	return false
end



vacuum.do_repair_spacesuit = function(inv)
	for i = 1, inv:get_size("main") do
		local stack = inv:get_stack("main", i)
		local item_def = minetest.registered_items[stack:get_name()]
		if item_def and item_def.wear_represents == "spacesuit_wear" and stack:get_wear() > 0 then
			stack:set_wear(0)
			inv:set_stack("main", i, stack)
			return true
		end
	end
	return false
end

-- just enabled
vacuum.airpump_enabled = function(meta)
	return meta:get_int("enabled") == 1
end

-- enabled and actively pumping
vacuum.airpump_active = function(meta)
	local inv = meta:get_inventory()
	return vacuum.airpump_enabled(meta) and vacuum.has_full_air_bottle(inv)
end
