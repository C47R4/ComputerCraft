local RRL = peripheral.find("redstone_relay")

local storage_list = {}

local crop_0 = math.floor(RRL.getAnalogInput("back") / 15 * 100)
table.insert(storage_list,{name = "[0]Crop", value = crop_0})

local wood_0 = math.floor(RRL.getAnalogInput("front") / 15 * 100)
table.insert(storage_list,{name = "[0]Wood", value = wood_0})

local prod_0 = math.floor(RRL.getAnalogInput("left") / 15 * 100)
table.insert(storage_list,{name = "[0]Prod", value = prod_0})

for _, storage in pairs(storage_list) do
  print(storage.name .. ":" , tostring(storage.value).."%")
end
