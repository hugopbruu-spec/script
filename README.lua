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
    DuplicateButton.Text = "Duplicar Item (Q)"
    DuplicateButton.Font = Enum.Font.SourceSans
    DuplicateButton.Parent = MainFrame
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    -- Função para duplicar o item
    local function duplicateItem()
        local character = Player.Character
        if character then
            local tool = character:FindFirstChildOfClass("Tool")
            if tool then
                -- 1. Clonagem Local
                local newTool = tool:Clone()
                newTool.Name = tool.Name .. "_Duplicated"

                -- 2. Replicação de Atributos
                --[[ ADAPTAR: Substitua "ItemID" pelo nome correto do atributo
                e gere um ID válido para o jogo.
                ]]
                newTool:SetAttribute("ItemID", tostring(math.random(1000, 9999)))

                --[[ 3. Exploração de Remote (Se Aplicável)
                ADAPTAR: Se você encontrar um Remote mal protegido,
                use-o para "legitimar" o item duplicado.
                ]]
                --[[
                local remote = game:GetService("ReplicatedStorage"):FindFirstChild("AdicionarItemAoInventario")
                if remote and remote:IsA("RemoteEvent") then
                    remote:FireServer(newTool)
                end
                ]]

                newTool.Parent = character

                print("Item duplicado!")
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
            duplicateItem()
        end
    end)

    DuplicateButton.MouseButton1Click:Connect(duplicateItem)
end)

if not success then
    warn("Erro ao criar a interface: " .. errorMessage)
end
