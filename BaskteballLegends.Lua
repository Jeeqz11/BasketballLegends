-- Basketball Legends Module for Survivor Hub
-- Perfect Auto Greener + Smart AI AutoPlay integrated

local player = game.Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")

local autoGreenerEnabled = false
local aiEnabled = false

local rageMode = "Legit Rage" -- not used here but kept for possible extension

local function HasBall()
    local ball = workspace:FindFirstChild("Basketball")
    local char = player.Character
    if ball and char and char:FindFirstChild("HumanoidRootPart") then
        if not ball.Anchored and (char.HumanoidRootPart.Position - ball.Position).Magnitude < 3 then
            return true
        end
    end
    return false
end

local function FindNearestOpponent()
    local shortestDist = math.huge
    local nearest = nil
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp = char.HumanoidRootPart

    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (plr.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            if dist < shortestDist then
                shortestDist = dist
                nearest = plr.Character.HumanoidRootPart
            end
        end
    end
    return nearest
end

local function SmartAutoPlayLoop()
    while aiEnabled do
        task.wait(0.2)
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
        local hrp = char.HumanoidRootPart
        local ball = workspace:FindFirstChild("Basketball")
        local basket = workspace:FindFirstChild("Basket")

        if HasBall() and basket then
            hrp.CFrame = CFrame.new(hrp.Position:Lerp(basket.Position + Vector3.new(0,5,0), 0.3))
            if math.random() < 0.4 then
                VirtualUser:Button1Down(Vector2.new(0,0))
                task.wait(0.1)
                VirtualUser:Button1Up(Vector2.new(0,0))
            end
        elseif ball and not ball.Anchored then
            hrp.CFrame = CFrame.new(hrp.Position:Lerp(ball.Position + Vector3.new(0, 2, 0), 0.4))
        else
            local target = FindNearestOpponent()
            if target then
                hrp.CFrame = CFrame.new(hrp.Position:Lerp(target.Position + Vector3.new(0, 0, -3), 0.4))
            end
        end
    end
end

local function AutoGreenerLoop()
    while autoGreenerEnabled do
        task.wait(0.1)
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
        local ball = workspace:FindFirstChild("Basketball")
        if ball and not ball.Anchored then
            -- Perfect timing for green release
            VirtualUser:Button1Down(Vector2.new(0,0))
            task.wait(0.035)
            VirtualUser:Button1Up(Vector2.new(0,0))
        end
    end
end

-- GUI Creation
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Basketball Legends Module",
    LoadingTitle = "Survivor Hub Basketball Legends",
    LoadingSubtitle = "Auto Greener + Smart Bot",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SurvivorHub",
        FileName = "BL_ModuleSettings"
    }
})

local MainTab = Window:CreateTab("MAIN", 4483362458)

MainTab:CreateToggle({
    Name = "Enable Perfect Auto Greener",
    CurrentValue = false,
    Callback = function(val)
        autoGreenerEnabled = val
        if val then
            task.spawn(AutoGreenerLoop)
        end
    end
})

MainTab:CreateToggle({
    Name = "Enable Smart AutoPlay Bot",
    CurrentValue = false,
    Callback = function(val)
        aiEnabled = val
        if val then
            task.spawn(SmartAutoPlayLoop)
        end
    end
})

MainTab:CreateParagraph({
    Title = "Status",
    Content = "Toggle AutoGreener and Smart Bot to control gameplay automation."
})

print("Basketball Legends Module loaded: Perfect AutoGreener + Smart AI Bot")


