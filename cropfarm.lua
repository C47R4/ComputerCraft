local relay = peripheral.find("redstone_relay")

local Program = {}
Program.__index = Program

function Program.new()
    local self = setmetatable({},Program)

    self.Version = "1.1.1"

    self.State = "Idle"

    return self
end

function Program:ShowState()
    shell.run("clear")
    print("Version: ".. self.Version)
    if self.State == "Idle" then
        print("Run 'go' to start proccess")
    elseif self.State == "Work" then
        print("Still working...")
    end
end

function Program:Pulse()
    relay.setOutput("back",true)
    os.sleep(2)
    relay.setOutput("back",false)
end

function Program:Work()
    while true do
        self:ShowState()
        write("Command> ")
        local input = read()

        if input:lower() == "go" then
            self.State = "Work"
            self:ShowState()

            self:Pulse()
        end

        os.sleep(1)
    end
end

local Device = Program.new()
Device:Work()
