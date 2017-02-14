-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

local pontoons_override_logs = minetest.setting_getbool("pontoons_override_logs")
if pontoons_override_logs == nil then pontoons_override_logs = true end -- default true

local pontoons_override_wood = minetest.setting_getbool("pontoons_override_wood")
if pontoons_override_wood == nil then pontoons_override_wood = true end -- default true

local pontoons_wood_pontoons = minetest.setting_getbool("pontoons_wood_pontoons") -- default false

local pontoons_steel_pontoons = minetest.setting_getbool("pontoons_steel_pontoons")
if pontoons_steel_pontoons == nil then pontoons_steel_pontoons = true end -- default true

local default_modpath = minetest.get_modpath("default")

if pontoons_override_logs or pontoons_override_wood then
	local override_def = {liquids_pointable = true}
	
	for node_name, node_def in pairs(minetest.registered_nodes) do
		if pontoons_override_logs and minetest.get_item_group(node_name, "tree") > 0 then
			minetest.override_item(node_name, override_def)
		end
		if pontoons_override_wood and minetest.get_item_group(node_name, "wood") > 0 then
			minetest.override_item(node_name, override_def)
		end
	end
end

if pontoons_wood_pontoons then
	local default_sound
	local wood_burn_time
	if default_modpath then
		default_sound = default.node_sound_wood_defaults()
		wood_burn_time = minetest.get_craft_result({method="fuel", width=1, items={ItemStack("group:wood")}}).time
	end
	if not wood_burn_time then wood_burn_time = 7 end

	minetest.register_node("pontoons:wood_pontoon", {
		description = S("Wood Pontoon"),
		_doc_items_longdesc = S("A hollow wooden block designed to be built on the surface of liquids."),
		tiles = {"pontoon_wood.png"},
		paramtype2 = "facedir",
		place_param2 = 0,
		is_ground_content = false,
		liquids_pointable = true,
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1},
		sounds = default_sound,
	})
	
	minetest.register_craft({
		output = 'pontoons:wood_pontoon 4',
		recipe = {
			{"","group:wood",""},
			{"group:wood","","group:wood"},
			{"","group:wood",""},
		}
	})
	
	minetest.register_craft({
		type = "fuel",
		recipe = "pontoons:wood_pontoon",
		burntime = wood_burn_time,
	})
	
end

if pontoons_steel_pontoons then
	local default_sound
	if default_modpath then
		if 	default.node_sound_metal_defaults ~= nil then
			default_sound = default.node_sound_metal_defaults()
		else
			default_sound = default.node_sound_wood_defaults()
		end
	end
	
	minetest.register_node("pontoons:steel_pontoon", {
		description = S("Steel Pontoon"),
		_doc_items_longdesc = S("A hollow steel block designed to be built on the surface of liquids. Magma-safe."),
		is_ground_content = false,
		tiles = {"pontoon_steel.png"},
		liquids_pointable = true,
		is_ground_content = false,
		groups = {cracky = 1, level = 2},
		sounds = default_sound,
	})
	
	if default_modpath then
		minetest.register_craft({
			output = 'pontoons:steel_pontoon',
			recipe = {
				{"","default:steel_ingot",""},
				{"default:steel_ingot","","default:steel_ingot"},
				{"","default:steel_ingot",""},
			}
		})
	end
end