-- LocalScript (StarterPlayerScripts)

print("Script de coleta automática iniciado!")

-- Configurações
local raioDeBusca = 10 -- Ajuste conforme necessário
local intervaloDeColeta = 5  -- Este não é mais usado diretamente, mas pode ser útil para implementar um cooldown.
local animationId = "rbxassetid://14493329472" -- SUBSTITUA - Id da animação de pedir esmola Plants vs Brainrots
local itemValue = 100 -- Valor padrão de um item coletado. Ajuste com o valor correto
-- Services
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RemoteEvent (Coloque em ReplicatedStorage)
local tradeEvent = ReplicatedStorage:WaitForChild("TradeEvent") -- Crie este RemoteEvent

-- Variáveis de estado
local coletaAutomaticaAtiva = false
local ultimoTempoColeta = 0 -- Para controlar o intervalo (cooldown)
local isCooldown = false

-- Função para encontrar o jogador mais próximo
local function encontrarJogadorMaisProximo()
    local jogadorMaisProximo = nil
    local distanciaMinima = math.huge
    local playerPosition = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character.HumanoidRootPart.Position
    if not playerPosition then return nil end

    for _, jogador in ipairs(Players:GetPlayers()) do
        if jogador ~= Player and jogador.Character and jogador.Character:FindFirstChild("HumanoidRootPart") then
            local distancia = (jogador.Character.HumanoidRootPart.Position - playerPosition).Magnitude
            if distancia < distanciaMinima then
                distanciaMinima = distancia
                jogadorMaisProximo = jogador
            end
        end
    end

    return jogadorMaisProximo
end


-- Função para simular a troca (agora pede esmola)
local function iniciarColeta()
    if isCooldown then return end

    local jogadorAlvo = encontrarJogadorMaisProximo()

    if jogadorAlvo then
        -- Carrega a animação
        local character = Player.Character
        local humanoid = character:WaitForChild("Humanoid")
        local animation = Instance.new("Animation")
        animation.AnimationId = animationId
        local animationTrack = humanoid:LoadAnimation(animation)

        -- Toca a animação (se houver)
        if animationTrack then
            animationTrack:Play()
            --wait(animationTrack.Length) -- Espera a animação terminar (opcional)
        end

        -- Chama o RemoteEvent para iniciar a troca no servidor (envia o valor do item)
        tradeEvent:FireServer(jogadorAlvo, itemValue)

        if animationTrack then
            animationTrack:Stop()
        end

        -- Inicia o cooldown
        isCooldown = true
        wait(intervaloDeColeta)
        isCooldown = false
        
    else
        print("Nenhum jogador próximo encontrado.")
    end
end

-- GUI
local function criarMenuGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ColetorAutomaticoGUI"
    screenGui.Parent = PlayerGui
    screenGui.ResetOnSpawn = false

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 200, 0, 50)
    toggleButton.Position = UDim2.new(0, 10, 0, 10)
    toggleButton.Text = "Ativar Coleta Automática"
    toggleButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)  -- Verde para indicar ativado
    toggleButton.TextColor3 = Color3.new(1, 1, 1) -- Texto branco

    toggleButton.MouseButton1Click:Connect(function()
        coletaAutomaticaAtiva = not coletaAutomaticaAtiva
        if coletaAutomaticaAtiva then
            toggleButton.Text = "Desativar Coleta Automática"
            toggleButton.BackgroundColor3 = Color3.fromRGB(200, 100, 100)  -- Vermelho para indicar desativado
            
            while coletaAutomaticaAtiva do  --Loop while
              iniciarColeta()
              game:GetService("RunService").Heartbeat:Wait() --Evita travar o game
            end

            toggleButton.Text = "Ativar Coleta Automática"
            toggleButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100) -- Volta ao verde
        else
            toggleButton.Text = "Ativar Coleta Automática"
            toggleButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        end
    end)
end


-- Inicialização
criarMenuGUI()


-- ServerScript (colocar em ServerScriptService)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local tradeEvent = ReplicatedStorage:WaitForChild("TradeEvent")

local function giveBones(player, amount)
  -- Caminho para o valor de "Bones"
  local bonesValue = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Bones")

  if bonesValue then
      bonesValue.Value = bonesValue.Value + amount
  else
      -- Se o leaderstats ou o valor "Bones" não existirem, cria-os
      local leaderstats = Instance.new("Folder")
      leaderstats.Name = "leaderstats"
      leaderstats.Parent = player

      bonesValue = Instance.new("IntValue")
      bonesValue.Name = "Bones"
      bonesValue.Value = amount
      bonesValue.Parent = leaderstats
  end
end


tradeEvent.OnServerEvent:Connect(function(player, jogadorAlvo, valorItem)
    if not jogadorAlvo or not player then return end

    -- Verifica se o jogadorAlvo está próximo o suficiente (ajuste o raio)
    local distancia = (player.Character.HumanoidRootPart.Position - jogadorAlvo.Character.HumanoidRootPart.Position).Magnitude
    if distancia > raioDeBusca then
        print(player.Name .. " está muito longe de " .. jogadorAlvo.Name .. " para coletar.")
        return
    end

    --[[
        Lógica para transferir itens do jogadorAlvo para o player:
        1. Verificar se o jogadorAlvo está próximo o suficiente (já feito acima).
        2. Verificar se o jogadorAlvo tem itens para doar. (Precisa implementar lógica específica do jogo).
        3. Transferir os itens (código específico do jogo).
    ]]
    print("Coleta solicitada por " .. player.Name .. " de " .. jogadorAlvo.Name)

    -- ADICIONE A LÓGICA DE TROCA AQUI - Adaptado para Plants vs Brainrots
    -- Supondo que você quer dar "Bones" ao jogador:
    giveBones(player, valorItem) --Ajustar  o valor do item recebido

    -- DEDUÇÃO DE BONES DO DOADOR (adaptar)
    local donorBones = jogadorAlvo:FindFirstChild("leaderstats") and jogadorAlvo.leaderstats:FindFirstChild("Bones")
    if donorBones then
      donorBones.Value = math.max(0, donorBones.Value - valorItem) -- Impede que o valor seja negativo
    end

    --[[  Código de exemplo (adaptado do original):
        for i = 1, 10 do
            local item = Instance.new("Part")
            item.Parent = player.Backpack
        end
    ]]
end)
