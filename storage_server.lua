local RRL = peripheral.find("redstone_relay")
local crop_0 = math.floor(RRL.getAnalogInput("back") / 15 * 100)

print(tostring(crop_0).."%")
