local module = {}

-- Enables the ability to encode, and code JSON strings.
HttpService = game:GetService("HttpService")

-- 
function module.grabPlayerData()
	
	local playerDefaultData = {
		
		basicData = [[
			{
				"message": "success",
				"info": {
					"selectedClass": "",
					"tickets": 0,
					"goldenTickets": 0,
					"ownedClasses": {
						"Berserker": true,
						"Elementalist": true,
						"Paladin": true,
						"Alchemist": true
					}
				}
			}
		]],
		
		partyData = [[
			{
				"message": "success",
				"info": {
					"leader": 0,
					"member1": 0,
					"member2": 0,
					"member3": 0
				}
			}
		]]
		
	}
	return playerDefaultData
end


function module.grabDefaultCharData()
	
	local charData = {
		["message"] = "success",
		["info"] = {
			["stats"] = {
				["health"] = {
					["current"] = 1,
					["max"] = 1
				},
				["experience"] = {
					["current"] = 0,
					["max"] = 50
				},
				["mana"] = {
					["current"] = 0,
					["max"] = 0
				},
				["damage"] = 0,
				["resistance"] = 0,
				["piercing"] = 0,
				["speed"] = 0,
				["crit"] = 0
			},
			
			["inventory"] = {},
			
			["equippedItems"] = {
				["armor"] = {},
				["hotbar"] = {}
			},
			
			["equippedVanity"] = {}
		}
	}
	
	return charData
end


-- Redone, unverified.
function module.pullDecoded(plr, plrFolder)
	local oddTable = {}
	
	local DataModule = require(script)
	local DataStore2 = require(script.Parent.MainModule)
	local _version = script.Parent:WaitForChild("_version").Value
	local masterDataName = "arcadeMasterData_dev".. _version
	local plrData = DataStore2(masterDataName, plr)
	local defaultData = DataModule.grabPlayerData()
	
	if defaultData ~= nil then
		for key, node in pairs(plrData:Get(defaultData)) do
			oddTable[key] = HttpService:JSONDecode(node)
		end
	end
	return oddTable
end


function module.EncodeUpdatedRaw(rawData)
	local newData = {}
	for i,v in pairs(rawData) do
		if type(v) == "table" then
			v = HttpService:JSONEncode(v)
		end
		newData[i] = v
	end
	return newData
end

-- Redone, unverified.
function module.grabFolder(plr)
	if plr:FindFirstChild("StorageReader") then
		return plr.StorageReader
	end
end

-- Redone, unverified.
function module.pushSave(plr, rawData)
	
	local DataStore2 = require(script.Parent.MainModule)
	local _version = script.Parent:WaitForChild("_version").Value
	local masterDataName = "arcadeMasterData_dev".. _version
	local plrData = DataStore2(masterDataName, plr)
	plrData:Set(rawData)
	
end


return module
