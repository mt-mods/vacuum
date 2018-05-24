local has_technic_mod = minetest.get_modpath("technic")

-- flush room with air
vacuum.flush_air = function(pos, i)
	if i == nil then
		-- default to 7 layers
		i = vacuum.air_pump_range
	end

	local pos1 = { x=pos.x-1, y=pos.y-1, z=pos.z-1 }
	local pos2 = { x=pos.x+1, y=pos.y+1, z=pos.z+1 }

	local vacuum_nodes = minetest.find_nodes_in_area(pos1, pos2, {"vacuum:vacuum"})

	for _,node in pairs(vacuum_nodes) do
		-- replace vacuum with air
		minetest.set_node(node, {name = "air"})
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

-- update airpump formspec
local update_formspec = function(meta)
	meta:set_string("formspec", "size[8,2;]" ..
		"label[0,0;Flush]" ..
		"button_exit[0,1;8,1;flush;Flush]" ..
		"")

	-- meta:set_string("infotext", "Airpump: " .. state)
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
			vacuum.flush_air(pos)
		end
	}},

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_int("enabled", 0)

		if has_technic_mod then
			meta:set_int("HV_EU_input", 0)
			meta:set_int("HV_EU_demand", 0)
		end

		update_formspec(meta)
	end,

	on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.get_meta(pos);

		if fields.flush then
			vacuum.flush_air(pos)
		end

		update_formspec(meta)
	end,


	technic_run = function(pos, node)
		local meta = minetest.get_meta(pos)

		local eu_input = meta:get_int("HV_EU_input")
		local demand = meta:get_int("HV_EU_demand")
		local store = meta:get_int("powerstorage")
		local enabled = meta:get_int("enabled") == 1

		if enabled then
			-- charge
			demand = 10000
			meta:set_int("HV_EU_demand", demand)
		end

		if eu_input < demand then
			-- no power
			meta:set_int("state", 0)
		else
			-- power!
			meta:set_int("state", 1)
		end
	end

})


if has_technic_mod then
	technic.register_machine("HV", "vacuum:airpump", technic.receiver)
end

