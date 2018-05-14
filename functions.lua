

-- player breath in vacuum
local player_breath = function(player)
	local inv = player:get_inventory()
	local did_breathe = false

	if inv:contains_item("main", "vacuum:airbottle") then
		-- air bottle in inventory
		local i = 1
		local size = inv:get_size("main")
		while i <= size and not did_breathe do
			local stack = inv:get_stack("main", i)
			if not stack:is_empty() and stack:get_name() == "vacuum:airbottle" then
				-- bottle found
				if stack:get_wear() < 65535 then
					-- air left in bottle
					stack:add_wear(65535/(60-1))
					did_breathe = true

					if stack:get_wear() >= 65535 or stack:is_empty() then
						-- air depleted, replace with empty bottle
						stack = ItemStack("vacuum:airbottle_empty 1")
						if inv:room_for_item("main", stack) then
							inv:add_item("main", stack)
						end
					else
						-- put stack back
						inv:set_stack("main", i, stack)
					end
				end
			end

			i = i + 1
		end
	end

	if not did_breathe then
		local hp = player:get_hp()
		player:set_hp(hp - 1)
	end
end


local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer >= 1 then
		local players = minetest.get_connected_players()
		for i,player in pairs(players) do
			local pos = player:getpos()

			if pos.y > vacuum.space_height then
				-- in space
				local node = minetest.get_node(pos)

				if node.name == "vacuum:vacuum" then
					-- in vacuum
					player_breath(player)
				end
			end
		end

		timer = 0
	end
end)