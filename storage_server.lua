local RRL = peripheral.find("redstone_relay")

local storage_list = {}

local crop_0 = math.floor(RRL.getAnalogInput("back") / 15 * 100)
table.insert(storage_list,{name = "Crop 0", value = crop_0})

for _, storage in storage_list do
  print(name .. ":" , tostring(crop_0).."%")
end
