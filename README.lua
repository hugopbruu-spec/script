--// Interface Gráfica (GUI) //--

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui", 10)

if not PlayerGui then
    warn("PlayerGui não encontrado após 10 segundos! A interface não será criada.")
    return
end

local success, errorMessage = pcall(function()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Duplicador"
    ScreenGui.Parent = PlayerGui
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 300, 0, 200)
    MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Tema Preto
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    MainFrame.ClipsDescendants = true

    local function createUICorner(parent, radius)
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, radius)
        corner.Parent = parent
    end

    createUICorner(MainFrame, 8)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0, 30)
    TitleLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    TitleLabel.TextColor3 = Color3.new(1, 1, 1)
    TitleLabel.Text = "Duplicador de Itens"
    TitleLabel.Font = Enum.Font.Oswald
    TitleLabel.TextScaled = true
    TitleLabel.Parent = MainFrame

    local DuplicateSeedsButton = Instance.new("TextButton")
    DuplicateSeedsButton.Size = UDim2.new(0.8, 0, 0, 40)
    DuplicateSeedsButton.Position = UDim2.new(0.1, 0, 0.2, 0)
    DuplicateSeedsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    DuplicateSeedsButton.TextColor3 = Color3.new(1, 1, 1)
    DuplicateSeedsButton.Text = "Duplicar Semente na Mão"
    DuplicateSeedsButton.Font = Enum.Font.SourceSansBold
    DuplicateSeedsButton.TextScaled = true
    DuplicateSeedsButton.Parent = MainFrame
    createUICorner(DuplicateSeedsButton, 4)

    local DuplicatePlantsButton = Instance.new("TextButton")
    DuplicatePlantsButton.Size = UDim2.new(0.8, 0, 0, 40)
    DuplicatePlantsButton.Position = UDim2.new(0.1, 0, 0.6, 0)
    DuplicatePlantsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    DuplicatePlantsButton.TextColor3 = Color3.new(1, 1, 1)
    DuplicatePlantsButton.Text = "Duplicar Planta na Mão"
    DuplicatePlantsButton.Font = Enum.Font.SourceSansBold
    DuplicatePlantsButton.TextScaled = true
    DuplicatePlantsButton.Parent = MainFrame
    createUICorner(DuplicatePlantsButton, 4)

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
    StatusLabel.Position = UDim2.new(0.05, 0, 0.85, 0)
    StatusLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    StatusLabel.TextColor3 = Color3.new(1, 1, 0)
    StatusLabel.Text = "Pronto para Duplicar."
    StatusLabel.Font = Enum.Font.SourceSans
    StatusLabel.TextScaled = true
    StatusLabel.Parent = MainFrame

	-- Funções --

	-- Função para obter o item na mão do personagem (ADAPTAR!)
    local function getItemInHand()
        -- *** IMPORTANTE: ADAPTAR ESTA FUNÇÃO PARA O JOGO ***
        -- Este é apenas um exemplo. Você precisará encontrar a maneira
        -- correta de obter o item que o jogador está segurando.
        -- Pode envolver acessar a ferramenta equipada, o objeto na mão, etc.
		local character = Player.Character or Player.CharacterAdded:Wait()
		local humanoid = character:FindFirstChild("Humanoid")

		if humanoid then
			local tool = humanoid. руках:FindFirstChild("Ferramenta")
			if tool then
				return tool
			else
				StatusLabel.Text = "Nenhuma ferramenta na mão."
				return nil
			end
		else
			StatusLabel.Text = "Humanoide não encontrado."
			return nil
		end
    end

    -- Função para duplicar um item e adicioná-lo ao inventário (ADAPTAR!)
    local function duplicateItem(item)
        -- *** IMPORTANTE: ADAPTAR ESTA FUNÇÃO PARA O JOGO ***
        -- Esta função precisa lidar com a duplicação do item e adicioná-lo
        -- ao inventário do jogador de forma que ele não seja automaticamente selecionado.
        -- Pode envolver o uso de RemoteEvents, manipulação de objetos, etc.

        if item then
            local newItem = item:Clone() -- Cria uma cópia do item
            newItem.Parent = Player.Backpack -- Adiciona ao inventário

            StatusLabel.Text = "Item duplicado e adicionado ao inventário: " .. item.Name
        else
            StatusLabel.Text = "Nenhum item para duplicar."
        end
    end

	-- Conexões dos Botões --

    DuplicateSeedsButton.MouseButton1Click:Connect(function()
        local item = getItemInHand()
        if item then
            if string.find(item.Name:lower(), "seed") then -- Verifica se é uma semente
                duplicateItem(item)
            else
                StatusLabel.Text = "O item na mão não é uma semente."
            end
        else
            StatusLabel.Text = "Nenhuma semente na mão."
        end
    end)

    DuplicatePlantsButton.MouseButton1Click:Connect(function()
        local item = getItemInHand()
        if item then
            if string.find(item.Name:lower(), "planta") then -- Verifica se é uma planta
                duplicateItem(item)
            else
                StatusLabel.Text = "O item na mão não é uma planta."
            end
        else
            StatusLabel.Text = "Nenhuma planta na mão."
        end
    end)
end)

if not success then
    warn("Erro ao criar a interface: " .. errorMessage)
end
