-- AUTO FARM BASE (ROBLOX STUDIO)
-- Plants vs Brainrots - LÓGICA DE TESTE
-- SEM EXPLOIT

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

local farming = true

-- CONFIGURAÇÕES
local FARM_POSITION = Vector3.new(0, 5, 0) -- altere para o local do farm
local FARM_DELAY = 2

-- Função de movimento
local function moveTo(position)
	humanoid:MoveTo(position)
	humanoid.MoveToFinished:Wait()
end

-- Loop principal
task.spawn(function()
	while farming do
		pcall(function()
			moveTo(FARM_POSITION)

			-- Simula ação (plantar / atacar)
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			task.wait(0.2)

			-- Delay do ciclo
			task.wait(FARM_DELAY)
		end)
	end
end)

-- Tecla para ligar/desligar
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.F6 then
		farming = not farming
		warn("AutoFarm:", farming and "ON" or "OFF")
	end
end)
