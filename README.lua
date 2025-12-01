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
    MainFrame.Size = UDim2.new(0, 300, 0, 500)  -- Aumentei a altura
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
    ScrollingFrame.Size = UDim2.new(0.9, 0, 0.4, 0)  -- Reduzi a altura
    ScrollingFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
    ScrollingFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    ScrollingFrame.Parent = MainFrame

    local RemoteListTextBox = Instance.new("TextBox")
    RemoteListTextBox.Size = UDim2.new(0.9, 0, 0.2, 0) -- Altura para caber o texto
    RemoteListTextBox.Position = UDim2.new(0.05, 0, 0.52, 0) -- Posicionado abaixo da lista
    RemoteListTextBox.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    RemoteListTextBox.TextColor3 = Color3.new(1, 1, 1)
    RemoteListTextBox.Font = Enum.Font.SourceSans
    RemoteListTextBox.Text = ""  -- Começa vazio
    RemoteListTextBox.ReadOnly = true -- Impede edição
    RemoteListTextBox.MultiLine = true -- Permite múltiplas linhas
    RemoteListTextBox.Parent = MainFrame

	local CopyReadyTextBox = Instance.new("TextBox")
    CopyReadyTextBox.Size = UDim2.new(0.9, 0, 0.2, 0) -- Altura para caber o texto
    CopyReadyTextBox.Position = UDim2.new(0.05, 0, 0.75, 0) -- Posicionado abaixo da lista
    CopyReadyTextBox.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    CopyReadyTextBox.TextColor3 = Color3.new(1, 1, 1)
    CopyReadyTextBox.Font = Enum.Font.SourceSans
    CopyReadyTextBox.Text = ""  -- Começa vazio
    CopyReadyTextBox.ReadOnly = true -- Impede edição
    CopyReadyTextBox.MultiLine = true -- Permite múltiplas linhas
    CopyReadyTextBox.Parent = MainFrame


    -- Função para listar os Remotes e preencher os textboxes
    local function listarRemotes()
        -- Limpar a lista anterior
        for _, child in ipairs(ScrollingFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        --Limpar os textboxes
        RemoteListTextBox.Text = ""
		CopyReadyTextBox.Text = ""

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

        local allRemoteNames = "" -- Acumular os nomes
		local copyReadyText = "" --Texto formatado para copiar

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

            allRemoteNames = allRemoteNames .. remote.Name .. " (" .. remote.ClassName .. ")\n"
			copyReadyText = copyReadyText .. remote.Name .. "\n" --Apenas o nome para facilitar
        end

        RemoteListTextBox.Text = allRemoteNames -- Preencher o textbox
		CopyReadyTextBox.Text = copyReadyText --Preencher o textbox para copiar

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
