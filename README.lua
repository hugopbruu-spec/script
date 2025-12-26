--[[
    INTERFACE GRÁFICA (GUI) "FROSTBR" INSPIRADA NO SPEED HUB
    (APENAS PARA FINS EDUCACIONAIS)

    ATENÇÃO: Este script não inclui a lógica de auto farm.
    Ele apenas cria a interface gráfica.
    Use por sua conta e risco.
]]

-- Serviços do Roblox
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Jogador local
local LocalPlayer = Players.LocalPlayer

-- Cores do tema
local corPrimaria = Color3.fromRGB(30, 26, 41) -- Preto/Roxo Escuro
local corSecundaria = Color3.fromRGB(149, 48, 255) -- Roxo
local corTexto = Color3.fromRGB(255, 255, 255) -- Branco

-- Criar a GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FrostBR_GUI"
ScreenGui.Parent = LocalPlayer.PlayerGui
ScreenGui.ResetOnSpawn = false

-- Frame principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 400) -- Tamanho inicial
MainFrame.Position = UDim2.new(0.35, 0, 0.3, 0) -- Centralizado
MainFrame.BackgroundColor3 = corPrimaria
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Título
local Titulo = Instance.new("TextLabel")
Titulo.Name = "Titulo"
Titulo.Size = UDim2.new(1, 0, 0, 40)
Titulo.Position = UDim2.new(0, 0, 0, 0)
Titulo.BackgroundColor3 = corSecundaria
Titulo.TextColor3 = corTexto
Titulo.Text = "FrostBR"
Titulo.Font = Enum.Font.SourceSansBold
Titulo.TextSize = 20
Titulo.Parent = MainFrame

-- Abas (Frame para conter os botões das abas)
local AbasFrame = Instance.new("Frame")
AbasFrame.Name = "AbasFrame"
AbasFrame.Size = UDim2.new(1, 0, 0, 40)
AbasFrame.Position = UDim2.new(0, 0, 0, 40)
AbasFrame.BackgroundColor3 = corPrimaria
AbasFrame.BorderSizePixel = 0
AbasFrame.Parent = MainFrame

-- Conteúdo das Abas (Frame para conter o conteúdo de cada aba)
local ConteudoAbas = Instance.new("Frame")
ConteudoAbas.Name = "ConteudoAbas"
ConteudoAbas.Size = UDim2.new(1, 0, 0.8, -40)
ConteudoAbas.Position = UDim2.new(0, 0, 0, 80)
ConteudoAbas.BackgroundColor3 = corPrimaria
ConteudoAbas.BorderSizePixel = 0
ConteudoAbas.Parent = MainFrame

-- Função para criar as abas
local function criarAba(nome, conteudo)
    local botaoAba = Instance.new("TextButton")
    botaoAba.Name = nome .. "AbaBotao"
    botaoAba.Size = UDim2.new(0.33, 0, 1, 0) -- Dividir o espaço igualmente
    botaoAba.Position = UDim2.new((table.getn(AbasFrame:GetChildren()) - 1) * 0.33, 0, 0, 0)
    botaoAba.BackgroundColor3 = corPrimaria
    botaoAba.TextColor3 = corTexto
    botaoAba.Text = nome
    botaoAba.Font = Enum.Font.SourceSansBold
    botaoAba.TextSize = 14
    botaoAba.BorderSizePixel = 0
    botaoAba.Parent = AbasFrame

    local frameConteudo = Instance.new("Frame")
    frameConteudo.Name = nome .. "AbaConteudo"
    frameConteudo.Size = UDim2.new(1, 0, 1, 0)
    frameConteudo.Position = UDim2.new(0, 0, 0, 0)
    frameConteudo.BackgroundColor3 = corPrimaria
    frameConteudo.BorderSizePixel = 0
    frameConteudo.Visible = false
    frameConteudo.Parent = ConteudoAbas

    botaoAba.MouseButton1Click:Connect(function()
        for _, aba in pairs(ConteudoAbas:GetChildren()) do
            aba.Visible = false
        end
        frameConteudo.Visible = true
    end)

    -- Se for a primeira aba, mostrar ela
    if table.getn(AbasFrame:GetChildren()) == 1 then
        frameConteudo.Visible = true
    end

    return frameConteudo
end

-- Criar as abas
local abaGeral = criarAba("Geral", {})
local abaPlantas = criarAba("Plantas", {})
local abaAtaque = criarAba("Ataque", {})

-- Funções de exemplo (substitua pela lógica real do jogo)
local function toggleAutoFarm(estado)
    print("Auto Farm: " .. (estado and "Ativado" or "Desativado"))
end

local function setPlantingSpeed(valor)
    print("Velocidade de plantio: " .. valor)
end

-- Opções da aba Geral
local ativarAutoFarm = Instance.new("CheckBox")
ativarAutoFarm.Name = "AtivarAutoFarm"
ativarAutoFarm.Size = UDim2.new(0, 20, 0, 20)
ativarAutoFarm.Position = UDim2.new(0.1, 0, 0.1, 0)
ativarAutoFarm.BackgroundColor3 = corPrimaria
ativarAutoFarm.Parent = abaGeral

local labelAtivarAutoFarm = Instance.new("TextLabel")
labelAtivarAutoFarm.Name = "LabelAtivarAutoFarm"
labelAtivarAutoFarm.Size = UDim2.new(0, 150, 0, 20)
labelAtivarAutoFarm.Position = UDim2.new(0.2, 0, 0.1, 0)
labelAtivarAutoFarm.BackgroundColor3 = corPrimaria
labelAtivarAutoFarm.TextColor3 = corTexto
labelAtivarAutoFarm.Text = "Ativar Auto Farm"
labelAtivarAutoFarm.Font = Enum.Font.SourceSans
labelAtivarAutoFarm.TextSize = 14
labelAtivarAutoFarm.Parent = abaGeral

ativarAutoFarm.Changed:Connect(function(novoValor)
    toggleAutoFarm(novoValor)
end)

-- Opções de exemplo na aba Plantas
local labelVelocidadePlantio = Instance.new("TextLabel")
labelVelocidadePlantio.Name = "LabelVelocidadePlantio"
labelVelocidadePlantio.Size = UDim2.new(0, 150, 0, 20)
labelVelocidadePlantio.Position = UDim2.new(0.1, 0, 0.1, 0)
labelVelocidadePlantio.BackgroundColor3 = corPrimaria
labelVelocidadePlantio.TextColor3 = corTexto
labelVelocidadePlantio.Text = "Velocidade de Plantio:"
labelVelocidadePlantio.Font = Enum.Font.SourceSans
labelVelocidadePlantio.TextSize = 14
labelVelocidadePlantio.Parent = abaPlantas

local sliderVelocidadePlantio = Instance.new("Slider")
sliderVelocidadePlantio.Name = "SliderVelocidadePlantio"
sliderVelocidadePlantio.Size = UDim2.new(0, 150, 0, 20)
sliderVelocidadePlantio.Position = UDim2.new(0.1, 0, 0.2, 0)
sliderVelocidadePlantio.BackgroundColor3 = corPrimaria
sliderVelocidadePlantio.Parent = abaPlantas
sliderVelocidadePlantio.Min = 1
sliderVelocidadePlantio.Max = 10
sliderVelocidadePlantio.Value = 5

sliderVelocidadePlantio.Changed:Connect(function(valor)
    setPlantingSpeed(valor)
end)

-- Animação ao abrir
MainFrame.Size = UDim2.new(0, 0, 0, 0) -- Inicia com tamanho zero

local tweenInfo = TweenInfo.new(
    0.5, -- Duração
    Enum.EasingStyle.Back, -- Estilo de animação (Back para efeito de "esticar")
    Enum.EasingDirection.Out, -- Direção
    0, -- Repetições
    false, -- Reverter?
    0 -- Delay
)

local tamanhoFinal = UDim2.new(0, 300, 0, 400)
local tween = TweenService:Create(MainFrame, tweenInfo, {Size = tamanhoFinal})
tween:Play()

print("GUI FrostBR Carregada!")
