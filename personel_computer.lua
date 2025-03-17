function split(input, delimiter)
    local result = {}
    for match in (input .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

rednet.open("top")

local ComputerLib = {}
ComputerLib.__index = ComputerLib

function ComputerLib.new()
    local self = setmetatable({},ComputerLib)

    self.Commands = {
        {name = "storage", args = {"info"}, description = "storage işleri cartcurt"}
    }

    return self
end

function  ComputerLib:Main()
    while true do
        shell.run("clear")
        write("computer>")
        local input = read()

        for _, cmd in pairs(self.Commands) do
            local args = split(input," ")
            local command = table.remove(args,1)
            if command == cmd.name then
                if cmd.name == "storage" then
                    print("storag")
                    goto continue
                end
            end
        end
        print("command not found")
        ::continue::
    end
end

function ComputerLib:EventListener()
    
end

local Computer = ComputerLib.new()

parallel.waitForAll(
    function () Computer:Main() end,
    function () Computer:EventListener() end
)