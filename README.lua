-- Configurações
local recursoAlvo = "Mango" -- Nome do recurso que você quer coletar.  IMPORTANTE: Ajuste para o nome EXATO do objeto no jogo.
local raioDeBusca = 10 -- Raio em studs para procurar recursos
local intervaloDeColeta = 5 -- Intervalo em segundos entre as tentativas de coleta

-- Serviço Players
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()  -- Espera o personagem carregar
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart") -- Espera a HumanoidRootPart carregar
local Humanoid = Character:WaitForChild("Humanoid")

--[[
Função auxiliar para debug.  Remova ou comente após testar.
Mostra mensagens no chat para ajudar a identificar problemas.
]]
local function debugPrint(message)
    game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
        Text = "[Coletor]: " .. message,
        Color = Color3.fromRGB(255, 255, 0), -- Amarelo
        Font = Enum.Font.SourceSansBold,
        TextSize = Enum.FontSize.Size14
    })
end


-- Função para encontrar o recurso mais próximo
local function encontrarRecursoMaisProximo()
    local recursoMaisProximo = nil
    local distanciaMinima = math.huge

    -- Itera sobre todos os descendentes do Workspace (e não apenas os filhos diretos)
    for _, recurso in ipairs(game.Workspace:GetDescendants()) do
        if recurso:IsA("Model") and string.find(recurso.Name, recursoAlvo) then --  USANDO string.find para correspondência parcial
            if recurso.PrimaryPart then
                local distancia = (recurso.PrimaryPart.Position - HumanoidRootPart.Position).Magnitude
                if distancia < distanciaMinima and distancia <= raioDeBusca then
                    distanciaMinima = distancia
                    recursoMaisProximo = recurso
                end
            else
                --debugPrint("Modelo '" .. recurso.Name .. "' não tem PrimaryPart.")
            end
        end
    end

    return recursoMaisProximo
end


-- Função para coletar o recurso
local function coletarRecurso(recurso)
    if recurso then
        local clickDetector = recurso:FindFirstChild("ClickDetector")
        if clickDetector then
            --debugPrint("Tentando coletar " .. recurso.Name)

            -- Usando o mouse para clicar (mais confiável do que fireclickdetector)
            local mouse = Player:GetMouse()
            mouse.Target = clickDetector.Parent  -- Aponta para o objeto que contém o ClickDetector
            mouse.TargetFilter = Character  -- Evita que o personagem bloqueie o clique
            mouse.Button1Click:Fire()  -- Simula o clique do botão esquerdo

            --debugPrint("Coletando " .. recursoAlvo)
        else
            --debugPrint("Recurso '" .. recurso.Name .. "' sem ClickDetector.")
        end
    else
        --debugPrint("Nenhum recurso '" .. recursoAlvo .. "' encontrado no raio de busca.")
    end
end



-- Loop principal
while true do
    if not Player or not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then
        --debugPrint("Esperando o personagem carregar...")
        wait(2) -- Espera um pouco mais para o personagem carregar completamente
        Player = Players.LocalPlayer
        Character = Player.Character
        if Character then
            HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
            Humanoid = Character:WaitForChild("Humanoid")
        end
    else
        local recurso = encontrarRecursoMaisProximo()
        coletarRecurso(recurso)
        wait(intervaloDeColeta)
    end
end
