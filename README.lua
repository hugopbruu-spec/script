--// Interface Gráfica (GUI) //--

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PVBHelper"
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui

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

-- Função para atualizar o texto do botão AutoBuy
local function updateAutoBuyButtonText()
    if AutoBuyEnabled then
        AutoBuyToggle.Text = "Auto Buy Seeds: On"
        AutoBuyToggle.BackgroundColor3 = Color3.fromRGB(100, 150, 100) -- Verde claro
    else
        AutoBuyToggle.Text = "Auto Buy Seeds: Off"
        AutoBuyToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end
end

AutoBuyToggle.MouseButton1Click:Connect(function()
    AutoBuyEnabled = not AutoBuyEnabled
    updateAutoBuyButtonText() -- Atualiza o texto do botão
    if AutoBuyEnabled then
        print("Auto Buy Ativado")
    else
        print("Auto Buy Desativado")
    end
end)

-- Inicializa o texto do botão
updateAutoBuyButtonText()

local DuplicateButton = Instance.new("TextButton")
DuplicateButton.Size = UDim2.new(0.9, 0, 0, 30)
DuplicateButton.Position = UDim2.new(0.05, 0, 0.3, 0)
DuplicateButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
DuplicateButton.TextColor3 = Color3.new(1, 1, 1)
DuplicateButton.Text = "Duplicar Item (Q)"
DuplicateButton.Font = Enum.Font.SourceSans
DuplicateButton.Parent = MainFrame

--// Funções //--

-- Função genérica para encontrar elementos na interface do usuário com um padrão de nome
local function findUIElementsWithPattern(parent, namePattern)
    local elements = {}
    for i, v in pairs(parent:GetDescendants()) do
        if typeof(v) == "Instance" and string.find(v.Name, namePattern) then
            table.insert(elements, v)
        end
    end
    return elements
end

-- Função para comprar uma seed (agora genérica)
local function buySeed(buyButton)
    if buyButton and buyButton:IsA("TextButton") then
        buyButton.MouseButton1Click:Fire()
        print("Comprando seed")
    else
        print("Botão de compra não encontrado.")
    end
end

-- Função para auto comprar seeds
local function autoBuySeeds()
    local player = game.Players.LocalPlayer
    local playerGui = player.PlayerGui

    -- Encontrar todos os botões de compra na loja (adapte o padrão de nome)
    local buyButtons = findUIElementsWithPattern(playerGui, "BuySeedButton")

    -- Comprar todas as seeds encontradas
    for _, button in ipairs(buyButtons) do
        buySeed(button)
    end
end

-- Função para duplicar um item (ATUALIZADA, EXTREMA e OCULTA)
local function duplicateItem()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then
        print("Personagem não encontrado.")
        return
    end

    local item = character:FindFirstChildOfClass("Tool")

    if item then
        -- Desconectar todos os eventos do item original
        for _, connection in pairs(item:GetDescendants()) do
            if typeof(connection) == "RBXScriptConnection" then
                connection:Disconnect()
            end
        end

        local newItem = Instance.new("Tool") --Cria um novo item ao invés de clonar
        newItem.Name = item.Name -- Mantém o mesmo nome do original (se for seguro)
        newItem.Parent = character

        -- Copiar propriedades essenciais do item original
        newItem. рукоятка = item.Handle:Clone() --Copia a рукоятка (punho/cabo) do item
        newItem. рукоятка.Parent = newItem

        -- Se for um modelo ou outra instância
        if newItem:FindFirstChild("BasePart") then
            newItem.CFrame = item.CFrame * CFrame.new(0, 1, 0)
            newItem.CanCollide = true
            newItem.Anchored = false
        end

        -- Copiar todos os filhos (incluindo scripts, ValueObjects, etc.)
        for _, child in pairs(item:GetChildren()) do
            local newChild = child:Clone()
            newChild.Parent = newItem

            if newChild:IsA("Script") then
                newChild.Disabled = false -- Ativa o script

                -- Conectar eventos específicos do script (adapte para cada script)
                if child.Name == "PlantingScript" then
                    newChild.Parent.Touched:Connect(function(hit)
                        if hit.Name == "PlantingArea" then
                            print("Planta plantada (cópia)!")
                            -- Lógica de plantação (adapte para o seu jogo)
                            -- **ADAPTAR A LÓGICA DE PLANTAR AQUI**
                        end
                    end)
                end

                -- Remover o nome "Copy" dos scripts para evitar detecção
                if string.find(newChild.Name, "Copy") then
                    newChild.Name = string.gsub(newChild.Name, "Copy", "")
                end

                -- Gerar um novo ID único para o item duplicado (se necessário)
                if newChild:FindFirstChild("ItemID") and newChild.ItemID:IsA("StringValue") then
                    newChild.ItemID.Value = tostring(math.random(100000, 999999)) -- Exemplo
                end

            -- Remova essa linha se o jogo usa o nome para validação
            newChild.Name = newChild.Name .. math.random(1000,9999)
            end
        end

        print("Item duplicado: " .. item.Name)

        -- Tentar camuflar o ID do jogador (altamente experimental e arriscado)
        local playerId = player.UserId
        local newPlayerId = math.random(100000000, 999999999)
        player.UserId = newPlayerId

        -- Tentar restaurar o ID do jogador após um curto período de tempo
        wait(1)
        player.UserId = playerId
    else
        print("Nenhum item equipado para duplicar.")
    end
end

--// Loop de Auto Compra (Exemplo) //--

game:GetService("RunService").Heartbeat:Connect(function()
    if AutoBuyEnabled then
        autoBuySeeds() -- Chama a função para comprar todas as seeds
    end
end)

--// Bind para Duplicar Item (Exemplo) //--

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.Q then
        duplicateItem()
    end
end)

DuplicateButton.MouseButton1Click:Connect(duplicateItem)
