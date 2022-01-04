-- disable drowning in certain trains/wagons
-- Enhancements:
--  * register/api functions for wagon types
--  * global api for vacuum/drowning overrides (_looks at the spacesuit mod_)

assert(type(advtrains.wagons) == "table", "advtrains sanity check failed!")

-- map of: playername -> bool
local players_in_airthight_wagons = {}

-- map of: wagon_type -> bool
local airthight_wagon_types = {
    ["advtrains:wagon_japan"] = true,
    ["advtrains:engine_japan"] = true
}

local function collect_seated_players()
    -- go over seats in every wagon
    players_in_airthight_wagons = {}
    for _, wagon in pairs(advtrains.wagons) do
        -- check wagon type
        if airthight_wagon_types[wagon.type] then
            -- check seats
            for _, playername in ipairs(wagon.seatp) do
                -- mark player as seated in aithight wagon
                players_in_airthight_wagons[playername] = true
            end
        end
    end
end

local function check_player(player)
    local playername = player:get_player_name()
    if players_in_airthight_wagons[playername] then
        player:set_breath(10)
    end
end

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime;
	if timer >= 2 then
        -- recreate list
        collect_seated_players()
		for _,player in ipairs(minetest.get_connected_players()) do
			check_player(player)
		end
		timer = 0
	end
end)
