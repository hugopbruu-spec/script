-- FROSTBR CLIENT FRAMEWORK
-- Interface + Gerenciador + Sistema de Eventos
-- Seguro para o Roblox e totalmente personalizável

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

------------------------
-- CORES DO TEMA

------------------------
local Theme = {
    Primary = Color3.fromRGB(25, 20, 35),
    Secondary = Color3.fromRGB(140, 40, 255),
    Text = Color3.fromRGB(255, 255, 255)
}

------------------------
-- SCREEN GUI

------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "FrostBR"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

------------------------
-- FUNÇÃO PARA CRIAR BOTÕES

------------------------
local function CreateButton(parent, text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 40)
    b.Position = UDim2.new(0, 10, 0, 0)
    b.BackgroundColor3 = Theme.Primary
    b.TextColor3 = Theme.Text
    b.BorderSizePixel = 0
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 18
    b.Text = text
    b.Parent = parent

    b.MouseButton1Click:Connect(function()
        callback()
    end)

    return b
end

------------------------
-- FUNÇÃO PARA CRIAR SLIDER

------------------------
local function CreateSlider(parent, text, min, max, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 60)
    frame.Position = UDim2.new(0, 10, 0, 0)
    frame.BackgroundColor3 = Theme.Primary
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0.4, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Theme.Text
    label.Text = text
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 16
    label.Parent = frame

    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(1, -20, 0, 20)
    slider.Position = UDim2.new(0, 10, 0.5, 0)
    slider.BackgroundColor3 = Theme.Secondary
    slider.Text = " "
    slider.BorderSizePixel = 0
    slider.Parent = frame

    local val = math.floor((min + max) / 2)
    callback(val)

    slider.MouseButton1Click:Connect(function()
        val = val + 1
        if val > max then val = min end
        callback(val)
    end)

    return frame
end

------------------------
-- JANELA PRINCIPAL

------------------------
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 350, 0, 450)
main.Position = UDim2.new(0.3, 0, 0.2, 0)
main.BackgroundColor3 = Theme.Primary
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Theme.Secondary
title.TextColor3 = Theme.Text
title.Text = "FROSTBR"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.Parent = main

------------------------
-- ABA SISTEMA

------------------------
local abaSistema = Instance.new("Frame")
abaSistema.BackgroundTransparency = 1
abaSistema.Size = UDim2.new(1, 0, 1, -40)
abaSistema.Position = UDim2.new(0, 0, 0, 40)
abaSistema.Parent = main

local lblTeste = Instance.new("TextLabel")
lblTeste.Size = UDim2.new(1, 0, 0, 30)
lblTeste.BackgroundTransparency = 1
lblTeste.TextColor3 = Theme.Text
lblTeste.Font = Enum.Font.SourceSans
lblTeste.TextSize = 16
lblTeste.Text = "Interface Carregada"
lblTeste.Parent = abaSistema

---------------------------------
-- BOTÃO: HABILITAR SISTEMA

---------------------------------
CreateButton(abaSistema, "Ativar Sistema", function()
    print("Sistema ativado (placeholder)")
end)

---------------------------------
-- SLIDER: VELOCIDADE

---------------------------------
CreateSlider(abaSistema, "Velocidade de Plantaçao", 1, 10, function(valor)
    print("Velocidade = ", valor)
end)

-------------------------------
-- SISTEMA DE EVENTOS (CLIENT)

-------------------------------
local FrostAPI = {}

function FrostAPI.Notificar(texto)
    print("[FrostBR] Notificação:", texto)
end

function FrostAPI.ColherPlanta(id)
    print("Colher planta (placeholder):", id)
end

function FrostAPI.Plantar(id)
    print("Plantar (placeholder):", id)
end

function FrostAPI.Atacar(zumbiID)
    print("Atacar (placeholder):", zumbiID)
end

_G.FrostBR = FrostAPI
print("FrostBR Framework carregado.")
