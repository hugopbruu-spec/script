-- AutoClickBola.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local ALCANCE = 20

-- RemoteEvent que será usado para simular o clique
local autoClickEvento = ReplicatedStorage:FindFirstChild("AutoClickEvento")
if not autoClickEvento then
    autoClickEvento = Instance.new("RemoteEvent")
    autoClickEvento.Name = "AutoClickEvento"
    autoClickEvento.Parent = ReplicatedStorage
end

local ativo = false

-- ===============================
-- Botão simples na tela
-- ===============================
local playerGui = player:WaitForChild("PlayerGui")
if not playerGui:FindFirstChild("AutoClickGUI") then
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AutoClickGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0,200,0,50)
    button.Position = UDim2.new(0,50,0,50)
    button.BackgroundColor3 = Color3.fromRGB(255,0,0)
    button.TextColor3 = Color3.fromRGB(255,255,255)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 20
    button.Text = "AutoClick: DESATIVADO"
    button.Parent = screenGui

    button.MouseButton1Click:Connect(function()
        ativo = not ativo
        if ativo then
            button.Text = "AutoClick: ATIVADO"
            button.BackgroundColor3 = Color3.fromRGB(0,255,0)
        else
            button.Text = "AutoClick: DESATIVADO"
            button.BackgroundColor3 = Color3.fromRGB(255,0,0)
        end
    end)
end

-- ===============================
-- Função para pegar todas as bolas
-- ===============================
local function getBalls()
    local balls = {}
