-- Basketball Legends Module with Smart AI and Realistic Auto Greener
local player = game.Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")

local autoGreenerEnabled = false
local aiEnabled = false

-- Helper Functions
local function HasBall()
    local ball = workspace:FindFirstChild("Basketball")
    local char = player.Character
    if ball and char and char:FindFirstChild("HumanoidRootPart") then
        return (char.HumanoidRootPart.Position - ball.Position).Magnitude < 3 and not ball.Anchored
    end
    return false
end

local function OnCourt()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return false end
    local hrp = char.HumanoidRootPart
    local court = workspace:FindFirstChild("Court") or workspace:FindFirstChild("Basket")
    if court then
        return (hrp.Position - court.Position).Magnitude < 30
    end
    return false
end

local function DribblePattern()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local basePos = hrp.Position
    for i=1,math.random(3,7) do
        local offsetX = math.random(-2,2)
        local offsetZ = math.random(-2,2)
        hrp.CFrame = CFrame.new(basePos + Vector3.new(offsetX,0,offsetZ))
        task.wait(math.random(0.3,0.7))
    end
end

-- Smart AI Auto Play Loop
local function SmartAutoPlayLoop()
    while aiEnabled do
        task.wait(0.25)
        if not OnCourt() then
            task.wait(1)
            continue
        end

        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
        local hrp = char.HumanoidRootPart
        local ball = workspace:FindFirstChild("Basketball")
        local basket = workspace:FindFirstChild("Basket")

        if HasBall() and basket then
            -- Approach basket smoothly
            hrp.CFrame = CFrame.new(hrp.Position:Lerp(basket.Position + Vector3.new(0,5,0), 0.3))
            -- Random chance to shoot
            if math.random() < 0.45 then
                VirtualUser:Button1Down(Vector2.new(0,0))
                task.wait(0.1 + math.random()*0.15)
                VirtualUser:Button1Up(Vector2.new(0,0))
            end
        elseif ball and not ball.Anchored then
            -- Chase ball and do dribble pattern when close
            if (hrp.Position - ball.Position).Magnitude > 3 then
                hrp.CFrame = CFrame.new(hrp.Position:Lerp(ball.Position + Vector3.new(0, 2, 0), 0.4))
            else
                DribblePattern()
            end
        else
            -- Guard nearest opponent intelligently
            local shortestDist = math.huge
            local nearest = nil
            for _, plr in pairs(game.Players:GetPlayers()) do
                if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (plr.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        nearest = plr.Character.HumanoidRootPart
                    end
                end
            end
            if nearest then
                hrp.CFrame = CFrame.new(hrp.Position:Lerp(nearest.Position + Vector3.new(0, 0, -3), 0.4))
            end
        end
    end
end

-- Auto Greener Loop with Realistic Timing
local function AutoGreenerLoop()
    while autoGreenerEnabled do
        task.wait(0.15)
        local char = player.Character
        local ball = workspace:FindFirstChild("Basketball")
        if char and char:FindFirstChild("HumanoidRootPart") and ball and not ball.Anchored then
            VirtualUser:Button1Down(Vector2.new(0,0))
            local timing = (math.random() < 0.6) and 0.035 or 0.055 -- 60% perfect, 40% great
            task.wait(timing)
            VirtualUser:Button1Up(Vector2.new(0,0))
        end
    end
end

-- GUI Integration (Example using Rayfield assumed available)
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Survivor Hub - Basketball Legends",
    LoadingTitle = "Loading Basketball Legends Module",
    LoadingSubtitle = "Smart AI + Auto Greener",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SurvivorHub",
        FileName = "BasketballLegendsSettings"
    }
})

local MainTab = Window:CreateTab("MAIN", 4483362458)

MainTab:CreateToggle({
    Name = "Enable Smart AI AutoPlay",
    CurrentValue = false,
    Flag = "AI_Toggle",
    Callback = function(value)
        aiEnabled = value
        if value then
            task.spawn(SmartAutoPlayLoop)
        end
    end
})

MainTab:CreateToggle({
    Name = "Enable Auto Greener (Great & Perfect)",
    CurrentValue = false,
    Flag = "AutoGreener_Toggle",
    Callback = function(value)
        autoGreenerEnabled = value
        if value then
            task.spawn(AutoGreenerLoop)
        end
    end
})

-- End of Basketball Legends Module

