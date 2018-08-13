
vacuum = {
	space_height = 1000,
	air_pump_range = 5, --radius
}


local MP = minetest.get_modpath("vacuum")

dofile(MP.."/common.lua")
dofile(MP.."/vacuum.lua")
dofile(MP.."/air.lua")
dofile(MP.."/airbottle.lua")
dofile(MP.."/airpump.lua")
dofile(MP.."/mapgen.lua")
dofile(MP.."/physics.lua")
dofile(MP.."/dignode.lua")

print("[OK] Vacuum")



