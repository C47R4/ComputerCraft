local monitor = peripheral.find("monitor")

redstone.setOutput("bottom", true)

local Program = {}
Program.__index = Program

function Program.new()
    local self = setmetatable({},Program)

    return self
end

function Program:Plant()
    redstone.setOutput("bottom", false)
    os.sleep(6)
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
        self:Cycle()
        os.sleep(600)
    end
end


local Sugracne = Program.new()

Sugracne:Work()
