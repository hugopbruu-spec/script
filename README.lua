--[[
    EXEMPLO GENÉRICO DE SCRIPT DE AUTO FARM (APENAS PARA FINS EDUCACIONAIS)
    COM MENU MAIS COMPLETO E PROFISSIONAL

    ATENÇÃO: Este script é apenas um exemplo e pode não funcionar diretamente em nenhum jogo.
    Use por sua conta e risco.
]]

-- Serviços do Roblox
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Jogador local
local LocalPlayer = Players.LocalPlayer

-- Variáveis de controle
local rodando = false
local intervaloDeAcao = 2 -- Segundos entre cada ação

-- Funções (substitua pela lógica real do jogo)
local function simularClique(botao)
    print("Simulando clique em: " .. botao.Name)
end

local function encontrarLocalParaPlantar()
    return Vector3.new(0, 0, 0) -- Posição de exemplo
end

local function plantar(posicao)
    print("Plantando em: " .. posicao)
end

-- Função principal do auto farm
local function autoFarm()
    while rodando do
        local posicao = encontrarLocalParaPlantar()
        plantar(posicao)
        wait(intervaloDeAcao)
    end
end

-- Criar a GUI (Interface Gráfica)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFarmGUI"
ScreenGui.Parent = LocalPlayer.PlayerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 0.4, 0, 0.5) -- Maior
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0) -- Centralizado
MainFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15) -- Cor mais escura
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Título
local Titulo = Instance.new("TextLabel")
Titulo.Name = "Titulo"
Titulo.Size = UDim2.new(1, 0, 0, 30)
Titulo.Position = UDim2.new(0, 0, 0, 0)
Titulo.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Titulo.TextColor3 = Color3.new(1, 1, 1)
Titulo.Text = "Auto Farm Script"
Titulo.Font = Enum.Font.SourceSansBold
Titulo.TextSize = 16
Titulo.Parent = MainFrame

-- Abas (Frame para conter os botões das abas)
local AbasFrame = Instance.new("Frame")
AbasFrame.Name = "AbasFrame"
AbasFrame.Size = UDim2.new(0, 100, 0, 30)
AbasFrame.Position = UDim2.new(0, 0, 0, 30)
AbasFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
AbasFrame.BorderSizePixel = 0
AbasFrame.Parent = MainFrame

-- Conteúdo das Abas (Frame para conter o conteúdo de cada aba)
local ConteudoAbas = Instance.new("Frame")
ConteudoAbas.Name = "ConteudoAbas"
ConteudoAbas.Size = UDim2.new(1, 0, 0.8, 0)
ConteudoAbas.Position = UDim2.new(0, 0, 0, 60)
ConteudoAbas.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
ConteudoAbas.BorderSizePixel = 0
ConteudoAbas.Parent = MainFrame

--Função para criar as abas
local function criarAba(nome, conteudo)
    local botaoAba = Instance.new("TextButton")
    botaoAba.Name = nome .. "AbaBotao"
    botaoAba.Size = UDim2.new(0, 100, 1, 0)
    botaoAba.Position = UDim2.new(0, (table.getn(AbasFrame:GetChildren()) -1) * 100, 0, 0)
    botaoAba.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    botaoAba.TextColor3 = Color3.new(1, 1, 1)
    botaoAba.Text = nome
    botaoAba.Font = Enum.Font.SourceSansBold
    botaoAba.TextSize = 14
    botaoAba.BorderSizePixel = 0
    botaoAba.Parent = AbasFrame

    local frameConteudo = Instance.new("Frame")
    frameConteudo.Name = nome .. "AbaConteudo"
    frameConteudo.Size = UDim2.new(1, 0, 1, 0)
    frameConteudo.Position = UDim2.new(0, 0, 0, 0)
    frameConteudo.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    frameConteudo.BorderSizePixel = 0
    frameConteudo.Visible = false
    frameConteudo.Parent = ConteudoAbas

    botaoAba.MouseButton1Click:Connect(function()
        for _, aba in pairs(ConteudoAbas:GetChildren()) do
            aba.Visible = false
        end
        frameConteudo.Visible = true
    end)

    --Se for a primeira aba, mostrar ela
    if table.getn(AbasFrame:GetChildren()) == 1 then
        frameConteudo.Visible = true
    end

    return frameConteudo
end

-- Criar as abas
local abaGeral = criarAba("Geral", {})
local abaPlantas = criarAba("Plantas", {})
local abaAtaque = criarAba("Ataque", {})

-- Opções da aba Geral
local ativarAutoFarm = Instance.new("CheckBox")
ativarAutoFarm.Name = "AtivarAutoFarm"
ativarAutoFarm.Size = UDim2.new(0, 20, 0, 20)
ativarAutoFarm.Position = UDim2.new(0.1, 0, 0.1, 0)
ativarAutoFarm.Parent = abaGeral

local labelAtivarAutoFarm = Instance.new("TextLabel")
labelAtivarAutoFarm.Name = "LabelAtivarAutoFarm"
labelAtivarAutoFarm.Size = UDim2.new(0, 150, 0, 20)
labelAtivarAutoFarm.Position = UDim2.new(0.2, 0, 0.1, 0)
labelAtivarAutoFarm.BackgroundColor3 = Color3.new(1, 1, 1)
labelAtivarAutoFarm.BackgroundTransparency = 1
labelAtivarAutoFarm.TextColor3 = Color3.new(1, 1, 1)
labelAtivarAutoFarm.Text = "Ativar Auto Farm"
labelAtivarAutoFarm.Font = Enum.Font.SourceSans
labelAtivarAutoFarm.TextSize = 14
labelAtivarAutoFarm.Parent = abaGeral

ativarAutoFarm.Changed:Connect(function(novoValor)
    rodando = novoValor
    if rodando then
        task.spawn(autoFarm)
    end
end)

--Animação ao abrir
MainFrame.Size = UDim2.new(0, 0, 0, 0) -- Inicia com tamanho zero

local tweenInfo = TweenInfo.new(
    0.5, -- Duração
    Enum.EasingStyle.Back, -- Estilo de animação (Back para efeito de "esticar")
    Enum.EasingDirection.Out, -- Direção
    0, -- Repetições
    false, -- Reverter?
    0 -- Delay
)

local tamanhoFinal = UDim2.new(0, 0.4, 0, 0.5)
local tween = TweenService:Create(MainFrame, tweenInfo, {Size = tamanhoFinal})
tween:Play()

print("Script de Auto Farm (Exemplo) Carregado!")
