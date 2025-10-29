-- DevTestGUI.lua (LocalScript)
-- GUI simples para desenvolvedor enviar comandos ao ServerTestBot

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild("DevToggleTestBot")

-- Cria UI mínima para selecionar alvo e alternar modos
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 120)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundTransparency = 0.2
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -10, 0, 24)
title.Position = UDim2.new(0, 5, 0, 5)
title.Text = "Dev Test Bot"
title.TextColor3 = Color3.fromRGB(230,230,230)
title.BackgroundTransparency = 1
title.Parent = frame

-- Input para UserId do alvo
local targetBox = Instance.new("TextBox")
targetBox.Size = UDim2.new(1, -110, 0, 28)
targetBox.Position = UDim2.new(0, 5, 0, 34)
targetBox.PlaceholderText = "Target UserId"
targetBox.Text = ""
targetBox.Parent = frame

local setButton = Instance.new("TextButton")
setButton.Size = UDim2.new(0, 90, 0, 28)
setButton.Position = UDim2.new(1, -95, 0, 34)
setButton.Text = "Set Target"
setButton.Parent = frame

local parryBtn = Instance.new("TextButton")
parryBtn.Size = UDim2.new(0, 120, 0, 28)
parryBtn.Position = UDim2.new(0, 5, 0, 70)
parryBtn.Text = "Parry : OFF"
parryBtn.Parent = frame

local spamBtn = Instance.new("TextButton")
spamBtn.Size = UDim2.new(0, 120, 0, 28)
spamBtn.Position = UDim2.new(1, -125, 0, 70)
spamBtn.Text = "Spam : OFF"
spamBtn.Parent = frame

local targetUserId = nil
local parryState = false
local spamState = false

setButton.MouseButton1Click:Connect(function()
    local txt = tonumber(targetBox.Text)
    if txt then
        targetUserId = txt
        setButton.Text = "Target set"
    else
        setButton.Text = "Invalid ID"
        task.delay(1, function() setButton.Text = "Set Target" end)
    end
end)

local function sendToggle(mode, enabled)
    if not targetUserId then return end
    remote:FireServer({action = "toggle", targetUserId = targetUserId, mode = mode, enabled = enabled})
end

parryBtn.MouseButton1Click:Connect(function()
    parryState = not parryState
    parryBtn.Text = "Parry : " .. (parryState and "ON" or "OFF")
    sendToggle("parry", parryState)
end)

spamBtn.MouseButton1Click:Connect(function()
    spamState = not spamState
    spamBtn.Text = "Spam : " .. (spamState and "ON" or "OFF")
    sendToggle("spam", spamState)
end)
