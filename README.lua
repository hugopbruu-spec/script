local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

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
    Fonte = Enum.Font.GothamBold,

    -- Seeds
    AutoComprarSeedsAtivar = true,
    NomeSeed = "Semente Mágica",
    CustoSeed = 100,

    -- Gear
    AutoComprarGearAtivar = true,
    IdGear = 123456789,

    -- Venda
    AutoSellAtivar = true,
    ItemParaVender = "Trigo",
    ValorItem = 5,

    -- Auto Resgate
    AutoResgateAtivar = true,
    NomeBotaoResgate = "Resgatar Recompensa",

    -- Interface
    TamanhoJanelaX = 300,
    TamanhoJanelaY = 450
}

-----------------------------------------------------
-- VARIÁVEIS DE CONTROLE

-----------------------------------------------------

local Rodando = false
local AutoComprarSeedsRodando = false
local AutoComprarGearRodando = false
local AutoSellRodando = false
local AutoResgateRodando = false

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
-- FUNÇÕES DE COMPRA, VENDA E RESGATE

-----------------------------------------------------

local Funcoes = {}

function Funcoes:AutoComprarSeeds()
    while AutoComprarSeedsRodando do
        -- Lógica para comprar sementes
        Utils:Log("Comprando sementes: " .. Config.NomeSeed)

        -- Exemplo:
        -- ReplicatedStorage.ComprarSemente:FireServer(Config.NomeSeed)

        task.wait(Config.Intervalo * 2)
    end
    Utils:Log("Auto compra de sementes finalizada")
end

function Funcoes:AutoComprarGear()
    while AutoComprarGearRodando do
        -- Lógica para comprar equipamentos
        Utils:Log("Comprando equipamento: " .. Config.IdGear)

        -- Exemplo:
        -- ReplicatedStorage.ComprarEquipamento:FireServer(Config.IdGear)

        task.wait(Config.Intervalo * 3)
    end
    Utils:Log("Auto compra de equipamento finalizada")
end

function Funcoes:AutoSell()
    while AutoSellRodando do
        -- Lógica para vender itens
        Utils:Log("Vendendo item: " .. Config.ItemParaVender)

        -- Exemplo:
        -- ReplicatedStorage.VenderItem:FireServer(Config.ItemParaVender)

        task.wait(Config.Intervalo * 1.5)
    end
    Utils:Log("Auto venda finalizada")
end

function Funcoes:AutoResgate()
    while AutoResgateRodando do
        -- Lógica para resgatar recompensas
        Utils:Log("Resgatando recompensa")

        -- Exemplo:
        -- StarterGui:SetCore("SendNotification", {
        --     Title = "Recompensa Resgatada!",
        --     Text = "Você resgatou uma recompensa gratuita.",
        --     Duration = 5
        -- })

        task.wait(Config.Intervalo * 4)
    end
    Utils:Log("Auto resgate finalizado")
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
Frame.Size = UDim2.fromOffset(0, 0)
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
-- FUNÇÕES DA INTERFACE

-----------------------------------------------------

local function CriarBotao(pai, nome, texto, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Name = nome
    btn.Parent = pai
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = pos
    btn.BackgroundColor3 = Config.CorBotoes
    btn.Text = texto
    btn.TextScaled = true
    btn.Font = Config.Fonte
    btn.TextColor3 = Color3.new(1, 1, 1)

    local uiCorner = Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(callback)

    return btn
end

local function CriarLabel(pai, texto, pos)
    local label = Instance.new("TextLabel")
    label.Parent = pai
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = pos
    label.BackgroundColor3 = Color3.new(0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = texto
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true
    label.Font = Config.Fonte
    label.TextColor3 = Color3.new(1, 1, 1)

    return label
end

-----------------------------------------------------
-- BOTÕES PRINCIPAIS

-----------------------------------------------------

local BtnAutoFarm = CriarBotao(Frame, "BtnAutoFarm", "Iniciar AutoFarm", UDim2.new(0, 10, 0, 10), function()
    Rodando = not Rodando

    if Rodando then
        BtnAutoFarm.Text = "Parar AutoFarm"
        BtnAutoFarm.BackgroundColor3 = Config.CorAtivo
        Utils:Log("AutoFarm iniciado")

        task.spawn(function()
            Farm:Loop()
        end)
    else
        BtnAutoFarm.Text = "Iniciar AutoFarm"
        BtnAutoFarm.BackgroundColor3 = Config.CorDesativo
        Utils:Log("AutoFarm parado")
    end
end)

local BtnAutoComprarSeeds = CriarBotao(Frame, "BtnAutoComprarSeeds", "Auto Comprar Seeds: OFF", UDim2.new(0, 10, 0, 50), function()
    AutoComprarSeedsRodando = not AutoComprarSeedsRodando

    if AutoComprarSeedsRodando then
        BtnAutoComprarSeeds.Text = "Auto Comprar Seeds: ON"
        BtnAutoComprarSeeds.BackgroundColor3 = Config.CorAtivo
        Utils:Log("Auto compra de seeds ativada")

        task.spawn(function()
            Funcoes:AutoComprarSeeds()
        end)
    else
        BtnAutoComprarSeeds.Text = "Auto Comprar Seeds: OFF"
        BtnAutoComprarSeeds.BackgroundColor3 = Config.CorDesativo
        Utils:Log("Auto compra de seeds desativada")
    end
end)

local BtnAutoComprarGear = CriarBotao(Frame, "BtnAutoComprarGear", "Auto Comprar Gear: OFF", UDim2.new(0, 10, 0, 90), function()
    AutoComprarGearRodando = not AutoComprarGearRodando

    if AutoComprarGearRodando then
        BtnAutoComprarGear.Text = "Auto Comprar Gear: ON"
        BtnAutoComprarGear.BackgroundColor3 = Config.CorAtivo
        Utils:Log("Auto compra de gear ativada")

        task.spawn(function()
            Funcoes:AutoComprarGear()
        end)
    else
        BtnAutoComprarGear.Text = "Auto Comprar Gear: OFF"
        BtnAutoComprarGear.BackgroundColor3 = Config.CorDesativo
        Utils:Log("Auto compra de gear desativada")
    end
end)

local BtnAutoSell = CriarBotao(Frame, "BtnAutoSell", "Auto Sell: OFF", UDim2.new(0, 10, 0, 130), function()
    AutoSellRodando = not AutoSellRodando

    if AutoSellRodando then
        BtnAutoSell.Text = "Auto Sell: ON"
        BtnAutoSell.BackgroundColor3 = Config.CorAtivo
        Utils:Log("Auto venda ativada")

        task.spawn(function()
            Funcoes:AutoSell()
        end)
    else
        BtnAutoSell.Text = "Auto Sell: OFF"
        BtnAutoSell.BackgroundColor3 = Config.CorDesativo
        Utils:Log("Auto venda desativada")
    end
end)

local InputItemParaVender = Instance.new("TextBox")
InputItemParaVender.Parent = Frame
InputItemParaVender.Size = UDim2.new(1, -20, 0, 30)
InputItemParaVender.Position = UDim2.new(0, 10, 0, 170)
InputItemParaVender.PlaceholderText = "Item para vender"
InputItemParaVender.Font = Config.Fonte
InputItemParaVender.Text = Config.ItemParaVender
InputItemParaVender.TextColor3 = Color3.new(1, 1, 1)
InputItemParaVender.BackgroundColor3 = Config.CorBotoes

InputItemParaVender.FocusLost:Connect(function()
    Config.ItemParaVender = InputItemParaVender.Text
    Utils:Log("Item para vender alterado para: " .. Config.ItemParaVender)
end)

local BtnAutoResgate = CriarBotao(Frame, "BtnAutoResgate", "Auto Resgate: OFF", UDim2.new(0, 10, 0, 210), function()
    AutoResgateRodando = not AutoResgateRodando

    if AutoResgateRodando then
        BtnAutoResgate.Text = "Auto Resgate: ON"
        BtnAutoResgate.BackgroundColor3 = Config.CorAtivo
        Utils:Log("Auto resgate ativado")

        task.spawn(function()
            Funcoes:AutoResgate()
        end)
    else
        BtnAutoResgate.Text = "Auto Resgate: OFF"
        BtnAutoResgate.BackgroundColor3 = Config.CorDesativo
        Utils:Log("Auto resgate desativado")
    end
end)

-----------------------------------------------------
-- ANIMAÇÃO DE ABERTURA

-----------------------------------------------------

task.wait(0.15)

Utils:Tweener(Frame, 0.5, {
    Size = UDim2.new(0, Config.TamanhoJanelaX, 0, Config.TamanhoJanelaY)
}, Enum.EasingStyle.Back)

Utils:Log("Interface carregada com sucesso!")
