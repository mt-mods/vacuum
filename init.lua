
vacuum = {
	space_height = 1000,
	air_pump_range = 16,

	-- technic
	air_pump_power_store = 50000,
	air_pump_power_draw = 5000
}


local MP = minetest.get_modpath("vacuum")

dofile(MP.."/vacuum.lua")
dofile(MP.."/air.lua")
dofile(MP.."/airbottle.lua")
dofile(MP.."/airpump.lua")
dofile(MP.."/mapgen.lua")
dofile(MP.."/abm.lua")
dofile(MP.."/dignode.lua")

print("[OK] Vacuum")



