
local c_vacuum = minetest.get_content_id("vacuum:vacuum")
local c_air = minetest.get_content_id("air")

minetest.register_on_generated(function(minp, maxp, seed)

	if minp.y < vacuum.space_height then
		return
	end

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local data = vm:get_data()
	local area = VoxelArea:new({MinEdge=emin, MaxEdge=emax})

	for i in area:iter(
		minp.x, minp.y, minp.z,
		maxp.x, maxp.y, maxp.z
	) do
		if data[i] == c_air then
			data[i] = c_vacuum
		end
	end
 
	vm:set_data(data)
	vm:write_to_map()
end)
