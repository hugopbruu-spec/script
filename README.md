-- LocalScript em StarterPlayerScripts

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

-- Configurações básicas
local baseRange = 15 -- distância base de detecção
local baseReboundForce = 120 -- força mínima do rebote
local enabled = false

local RunService = game:GetService("RunService")

-- 🧱 Interface
local gui = Instance.new("ScreenGui")
gui.Name = "RebateGui"
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

-- 🌀 Função de rebater (quanto mais rápida a bola, mais forte)
local function rebound(ball)
	if not ball:IsA("BasePart") then return end

	local ballVelocity = ball.AssemblyLinearVelocity.Magnitude
	local direction = (ball.Position - root.Position).Unit

	-- Força proporcional à velocidade (evita valores absurdos)
	local reboundForce = math.clamp(baseReboundForce + ballVelocity * 1.2, 100, 2000)

	ball.AssemblyLinearVelocity = direction * reboundForce
end

-- 🔄 Loop dinâmico (tempo de reação proporcional à velocidade)
task.spawn(function()
	while task.wait(0.02) do -- atualização rápida
		if enabled then
			for _, obj in ipairs(workspace:GetChildren()) do
				if obj:IsA("BasePart") and obj.Name == "PhantomBall" then
					local dist = (obj.Position - root.Position).Magnitude
					if dist < baseRange then
						local speed = obj.AssemblyLinearVelocity.Magnitude
						-- se a bola está rápida, reagir mais "imediatamente"
						local reactionChance = math.clamp(speed / 50, 0.5, 10)
						for i = 1, reactionChance do
							rebound(obj)
						end
					end
				end
			end
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
