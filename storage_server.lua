local RRL = peripheral.find("redstone_relay")
rednet.open("top")

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
  print("[]---[Storage Info]---[] \n")
  for _, storage in pairs(self.storageList) do
    print("      "..storage.name .. ":" , tostring(storage.value).."%")
  end
  print("[]--------------------[]")
end

function ServerLib:EventListener()
  while true do
    local id, msg, prot = rednet.receive()

    if prot == "storage_data_ping" then
      self:UpdateInfo()
      rednet.send(id,self.storageList,prot)
      print(id,"wanted to know about storage data.")
    end
  end
end

local Server = ServerLib.new()

print("Set and ready.")
Server:EventListener()