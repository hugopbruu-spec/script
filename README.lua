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
    MainFrame.Size = UDim2.new(0, 350, 0, 500)  -- Aumentei a largura
    MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    MainFrame.Parent = ScreenGui

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0, 30)
    TitleLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    TitleLabel.TextColor3 = Color3.new(1, 1, 1)
    TitleLabel.Text = "RemoteEvents de Inventário"
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextScaled = true
    TitleLabel.Parent = MainFrame

    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Size = UDim2.new(0.9, 0, 0.7, 0)  -- Aumentei a altura
    ScrollingFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
    ScrollingFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    ScrollingFrame.Parent = MainFrame

	local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 0, 30)
    StatusLabel.Position = UDim2.new(0, 0, 0.82, 0)
    StatusLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    StatusLabel.TextColor3 = Color3.new(1, 1, 0) -- Amarelo
    StatusLabel.Text = "Equipe um item e clique nos botões."
    StatusLabel.Font = Enum.Font.SourceSans
    StatusLabel.TextScaled = true
    StatusLabel.Parent = MainFrame

    -- Palavras-chave para filtrar RemoteEvents
    local keywords = {"Item", "Inventory", "Add", "Give", "Equip", "Trade", "Coin", "Gem", "Reward"}

    -- Função para listar os RemoteEvents
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

        local relevantRemotes = {}
        for _, remote in ipairs(remotes) do
            local name = string.lower(remote.Name)
            for _, keyword in ipairs(keywords) do
                if string.find(name, string.lower(keyword)) then
                    table.insert(relevantRemotes, remote)
                    break -- Evita adicionar o mesmo RemoteEvent várias vezes
                end
            end
        end

        -- Criar botões para cada RemoteEvent relevante
        for i, remote in ipairs(relevantRemotes) do
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 0, 30)
            button.Position = UDim2.new(0, 0, (i - 1) * 0.05, 0)
            button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            button.TextColor3 = Color3.new(1, 1, 1)
            button.Text = remote.Name
            button.Font = Enum.Font.SourceSans
            button.Parent = ScrollingFrame

            button.MouseButton1Click:Connect(function()
                local character = Player.Character
                if character then
                    local tool = character:FindFirstChildOfClass("Tool")
                    if tool then
                        -- Tentar enviar o item para o RemoteEvent
                        pcall(function()
                            remote:FireServer(tool)
                            StatusLabel.Text = "Enviando item para " .. remote.Name
							wait(2) -- Aguarda um pouco para ver o resultado
							StatusLabel.Text = "Equipe um item e clique nos botões."
                        end)
                    else
                        StatusLabel.Text = "Nenhum item equipado."
                    end
                else
                    StatusLabel.Text = "Personagem não encontrado."
                end
            end)
        end

		if #relevantRemotes == 0 then
			local noRemotesLabel = Instance.new("TextLabel")
            noRemotesLabel.Size = UDim2.new(1, 0, 0, 30)
            noRemotesLabel.Position = UDim2.new(0, 0, 0, 0)
            noRemotesLabel.BackgroundColor3 = Color3.new(0, 0, 0)
            noRemotesLabel.TextColor3 = Color3.new(1, 1, 1)
            noRemotesLabel.Text = "Nenhum RemoteEvent relevante encontrado."
            noRemotesLabel.Font = Enum.Font.SourceSans
            noRemotesLabel.TextScaled = true
            noRemotesLabel.Parent = ScrollingFrame
		end
    end

    -- Chamar a função para listar os Remotes
    listarRemotes()
end)

if not success then
    warn("Erro ao criar a interface: " .. errorMessage)
end
