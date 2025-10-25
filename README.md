-- LocalScript em StarterPlayerScripts
-- Ambiente legítimo de teste / jogo próprio

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

local range = 20               -- raio de detecção maior
local baseReboundForce = 100   -- força base
local enabled = false
local RunService = game:GetService("RunService")

-- 🧱 Interface
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 150, 0, 40)
button.Position = UDim2.new(0.05, 0, 0.1, 0)
button.Text = "Ativar Rebater"
button.BackgroundColor3 = Color3.fromRGB(60, 200, 100)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.GothamBold
button.TextSize = 16
button.Parent = gui

-- 🌀 Função de rebater
local function rebound(ball)
	if not ball:IsA("BasePart") then return end
	local velocity = ball.AssemblyLinearVelocity.Magnitude
	local direction = (ball.Position - root.Position).Unit
	local reboundForce = baseReboundForce + (velocity * 0.5) -- quanto mais rápida a bola, maior a força
	ball.AssemblyLinearVelocity = direction * reboundForce
end

-- 🔄 Loop contínuo e reativo
RunService.Heartbeat:Connect(function()
	if not enabled then return end

	-- Pega todas as partes no raio de alcance
	local partsInRange = workspace:GetPartBoundsInRadius(root.Position, range)
	for _, part in ipairs(partsInRange) do
		if part:IsA("BasePart") and part.Name == "PhantomBall" then
			rebound(part)
		end
	end
end)

-- 🖱️ Botão para ativar/desativar
button.MouseButton1Click:Connect(function()
	enabled = not enabled
	if enabled then
		button.Text = "Desativar Rebater"
		button.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
	else
		button.Text = "Ativar Rebater"
		button.BackgroundColor3 = Color3.fromRGB(60, 200, 100)
	end
end)
