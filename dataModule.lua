local dataFunctions = {}

HttpService = game:GetService("HttpService")

-- Example data.
function dataFunctions.grabPlayerData()
	
	local playerDefaultData = {
		basicData = [[
			{
				"message": "success",
				"info": {
					"selectedClass": "",
					"displayClass": "",
					"tickets": 0,
					"premium": 0,
					"score": 0,
					"maxSlots": 32,
					"maxRuneSlots": 12,
					
					"raidData": {
						"raidsRemaining": 0,
						"lastRaid": 0
					},
					
					"ownedClasses": {
						"Berserker": true,
						"Elementalist": true,
						"Paladin": true,
						"Alchemist": true
					},
					
					"customizations": {
						"skinTone": "#fdea8d",
						"shirtColor": "#287f47",
						"trouserColor": "#0d69ac",
						"hat": "none",
						"hair": "none",
						"face": "none"
					}
				}
			}
		]],
		
		optionData = [[
			{
				"message": "success",
				"info": {}
			}
		]],
		
		bankData = [[
			{
				"message": "success",
				"info": {}
			}
		]],
		
		recordData = [[
			{
				"message": "success",
				"info": {}
			}
		]]
		
	}
	return playerDefaultData
end


function dataFunctions.pullDecoded(plr)
	local decodedData = {}
	
	local DataModule = require(script)
	local DataStore2 = require(script.Parent.DataStore2)
	local _version = script.Parent:WaitForChild("_version").Value
	local masterDataName = "arcadeMasterData_dev".. _version
	local plrData = DataStore2(masterDataName, plr)
	local defaultData = DataModule.grabPlayerData()
	
	if defaultData ~= nil then
		for key, tableValue in pairs(plrData:Get(defaultData)) do
			decodedData[key] = HttpService:JSONDecode(tableValue)
		end
	end
	return decodedData
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

function dataFunctions.pushSave(plr, encodedData)
	local DataStore2 = require(script.Parent.DataStore2)
	local masterDataName = "dataStore_name"
	local plrData = DataStore2(masterDataName, plr)
	plrData:Set(encodedData)
end


return dataFunctions
