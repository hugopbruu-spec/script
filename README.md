-- AutoRebateFinal.lua

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local ALCANCE = 20

-- RemoteEvent do servidor
local rebaterEvento = ReplicatedStorage:WaitForChild("RebaterBolaEvento")

-- Flag de ativação
local autoRebateAtivo = false

-- ===============================
-- Criar botão simples na tela
-- ===============================
local playerGui = player:WaitForChild("PlayerGui")
if not playerGui:FindFirstChild("AutoRebateGUI") then
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
end

-- ===============================
-- Função para pegar todas as bolas no workspace
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
-- Loop principal de detecção
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
                -- Checa se a bola está se aproximando
                local vel = ball.Velocity
                local dirParaPlayer = (root.Position - ball.Position).Unit
                local aproximando = vel:Dot(dirParaPlayer)

                if aproximando > 0 then
                    -- Envia evento para o servidor rebater a bola
                    rebaterEvento:FireServer(ball, aproximando)
                end
            end
        end
    end
end)

-- Garante que o botão exista após respawn
player.CharacterAdded:Connect(function()
    if not playerGui:FindFirstChild("AutoRebateGUI") then
        -- recria GUI caso tenha sido removida
        local clone = script:Clone()
        clone.Parent = player
    end
end)
