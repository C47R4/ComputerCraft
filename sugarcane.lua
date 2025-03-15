local monitor = peripheral.wrap("top")
monitor.setTextScale(0.75)
local x_size, y_size = monitor.getSize()

redstone.setOutput("bottom", true)

local Program = {}
Program.__index = Program

function Program.new()
    local self = setmetatable({},Program)

    self.Version = 1.12

    self.WaitTime = 30
    self.TimeLeft = self.WaitTime
    self.State = "Wait"

    self.inCycle = false

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
    self.inCycle = true
    self.State = "Harvest"
    self:ShowState()
    self:Harvest()
    os.sleep(6)
    self.State = "Plant"
    self:ShowState()
    self:Plant()
    os.sleep(6)
    self.State = "Wait"
    self.TimeLeft = self.WaitTime
    self.inCycle = false
end

function Program:ShowState()
    monitor.clear()
    if self.State == "Wait" then
        monitor.setCursorPos(x_size - 30,2)
        local MinutesTime = tostring(math.floor(self.TimeLeft / 60))
        local SecondsTime = self.TimeLeft - (MinutesTime * 60)
        local SecondsTime = SecondsTime < 10 and "0".. tostring(SecondsTime) or tostring(SecondsTime)
        monitor.write("Time to auto harvest : [ ".. MinutesTime .. ":" .. SecondsTime.." ]")
    
        monitor.setCursorPos(x_size/5 * 1, y_size /5 *1)
        monitor.write("[Start manual harvest]")
    elseif self.State == "Harvest" then
        monitor.setCursorPos(x_size/2 - 7,y_size/2)
        monitor.write("Harvesting...")
    elseif self.State == "Plant" then
        monitor.setCursorPos(x_size/2 - 6,y_size/2)
        monitor.write("Planting...")
    end
end

function Program:EventListener()
    while true do 
        local event, side, x_touch, y_touch = os.pullEvent("monitor_touch")



        os.sleep(0.1)
    end
end

function Program:Work()
    print("Version: ".. self.Version)
    while true do
        if self.inCycle == true then return end
        self:ShowState()

        if self.TimeLeft <= 0 then
            self:Cycle()
        end
        os.sleep(1)
        self.TimeLeft = self.TimeLeft - 1
    end
end


local Sugracne = Program.new()

parallel.waitForAll(
    function() Sugracne:Work() end,
    function() Sugracne:EventListener() end
)