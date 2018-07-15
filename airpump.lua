local has_technic_mod = minetest.get_modpath("technic")

-- flush room with air
vacuum.flush_air = function(pos, i)

	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	local air_bottle_present = inv:contains_item("main", {name="vacuum:air_bottle", count=1})
	if air_bottle_present then
		local new_stack = ItemStack("vessels:steel_bottle")

		if inv:room_for_item("main", new_stack) then
			inv:remove_item("main", {name="vacuum:air_bottle", count=1})
			inv:add_item("main", new_stack)
		end
	else
		meta:set_int("powerstorage", 0)
	end

	if i == nil then
		-- default layers
		i = vacuum.air_pump_range
	end

	local pos1 = { x=pos.x-1, y=pos.y-1, z=pos.z-1 }
	local pos2 = { x=pos.x+1, y=pos.y+1, z=pos.z+1 }

	local vacuum_nodes = minetest.find_nodes_in_area(pos1, pos2, {"vacuum:vacuum"})

	for _,node in pairs(vacuum_nodes) do
		-- replace vacuum with buffer air and start expiration timer
		minetest.set_node(node, {name = "vacuum:air"})
		local timer = minetest.get_node_timer(node)

		-- buffer air expiry timer (gets copied from abm code)
		timer:start(5)
	end

	if i <= 0 then
		-- max iterations reached, abort here
		return
	end

	for _,node in pairs(vacuum_nodes) do
		-- recurse after surrounding air set
		vacuum.flush_air(node, i-1)
	end

end

local is_airpump_ready = function(meta)
	if not has_technic_mod then
		-- no technic, always ready
		return true
	end

	local inv = meta:get_inventory()

	local air_bottle_present = inv:contains_item("main", {name="vacuum:air_bottle", count=1})

	if air_bottle_present then
		return true
	end

	-- check power levels
	local store = meta:get_int("powerstorage")
	return store >= vacuum.air_pump_power_store
end

local update_infotext = function(meta)
	local state = "Charging..."

	if has_technic_mod then
		local percent = math.floor(meta:get_int("powerstorage") / vacuum.air_pump_power_store * 100)
		state = state .. " (" .. percent .. " %)"
	end

	if is_airpump_ready(meta) then
		state = "Ready!"
	end

	meta:set_string("infotext", "Airpump: " .. state)
end

-- update airpump formspec
local update_formspec = function(meta)
	meta:set_string("formspec", "size[8,7.2;]" ..
		"label[0,0;Flush]" ..
		"button_exit[0,1;8,1;flush;Flush]" ..
		"list[context;main;0,2;8,1;]" ..
		"list[current_player;main;0,3.2;8,4;]" ..
		"")

	update_infotext(meta)

end


minetest.register_node("vacuum:airpump", {
	description = "Air pump",
	tiles = {"vacuum_airpump.png"},
	paramtype = "light",
	groups = {cracky=3,oddly_breakable_by_hand=3,technic_machine = 1, technic_hv = 1},
	sounds = default.node_sound_glass_defaults(),

	connects_to = {"group:technic_hv_cable"},
	connect_sides = {"bottom", "top", "left", "right", "front", "back"},

	mesecons = {effector = {
		action_on = function (pos, node)
			local meta = minetest.get_meta(pos)
			if is_airpump_ready(meta) then
				vacuum.flush_air(pos)
				update_infotext(meta)
			end
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

		if has_technic_mod then
			meta:set_int("HV_EU_input", 0)
			meta:set_int("HV_EU_demand", 0)
		end

		update_formspec(meta)
	end,

	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,

	on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.get_meta(pos);

		if fields.flush and is_airpump_ready(meta) then
			vacuum.flush_air(pos)
		end

		update_formspec(meta)
	end,


	technic_run = function(pos, node)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()

		local eu_input = meta:get_int("HV_EU_input")
		local demand = meta:get_int("HV_EU_demand")
		local store = meta:get_int("powerstorage")

		local empty_vessel_present = inv:contains_item("main", {name="vessels:steel_bottle", count=1}) and pos.y <= vacuum.space_height

		if store < vacuum.air_pump_power_store or empty_vessel_present then
			-- not full, charge
			meta:set_int("HV_EU_demand", vacuum.air_pump_power_draw)
		else
			-- full
			meta:set_int("HV_EU_demand", 0)
		end

		if empty_vessel_present then
			-- on earth and empty steel bottle present
			local new_stack = ItemStack("vacuum:air_bottle")

			if inv:room_for_item("main", new_stack) then
				inv:remove_item("main", {name="vessels:steel_bottle", count=1})
				inv:add_item("main", new_stack)
			end

		elseif eu_input >= 0 then
			-- power!
			meta:set_int("powerstorage", meta:get_int("powerstorage") + eu_input)
		end

		update_infotext(meta)
	end

})


if has_technic_mod then
	technic.register_machine("HV", "vacuum:airpump", technic.receiver)

	minetest.register_craft({
		output = "vacuum:airpump",
		recipe = {
			{"default:steel_ingot", "technic:machine_casing", "default:steelblock"},
			{"default:glass", "technic:hv_transformer", "default:diamond"},
			{"default:steelblock", "technic:machine_casing", "default:steel_ingot"},
		},
	})

else
	minetest.register_craft({
		output = "vacuum:airpump",
		recipe = {
			{"default:steel_ingot", "default:mese_block", "default:steel_ingot"},
			{"default:diamond", "default:glass", "default:steel_ingot"},
			{"default:steel_ingot", "default:steelblock", "default:steel_ingot"},
		},
	})

end

