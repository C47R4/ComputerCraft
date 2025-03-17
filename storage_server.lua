local RRL = peripheral.find("redstone_relay")

local ServerLib = {}
ServerLib.__index = ServerLib

function ServerLib.new()
  local self = setmetatable({},ServerLib)

  self.storageList = {}

  return self
end

function ServerLib:UpdateInfo()
  
  self.storageList = {}

  local crop_0 = math.floor(RRL.getAnalogInput("back") / 15 * 100)
  table.insert(self.storageList,{name = "[0]Crop", value = crop_0})
  
  local wood_0 = math.floor(RRL.getAnalogInput("front") / 15 * 100)
  table.insert(self.storageList,{name = "[0]Wood", value = wood_0})
  
  local prod_0 = math.floor(RRL.getAnalogInput("left") / 15 * 100)
  table.insert(self.storageList,{name = "[0]Prod", value = prod_0})

end

function ServerLib:PrintInfo()
  print("[]---[Storage Info]---[]")
  for _, storage in pairs(self.storageList) do
    print("|"..storage.name .. ":" , tostring(storage.value).."%            | ")
  end
  print("[]--------------------[]")
end

local Server = ServerLib.new()

Server:UpdateInfo()
Server:PrintInfo()