--[[
    
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
local guiArrastavel = false
local guiPosicaoInicial = nil

-- Função para simular clique em um botão (substitua pela lógica real do jogo)
local function simularClique(botao)
    --firetouchinput(botao.Position.X.Offset, botao.Position.Y.Offset, 1280, 720)
    -- Não consigo simular o clique diretamente, mas você pode adaptar essa função
    -- para interagir com elementos do jogo de alguma outra forma.
    print("Simulando clique em: " .. botao.Name)
end

-- Função para encontrar um local para plantar (substitua pela lógica real do jogo)
local function encontrarLocalParaPlantar()
    -- Lógica para encontrar um local válido no jogo
    -- Retorne um Vector3 com a posição
    return Vector3.new(0, 0, 0) -- Posição de exemplo
end

-- Função para plantar (substitua pela lógica real do jogo)
local function plantar(posicao)
    -- Use RemoteEvents ou funções do jogo para plantar
    print("Plantando em: " .. posicao)
    -- Exemplo: ReplicatedStorage.Plantar:FireServer(posicao)
end

-- Função principal do auto farm
local function autoFarm()
    while rodando do
        -- Encontrar um local para plantar
        local posicao = encontrarLocalParaPlantar()

        -- Plantar na posição encontrada
        plantar(posicao)

        -- Esperar um intervalo antes da próxima ação
        wait(intervaloDeAcao)
    end
end

-- Criar a GUI (Interface Gráfica)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFarmGUI"
ScreenGui.Parent = LocalPlayer.PlayerGui
ScreenGui.ResetOnSpawn = false -- Manter a GUI após o respawn

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 0.3, 0, 0.4) -- Tamanho maior (30% da tela na largura, 40% na altura)
MainFrame.Position = UDim2.new(0.35, 0, 0.3, 0) -- Centralizado (35% da largura, 30% da altura)
MainFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
MainFrame.Parent = ScreenGui
MainFrame.BorderSizePixel = 0
MainFrame.Active = true -- Necessário para tornar a GUI arrastável
MainFrame.Draggable = true

local AutoFarmButton = Instance.new("TextButton")
AutoFarmButton.Name = "AutoFarmButton"
AutoFarmButton.Size = UDim2.new(0, 150, 0, 30)
AutoFarmButton.Position = UDim2.new(0.25, 0, 0.1, 0)
AutoFarmButton.Text = "Iniciar Auto Farm"
AutoFarmButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
AutoFarmButton.Parent = MainFrame

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

local tamanhoFinal = UDim2.new(0, 0.3, 0, 0.4)
local tween = TweenService:Create(MainFrame, tweenInfo, {Size = tamanhoFinal})
tween:Play()

-- Ação do botão
AutoFarmButton.MouseButton1Click:Connect(function()
    rodando = not rodando
    if rodando then
        AutoFarmButton.Text = "Parar Auto Farm"
        -- Iniciar a função de auto farm em uma nova thread
        task.spawn(autoFarm)
    else
        AutoFarmButton.Text = "Iniciar Auto Farm"
        print("Auto Farm Parado!")
    end
end)

print("Script de Auto Farm (Exemplo) Carregado!")
