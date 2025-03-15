local monitor = peripheral.wrap("top")
local x_size, y_size = monitor.getScale()

redstone.setOutput("bottom", true)

local Program = {}
Program.__index = Program

function Program.new()
    local self = setmetatable({},Program)

    self.TimeLeft = 15

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
    self:Harvest()
    os.sleep(6)
    self:Plant()
end

function Program:Work()
    while true do
        monitor.setCursorPos(x_size - 10,1)
        monitor.write("[",tostring(self.TimeLeft,"]"))

        if self.TimeLeft <= 0 then
            self:Cycle()
            self.TimeLeft = 15
        end
        os.sleep(1)
        self.TimeLeft = self.TimeLeft - 1
    end
end


local Sugracne = Program.new()

Sugracne:Work()
