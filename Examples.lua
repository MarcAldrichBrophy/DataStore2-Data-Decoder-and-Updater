
local servStorage = game:GetService("ServerStorage")
local sss = game:GetService("ServerScriptService")
local servToServ = servStorage:WaitForChild("servToServ")
local dataModule = require(sss:WaitForChild("DataFolder"):WaitForChild("DataModule"))


servToServ.Event:Connect(function(plr, msg)
	
	if msg == "addData" then
		-- This section shows how to use the Data Module in order to add a new value,
		-- and save data when finished.
		local rawData = dataModule.pullDecoded(plr)
		rawData.basicData.info["newDataName"] = 2
		-- conversely, you can set an existing data name to = nil.
		-- ex: rawData.basicData.info["existingName"] = nil.
		
		local newData = dataModule.EncodeUpdatedRaw(rawData)
		dataModule.pushSave(plr, newData)
	end
	
	
	if msg == "increaseTicket" then
		-- This section shows how to use the Data Module in order to increase/change an
		-- existing value and save when finished.
		local rawData = dataModule.pullDecoded(plr)
		
		rawData.basicData.info.tickets = rawData.basicData.info.tickets + 1
		
		local newData = dataModule.EncodeUpdatedRaw(rawData)
		dataModule.pushSave(plr, newData)
	end
end)
