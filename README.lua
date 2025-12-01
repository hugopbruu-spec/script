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

    local DuplicateButton = Instance.new("TextButton")
    DuplicateButton.Size = UDim2.new(0.9, 0, 0, 30)
    DuplicateButton.Position = UDim2.new(0.05, 0, 0.15, 0)
    DuplicateButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    DuplicateButton.TextColor3 = Color3.new(1, 1, 1)
    DuplicateButton.Text = "Tentar Duplicar (Q)"
    DuplicateButton.Font = Enum.Font.SourceSans
    DuplicateButton.Parent = MainFrame
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    -- Função para tentar duplicar o item
    local function tentarDuplicar()
        local character = Player.Character
        if character then
            local tool = character:FindFirstChildOfClass("Tool")
            if tool then
                -- 1. Clonar o Item
                local newTool = tool:Clone()
                newTool.Name = tool.Name .. "_Duplicated"
                newTool.Parent = nil -- Remover o pai original

                -- 2. Encontrar TODOS os Remotes (Events E Functions)
                local remotes = {}
                local function findAllRemotes(obj)
                    for _, child in ipairs(obj:GetDescendants()) do
                        if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                            table.insert(remotes, child)
                        end
                    end
                end
                findAllRemotes(game)

                -- 3. Tentar enviar o item duplicado para cada Remote
                if #remotes > 0 then
                    print("Encontrados " .. #remotes .. " Remotes. Tentando enviar o item para cada um...")
                    for i, remote in ipairs(remotes) do
                        pcall(function() -- Usar pcall para evitar erros que interrompam o loop
                            if remote:IsA("RemoteEvent") then
                                remote:FireServer(newTool)
                                print("Enviando item para RemoteEvent: " .. remote.Name)
                            elseif remote:IsA("RemoteFunction") then
                                remote:InvokeServer(newTool)
                                print("Enviando item para RemoteFunction: " .. remote.Name)
                            end
                        end)
                    end
                else
                    print("Nenhum RemoteEvent ou RemoteFunction encontrado no jogo.")
                end
            else
                print("Nenhum item equipado para duplicar.")
            end
        else
            print("Personagem não encontrado.")
        end
    end

    --// Bind para Duplicar Item //--

    game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
        if input.KeyCode == Enum.KeyCode.Q then
            tentarDuplicar()
        end
    end)

    DuplicateButton.MouseButton1Click:Connect(tentarDuplicar)
end)

if not success then
    warn("Erro ao criar a interface: " .. errorMessage)
end
