local monitor = peripheral.wrap("top")
monitor.setTextScale(0.75)
local x_size, y_size = monitor.getSize()

redstone.setOutput("bottom", true)

local Program = {}
Program.__index = Program

function Program.new()
    local self = setmetatable({},Program)

    self.TimeLeft = 60
    self.State = "Wait"

    return self
end

function Program:Plant()
    redstone.setOutput("bottom", false)
    os.sleep(5)
    redstone.setOutput("bottom", true)
end

function Program:Harvest()
    redstone.setOutput("back", true)
    os.sleep(6)
    redstone.setOutput("back", false)
end

function Program:Cycle()
    self.State = "Harvest"
    self:Harvest()
    os.sleep(6)
    self.State = "Plant"
    self:Plant()
    self.State = "Wait"
end

function Program:ShowState()
    monitor.clear()
    if self.State == "Wait" then
        monitor.setCursorPos(x_size - 30,2)
        local MinutesTime = math.floor(self.TimeLeft / 60)
        local SecondsTime = self.TimeLeft - (MinutesTime * 60)
        monitor.write("Time to auto harvest : [ "..tostring(MinutesTime) .. ":" .. tostring(SecondsTime).." ]")
    elseif self.State == "Harvest" then
        monitor.setCursorPos(x_size/2 - 7,y_size/2)
        monitor.write("Harvesting...")
    elseif self.State == "Plant" then
        monitor.setCursorPos(x_size/2 - 6,y_size/2)
        monitor.write("Planting...")
    end
end

function Program:Work()
    while true do
        self:ShowState()

        if self.TimeLeft <= 0 then
            self:Cycle()
            self.TimeLeft = 60
        end
        os.sleep(1)
        self.TimeLeft = self.TimeLeft - 1
    end
end


local Sugracne = Program.new()

Sugracne:Work()
