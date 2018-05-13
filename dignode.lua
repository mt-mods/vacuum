

minetest.register_on_dignode(function(pos, oldnode, digger)
	local np = minetest.find_node_near(pos, 1,{"vacuum:vacuum"})
	if np ~= nil then
		minetest.set_node(pos, {name = "vacuum:vacuum"})
	end
end)