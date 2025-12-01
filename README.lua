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
    TitleLabel.Text = "Varredura de Duplicação (ALTAMENTE EXPERIMENTAL)"
    TitleLabel.Font = Enum.Font.Oswald
    TitleLabel.TextScaled = true
    TitleLabel.Parent = MainFrame

	local TryButton = Instance.new("TextButton")
    TryButton.Size = UDim2.new(0.4, 0, 0, 30)
    TryButton.Position = UDim2.new(0.05, 0, 0.1, 0)
    TryButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    TryButton.TextColor3 = Color3.new(1, 1, 1)
    TryButton.Text = "Iniciar Varredura"
    TryButton.Font = Enum.Font.SourceSansBold
	TryButton.TextScaled = true
    TryButton.Parent = MainFrame

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
    StatusLabel.Position = UDim2.new(0.05, 0, 0.85, 0)
    StatusLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    StatusLabel.TextColor3 = Color3.new(1, 1, 0)
    StatusLabel.Text = "Pronto para iniciar a varredura (EXTREMO CUIDADO!)."
    StatusLabel.Font = Enum.Font.SourceSans
    StatusLabel.TextScaled = true
    StatusLabel.Parent = MainFrame

    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Size = UDim2.new(0.45, 0, 0.5, 0)
    ScrollingFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
    ScrollingFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    ScrollingFrame.Parent = MainFrame

    local SeedNameTextBox = Instance.new("TextBox")
    SeedNameTextBox.Size = UDim2.new(0.4, 0, 0, 30)
    SeedNameTextBox.Position = UDim2.new(0.55, 0, 0.15, 0)
    SeedNameTextBox.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    SeedNameTextBox.TextColor3 = Color3.new(1, 1, 1)
    SeedNameTextBox.Font = Enum.Font.SourceSans
    SeedNameTextBox.PlaceholderText = "Nome da Semente a Testar"
    SeedNameTextBox.Parent = MainFrame

    local RefreshButton = Instance.new("TextButton")
    RefreshButton.Size = UDim2.new(0.4, 0, 0, 30)
    RefreshButton.Position = UDim2.new(0.05, 0, 0.75, 0)
    RefreshButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    RefreshButton.TextColor3 = Color3.new(1, 1, 1)
    RefreshButton.Text = "Atualizar Lista"
    RefreshButton.Font = Enum.Font.SourceSansBold
    RefreshButton.TextScaled = true
    RefreshButton.Parent = MainFrame

    -- Função para gerar um nome aleatório
	local function generateRandomName()
		local length = math.random(5, 10)
		local chars = "abcdefghijklmnopqrstuvwxyz"
		local result = ""
		for i = 1, length do
			result = result .. string.sub(chars, math.random(1, string.len(chars)), math.random(1, string.len(chars)))
		end
		return result
	end

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
					--RemoteNameTextBox.Text = remote.Name
				end)
			end
        end
		ScrollingFrame.CanvasSize = UDim2.new(0,0,0,(#remotes * 25))
    end

    -- Função para testar RemoteEvents
    local function testRemoteEvent(remote, seedName)
        local randomName = generateRandomName()
        local itemID = "seed_test" -- Substitua pelo ID real da semente
        local price = 10
        local quantity = 1

		-- Defina os argumentos a serem testados. Adapte para a lógica do jogo.
        local arguments = {
            -- Argumentos comuns com nome aleatório
            "{player = '" .. randomName .. "', item = '" .. seedName .. "', quantity = " .. quantity .. "}",
            "{player = '" .. randomName .. "', itemID = '" .. itemID .. "', price = " .. price .. "}",
            "{item = '" .. seedName .. "', quantity = " .. quantity .. ", target = '" .. randomName .. "'}",
            "{from = '" .. randomName .. "', to = '" .. randomName .. "', item = '" .. seedName .. "'}",

            -- Argumentos com valores negativos (possível exploração)
            "{player = '" .. randomName .. "', item = '" .. seedName .. "', quantity = " .. -quantity .. "}",
            "{player = '" .. randomName .. "', itemID = '" .. itemID .. "', price = " .. -price .. "}",

			-- Argumentos usando o nome REAL do jogador (necessário em alguns casos)
			"{player = '" .. Player.Name .. "', item = '" .. seedName .. "', quantity = " .. quantity .. "}",
			"{player = '" .. Player.Name .. "', itemID = '" .. itemID .. "', price = " .. price .. "}",
        }

        for _, arg in ipairs(arguments) do
            pcall(function()
                StatusLabel.Text = "Testando " .. remote.Name .. " com argumento: " .. arg
                remote:FireServer(arg)
                wait(2)
            end)
        end
    end

	--[[
	-- Função para testar funções (Exemplo: Se souber de funções relevantes)
	local function testFunction(func, seedName)
		local randomName = generateRandomName()
		local itemID = "seed_test" -- Substitua pelo ID real da semente
		local quantity = 1

		local arguments = {
			randomName,
			seedName,
			itemID,
			quantity,
			-quantity
		}

		for _, arg in ipairs(arguments) do
			pcall(function()
				StatusLabel.Text = "Testando " .. tostring(func) .. " com argumento: " .. tostring(arg)
				func(arg)
				wait(2)
			end)
		end
	end
	]]

    -- Conectar o botão "Iniciar Varredura"
    TryButton.MouseButton1Click:Connect(function()
        local seedName = SeedNameTextBox.Text

        -- 1. Testar RemoteEvents
        StatusLabel.Text = "Iniciando varredura de RemoteEvents..."
        local keywords = {"compra", "loja", "shop", "seed", "semente", "buy", "trade", "troca", "recompensa", "reward", "inventario", "inventory"}
        for _, descendent in ipairs(game:GetDescendants()) do
            if descendent:IsA("RemoteEvent") then
                local name = descendent.Name:lower()
                for _, keyword in ipairs(keywords) do
                    if string.find(name, keyword) then
                        StatusLabel.Text = "Encontrado RemoteEvent relevante: " .. descendent.Name
                        testRemoteEvent(descendent, seedName)
                        wait(5)
                        break
                    end
                end
            end
        end

		-- 2. Testar funções (Exemplo: Se souber de funções relevantes - DESABILITADO POR SEGURANÇA)
		--StatusLabel.Text = "Iniciando varredura de funções..."
		--testFunction(game.ServerScriptService.Inventory.AddItem, seedName)

        StatusLabel.Text = "Varredura completa."
    end)

    -- Conectar o botão "Atualizar Lista"
    RefreshButton.MouseButton1Click:Connect(listarRemotes)

    -- Chamar a função para listar os RemoteEvents
    listarRemotes()
end)

if not success then
    warn("Erro ao criar a interface: " .. errorMessage)
end
