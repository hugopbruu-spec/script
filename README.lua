-- ==============================
-- AUTO FARM MENU UI
-- Plants vs Brainrots (Studio)
-- ==============================

-- Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- ==============================
-- GUI BASE
-- ==============================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFarmUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 260)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Parent = ScreenGui
MainFrame.Visible = false

-- Cantos arredondados
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 16)
Corner.Parent = MainFrame

-- ==============================
-- TÍTULO
-- ==============================

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "AUTO FARM – PLANTS VS BRAINROTS"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

-- ==============================
-- BOTÃO FARM
-- ==============================

local FarmButton = Instance.new("TextButton")
FarmButton.Size = UDim2.new(0, 260, 0, 55)
FarmButton.Position = UDim2.new(0.5, -130, 0, 90)
FarmButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
FarmButton.Text = "AUTO FARM: OFF"
FarmButton.TextColor3 = Color3.fromRGB(255, 80, 80)
FarmButton.Font = Enum.Font.GothamBold
FarmButton.TextSize = 16
FarmButton.Parent = MainFrame

local FarmCorner = Instance.new("UICorner")
FarmCorner.CornerRadius = UDim.new(0, 12)
FarmCorner.Parent = FarmButton

-- ==============================
-- INFO
-- ==============================

local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, -20, 0, 50)
Info.Position = UDim2.new(0, 10, 1, -60)
Info.BackgroundTransparency = 1
Info.Text = "F7 - Abrir / Fechar Menu"
Info.TextColor3 = Color3.fromRGB(200, 200, 200)
Info.Font = Enum.Font.Gotham
Info.TextSize = 14
Info.Parent = MainFrame

-- ==============================
-- ANIMAÇÃO DE ABERTURA
-- ==============================

local function openMenu()
	MainFrame.Visible = true
	MainFrame.Size = UDim2.new(0, 0, 0, 0)

	local tween = TweenService:Create(
		MainFrame,
		TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{Size = UDim2.new(0, 420, 0, 260)}
	)
	tween:Play()
end

local function closeMenu()
	local tween = TweenService:Create(
		MainFrame,
		TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
		{Size = UDim2.new(0, 0, 0, 0)}
	)
	tween:Play()
	tween.Completed:Wait()
	MainFrame.Visible = false
end

-- ==============================
-- MENU TOGGLE
-- ==============================

local menuOpen = false

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.F7 then
		menuOpen = not menuOpen
		if menuOpen then
			openMenu()
		else
			closeMenu()
		end
	end
end)

-- ==============================
-- MENU ARRASTÁVEL
-- ==============================

local dragging = false
local dragStart
local startPos

MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
	end
end)

MainFrame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- ==============================
-- AUTO FARM LÓGICA (BASE)
-- ==============================

local farming = false
local humanoid
local root

local function setupChar()
	local char = player.Character or player.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")
	root = char:WaitForChild("HumanoidRootPart")
end

setupChar()
player.CharacterAdded:Connect(setupChar)

local FARM_POSITION = Vector3.new(0, 5, 0) -- ajuste no Studio

FarmButton.MouseButton1Click:Connect(function()
	farming = not farming
	if farming then
		FarmButton.Text = "AUTO FARM: ON"
		FarmButton.TextColor3 = Color3.fromRGB(80, 255, 120)
	else
		FarmButton.Text = "AUTO FARM: OFF"
		FarmButton.TextColor3 = Color3.fromRGB(255, 80, 80)
	end
end)

task.spawn(function()
	while true do
		if farming and humanoid and root then
			pcall(function()
				humanoid:MoveTo(FARM_POSITION)
				humanoid.MoveToFinished:Wait()
				humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end)
		end
		task.wait(2)
	end
end)
