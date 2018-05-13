
vacuum = {
	space_height = 100
}


local MP = minetest.get_modpath("vacuum")

dofile(MP.."/vacuum.lua")
dofile(MP.."/airpump.lua")
dofile(MP.."/mapgen.lua")
dofile(MP.."/abm.lua")

print("[OK] Vacuum")



