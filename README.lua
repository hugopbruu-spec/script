local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-----------------------------------------------------
-- CONFIGURAÇÕES

-----------------------------------------------------

local Config = {
    Intervalo = 2, 
    CorAtivo = Color3.fromRGB(50, 200, 50),
    CorDesativo = Color3.fromRGB(200, 50, 50),
    CorBG = Color3.fromRGB(40, 40, 40),
    CorBotoes = Color3.fromRGB(70, 70, 70),
    Fonte = Enum.Font.GothamBold
}

-----------------------------------------------------
-- VARIÁVEIS DE CONTROLE

-----------------------------------------------------

local Rodando = false

-----------------------------------------------------
-- FUNÇÕES UTILITÁRIAS

-----------------------------------------------------

local Utils = {}

function Utils:Log(txt)
    print("[AutoFarm] " .. txt)
end

function Utils:Tweener(obj, dur, props, easing)
    local info = TweenInfo.new(
        dur,
        easing or Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

-----------------------------------------------------
-- FUNÇÕES DO AUTO FARM

-----------------------------------------------------

local Farm = {}

function Farm:EncontrarLocal()
    -- Substituir pela lógica real do jogo
    return Vector3.new(math.random(-10,10), 0, math.random(-10,10))
end

function Farm:Plantar(pos)
    Utils:Log("Plantando em: " .. tostring(pos))

    -- Exemplo:
    -- ReplicatedStorage.Plantar:FireServer(pos)
end

function Farm:Loop()
    while Rodando do
        local pos = Farm:EncontrarLocal()
        Farm:Plantar(pos)
        task.wait(Config.Intervalo)
    end
    Utils:Log("Loop finalizado")
end

-----------------------------------------------------
-- GUI

-----------------------------------------------------

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFarmUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.fromOffset(0,0)
Frame.Position = UDim2.new(0.35, 0, 0.3, 0)
Frame.BackgroundColor3 = Config.CorBG
Frame.BorderSizePixel = 0

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 10)

-----------------------------------------------------
-- SISTEMA DE ARRASTAR

-----------------------------------------------------

local dragging = false
local dragStart, startPos

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-----------------------------------------------------
-- BOTÃO PRINCIPAL

-----------------------------------------------------

local Btn = Instance.new("TextButton")
Btn.Parent = Frame
Btn.Size = UDim2.new(1, -20, 0, 40)
Btn.Position = UDim2.new(0, 10, 0, 10)
Btn.BackgroundColor3 = Config.CorDesativo
Btn.Text = "Iniciar AutoFarm"
Btn.TextScaled = true
Btn.Font = Config.Fonte
Btn.TextColor3 = Color3.new(1,1,1)

local UICorner2 = Instance.new("UICorner", Btn)

-----------------------------------------------------
-- ANIMAÇÃO DE ABERTURA

-----------------------------------------------------

task.wait(0.15)

Utils:Tweener(Frame, 0.5, {
    Size = UDim2.new(0, 260, 0, 150)
}, Enum.EasingStyle.Back)

-----------------------------------------------------
-- LÓGICA DO BOTÃO

-----------------------------------------------------

Btn.MouseButton1Click:Connect(function()
    Rodando = not Rodando

    if Rodando then
        Btn.Text = "Parar AutoFarm"
        Btn.BackgroundColor3 = Config.CorAtivo
        Utils:Log("AutoFarm iniciado")

        task.spawn(function()
            Farm:Loop()
        end)
    else
        Btn.Text = "Iniciar AutoFarm"
        Btn.BackgroundColor3 = Config.CorDesativo
        Utils:Log("AutoFarm parado")
    end
end)

Utils:Log("Interface carregada com sucesso!")
