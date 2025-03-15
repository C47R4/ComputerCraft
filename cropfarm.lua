local relay = peripheral.find("redstone_relay")

local Program = {}
Program.__index = Program

function Program.new()
    local self = setmetatable({},Program)

    self.Version = "1.3.0"

    self.Ended = true
    self.Started = false
    self.Halfed = false

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
                self.Ended = false
                self.Started = false
                self.Halfed = true
                print("halfed")
            end
        elseif Started then 
            if self.Halfed then
                self.Ended = true
                self.Started = false
                self.Halfed = false
                print("ended")
            else
                self.Ended = false
                self.Started = true
                self.Halfed = false
                print("started")
            end
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

            while self.Ended == false do
                os.sleep(1)
            end

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
