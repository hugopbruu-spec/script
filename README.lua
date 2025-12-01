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
    MainFrame.Size = UDim2.new(0, 300, 0, 400)
    MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    MainFrame.Parent = ScreenGui

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0, 30)
    TitleLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    TitleLabel.TextColor3 = Color3.new(1, 1, 1)
    TitleLabel.Text = "Lista de Remotes"
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextScaled = true
    TitleLabel.Parent = MainFrame

    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Size = UDim2.new(0.9, 0, 0.8, 0)
    ScrollingFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
    ScrollingFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    ScrollingFrame.Parent = MainFrame

    -- Função para listar os Remotes
    local function listarRemotes()
        -- Limpar a lista anterior
        for _, child in ipairs(ScrollingFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        -- Encontrar todos os Remotes
        local remotes = {}
        local function findAllRemotes(obj)
            for _, child in ipairs(obj:GetDescendants()) do
                if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                    table.insert(remotes, child)
                end
            end
        end
        findAllRemotes(game)

        -- Criar botões para cada Remote
        for i, remote in ipairs(remotes) do
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 0, 30)
            button.Position = UDim2.new(0, 0, (i - 1) * 0.05, 0)
            button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            button.TextColor3 = Color3.new(1, 1, 1)
            button.Text = remote.Name .. " (" .. remote.ClassName .. ")"
            button.Font = Enum.Font.SourceSans
            button.Parent = ScrollingFrame

			--[[ -- Funcionalidade de copiar para a área de transferência (não funciona no Roblox Studio)
            button.MouseButton1Click:Connect(function()
                -- Copiar o nome do Remote para a área de transferência
                print("Nome do Remote copiado: " .. remote.Name)
            end)
			]]
        end
    end

	-- Botão para atualizar a lista
	local RefreshButton = Instance.new("TextButton")
    RefreshButton.Size = UDim2.new(0.9, 0, 0, 30)
    RefreshButton.Position = UDim2.new(0.05, 0, 0.9, 0)
    RefreshButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    RefreshButton.TextColor3 = Color3.new(1, 1, 1)
    RefreshButton.Text = "Atualizar Lista"
    RefreshButton.Font = Enum.Font.SourceSans
    RefreshButton.Parent = MainFrame

	RefreshButton.MouseButton1Click:Connect(listarRemotes)


    -- Chamar a função para listar os Remotes
    listarRemotes()
end)

if not success then
    warn("Erro ao criar a interface: " .. errorMessage)
end
