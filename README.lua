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
    MainFrame.Size = UDim2.new(0, 400, 0, 600)  -- Tela menor
    MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- Cor mais escura
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    MainFrame.ClipsDescendants = true -- Importante para as bordas arredondadas

	-- Arrastar a janela
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

    -- Função para criar cantos arredondados (opcional)
    local function createUICorner(parent, radius)
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, radius)
        corner.Parent = parent
    end

    createUICorner(MainFrame, 8) -- Arredondar o MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0, 30)
    TitleLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    TitleLabel.TextColor3 = Color3.new(1, 1, 1)
    TitleLabel.Text = "Explorador de RemoteEvents"
    TitleLabel.Font = Enum.Font.Oswald -- Fonte mais bonita
    TitleLabel.TextScaled = true
    TitleLabel.Parent = MainFrame

	local TryButton = Instance.new("TextButton")
    TryButton.Size = UDim2.new(0.4, 0, 0, 30)
    TryButton.Position = UDim2.new(0.05, 0, 0.1, 0) -- Topo!
    TryButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    TryButton.TextColor3 = Color3.new(1, 1, 1)
    TryButton.Text = "Tentar"
    TryButton.Font = Enum.Font.SourceSansBold -- Fonte mais visível
	TryButton.TextScaled = true
    TryButton.Parent = MainFrame

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
    StatusLabel.Position = UDim2.new(0.05, 0, 0.75, 0)
    StatusLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    StatusLabel.TextColor3 = Color3.new(1, 1, 0)
    StatusLabel.Text = "Explore os RemoteEvents e manipule argumentos."
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
    RemoteNameTextBox.PlaceholderText = "Nome do RemoteEvent"
    RemoteNameTextBox.Parent = MainFrame

    -- Frame para os argumentos
    local ArgumentsFrame = Instance.new("Frame")
    ArgumentsFrame.Size = UDim2.new(0.4, 0, 0.3, 0)
    ArgumentsFrame.Position = UDim2.new(0.55, 0, 0.3, 0)
    ArgumentsFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    ArgumentsFrame.Parent = MainFrame

    local AddArgumentButton = Instance.new("TextButton")
    AddArgumentButton.Size = UDim2.new(1, 0, 0, 25)
    AddArgumentButton.Position = UDim2.new(0, 0, 0.9, 0)
    AddArgumentButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    AddArgumentButton.TextColor3 = Color3.new(1, 1, 1)
    AddArgumentButton.Text = "Adicionar Argumento"
    AddArgumentButton.Font = Enum.Font.SourceSansBold
    AddArgumentButton.TextScaled = true
    AddArgumentButton.Parent = ArgumentsFrame

    local RefreshButton = Instance.new("TextButton")
    RefreshButton.Size = UDim2.new(0.4, 0, 0, 30)
    RefreshButton.Position = UDim2.new(0.05, 0, 0.85, 0)
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
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 0, 25)
            button.Position = UDim2.new(0, 0, (i - 1) * 0.04, 0)
            button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            button.TextColor3 = Color3.new(1, 1, 1)
            button.Text = remote.Name
            button.Font = Enum.Font.SourceSans
			button.TextScaled = true
            button.Parent = ScrollingFrame

            button.MouseButton1Click:Connect(function()
                RemoteNameTextBox.Text = remote.Name -- Preenche o nome ao clicar
            end)
			createUICorner(button, 4) -- Arredondar os botões da lista
        end
		ScrollingFrame.CanvasSize = UDim2.new(0,0,0,(#remotes * 25))
    end

    -- Variável para armazenar os argumentos
    local arguments = {}

    -- Função para adicionar um novo campo de argumento
    local function addArgumentField()
        local index = #arguments + 1
        local argumentTextBox = Instance.new("TextBox")
        argumentTextBox.Size = UDim2.new(0.9, 0, 0, 25)
        argumentTextBox.Position = UDim2.new(0.05, 0, (index - 1) * 0.1, 0)
        argumentTextBox.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
        argumentTextBox.TextColor3 = Color3.new(1, 1, 1)
        argumentTextBox.Font = Enum.Font.SourceSans
        argumentTextBox.PlaceholderText = "Argumento " .. index
        argumentTextBox.Parent = ArgumentsFrame

        table.insert(arguments, argumentTextBox)

        -- Atualizar o tamanho do ArgumentsFrame
        ArgumentsFrame.Size = UDim2.new(0.4, 0, index * 0.1 + 0.1, 0)
    end

    -- Função para tentar interagir com o RemoteEvent
    local function tentarInteragir(remoteName, args)
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
            findAllRemotes(game)
            remote = foundRemote
        end

        if remote then
            pcall(function()
                -- Converter os argumentos para os tipos corretos
                local convertedArgs = {}
                for i, argTextBox in ipairs(args) do
                    local arg = argTextBox.Text
                    if tonumber(arg) then
                        convertedArgs[i] = tonumber(arg)
                    elseif arg == "true" then
                        convertedArgs[i] = true
                    elseif arg == "false" then
                        convertedArgs[i] = false
                    else
                        convertedArgs[i] = arg
                    end
                end

                -- Chamar o RemoteEvent com múltiplos argumentos
                remote:FireServer(unpack(convertedArgs))

                StatusLabel.Text = "Interagindo com " .. remoteName .. " com " .. #convertedArgs .. " argumentos."
                wait(2)
                StatusLabel.Text = "Explore os RemoteEvents e manipule argumentos."
            end)
        else
            StatusLabel.Text = "RemoteEvent '" .. remoteName .. "' não encontrado."
        end
    end

    -- Conectar o botão "Tentar"
    TryButton.MouseButton1Click:Connect(function()
        local remoteName = RemoteNameTextBox.Text
        tentarInteragir(remoteName, arguments)
    end)

    -- Conectar o botão "Adicionar Argumento"
    AddArgumentButton.MouseButton1Click:Connect(addArgumentField)

    -- Conectar o botão "Atualizar Lista"
    RefreshButton.MouseButton1Click:Connect(listarRemotes)

    -- Chamar a função para listar os RemoteEvents
    listarRemotes()
end)

if not success then
    warn("Erro ao criar a interface: " .. errorMessage)
end
