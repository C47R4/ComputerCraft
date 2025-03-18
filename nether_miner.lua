local TurtleLib = {}
TurtleLib.__index = TurtleLib -- kaklumba tanımlaması

function TurtleLib.new() -- library yi kullanabilmek pratik olsun diye başlangıç tanım fonksiyonu
    local self = setmetatable({},TurtleLib) -- fonksiyonlara dışarıdan erişebilmek için köle gibi bir şey

    self.mode = ""
    self.running = false
    self.commandList = { -- terminalde kullanılacak komutların önceden yazılmış listesi
        {name = "help"},
        {name = "setMode"},
        {name = "start"}
    }
    self.triedRefuelSince = 10 -- her 10 adımda bir refuel denesin
    self.valuablesList = { -- envanterden atmayacağı eşyalar listesi
        "coal",
        "charcoal",
        "coal_block",
        "ancient_debris",
        "tnt"
    }

    return self -- kullanılabilir olması için döndürülmeli
end

function split(input, delimiter) -- chatgpt den çaldığım split fonksiyonu
    local result = {}
    for match in (input .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

function TurtleLib:SearchInventory(name)
    for i = 1, 16 do 
        if turtle.getItemDetail(i) ~= nil then
            local itemName = split(turtle.getItemDetail(i).name,":")[2]

            if itemName == name then
               return i 
            end 
        end
    end
    return nil
end

function TurtleLib:TryRefuel()
    local coalSlot = self:SearchInventory("coal")
    coalSlot = coalSlot == nil and self:SearchInventory("charcoal") or coalSlot -- kömür yoksa odun kömürü arayacak
    coalSlot = coalSlot == nil and self:SearchInventory("coal_block") or coalSlot -- o da yoksa kömür bloğu

    if coalSlot ~= nil then
        turtle.select(coalSlot)
        turtle.refuel()
    else
        -- yenileyemedi
    end
end

function TurtleLib:ThrowNiggas()
    for i = 1, 16 do 
        if turtle.getItemDetail(i) ~= nil then
            local itemName = split(turtle.getItemDetail(i).name,":")[2]

            local itemOK = false
            for _, item in pairs(self.valuablesList) do
                if item == itemName then
                    itemOK = true
                end
            end

            if not itemOK then
                turtle.select(i)
                turtle.drop()
            end
        end
    end
end

function TurtleLib:TNT()
    
    for i = 1, 2 do -- her 4 blokda bir duracak
        turtle.dig()
        turtle.forward()
        turtle.digDown()
        turtle.down()
        turtle.dig()
        turtle.forward()
        turtle.digUp()
        turtle.up()
    end

    local tntSlot = self:SearchInventory("tnt")
    if tntSlot == nil then self.running = false return end
    turtle.select(tntSlot) -- envanterde tnt arayacak

    turtle.placeDown()

end

function TurtleLib:Dig5o5()

    local function ToLeft()
        turtle.turnLeft()
        for i= 1, 4 do
            turtle.dig()
            turtle.forward()
        end
        turtle.turnRight() 
        return true
    end

    local function ToRight()
        turtle.turnRight()
        for i= 1, 4 do
            turtle.dig()
            turtle.forward()
        end
        turtle.turnLeft() 
        return true
    end

    local function partFunction(part)
        turtle.dig()
        turtle.forward()
        for a = 1, 2 do
            if part == 1 then ToLeft() else ToRight() end
            if part == 1 then turtle.digUp() turtle.up() else turtle.digDown() turtle.down() end
            if part == 1 then ToRight() else ToLeft() end
            if part == 1 then turtle.digUp() turtle.up() else turtle.digDown() turtle.down() end
        end
        if part == 1 then ToLeft() else ToRight() end
    end

    -- Aşama 1
    partFunction(1)
    -- Aşama 2
    partFunction(2)
end

function TurtleLib:Executioner() -- terminal kodu durmasın diye ekstradan bir fonksiyon
    while true do

        if self.running then
            if self.mode == "straight" then
                term.setTextColor(colors.gray)
                print("Started",self.mode)
                term.setTextColor(colors.white)
                for i = 1, 500 do -- 1000 block gidecek
                    self:ThrowNiggas()
                    self:Dig5o5()

                    self.triedRefuelSince = self.triedRefuelSince - 2
                    if self.triedRefuelSince <= 0 then
                        self:TryRefuel()

                        self.triedRefuelSince = 10
                    end
                end

                if not self.running then break end
            elseif self.mode == "tnt" then
                term.setTextColor(colors.gray)
                print("Started",self.mode)
                term.setTextColor(colors.white)
                for i = 1, 250 do -- 1000 block gidecek
                    self:ThrowNiggas()
                    self:TNT()

                    self.triedRefuelSince = self.triedRefuelSince - 4
                    if self.triedRefuelSince <= 0 then
                        self:TryRefuel()

                        self.triedRefuelSince = 10
                    end

                    if not self.running then break end
                end
            else -- yanlış mod girilirse fonksiyonu kapatacak
                term.setTextColor(colors.gray)
                print("Mode unrecognized")
                term.setTextColor(colors.white)
                self.running = false
            end
        end

        os.sleep(0.1)
    end
end

function TurtleLib:Main() -- başta çağırılacak olan ana fonksiyon
    shell.run("clear") -- temiz olsun diye başta bir clear
    self:TryRefuel()
    while true do
        write("Turtle>")
        local input = read()

        local args = split(input," ")
        local command = table.remove(args,1)

        if command == "help" then
            term.setTextColor(colors.gray)
            for _, cmd in pairs(self.commandList) do
                print(cmd.name)
            end
            term.setTextColor(colors.white)
        elseif command == "setMode" then
            local mode = args[1]

            if mode == nil then
                term.setTextColor(colors.gray)
                print("You need to specify a mode\nModes: ")
                term.setTextColor(colors.lightGray)
                print("straight\ntnt")
                term.setTextColor(colors.white)
            else
                self.mode = mode
                term.setTextColor(colors.gray)
                print("Mode set to", mode)
                term.setTextColor(colors.white)
            end
        elseif command == "start" then
            self.running = true
        else -- Anlamsız bir kod yazılırsa uyarı vericek
            term.setTextColor(colors.gray)
            print("No such command as", command)
            term.setTextColor(colors.white)
        end


        os.sleep(0.1) -- her ne kadar başka şeyler tarafından yavaşlatılacak olsa da ne olur ne olmaz diye sonsuz döngülere küçük bir delay koymak gerek
    end
end

local MinerTurtle = TurtleLib.new() -- burada objeyi kullanılabilsin diye oluşturuyoruz

parallel.waitForAll( -- aynı anda 2 fonksiyonu da çağırıyor
    function () MinerTurtle:Main() end,
    function () MinerTurtle:Executioner() end
) 
