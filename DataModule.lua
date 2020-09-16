local module = {}

-- Enables the ability to encode, and code JSON strings.
HttpService = game:GetService("HttpService")

-- This function will return a table listed with 2 additional data tables for organization. Change the name of the data tables, and values within
-- 'info' to fit your needs. The 'info' table is used to store data. See "examples.lua" in order to see how we manage it.

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

-- Below here, you can add additional function to make management/adding data/changing data smoother.


-- The purpose of the script is to decode data in a datastore so it can be modified and saved. See "examples.lua" to see how to use it.
-- the "pullDecoded" function takes the parameter of the player.
-- 'oddTable' is used to store decoded data.
function module.pullDecoded(plr)
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

-- EncodeUpdatedRaw takes the raw decoded data, and recodes it using JSONEncode. This creates a new JSON String.
-- see "examples.lua" to see how its being used.
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

-- Push save is used to save a JSON String 'rawData'.
-- See "exmaples.lua" to see how this is done.
function module.pushSave(plr, rawData)
	
	local DataStore2 = require(script.Parent.MainModule)
	local _version = script.Parent:WaitForChild("_version").Value
	local masterDataName = "arcadeMasterData_dev".. _version
	local plrData = DataStore2(masterDataName, plr)
	plrData:Set(rawData)
	
end


return module
