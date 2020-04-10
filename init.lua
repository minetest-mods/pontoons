-- internationalization boilerplate
local S = minetest.get_translator("pontoons")
local default_modpath = minetest.get_modpath("default")
local mineclone_path = core.get_modpath("mcl_core") and mcl_core

-- compatibility layer
local moditems = {}

if mineclone_path then -- means MineClone 2 is loaded, this is its core mod
  moditems.iron_item = "mcl_core:iron_ingot"  -- MCL iron
  moditems.sounds_wood = mcl_sounds.node_sound_wood_defaults
  moditems.sounds_metal = mcl_sounds.node_sound_metal_defaults
  moditems.metal_block_group = { pickaxey=2 }

elseif default_modpath then   -- fallback, assume default (MineTest Game) is loaded, otherwise it will error anyway here.
  moditems.iron_item = "default:steel_ingot"  -- default iron
  moditems.sounds_wood = default.node_sound_wood_defaults
  moditems.sounds_metal = default.node_sound_metal_defaults
  moditems.metal_block_group = { cracky = 1, level = 2 }
end

-- load settings from minetest

local pontoons_override_logs = minetest.settings:get_bool("pontoons_override_logs") -- default false
if pontoons_override_logs == nil then pontoons_override_logs = false end

local pontoons_override_wood = minetest.settings:get_bool("pontoons_override_wood") -- default false
if pontoons_override_wood == nil then pontoons_override_wood = false end

local pontoons_wood_pontoons = minetest.settings:get_bool("pontoons_wood_pontoons") -- default true
if pontoons_wood_pontoons == nil then pontoons_wood_pontoons = true end

local pontoons_steel_pontoons = minetest.settings:get_bool("pontoons_steel_pontoons") -- default true
if pontoons_steel_pontoons == nil then pontoons_steel_pontoons = true end 


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
	local wood_burn_time = minetest.get_craft_result({method="fuel", width=1, items={ItemStack("group:wood")}}).time

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
		sounds = moditems.sounds_wood(),
		_mcl_blast_resistance = 3,
		_mcl_hardness = 0.6,
	})

-- modify recipe, if "airtank" mod is loaded as it has similar recipe and conflicts with pontoons.

if core.get_modpath("airtanks") and airtanks then
	minetest.register_craft({
		output = 'pontoons:wood_pontoon 4',
		recipe = {
			{"group:wood","group:wood","group:wood"},
			{"","",""},
			{"","","group:wood"},
		}
	})
else
	minetest.register_craft({
		output = 'pontoons:wood_pontoon 4',
		recipe = {
			{"","group:wood",""},
			{"group:wood","","group:wood"},
			{"","group:wood",""},
		}
	})
end

	minetest.register_craft({
		type = "fuel",
		recipe = "pontoons:wood_pontoon",
		burntime = wood_burn_time,
	})
	
end

if pontoons_steel_pontoons then

	minetest.register_node("pontoons:steel_pontoon", {
		description = S("Steel Pontoon"),
		_doc_items_longdesc = S("A hollow steel block designed to be built on the surface of liquids. Magma-safe."),
		is_ground_content = false,
		tiles = {"pontoon_steel.png"},
		liquids_pointable = true,
		groups = moditems.metal_block_group,
		sounds = moditems.sounds_metal(),
		_mcl_blast_resistance = 30,
	  _mcl_hardness = 5,
	})
	
	if default_modpath then
		if core.get_modpath("airtanks") and airtanks then
			minetest.register_craft({
				output = 'pontoons:steel_pontoon',
				recipe = {
					{"",moditems.iron_item,""},
					{moditems.iron_item,"",moditems.iron_item},
					{"","",moditems.iron_item},
				}
			})
	  else		
			minetest.register_craft({
				output = 'pontoons:steel_pontoon',
				recipe = {
					{"",moditems.iron_item,""},
					{moditems.iron_item,"",moditems.iron_item},
					{"",moditems.iron_item,""},
				}
			})
		end
	end
end
