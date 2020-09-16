--[[
  The purpose of this script is to load, save, delete, and write on top of existing data.
  This script creates a folder within each player called 'DataReader'. This folder is used to check a players data through the server/client boundary.
  DO NOT attempt to write on the folder, instead, use the functions on the DataModule.
  This script uses an IntValue called '_version' in order to clear out the datastore. A new version means a new datastore, since the ds name is changing.
  This script can be configured to hold multiple datastores (as had previously).
]]
-- Core service grabs.
HttpService = game:GetService("HttpService")
repStore = game:GetService("ReplicatedStorage")
servStore = game:GetService("ServerScriptService")
scriptServ = game:GetService("ServerScriptService")

DataStore2 = require(script.Parent:WaitForChild("MainModule"))
dataModule = require(script.Parent:WaitForChild("DataModule"))

local defaultData = dataModule.grabPlayerData()

-- Data keys.

_version = script.Parent:WaitForChild("_version").Value
masterDataName = "dataName".. _version

game.Players.PlayerAdded:Connect(function(plr)
	
	-- Data initializer.
	local plrData = DataStore2(masterDataName, plr)
	
	-- function to create values easier.
	local function makeValue(name, typeF, parent, val)
		local v = Instance.new(typeF, parent)
		v.Name = name
		if val then
			v.Value = val
		end
		return v
	end
	
	local dataLoaded = makeValue("masterDataLoaded", "BoolValue", plr, false)
	
	-- Function that handles the saving and loading of data.
	--------------------------------------------------------------------------------
	---------------------------- HANDLE DATA FUNCTIONS -----------------------------
	--------------------------------------------------------------------------------
	-- START OF HANDLE DATA
	
	local function handleData(_dataStore, defaultToHandle)
		
		local genericError = "Data could not be loaded for "
		
		-- The datastore to handle, _dataStore being the store,
		-- defaultToHandle is the default backup.
		local fullPull = _dataStore:Get(defaultToHandle)
		
		-- Creates data values inside of folder (dataFolder) by looping through the raw data.
		local function generateData(dataFolder, rawData)
			
			local function genVal(_v, key, par)
				
				local function decideData(valBeingPassed, keyToCheck, parToCheck, valType)
					if parToCheck:FindFirstChild(keyToCheck) then
						local thisDataValue = parToCheck:FindFirstChild(keyToCheck)
						thisDataValue.Value = valBeingPassed
					else
						local value = makeValue(keyToCheck, valType, parToCheck, valBeingPassed)
					end
				end
				
				if type(_v) == "number" then
					decideData(_v, key, par, "IntValue")
				elseif type(_v) == "string" then
					decideData(_v, key, par, "StringValue")
				elseif type(_v) == "boolean" then
					decideData(_v, key, par, "BoolValue")
				elseif type(_v) == "table" then
					local fToUse = nil
					if par:FindFirstChild(key) then
						fToUse = par:FindFirstChild(key)
					else
						fToUse = makeValue(key, "Folder", par)
					end
					for key2, v2 in pairs(_v) do
						genVal(v2, key2, fToUse)
					end
				end
			end
			
			-- Generates then updates data.
			for key,v in pairs(rawData.info) do
				genVal(v, key, dataFolder)
			end
			
			local function cleanData()
				-- "rawData is each data node."
				
				local function isInTable(tableValue, toFind)
					local found = false
					for key ,val in pairs(tableValue) do
						if key == toFind then
							found = true
				            break
						end
					end
					return found
				end
				
				local function purgeData(folderToCheck, rawDataToCheck)
					for _, nodeData in pairs(folderToCheck:GetChildren()) do
						
						if rawDataToCheck ~= nil then
							if isInTable(rawDataToCheck, nodeData.Name) then
								-- Data exists.
							elseif nodeData.ClassName == "Folder" then
								local rawDataTable = rawDataToCheck[nodeData.Name]
								purgeData(nodeData, rawDataTable)
							else
								nodeData:Destroy()
							end
						else
							folderToCheck:Destroy()
							warn(folderToCheck.Name.. " cannot be found on data.")
						end
						
					end
				end
				
				for nodeKey, nodeData in pairs(dataFolder:GetChildren()) do
					--warn(key)
					--print(node)
					if nodeData.ClassName == "Folder" then -- Gets nodes in data folder.
						-- Start of purging.
						if isInTable(rawData.info, nodeData.Name) then
							purgeData(nodeData, rawData.info[nodeData.Name])
						else
							nodeData:Destroy()
						end
					else
						if isInTable(rawData.info, nodeData.Name) == false then
							nodeData:Destroy()
						end
					end
				end
				
			end
			cleanData()
			
			print("Data Handled")
		end
		
		-- Reads through each node in the datastore and sends them to "createData".
		local function pullData(reader, mode)
			local _fullPull = _dataStore:Get(defaultToHandle)
			for key, node in pairs(_fullPull) do
				local nodeData = HttpService:JSONDecode(node)
				if nodeData.message == "success" then
					if reader:FindFirstChild(tostring(key)) then
						local folderToUpdate = reader:FindFirstChild(tostring(key))
						generateData(folderToUpdate, nodeData)
					else
						local newFolder = makeValue(tostring(key), "Folder", reader)
						generateData(newFolder, nodeData)
					end
				else
					warn(genericError.. tostring(key))
				end
			end
		end
		
		-- Main Function.
		local function main()
			if plr:FindFirstChild("DataReader") then
				local folder = plr.DataReader
				pullData(folder)
			else
				local dataFolder = makeValue("DataReader", "Folder", plr)
				pullData(dataFolder)
			end
		end
		main()
		
	end
	-- END OF HANDLE DATA
	--------------------------------------------------------------------------------
	--------------------------------------------------------------------------------
	--------------------------------------------------------------------------------
	
	-- Master Handle.
	handleData(plrData, defaultData)
	
	local function pushData()
		handleData(plrData, defaultData)
	end
	
	-- When data updates, push values to the reader folders.
	plrData:OnUpdate(pushData)
	
end)
