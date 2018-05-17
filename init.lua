
vacuum = {
	space_height = 1000,
	air_pump_range = 8
}


local MP = minetest.get_modpath("vacuum")

dofile(MP.."/vacuum.lua")
dofile(MP.."/airpump.lua")
dofile(MP.."/mapgen.lua")
dofile(MP.."/abm.lua")
dofile(MP.."/dignode.lua")

print("[OK] Vacuum")



