--[[
📦 NEO HUB - PHANTOMBALL (Optimized Black Hole)
Versão leve, reescrita por ChatGPT - otimizada para menor uso de CPU
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ⚙️ Variáveis principais
local detectionDistance = 22
local distanceIncrement = 1.5
local incrementBonus = 0

local state = {
	AutoParry = false,
	AutoSpam = false,
	AutoSpamV2 = false,
	AutoSpamLock = false,
	AntiDasherSpam = false,
	ManualSpam = false
}

-- 🔁 Variáveis internas de controle
local isSpamming = false
local lastBall, lastBallColor = nil, nil
local lastCacheTime = 0
local cachedBall, cachedNearest, cachedDasher = nil, nil, nil

-- ==================== 🔹 Funções auxiliares ====================

local function fireServerCode()
	local args = {[1] = 2.933813859058389e+76}
	pcall(function()
		local remote = ReplicatedStorage:FindFirstChild("TS") and
			ReplicatedStorage.TS:FindFirstChild("GeneratedNetworkRemotes") and
			ReplicatedStorage.TS.GeneratedNetworkRemotes:FindFirstChild("RE_4.6848415795802784e+76")
		if remote then
			remote:FireServer(unpack(args))
		end
	end)
end

local function findGameBall()
	local b = workspace:FindFirstChild("GameBall")
	return (b and b:IsA("BasePart")) and b or nil
end

local function findNearestPlayer(maxDist)
	local char = LocalPlayer.Character
	if not char then return nil end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return nil end

	local nearest, dist = nil, maxDist
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character then
			local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
			if tHRP then
				local d = (tHRP.Position - hrp.Position).Magnitude
				if d < dist then
					dist = d
					nearest = plr
				end
			end
		end
	end
	return nearest
end

local function findDasher(maxDist)
	local char = LocalPlayer.Character
	if not char then return nil end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return nil end

	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character then
			local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
			if tHRP then
				local d = (tHRP.Position - hrp.Position).Magnitude
				local vel = tHRP.AssemblyLinearVelocity.Magnitude
				if d <= maxDist and vel >= 40 then
					return plr
				end
			end
		end
	end
	return nil
end

-- ==================== 🔸 Sistema de spam ====================

local function startSpam(amount)
	for i = 1, amount or 1 do
		fireServerCode()
	end
end

-- ==================== 🧠 Loop unificado ====================
RunService.RenderStepped:Connect(function(dt)
	-- Cache a cada 0.1s
	if tick() - lastCacheTime > 0.1 then
		cachedBall = findGameBall()
		cachedNearest = findNearestPlayer(34.3)
		cachedDasher = findDasher(45)
		lastCacheTime = tick()
	end

	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp or not cachedBall then return end

	local ball = cachedBall
	local distToBall = (hrp.Position - ball.Position).Magnitude
	local isRed = (ball.BrickColor == BrickColor.new("Bright red"))

	-- === AUTO PARRY ===
	if state.AutoParry and isRed and distToBall <= detectionDistance then
		if lastBall ~= ball then
			lastBall = ball
			fireServerCode()
			detectionDistance = math.clamp(detectionDistance + distanceIncrement, 0, 100)
		end
	else
		lastBall = nil
	end

	-- === AUTO SPAM ===
	if state.AutoSpam and isRed and cachedNearest and distToBall <= 34.3 then
		startSpam(1)
	end

	-- === AUTO SPAM V2 ===
	if state.AutoSpamV2 and isRed and cachedNearest and distToBall <= 34.3 then
		startSpam(10)
	end

	-- === CAMERA LOCK ===
	if state.AutoSpamLock and cachedNearest and cachedNearest.Character then
		if isRed and distToBall <= 34.3 then
			local tHRP = cachedNearest.Character:FindFirstChild("HumanoidRootPart")
			if tHRP then
				Camera.CameraType = Enum.CameraType.Scriptable
				Camera.CFrame = CFrame.new(Camera.CFrame.Position, tHRP.Position)
			end
		else
			Camera.CameraType = Enum.CameraType.Custom
			Camera.CameraSubject = char:FindFirstChildOfClass("Humanoid")
		end
	end

	-- === ANTI-DASHER SPAM ===
	if state.AntiDasherSpam and isRed and cachedDasher and distToBall <= 45 then
		startSpam(1)
	end

	-- === MANUAL SPAM ===
	if state.ManualSpam then
		startSpam(1)
	end
end)

-- ==================== ✅ Setup de toggles (Exemplo rápido) ====================

-- Exemplo de toggle com função leve (repita para os outros)
local function createToggle(name)
	local btn = Instance.new("TextButton")
	btn.Text = name
	btn.Size = UDim2.new(0, 150, 0, 20)
	btn.Parent = LocalPlayer:WaitForChild("PlayerGui")
	btn.Position = UDim2.new(0.1, 0, 0.1 + (#Players:GetPlayers() * 0.05), 0)
	local enabled = false
	btn.MouseButton1Click:Connect(function()
		enabled = not enabled
		state[name] = enabled
		btn.TextColor3 = enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 100)
	end)
end

-- Cria os principais toggles
for _, name in pairs({"AutoParry", "AutoSpam", "AutoSpamLock", "AutoSpamV2", "AntiDasherSpam", "ManualSpam"}) do
	createToggle(name)
end

print("✅ Neo Hub Optimized Loaded (Leve e funcional)")
