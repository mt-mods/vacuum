

vacuum.air_bottle_image = "vessels_steel_bottle.png^[colorize:#0000FFAA"

-- returns true, if in space (with safety margin for abm)
vacuum.is_pos_in_space = function(pos)
	return pos.y > vacuum.space_height + 40
end

vacuum.is_pos_on_earth = function(pos)
	return pos.y < vacuum.space_height - 40
end