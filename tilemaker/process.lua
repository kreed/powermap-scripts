-- Nodes will only be processed if one of these keys is present

node_keys = { "amenity", "shop" }

local function split(inputstr, seps)
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..seps.."]+)") do
		table.insert(t, str)
	end
	return t
end

function alphanumsort(o)
	local function padnum(d) return ("%012d"):format(d) end
	table.sort(o, function(a,b)
		return tostring(a):gsub("%d+",padnum) > tostring(b):gsub("%d+",padnum) end)
	return o
end

-- Initialize Lua logic

function init_function()
end

-- Finalize Lua logic()
function exit_function()
end

-- Assign nodes to a layer, and set attributes, based on OSM tags

function node_function(node)
end

-- Similarly for ways

function way_function(way)
	local power = way:Find("power")
	if power=="line" then
		way:Layer("power_lines", false)
		way:Attribute("cables", way:Find("cables"))
		way:Attribute("circuits", way:Find("circuits"))
		way:Attribute("wires", way:Find("wires"))
	elseif power=="plant" or power=="substation" then
		way:Layer("power_areas", true)
		way:Attribute("substation", way:Find("substation"))
	else
		return
	end
	way:Attribute("power", power)
	way:Attribute("name", way:Find("name"))
	way:Attribute("operator", way:Find("operator"))
	way:Attribute("frequency", way:Find("frequency"))

	local voltage = way:Find("voltage")
	local volts = alphanumsort(split(voltage, ";/"))
	way:Attribute("voltage", table.concat(volts,";"))
	way:Attribute("high_voltage", volts[1] or "")
end
