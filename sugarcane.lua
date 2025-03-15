local monitor = peripheral.find("monitor")

redstone.setOutput("bottom", true)

local Program = {}

function Program.new()
    local self = setmetatable({},Program)

    return self
end

function Program:Plant()
    redstone.setOutput("bottom", false)
    os.sleep(10)
    redstone.setOutput("bottom", true)
end

function Program:Harvest()
    redstone.setOutput("back", true)
    os.sleep(10)
    redstone.setOutput("back", false)
end

function Program:Cycle()
    self:Harvest()
    os.sleep(10)
    self:Plant()
end

function Program:Run()
    while true do
        self:Cycle
        os.sleep(1)
    end
end


local Sugracne = Program.new()

Sugracne:Run()
