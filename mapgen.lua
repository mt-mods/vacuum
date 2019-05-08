
local c_vacuum = minetest.get_content_id("vacuum:vacuum")
local c_ignore = minetest.get_content_id("ignore")
local c_air = minetest.get_content_id("air")

minetest.register_on_generated(function(minp, maxp, seed)
	--local t0 = minetest.get_us_time()

	if not vacuum.is_mapgen_block_in_space(minp, maxp) then
		return
	end

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local data = vm:get_data()
	local area = VoxelArea:new({MinEdge=emin, MaxEdge=emax})

	for i in area:iter(
		minp.x, minp.y, minp.z,
		maxp.x, maxp.y, maxp.z
	) do
		if data[i] == c_air or data[i] == c_ignore then
			data[i] = c_vacuum
		end
	end

	vm:set_data(data)
	vm:write_to_map()

	--local t1 = minetest.get_us_time()
	--local micros = t1 -t0

	--print("mapgen for " .. minetest.pos_to_string(minp) .. " took " .. micros .. " us")
end)
