
vacuum = {
	space_height = 1000
}


local MP = minetest.get_modpath("vacuum")

dofile(MP.."/vacuum.lua")
dofile(MP.."/airbottle.lua")
dofile(MP.."/airpump.lua")
dofile(MP.."/mapgen.lua")
dofile(MP.."/abm.lua")
dofile(MP.."/functions.lua")
dofile(MP.."/dignode.lua")

print("[OK] Vacuum")



