

minetest.register_node("vacuum:vacuum", {
	description = "Vacuum",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drawtype = "glasslike",
	post_effect_color = {a = 20, r = 220, g = 200, b = 200},
	tiles = {"vacuum_texture.png^[colorize:#E0E0E033"},
	alpha = 0.1,
	groups = {not_in_creative_inventory=0},
	paramtype = "light",
	sunlight_propagates =true,
})

local c_vacuum = minetest.get_content_id("vacuum:vacuum")
local c_air = minetest.get_content_id("air")

minetest.register_on_generated(function(minp, maxp, seed)

	if minp.y < 100 then
		return
	end

	-- local debug = "minp="..(minetest.pos_to_string(minp))..", maxp="..(minetest.pos_to_string(maxp))..", seed="..seed
	-- print(debug)
 
	-- Get the vmanip mapgen object and the nodes and VoxelArea
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local data = vm:get_data()
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	local count = 0

	for i in area:iter(
		minp.x, minp.y, minp.z,
		maxp.x, maxp.y, maxp.z
	) do
		if data[i] == c_air then
			count = count + 1
			data[i] = c_vacuum
		end
	end
 
	-- Return the changed nodes data, fix light and change map
	vm:set_data(data)
	-- vm:set_lighting{day=0, night=0}
	vm:calc_lighting()
	vm:write_to_map()
end)

