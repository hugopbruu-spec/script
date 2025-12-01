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
    MainFrame.Size = UDim2.new(0, 450, 0, 750)  -- Aumentei a altura
    MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    MainFrame.Parent = ScreenGui
	MainFrame.Draggable = true -- Tornar o menu arrastável

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0, 30)
    TitleLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    TitleLabel.TextColor3 = Color3.new(1, 1, 1)
    TitleLabel.Text = "Enganando a Criação de Itens"
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextScaled = true
    TitleLabel.Parent = MainFrame

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
    StatusLabel.Position = UDim2.new(0.05, 0, 0.95, 0)
    StatusLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    StatusLabel.TextColor3 = Color3.new(1, 1, 0)
    StatusLabel.Text = "Tentar criar o cacto como outro item."
    StatusLabel.Font = Enum.Font.SourceSans
    StatusLabel.TextScaled = true
    StatusLabel.Parent = MainFrame

    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Size = UDim2.new(0.45, 0, 0.7, 0)
    ScrollingFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
    ScrollingFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    ScrollingFrame.Parent = MainFrame

    local RemoteNameTextBox = Instance.new("TextBox")
    RemoteNameTextBox.Size = UDim2.new(0.4, 0, 0, 30)
    RemoteNameTextBox.Position = UDim2.new(0.55, 0, 0.1, 0)
    RemoteNameTextBox.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    RemoteNameTextBox.TextColor3 = Color3.new(1, 1, 1)
    RemoteNameTextBox.Font = Enum.Font.SourceSans
    RemoteNameTextBox.PlaceholderText = "Nome do RemoteEvent"
    RemoteNameTextBox.Parent = MainFrame

    local ArgumentTextBox = Instance.new("TextBox")
    ArgumentTextBox.Size = UDim2.new(0.4, 0, 0, 30)
    ArgumentTextBox.Position = UDim2.new(0.55, 0, 0.2, 0)
    ArgumentTextBox.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    ArgumentTextBox.TextColor3 = Color3.new(1, 1, 1)
    ArgumentTextBox.Font = Enum.Font.SourceSans
    ArgumentTextBox.PlaceholderText = "Argumento (Item Fácil)"
    ArgumentTextBox.Parent = MainFrame

	local CactoArgumentTextBox = Instance.new("TextBox")
    CactoArgumentTextBox.Size = UDim2.new(0.4, 0, 0, 30)
    CactoArgumentTextBox.Position = UDim2.new(0.55, 0, 0.3, 0)
    CactoArgumentTextBox.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    CactoArgumentTextBox.TextColor3 = Color3.new(1, 1, 1)
    CactoArgumentTextBox.Font = Enum.Font.SourceSans
    CactoArgumentTextBox.PlaceholderText = "Argumento (Cacto)"
    CactoArgumentTextBox.Parent = MainFrame

    local TryButton = Instance.new("TextButton")
    TryButton.Size = UDim2.new(0.4, 0, 0, 30)
    TryButton.Position = UDim2.new(0.55, 0, 0.4, 0)
    TryButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    TryButton.TextColor3 = Color3.new(1, 1, 1)
    TryButton.Text = "Tentar Criar Cacto"
    TryButton.Font = Enum.Font.SourceSans
    TryButton.Parent = MainFrame

	local RefreshButton = Instance.new("TextButton")
    RefreshButton.Size = UDim2.new(0.4, 0, 0, 30)
    RefreshButton.Position = UDim2.new(0.55, 0, 0.5, 0)
    RefreshButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    RefreshButton.TextColor3 = Color3.new(1, 1, 1)
    RefreshButton.Text = "Atualizar Lista"
    RefreshButton.Font = Enum.Font.SourceSans
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
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 0, 30)
            button.Position = UDim2.new(0, 0, (i - 1) * 0.05, 0)
            button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            button.TextColor3 = Color3.new(1, 1, 1)
            button.Text = remote.Name
            button.Font = Enum.Font.SourceSans
            button.Parent = ScrollingFrame

			button.MouseButton1Click:Connect(function()
				RemoteNameTextBox.Text = remote.Name -- Preenche o nome ao clicar
			end)

        end
    end

    -- Função para tentar interagir com o RemoteEvent
    local function tentarInteragir(remoteName, itemFacilArgument, cactoArgument)
        -- Tenta encontrar o RemoteEvent em ReplicatedStorage
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild(remoteName)
        if not remote or not remote:IsA("RemoteEvent") then
            -- Se não encontrar em ReplicatedStorage, procura em outros lugares
            local foundRemote = nil
            local function findRemote(obj)
                for _, child in ipairs(obj:GetDescendants()) do
                    if child:IsA("RemoteEvent") and child.Name == remoteName then
                        foundRemote = child
                        return
                    end
                end
            end
            findRemote(game)
            remote = foundRemote
        end

        if remote then
            pcall(function()
				-- Tentar converter o argumento para diferentes tipos
				local convertedItemFacilArgument = itemFacilArgument
				if tonumber(itemFacilArgument) then
					convertedItemFacilArgument = tonumber(itemFacilArgument)
				elseif itemFacilArgument == "true" then
					convertedItemFacilArgument = true
				elseif itemFacilArgument == "false" then
					convertedItemFacilArgument = false
				end

				local convertedCactoArgument = cactoArgument
				if tonumber(cactoArgument) then
					convertedCactoArgument = tonumber(cactoArgument)
				elseif cactoArgument == "true" then
					convertedCactoArgument = true
				elseif cactoArgument == "false" then
					convertedCactoArgument = false
				end


                if itemFacilArgument and itemFacilArgument ~= "" and cactoArgument and cactoArgument ~= "" then
                    remote:FireServer(convertedCactoArgument)
                    StatusLabel.Text = "Tentando criar cacto com " .. remoteName .. " e argumento: " .. tostring(convertedCactoArgument)
                else
                    StatusLabel.Text = "Por favor, preencha ambos os argumentos."
                end
                wait(2)
                StatusLabel.Text = "Tentar criar o cacto como outro item."
            end)
        else
            StatusLabel.Text = "RemoteEvent '" .. remoteName .. "' não encontrado."
        end
    end

    -- Conectar o botão "Tentar"
    TryButton.MouseButton1Click:Connect(function()
        local remoteName = RemoteNameTextBox.Text
        local itemFacilArgument = ArgumentTextBox.Text
		local cactoArgument = CactoArgumentTextBox.Text
        tentarInteragir(remoteName, itemFacilArgument, cactoArgument)
    end)

	--Conectar o botão "Atualizar Lista"
	RefreshButton.MouseButton1Click:Connect(listarRemotes)


    -- Chamar a função para listar os RemoteEvents
    listarRemotes()
end)

if not success then
    warn("Erro ao criar a interface: " .. errorMessage)
end
