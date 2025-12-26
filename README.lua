--[[
    EXEMPLO GENÉRICO DE SCRIPT DE AUTO FARM (APENAS PARA FINS EDUCACIONAIS)

    ATENÇÃO: Este script é apenas um exemplo e pode não funcionar diretamente em nenhum jogo.
    Use por sua conta e risco.
]]

-- Serviços do Roblox
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- Jogador local
local LocalPlayer = Players.LocalPlayer

-- Variáveis de controle
local rodando = false
local intervaloDeAcao = 2 -- Segundos entre cada ação

-- Função para simular clique em um botão (substitua pela lógica real do jogo)
local function simularClique(botao)
    firetouchinput(botao.Position.X.Offset, botao.Position.Y.Offset, 1280, 720)
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

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 200, 0, 100)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
MainFrame.Parent = ScreenGui

local AutoFarmButton = Instance.new("TextButton")
AutoFarmButton.Name = "AutoFarmButton"
AutoFarmButton.Size = UDim2.new(0, 150, 0, 30)
AutoFarmButton.Position = UDim2.new(0.25, 0, 0.1, 0)
AutoFarmButton.Text = "Iniciar Auto Farm"
AutoFarmButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
AutoFarmButton.Parent = MainFrame

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
