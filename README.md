-- AutoBloquePhantomBall.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local ALCANCE = 15 -- alcance de detecção da bola
local BOTAO_BLOQUE = Enum.KeyCode.E -- ou a tecla correspondente ao botão BLOQUE

local ativo = false

-- ===============================
-- Botão simples na tela
-- ===============================
local playerGui = player:WaitForChild("PlayerGui")
if not playerGui:FindFirstChild("AutoBloqueGUI") then
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AutoBloqueGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0,200,0,50)
    button.Position = UDim2.new(0,50,0,50)
    button.BackgroundColor3 = Color3.fromRGB(255,0,0)
    button.TextColor3 = Color3.fromRGB(255,255,255)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 20
    button.Text = "AutoBloque: DESATIVADO"
    button.Parent = screenGui

    button.MouseButton1Click:Connect(function()
        ativo = not ativ
        if ativo then
            button.Text = "AutoBloque: ATIVADO"
            button.BackgroundColor3 = Color3.fromRGB(0,255,0)
        else
            button.Text = "AutoBloque: DESATIVADO"
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
        if obj:IsA("BasePart") and obj.Name:lower():find("ball") then
            table.insert(balls, obj)
        end
    end
    return balls
end

-- ===============================
-- Loop principal para detectar e bloquear
-- ===============================
RunService.Heartbeat:Connect(function()
    if not ativo then return end
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local balls = getBalls()
    for _, ball in ipairs(balls) do
        local distancia = (ball.Position - root.Position).Magnitude
        if distancia <= ALCANCE then
            local vel = ball.Velocity
            local dirParaPlayer = (root.Position - ball.Position).Unit
            local aproximando = vel:Dot(dirParaPlayer)

            if aproximando > 0 then
                -- Quanto maior a velocidade da bola, mais rápido bloqueia
                local delay = math.max(0.05, 1 / (aproximando/20))
                spawn(function()
                    -- Simula pressionar a tecla BLOQUE
                    UserInputService.InputBegan:Fire({
                        KeyCode = BOTAO_BLOQUE,
                        UserInputType = Enum.UserInputType.Keyboard
                    }, false)
                    wait(delay)
                end)
            end
        end
    end
end)
