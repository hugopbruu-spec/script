-- AutoRebateAvancado.lua

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local ALCANCE = 20

-- RemoteEvent que será usado pelo servidor
local rebaterEvento = ReplicatedStorage:WaitForChild("RebaterBolaEvento")

-- Flag de ativação
local autoRebateAtivo = false

-- ===============================
-- Criar GUI persistente
-- ===============================
local function criarGUI()
    local playerGui = player:WaitForChild("PlayerGui")

    -- Evitar criar múltiplas GUIs
    if playerGui:FindFirstChild("AutoRebateGUI") then
        return playerGui.AutoRebateGUI
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AutoRebateGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0,200,0,50)
    button.Position = UDim2.new(0,50,0,50)
    button.BackgroundColor3 = Color3.fromRGB(255,0,0)
    button.TextColor3 = Color3.fromRGB(255,255,255)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 20
    button.Text = "AutoRebate: DESATIVADO"
    button.Parent = screenGui

    -- Botão móvel
    local dragging = false
    local dragInput, dragStart, startPos

    local function updateInput(input)
        local delta = input.Position - dragStart
        button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                    startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = button.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    button.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            updateInput(input)
        end
    end)

    -- Alterna ativação
    button.MouseButton1Click:Connect(function()
        autoRebateAtivo = not autoRebateAtivo
        if autoRebateAtivo then
            button.Text = "AutoRebate: ATIVADO"
            button.BackgroundColor3 = Color3.fromRGB(0,255,0)
        else
            button.Text = "AutoRebate: DESATIVADO"
            button.BackgroundColor3 = Color3.fromRGB(255,0,0)
        end
    end)

    return screenGui
end

criarGUI()

-- ===============================
-- Função para pegar bolas no workspace
-- ===============================
local function getBalls()
    local balls = {}
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("BasePart") and obj.Name == "Ball" then
            table.insert(balls, obj)
        end
    end
    return balls
end

-- ===============================
-- Loop principal para rebater
-- ===============================
RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if autoRebateAtivo then
        local balls = getBalls()
        for _, ball in ipairs(balls) do
            local distancia = (ball.Position - root.Position).Magnitude
            if distancia <= ALCANCE then
                -- Calcula se a bola está se aproximando
                local vel = ball.Velocity
                local dirParaPlayer = (root.Position - ball.Position).Unit
                local aproximando = vel:Dot(dirParaPlayer)

                if aproximando > 0 then
                    -- Força proporcional à velocidade da bola
                    rebaterEvento:FireServer(ball, aproximando)
                end
            end
        end
    end
end)

-- Garante GUI persistente após respawn
player.CharacterAdded:Connect(function()
    criarGUI()
end)
