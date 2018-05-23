local has_technic_mod = minetest.get_modpath("technic")


local update_formspec = function(meta)
	local enabled = meta:get_int("enabled") == 1

	local state = "Disabled"
	if enabled then state = "Enabled" end

	meta:set_string("formspec", "size[8,2;]" ..
		"label[0,0;" .. state .. "]" ..
		"button_exit[0,1;8,1;toggle;Toggle]" ..
		"")

	meta:set_string("infotext", "Airpump: " .. state)

	if not has_technic_mod then
		-- state == enabled
		meta:set_int("state", meta:get_int("enabled"))
	end

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
		local enabled = meta:get_int("enabled") == 1

		if fields.toggle then
			if enabled then
				meta:set_int("enabled", 0)
			else
				meta:set_int("enabled", 1)
			end
		end
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

