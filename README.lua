-- NeoHub - Versão simples e otimizada (SEM BYPASS)
-- Colocar como LocalScript em StarterPlayerScripts ou dentro de StarterGui (LocalScript)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

if not LocalPlayer then
    warn("[NeoHub] LocalPlayer não encontrado. Coloque esse LocalScript em StarterPlayerScripts ou StarterGui.")
    return
end

-- estado
local state = {
    AutoParry = false,
    AutoSpam = false,
    AutoSpamV2 = false,
    AutoSpamLock = false,
    AntiDasherSpam = false,
    ManualSpam = false
}

-- parâmetros
local detectionDistance = 22
local distanceIncrement = 1.5
local incrementBonus = 0

-- cache e controle
local lastCache = 0
local cachedBall = nil
local cachedNearest = nil
local cachedDasher = nil
local lastBallSeen = nil

-- função segura para disparar remote (mantive sua lógica pcall)
local function fireServerCode()
    local args = {[1] = 2.933813859058389e+76}
    pcall(function()
        -- tentativa segura de encontrar o remote (não assume caminhos fixos)
        local ts = ReplicatedStorage:FindFirstChild("TS")
        local remote
        if ts then
            local gen = ts:FindFirstChild("GeneratedNetworkRemotes")
            if gen then
                remote = gen:FindFirstChild("RE_4.6848415795802784e+76")
            end
        end
        -- fallback direto em ReplicatedStorage (se existia no seu projeto)
        if not remote then
            remote = ReplicatedStorage:FindFirstChild("RE_4.6848415795802784e+76") or ReplicatedStorage:FindFirstChild("RE_4.6848415795802784e+76")
        end
        if remote and remote.FireServer then
            remote:FireServer(unpack(args))
        end
    end)
end

-- helpers
local function findGameBall()
    local b = workspace:FindFirstChild("GameBall")
    return (b and b:IsA("BasePart")) and b or nil
end

local function findNearestPlayer(maxDist)
    local char = LocalPlayer.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local nearest, best = nil, maxDist
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local tHRP = p.Character:FindFirstChild("HumanoidRootPart")
            if tHRP then
                local d = (tHRP.Position - hrp.Position).Magnitude
                if d < best then
                    best = d
                    nearest = p
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

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local tHRP = p.Character:FindFirstChild("HumanoidRootPart")
            if tHRP then
                local d = (tHRP.Position - hrp.Position).Magnitude
                local vel = tHRP.AssemblyLinearVelocity and tHRP.AssemblyLinearVelocity.Magnitude or 0
                if d <= maxDist and vel >= 40 then
                    return p
                end
            end
        end
    end
    return nil
end

local function spam(amount)
    for i = 1, (amount or 1) do
        fireServerCode()
    end
end

-- GUI simples
local screen = Instance.new("ScreenGui")
screen.Name = "NeoHubSimpleUI"
screen.ResetOnSpawn = false
screen.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 160)
frame.Position = UDim2.new(0, 20, 0, 80)
frame.BackgroundColor3 = Color3.fromRGB(20,20,30)
frame.Parent = screen

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,24)
title.BackgroundTransparency = 1
title.Text = "Neo Hub - Simples"
title.TextColor3 = Color3.fromRGB(200,180,255)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.Parent = frame

local function makeToggle(text, y, stateKey)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 20)
    btn.Position = UDim2.new(0, 6, 0, 24 + y)
    btn.BackgroundColor3 = Color3.fromRGB(40,30,60)
    btn.TextColor3 = Color3.fromRGB(200,200,200)
    btn.Text = text.." [OFF]"
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Parent = frame

    btn.MouseButton1Click:Connect(function()
        state[stateKey] = not state[stateKey]
        btn.Text = text .. (state[stateKey] and " [ON]" or " [OFF]")
        btn.BackgroundColor3 = state[stateKey] and Color3.fromRGB(120,50,200) or Color3.fromRGB(40,30,60)
    end)
end

makeToggle("AutoParry", 6, "AutoParry")
makeToggle("AutoSpam", 32, "AutoSpam")
makeToggle("AutoSpamV2", 58, "AutoSpamV2")
makeToggle("CameraLock", 84, "AutoSpamLock")
makeToggle("AntiDasher", 110, "AntiDasherSpam")
-- manual spam separadamente (toggle)
makeToggle("ManualSpam", 136, "ManualSpam")

-- Loop unificado (mais leve)
RunService.RenderStepped:Connect(function()
    local now = tick()
    if now - lastCache > 0.12 then
        cachedBall = findGameBall()
        cachedNearest = findNearestPlayer(34.3)
        cachedDasher = findDasher(45)
        lastCache = now
    end

    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        -- tenta resetar camera caso o personagem não exista
        if Camera and Camera.CameraType ~= Enum.CameraType.Custom then
            pcall(function()
                Camera.CameraType = Enum.CameraType.Custom
                Camera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            end)
        end
        return
    end

    local hrp = char.HumanoidRootPart
    local ball = cachedBall
    if not ball then return end

    local dist = (hrp.Position - ball.Position).Magnitude
    local isRed = ball.BrickColor == BrickColor.new("Bright red")

    -- Auto Parry
    if state.AutoParry and isRed then
        if dist <= detectionDistance and lastBallSeen ~= ball then
            lastBallSeen = ball
            fireServerCode()
            detectionDistance = math.clamp(detectionDistance + distanceIncrement + incrementBonus, 0, 100)
            incrementBonus = incrementBonus + 0.7
        end
    else
        lastBallSeen = nil
    end

    -- Auto Spam
    if state.AutoSpam and isRed and cachedNearest and dist <= 34.3 then
        spam(1)
    end

    -- Auto Spam V2 (10x)
    if state.AutoSpamV2 and isRed and cachedNearest and dist <= 34.3 then
        spam(10)
    end

    -- Camera Lock
    if state.AutoSpamLock and cachedNearest and cachedNearest.Character and isRed and dist <= 34.3 then
        local tHRP = cachedNearest.Character:FindFirstChild("HumanoidRootPart")
        if tHRP then
            Camera.CameraType = Enum.CameraType.Scriptable
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, tHRP.Position)
        end
    else
        if Camera.CameraType ~= Enum.CameraType.Custom then
            Camera.CameraType = Enum.CameraType.Custom
            Camera.CameraSubject = char:FindFirstChildOfClass("Humanoid")
        end
    end

    -- Anti-Dasher Spam
    if state.AntiDasherSpam and isRed and cachedDasher and dist <= 45 then
        spam(1)
    end

    -- Manual spam (quando ligado)
    if state.ManualSpam then
        spam(1)
    end
end)

print("[NeoHubSimple] Script carregado. Verifique a GUI no canto superior esquerdo.")
