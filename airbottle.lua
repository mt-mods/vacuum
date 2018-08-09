


minetest.register_craftitem("vacuum:air_bottle", {
	description = "Air Bottle",
	inventory_image = "vessels_steel_bottle.png^[colorize:#0000FFAA",
	stack_max = 1,
	on_secondary_use = function(itemstack, user)
		print("air_bottle secondary use: " .. itemstack:to_string() .. " " .. user:get_player_name())--XXX
		local pos = user:get_pos()
		pos.y = pos.y + 1.5
		user:move_to(pos, true)
	end,

	on_place = function(itemstack, placer, pointed_thing)
		print("air_bottle place: " .. itemstack:to_string() .. " " .. placer:get_player_name())--XXX
	end,

	on_use = function(itemstack, user, pointed_thing)
		print("air_bottle use: " .. itemstack:to_string() .. " " .. user:get_player_name())--XXX
	end
})

minetest.register_craft({
	output = "vacuum:air_bottle",
	recipe = {
		{"vessels:steel_bottle", "vessels:steel_bottle", "vessels:steel_bottle"},
		{"", "wool:blue", ""},
		{"", "", ""}
	}
})