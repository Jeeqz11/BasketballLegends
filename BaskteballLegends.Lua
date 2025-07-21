-- BasketballLegendsEnhanced.lua
-- Full Smart AI + Auto Greener by Survivor Team

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

local ShootKey = Enum.KeyCode.E
local StealKey = Enum.KeyCode.R
local BlockKey = Enum.KeyCode.Space

local ball = nil
local isShooting = false
local autoGreenerEnabled = true

-- Get ball reference (simplified)
local function FindBall()
	return workspace:FindFirstChild("Basketball") or workspace:FindFirstChildWhichIsA("BasePart", true)
end

-- Simulate dribble moves with slight random movement to fake legit player
local function DribbleMovement()
	local offset = Vector3.new(math.sin(tick()*3)*1.5, 0, math.cos(tick()*3)*1.5)
	RootPart.CFrame = RootPart.CFrame * CFrame.new(offset.X, 0, offset.Z)
end

-- Auto Greener - manipulate release time for perfect shot
local function AutoGreener()
	if not autoGreenerEnabled or not ball then return end
	if isShooting then return end
	isShooting = true
	
	-- Step 1: Prepare shot
	task.wait(math.random(0.05,0.1))
	
	-- Step 2: Release perfectly timed
	-- Manipulate the throw force or release timing here:
	-- This is a placeholder, real game mechanics vary
	local throwForce = 80 + math.random(-2, 2) -- slight randomness for natural feel
	
	-- Fire the shoot event (replace with actual shoot event)
	local shootEvent = workspace:FindFirstChild("ShootEvent") or nil
	if shootEvent and shootEvent:IsA("RemoteEvent") then
		shootEvent:FireServer(throwForce)
	end
	
	task.wait(0.1)
	isShooting = false
end

-- Smart AI decision maker
local function SmartAI()
	while true do
		task.wait(0.01) -- super fast reaction
		
		ball = FindBall()
		if not ball then continue end
		
		-- Check if player has ball
		local hasBall = false
		local ballOwner = ball:FindFirstChild("Owner") -- example
		if ballOwner and ballOwner.Value == LocalPlayer then
			hasBall = true
		end
		
		if hasBall then
			-- Move to shooting position
			RootPart.CFrame = CFrame.new(ball.Position) * CFrame.new(0,0,-2)
			
			-- Dribble to fake out defender
			DribbleMovement()
			
			-- Shoot randomly between perfect/great
			if math.random() < 0.03 then -- 3% chance to shoot each tick
				AutoGreener()
			end
			
		else
			-- Defensive behavior
			-- Find opponent with ball and guard / steal / block
			local opponents = {}
			for _, plr in pairs(Players:GetPlayers()) do
				if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
					local char = plr.Character
					local hasBallOpponent = false
					local ballOwner = ball:FindFirstChild("Owner")
					if ballOwner and ballOwner.Value == plr then
						hasBallOpponent = true
					end
					if hasBallOpponent then
						table.insert(opponents, char.HumanoidRootPart)
					end
				end
			end
			
			if #opponents > 0 then
				local target = opponents[1]
				local dist = (RootPart.Position - target.Position).Magnitude
				
				-- Guard player by moving close
				if dist > 3 then
					RootPart.CFrame = CFrame.new(target.Position) * CFrame.new(0,0,-1)
				end
				
				-- Steal if close enough and R pressed
				if dist <= 3 and UserInputService:IsKeyDown(StealKey) then
					-- Fire steal event (replace with actual game event)
					local stealEvent = workspace:FindFirstChild("StealEvent")
					if stealEvent and stealEvent:IsA("RemoteEvent") then
						stealEvent:FireServer(target.Parent)
					end
				end
				
				-- Block if close and space pressed
				if dist <= 3 and UserInputService:IsKeyDown(BlockKey) then
					-- Fire block event or jump action
					Humanoid.Jump = true
				end
			end
		end
	end
end

-- Start Smart AI in coroutine
coroutine.wrap(SmartAI)()

print("[SurvivorHub] Basketball Legends Enhanced AI + AutoGreener loaded.")
