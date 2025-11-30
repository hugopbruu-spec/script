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

AutoBuyToggle.MouseButton1Click:Connect(function()
    AutoBuyEnabled = not AutoBuyEnabled
    if AutoBuyEnabled then
        AutoBuyToggle.Text = "Auto Buy Seeds: On"
        print("Auto Buy Ativado")
    else
        AutoBuyToggle.Text = "Auto Buy Seeds: Off"
        print("Auto Buy Desativado")
    end
end)

local DuplicateButton = Instance.new("TextButton")
DuplicateButton.Size = UDim2.new(0.9, 0, 0, 30)
DuplicateButton.Position = UDim2.new(0.05, 0, 0.3, 0)
DuplicateButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
DuplicateButton.TextColor3 = Color3.new(1, 1, 1)
DuplicateButton.Text = "Duplicar Item (Q)"
DuplicateButton.Font = Enum.Font.SourceSans
DuplicateButton.Parent = MainFrame

--// Funções //--

-- Função genérica para encontrar um elemento na interface do usuário
local function findUIElement(parent, elementName)
    -- parent: O objeto pai onde a busca será realizada (ex: PlayerGui)
    -- elementName: O nome do elemento que você está procurando (ex: "BuySeedButton123")

    for i, v in pairs(parent:GetDescendants()) do
        if v.Name == elementName then
            return v -- Retorna o elemento se encontrado
        end
    end

    return nil -- Retorna nil se o elemento não for encontrado
end

-- Função para comprar uma seed específica
local function buySeed(seedId)
    -- seedId: O ID da seed que você deseja comprar

    -- **IMPORTANTE:** Descubra o nome exato do botão de compra da seed na interface do jogo
    local buttonName = "BuySeedButton" .. seedId -- Exemplo: "BuySeedButton123"

    -- Encontre o botão de compra usando a função findUIElement
    local buyButton = findUIElement(game.Players.LocalPlayer.PlayerGui, buttonName)

    if buyButton and buyButton:IsA("TextButton") then
        -- Simule um clique no botão
        buyButton.MouseButton1Click:Fire()
        print("Comprando seed " .. seedId)
    else
        print("Botão de compra da seed " .. seedId .. " não encontrado.")
    end
end

-- Função para duplicar um item
local function duplicateItem()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then
        print("Personagem não encontrado.")
        return
    end

    local item = character:FindFirstChildOfClass("Tool")

    if item then
        -- **IMPORTANTE:** Descubra como o item funciona internamente e como replicar sua funcionalidade
        -- Se o item tem scripts, considere cloná-los também
        -- Se o item depende de eventos, certifique-se de conectá-los corretamente

        local newItem = item:Clone()
        newItem.Name = item.Name .. "Copy"
        newItem.Parent = character

        newItem.CFrame = item.CFrame * CFrame.new(0, 1, 0)
        newItem.CanCollide = true
        newItem.Anchored = false

        -- **Exemplo de como copiar scripts (adapte para o seu item):**
        for i, script in pairs(item:GetChildren()) do
            if script:IsA("Script") then
                local newScript = script:Clone()
                newScript.Parent = newItem
            end
        end

        print("Item duplicado: " .. item.Name)
    else
        print("Nenhum item equipado para duplicar.")
    end
end

--// Loop de Auto Compra (Exemplo) //--

-- Este é apenas um exemplo básico. A lógica real dependerá da estrutura do jogo.
game:GetService("RunService").Heartbeat:Connect(function()
    if AutoBuyEnabled then
        -- Exemplo: Comprar as seeds com IDs 12345 e 67890
        buySeed(12345)
        buySeed(67890)
        -- Adicione mais IDs de seeds aqui
    end
end)

--// Bind para Duplicar Item (Exemplo) //--

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.Q then
        duplicateItem()
    end
end)

DuplicateButton.MouseButton1Click:Connect(duplicateItem)
