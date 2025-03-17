local ValuableList = {
    "coal_ore",
    "diamond_ore",
    "copper_ore",
    "iron_ore",
    "redstone_ore",
    "deepslate_diamond_ore",
    "deepslate_copper_ore",
    "deepslate_iron_ore",
    "deepslate_redstone_ore"
}

function split(input, delimiter)
    local result = {}
    for match in (input .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

local function CheckIfValuable(id)
    local name = split(id,":")[2]
    for _, Valuable in pairs(ValuableList) do
        if Valuable == name then
            return true
        end
    end
    return false
end

function ReverseList(input)
    local reversed = {}
    for i = #input, 1, -1 do
        table.insert(reversed, input[i])
    end
    return reversed
end

local Program = {}
Program.__index = Program

function Program.new()
    local self = setmetatable({},Program)

    self.Status = "Idle"
    self.Mode = "Random"

    self.Bond = nil

    self.MovesMadeSinceStart = {}
    self.MovesMadeSinceVein = {}
    self.BotLog = {}

    self.ConnectedTo = nil
    self.GivenOrders = {}

    self.ActiveCoroutines = {}

    return self
end

function Program:Inspect(face)
    if face then
        local has_block, data
        if face == "down" then
            has_block, data = turtle.inspectDown()
        elseif face == "up" then
            has_block, data = turtle.inspectUp()
        else
            return false
        end

        if has_block then
            if CheckIfValuable(data.name) then
                return true
            end
        else
            return false
        end 
    else
        local has_block, data = turtle.inspect()
        if has_block then
            if CheckIfValuable(data.name) then
                return true
            end
        else
            return false
        end 
    end
end

function Program:Report(info)
    table.insert(self.BotLog,info)
    print(info)
end

function Program:TryRefuel()
    local Charge = turtle.getFuelLevel()/(turtle.getFuelLimit()/100)
    if Charge < 10 then -- recharge
        self.Status = "Charging"
        for slot = 1, 16 do
            turtle.select(slot)
            while turtle.getItemCount(slot) > 0 do
                if not turtle.refuel(1) then
                    break
                end
            end
        end

        local newCharge = turtle.getFuelLevel()/(turtle.getFuelLimit()/100)
        if newCharge > Charge then
            self:Report("Charged! New charge: ".. newCharge .. "%")
        else
            self:Report("Not enough fuel! Can't charge.")
        end
    end
    self.Status = "Strip mining"
end

function Program:ReturnHome() -- WIP
    for i = 1, #self.MovesMadeSinceStart/4, 1 do
        turtle.back()
        os.sleep(0.1)
    end
end

function Program:ReturnPosition()
    local ReversedMoves = self.MovesMadeSinceVein
    for i = #ReversedMoves, 1, -1 do
        local Move = ReversedMoves[i]
    
        if Move == "forward" then
            turtle.back()
            table.remove(ReversedMoves, i)
            table.remove(self.MovesMadeSinceStart, #self.MovesMadeSinceStart-#self.MovesMadeSinceVein + i)
        elseif Move == "up" then
            turtle.down()
            table.remove(ReversedMoves, i)
            table.remove(self.MovesMadeSinceStart, #self.MovesMadeSinceStart-#self.MovesMadeSinceVein + i)
        elseif Move == "down" then
            turtle.up()
            table.remove(ReversedMoves, i)
            table.remove(self.MovesMadeSinceStart, #self.MovesMadeSinceStart-#self.MovesMadeSinceVein + i)
        elseif Move == "left" then
            if ReversedMoves[i-1] == "left" and ReversedMoves[i-2] == "left" and ReversedMoves[i-3] == "left" then
                table.remove(ReversedMoves, i)
                table.remove(ReversedMoves, i-1)
                table.remove(ReversedMoves, i-2)
                table.remove(ReversedMoves, i-3)
                table.remove(self.MovesMadeSinceStart, #self.MovesMadeSinceStart-#self.MovesMadeSinceVein + i)
                table.remove(self.MovesMadeSinceStart, #self.MovesMadeSinceStart-#self.MovesMadeSinceVein + (i-1))
                table.remove(self.MovesMadeSinceStart, #self.MovesMadeSinceStart-#self.MovesMadeSinceVein + (i-2))
                table.remove(self.MovesMadeSinceStart, #self.MovesMadeSinceStart-#self.MovesMadeSinceVein + (i-3))
            elseif ReversedMoves[i-1] == "left" and ReversedMoves[i-2] == "left" then
                table.remove(ReversedMoves, i)
                table.remove(ReversedMoves, i-1)
                table.remove(ReversedMoves, i-2)
                table.remove(self.MovesMadeSinceStart, #self.MovesMadeSinceStart-#self.MovesMadeSinceVein + i)
                table.remove(self.MovesMadeSinceStart, #self.MovesMadeSinceStart-#self.MovesMadeSinceVein + (i-1))
                table.remove(self.MovesMadeSinceStart, #self.MovesMadeSinceStart-#self.MovesMadeSinceVein + (i-2))
                turtle.turnLeft()
            else
                turtle.turnRight()
                table.remove(ReversedMoves, i)
                table.remove(self.MovesMadeSinceStart, #self.MovesMadeSinceStart-#self.MovesMadeSinceVein + i)
            end
        end 
    end
    self.MovesMadeSinceVein = ReversedMoves
end

function Program:Search()
    self.Status = "Searching"
    if self:Inspect("up") then
        turtle.digUp()

        if self.Mode ~= "Search" then
            turtle.up()
            table.insert(self.MovesMadeSinceStart,"up")
            table.insert(self.MovesMadeSinceVein,"up")
            self:Search()
            return
        end
    end
    if self:Inspect("down") then
        turtle.digDown()

        if self.Mode ~= "Search" then
            turtle.down()
            table.insert(self.MovesMadeSinceStart,"down")
            table.insert(self.MovesMadeSinceVein,"down")
            self:Search()
            return
        end
    end
    for i = 1 , 4 do
        if self:Inspect() then
            turtle.dig()

            if self.Mode ~= "Search" then
                turtle.forward()
                table.insert(self.MovesMadeSinceStart,"forward")
                table.insert(self.MovesMadeSinceVein,"forward")
                self:Search()
                return
            end
        end
        turtle.turnLeft()
        table.insert(self.MovesMadeSinceStart,"left")
        table.insert(self.MovesMadeSinceVein,"left")
    end
    self.Status = "Strip mining"
end

function Program:StripMine(Distance)
    for Dist = 1, Distance do
        -- Casual
        self.Status = "Strip mining"
        self:TryRefuel()


        while not turtle.forward() do turtle.dig() end
        table.insert(self.MovesMadeSinceStart,"forward")
        if self.Mode ~= "StripMine" then self:Search() self:ReturnPosition() end

        while not turtle.down() do turtle.digDown() end
        table.insert(self.MovesMadeSinceStart,"down")
        if self.Mode ~= "StripMine" then self:Search() self:ReturnPosition() end

        while not turtle.forward() do turtle.dig() end
        table.insert(self.MovesMadeSinceStart,"forward")
        if self.Mode ~= "StripMine" then self:Search() self:ReturnPosition() end

        while not turtle.up() do turtle.digUp() end
        table.insert(self.MovesMadeSinceStart,"up")
        if self.Mode ~= "StripMine" then self:Search() self:ReturnPosition() end
    end
end

function Program:Updater()
    while true do
        if self.ConnectedTo ~= nil then
            rednet.send(self.ConnectedTo,{
                stat = self.Status,
                mode = self.Mode
            },"MT")
        end
        os.sleep(0.1)
    end
end

function Program:OrderMediator()
    rednet.open("right")
    while true do
        local id, message, protocol = rednet.receive("MT")
        if message == "ping" then
            rednet.send(id,"ping","MT")
        elseif message == "update" then
            self.ConnectedTo = id
            print("updating")
        elseif message == "strip_mine" then
            table.insert(self.GivenOrders,"StripMine")
        end

        os.sleep(.1)
    end
end

function Program:Main()
    if self.Bond == nil then
        self:StripMine(300)
        self:ReturnHome()
    else
        while true do
            if #self.GivenOrders > 0 then
                local order = table.remove(self.GivenOrders, 1)
                if order == "StripMine" then
                   self:StripMine(999) 
                end
            end
            os.sleep(0.1)
        end
    end
end

function Program:Start()
    parallel.waitForAll(
        function() self:Main() end
        --function() self:OrderMediator() end,
        --function() self:Updater() end
    )
end

local Bot = Program.new()
Bot:Start()
