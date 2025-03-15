local relay = peripheral.find("redstone_relay")

local Program = {}
Program.__index = Program

function Program.new()
    local self = setmetatable({},Program)

    self.Version = "1.2.2"

    self.Ended = false
    self.Started = false

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

function Program:EventListener()
    while true do
        os.pullEvent("redstone")

        local ended = relay.getInput("top")
        local started = relay.getInput("right")

        if ended then
            if self.Started then 
                self.Ended = true
            end
        elseif Started then 
            self.Started = true
        end

    end
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
            self.State = "Idle"
        end

        os.sleep(1)
    end
end

local Device = Program.new()
parallel.waitForAll(
    function() Device:Work() end,
    function() Device:EventListener() end
)
