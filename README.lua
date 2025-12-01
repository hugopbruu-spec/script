--// Interface Gráfica (GUI) //--

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui", 10)

if not PlayerGui then
    warn("PlayerGui não encontrado após 10 segundos! A interface não será criada.")
    return
end

local success, errorMessage = pcall(function()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PVBHelper"
    ScreenGui.Parent = PlayerGui
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 250, 0, 300)
    MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    MainFrame.Parent = ScreenGui

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0, 30)
    TitleLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    TitleLabel.TextColor3 = Color3.new(1, 1, 1)
    TitleLabel.Text = "Plants vs Brainrots Helper"
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextScaled = true
    TitleLabel.Parent = MainFrame

    local AutoBuyToggle = Instance.new("TextButton")
    AutoBuyToggle.Size = UDim2.new(0.9, 0, 0, 30)
    AutoBuyToggle.Position = UDim2.new(0.05, 0, 0.15, 0)
    AutoBuyToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    AutoBuyToggle.TextColor3 = Color3.new(1, 1, 1)
    AutoBuyToggle.Text = "Auto Buy Seeds: Off"
    AutoBuyToggle.Font = Enum.Font.SourceSans
    AutoBuyToggle.Parent = MainFrame

    local AutoBuyEnabled = false

    local function updateAutoBuyButtonText()
        if AutoBuyEnabled then
            AutoBuyToggle.Text = "Auto Buy Seeds: On"
            AutoBuyToggle.BackgroundColor3 = Color3.fromRGB(100, 150, 100)
        else
            AutoBuyToggle.Text = "Auto Buy Seeds: Off"
            AutoBuyToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        end
    end

    AutoBuyToggle.MouseButton1Click:Connect(function()
        AutoBuyEnabled = not AutoBuyEnabled
        updateAutoBuyButtonText()
        if AutoBuyEnabled then
            print("Auto Buy Ativado")
        else
            print("Auto Buy Desativado")
        end
    end)

    updateAutoBuyButtonText()

    local DuplicateButton = Instance.new("TextButton")
    DuplicateButton.Size = UDim2.new(0.9, 0, 0, 30)
    DuplicateButton.Position = UDim2.new(0.05, 0, 0.3, 0)
    DuplicateButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    DuplicateButton.TextColor3 = Color3.new(1, 1, 1)
    DuplicateButton.Text = "Duplicar Item (Q)"
    DuplicateButton.Font = Enum.Font.SourceSans
    DuplicateButton.Parent = MainFrame
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    --// Funções //--

    local function findUIElementsWithPattern(parent, namePattern)
        local elements = {}
        for i, v in pairs(parent:GetDescendants()) do
            if typeof(v) == "Instance" and string.find(v.Name, namePattern) then
                table.insert(elements, v)
            end
        end
        return elements
    end

    local function buySeed(buyButton)
        if buyButton and buyButton:IsA("TextButton") then
            pcall(function()
                buyButton:FireServer() -- Use RemoteEvents para interagir com o servidor
                print("Comprando seed")
            end)
        else
            print("Botão de compra não encontrado.")
        end
    end

    local function autoBuySeeds()
        local player = game.Players.LocalPlayer
        local playerGui = player.PlayerGui

        -- ADAPTAR: Substitua "BuySeedButton" pelo padrão correto dos botões de compra
        local buyButtons = findUIElementsWithPattern(playerGui, "BuySeedButton")

        for _, button in ipairs(buyButtons) do
            buySeed(button)
        end
    end

    -- Framework de Mimetismo Avançado
    local MimicryFramework = {}

    --[[ ADAPTAR: CLONAGEM OCULTA
    Implementar a clonagem do item de forma a minimizar rastros.
    ]]
    function MimicryFramework:CloneItem(item)
        -- Exemplo: Clonar propriedades essenciais manualmente (mais difícil de detectar)
        local newItem = Instance.new("Tool") -- Ou o tipo correto do item
        newItem.Name = item.Name
        --[[ ADAPTAR: Copiar propriedades essenciais do item (ex: dano, alcance, etc.)
        newItem.Dano = item.Dano
        newItem.Alcance = item.Alcance
        ]]
        --[[ ADAPTAR: Copiar scripts essenciais do item
        for _, script in ipairs(item:GetChildren()) do
            if script:IsA("Script") then
                local newScript = script:Clone()
                newScript.Parent = newItem
            end
        end
        ]]
        return newItem
    end

    --[[ ADAPTAR: GERAÇÃO DE METADADOS FALSOS
    Criar metadados que correspondam aos de um item legítimo.
    ]]
    function MimicryFramework:GenerateFakeMetadata(item)
        -- Exemplo: Gerar um ID falso
        local fakeId = tostring(math.random(1000000, 9999999))
        --[[ ADAPTAR: Adicionar metadados falsos ao item duplicado
        newItem:SetAttribute("ItemId", fakeId)
        ]]
    end

    --[[ ADAPTAR: SIMULAÇÃO COMPORTAMENTAL
    Simular ações legítimas que um jogador realizaria ao obter o item.
    ]]
    function MimicryFramework:SimulateLegitimateActions(player, newItem)
        -- Exemplo: Simular a conclusão de uma missão
        --[[ ADAPTAR: Disparar eventos para simular a conclusão de uma missão
        local missionCompleteEvent = player:FindFirstChild("MissionCompleteEvent")
        if missionCompleteEvent and missionCompleteEvent:IsA("RemoteEvent") then
            missionCompleteEvent:FireServer("Mission123")
        end
        ]]
        --[[ ADAPTAR: Adicionar o item ao inventário do jogador
        local inventory = player:FindFirstChild("Inventory")
        if inventory and inventory:IsA("Folder") then
            newItem.Parent = inventory
        end
        ]]
    end

    --[[ ADAPTAR: RESPEITAR RESTRIÇÕES
    Garantir que o item duplicado respeite todas as restrições impostas pelo jogo.
    ]]
    function MimicryFramework:EnforceRestrictions(newItem)
        -- Exemplo: Garantir que o item tenha o nível correto
        --[[ ADAPTAR: Verificar e ajustar o nível do item
        if newItem.Level < 1 then
            newItem.Level = 1
        end
        ]]
    end

    --[[ ADAPTAR: REMOÇÃO DE EVIDÊNCIAS
    Remover quaisquer evidências da duplicação.
    ]]
    function MimicryFramework:RemoveEvidence(item)
        -- Exemplo: Destruir o item original
        --item:Destroy() -- Descomente se quiser remover o item original
    end

    -- Função principal para duplicar o item
    local function duplicateItem()
        local player = game.Players.LocalPlayer
        local character = player.Character
        if not character then
            print("Personagem não encontrado.")
            return
        end

        local item = character:FindFirstChildOfClass("Tool")

        if item then
            --[[ ADAPTAR: DUPLICAÇÃO CAMUFLADA
            Duplicar o item sem deixar rastros óbvios.
            ]]
            local newItem = MimicryFramework:CloneItem(item)

            --[[ ADAPTAR: GERAÇÃO DE METADADOS FALSOS
            Criar metadados que correspondam aos de um item legítimo.
            ]]
            MimicryFramework:GenerateFakeMetadata(newItem)

            --[[ ADAPTAR: SIMULAÇÃO COMPORTAMENTAL
            Simular ações legítimas que um jogador realizaria ao obter o item.
            ]]
            MimicryFramework:SimulateLegitimateActions(player, newItem)

            --[[ ADAPTAR: RESPEITAR RESTRIÇÕES
            Garantir que o item duplicado respeite todas as restrições impostas pelo jogo.
            ]]
            MimicryFramework:EnforceRestrictions(newItem)

            --[[ ADAPTAR: REMOÇÃO DE EVIDÊNCIAS
            Remover quaisquer evidências da duplicação.
            ]]
            MimicryFramework:RemoveEvidence(item)

            print("Item duplicado com sucesso (mimetismo avançado).")
        else
            print("Nenhum item equipado para duplicar.")
        end
    end

    --// Loop de Auto Compra (Exemplo) //--

    game:GetService("RunService").Heartbeat:Connect(function()
        if AutoBuyEnabled then
            autoBuySeeds()
        end
    end)

    --// Bind para Duplicar Item (Exemplo) //--

    game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
        if input.KeyCode == Enum.KeyCode.Q then
            duplicateItem()
        end
    end)

    DuplicateButton.MouseButton1Click:Connect(duplicateItem)
end)

if not success then
    warn("Erro ao criar a interface: " .. errorMessage)
end
