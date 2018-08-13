

local has_full_air_bottle = function(inv)
	return inv:contains_item("main", {name="vacuum:air_bottle", count=1})
end

local has_empty_air_bottle = function(inv)
	return inv:contains_item("main", {name="vessels:steel_bottle", count=1})
end

local do_empty_bottle = function(inv)
	if not has_full_air_bottle then
		return false
	end

	local new_stack = ItemStack("vessels:steel_bottle")

	if inv:room_for_item("main", new_stack) then
		inv:remove_item("main", {name="vacuum:air_bottle", count=1})
		inv:add_item("main", new_stack)
	end

	return true
end

local do_fill_bottle = function(inv)
	if not has_empty_air_bottle then
		return false
	end

	local new_stack = ItemStack("vacuum:air_bottle")

	if inv:room_for_item("main", new_stack) then
		inv:remove_item("main", {name="vessels:steel_bottle", count=1})
		inv:add_item("main", new_stack)
	end

	return true
end

-- just enabled
vacuum.airpump_enabled = function(meta)
	return meta:get_int("enabled") == 1
end

-- enabled and actively pumping
vacuum.airpump_active = function(meta)
	local inv = meta:get_inventory()
	return vacuum.airpump_enabled(meta) and has_full_air_bottle(inv)
end


local update_infotext = function(meta)
	local str = "Airpump: "

	if vacuum.airpump_enabled(meta) then
		str = str .. " (Enabled)"
	else
		str = str .. " (Disabled)"
	end

	meta:set_string("infotext", str)
end

-- update airpump formspec
local update_formspec = function(meta)
	local btnName = "State: "

	if meta:get_int("enabled") == 1 then
		btnName = btnName .. "<Enabled>"
	else
		btnName = btnName .. "<Disabled>"
	end

	meta:set_string("formspec", "size[8,7.2;]" ..
		"image[3,0;1,1;" .. vacuum.air_bottle_image .. "]" ..
		"image[4,0;1,1;vessels_steel_bottle.png]" ..
		"button[0,1;8,1;toggle;" .. btnName .. "]" ..
		"list[context;main;0,2;8,1;]" ..
		"list[current_player;main;0,3.2;8,4;]" ..
		"liststring[]" ..
		"")

	update_infotext(meta)

end


minetest.register_node("vacuum:airpump", {
	description = "Air pump",
	tiles = {"vacuum_airpump.png"},
	paramtype = "light",
	groups = {cracky=3,oddly_breakable_by_hand=3},
	sounds = default.node_sound_glass_defaults(),

	connects_to = {"group:technic_hv_cable"},
	connect_sides = {"bottom", "top", "left", "right", "front", "back"},

	mesecons = {effector = {
		action_on = function (pos, node)
			local meta = minetest.get_meta(pos)
			meta:set_int("enabled", 1)
		end,
		action_off = function (pos, node)
			local meta = minetest.get_meta(pos)
			meta:set_int("enabled", 0)
		end
	}},

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
	end,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_int("enabled", 0)

		local inv = meta:get_inventory()
		inv:set_size("main", 8)

		update_formspec(meta)
	end,

	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,

	on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.get_meta(pos);

		if fields.toggle then
			if meta:get_int("enabled") == 1 then
				meta:set_int("enabled", 0)
			else
				meta:set_int("enabled", 1)
			end
		end

		update_formspec(meta)
	end

})


minetest.register_abm({
        label = "airpump",
	nodenames = {"vacuum:airpump"},
	interval = 5,
	chance = 1,
	action = function(pos)
		local meta = minetest.get_meta(pos)
		if vacuum.airpump_enabled(meta) then
			minetest.sound_play("vacuum_hiss", {pos = pos, gain = 0.5})
			if vacuum.is_pos_in_space(pos) then
				do_empty_bottle(meta:get_inventory())
			else
				do_fill_bottle(meta:get_inventory())
			end
			update_infotext(meta)
		end
	end
})



-- initial airpump step
minetest.register_abm({
        label = "airpump seed",
	nodenames = {"vacuum:airpump"},
	neighbors = {"vacuum:vacuum"},
	interval = 1,
	chance = 1,
	action = function(pos)
		local meta = minetest.get_meta(pos)
		if vacuum.airpump_active(meta) then
			-- seed initial air
			local node = minetest.find_node_near(pos, 1, {"vacuum:vacuum"})

			if node ~= nil then
				minetest.set_node(node, {name = "air"})
			end
		end
	end
})

minetest.register_craft({
	output = "vacuum:airpump",
	recipe = {
		{"default:steel_ingot", "default:mese_block", "default:steel_ingot"},
		{"default:diamond", "default:glass", "default:steel_ingot"},
		{"default:steel_ingot", "default:steelblock", "default:steel_ingot"},
	},
})


