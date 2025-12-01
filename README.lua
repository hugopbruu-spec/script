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
    MainFrame.Size = UDim2.new(0, 400, 0, 600)
    MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    MainFrame.ClipsDescendants = true

    local dragging = false
    local dragInput = nil
    local dragStart = nil

    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            dragInput = input
        end
    end)

    MainFrame.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset + delta.X,
                MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset + delta.Y)
            dragStart = input.Position
        end
    end)

    MainFrame.InputEnded:Connect(function(input)
        if input == dragInput and dragging then
            dragging = false
            dragInput = nil
        end
    end)

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
    TitleLabel.Text = "Duplicador de Itens (EXPERIMENTAL)"
    TitleLabel.Font = Enum.Font.Oswald
    TitleLabel.TextScaled = true
    TitleLabel.Parent = MainFrame

	local TryButton = Instance.new("TextButton")
    TryButton.Size = UDim2.new(0.4, 0, 0, 30)
    TryButton.Position = UDim2.new(0.05, 0, 0.1, 0)
    TryButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    TryButton.TextColor3 = Color3.new(1, 1, 1)
    TryButton.Text = "Duplicar"
    TryButton.Font = Enum.Font.SourceSansBold
	TryButton.TextScaled = true
    TryButton.Parent = MainFrame

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
    StatusLabel.Position = UDim2.new(0.05, 0, 0.85, 0)
    StatusLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    StatusLabel.TextColor3 = Color3.new(1, 1, 0)
    StatusLabel.Text = "Pronto para duplicar itens (USE COM CAUTELA)."
    StatusLabel.Font = Enum.Font.SourceSans
    StatusLabel.TextScaled = true
    StatusLabel.Parent = MainFrame

    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Size = UDim2.new(0.45, 0, 0.5, 0)
    ScrollingFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
    ScrollingFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    ScrollingFrame.Parent = MainFrame

    local RemoteNameTextBox = Instance.new("TextBox")
    RemoteNameTextBox.Size = UDim2.new(0.4, 0, 0, 30)
    RemoteNameTextBox.Position = UDim2.new(0.55, 0, 0.15, 0)
    RemoteNameTextBox.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    RemoteNameTextBox.TextColor3 = Color3.new(1, 1, 1)
    RemoteNameTextBox.Font = Enum.Font.SourceSans
    RemoteNameTextBox.PlaceholderText = "RemoteEvent para duplicar"
    RemoteNameTextBox.Parent = MainFrame

    local ItemNameTextBox = Instance.new("TextBox")
    ItemNameTextBox.Size = UDim2.new(0.4, 0, 0, 30)
    ItemNameTextBox.Position = UDim2.new(0.55, 0, 0.25, 0)
    ItemNameTextBox.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    ItemNameTextBox.TextColor3 = Color3.new(1, 1, 1)
    ItemNameTextBox.Font = Enum.Font.SourceSans
    ItemNameTextBox.PlaceholderText = "Nome do Item a Duplicar"
    ItemNameTextBox.Parent = MainFrame

    local RefreshButton = Instance.new("TextButton")
    RefreshButton.Size = UDim2.new(0.4, 0, 0, 30)
    RefreshButton.Position = UDim2.new(0.05, 0, 0.75, 0)
    RefreshButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    RefreshButton.TextColor3 = Color3.new(1, 1, 1)
    RefreshButton.Text = "Atualizar Lista"
    RefreshButton.Font = Enum.Font.SourceSansBold
    RefreshButton.TextScaled = true
    RefreshButton.Parent = MainFrame

    -- Função para listar todos os RemoteEvents
    local function listarRemotes()
        -- Limpar a lista anterior
        for _, child in ipairs(ScrollingFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        -- Encontrar todos os RemoteEvents
        local remotes = {}
        local function findAllRemotes(obj)
            for _, child in ipairs(obj:GetDescendants()) do
                if child:IsA("RemoteEvent") then
                    table.insert(remotes, child)
                end
            end
        end

        findAllRemotes(game)

        -- Criar botões para cada RemoteEvent
        for i, remote in ipairs(remotes) do
			if remote.Name ~= "CmdrEvent" then -- Ignorar o CmdrEvent
				local button = Instance.new("TextButton")
				button.Size = UDim2.new(1, 0, 0, 25)
				button.Position = UDim2.new(0, 0, (i - 1) * 0.04, 0)
				button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
				button.TextColor3 = Color3.new(1, 1, 1)
				button.Text = remote.Name
				button.Font = Enum.Font.SourceSans
				button.TextScaled = true
				button.Parent = ScrollingFrame
				createUICorner(button, 4)

				button.MouseButton1Click:Connect(function()
					RemoteNameTextBox.Text = remote.Name
				end)
			end
        end
		ScrollingFrame.CanvasSize = UDim2.new(0,0,0,(#remotes * 25))
    end

    -- Função para tentar interagir com o RemoteEvent
    local function tentarDuplicar(remoteName, itemName)
        -- Encontrar o RemoteEvent pelo nome
		local remote = nil
		for _, descendent in ipairs(game:GetDescendants()) do
			if descendent:IsA("RemoteEvent") and descendent.Name == remoteName then
				remote = descendent
				break
			end
		end

        if remote then
            pcall(function()
				-- Argumentos padronizados
				local arg = "{player = '" .. Player.Name .. "', item = '" .. itemName .. "', quantity = 1}"

                remote:FireServer(arg)
                StatusLabel.Text = "Tentando duplicar " .. itemName .. " usando " .. remoteName
                wait(2) -- Aguarda um pouco para mostrar o resultado
				StatusLabel.Text = "Pronto para duplicar itens (USE COM CAUTELA)."
            end)
        else
            StatusLabel.Text = "RemoteEvent não encontrado."
        end
    end

    -- Conectar o botão "Duplicar"
    TryButton.MouseButton1Click:Connect(function()
		local remoteName = RemoteNameTextBox.Text
		local itemName = ItemNameTextBox.Text
        tentarDuplicar(remoteName, itemName)
    end)

    -- Conectar o botão "Atualizar Lista"
    RefreshButton.MouseButton1Click:Connect(listarRemotes)

    -- Chamar a função para listar os RemoteEvents
    listarRemotes()
end)

if not success then
    warn("Erro ao criar a interface: " .. errorMessage)
end
