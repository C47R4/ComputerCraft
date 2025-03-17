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
        {name = "storage", args = {"info"}, usage = "storage <arg>"}
    }

    return self
end

function  ComputerLib:Main()
    shell.run("clear")
    while true do
        write("computer>")
        local input = read()

        local args = split(input," ")
        local command = table.remove(args,1)

        for _, cmd in pairs(self.Commands) do
            if command == cmd.name then
                if cmd.name == "storage" then

                    for _, commandarg in pairs(cmd.args) do
                        if args[1] == commandarg then
                            if args[1] == "info" then
                                
                                rednet.broadcast("nigger","storage_data_ping")

                            end
                        end
                    end

                    print("Usage: ", cmd.usage, "\nArgs: ")
                    for _, commandarg in pairs(cmd.args) do
                        print(commandarg)
                    end
                    ::continue2::
                end
            end
        end
        print("no such command as",command)
        ::continue::
    end
end

function ComputerLib:EventListener()
    while true do
        local eventData = os.pullEvent()

        local eventName = eventData[1]

        print(eventName)

    end
end

local Computer = ComputerLib.new()

parallel.waitForAll(
    function () Computer:Main() end,
    function () Computer:EventListener() end
)