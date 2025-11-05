-- Import necessary modules
local game = require('game')
local player = require('player')
local ui = require('ui')

-- Initialize variables
local isAutoParryActive = false
local isAutoSpamActive = false

-- Create UI screen
local screen = ui.newScreen('Phantom Ball Script')

-- Create UI buttons
local autoParryButton = ui.newButton(screen, 'Auto Parry', function() toggleAutoParry() end)
local autoSpamButton = ui.newButton(screen, 'Auto Spam', function() toggleAutoSpam() end)

-- Function to toggle Auto Parry
function toggleAutoParry()
    isAutoParryActive = not isAutoParryActive
    if isAutoParryActive then
        autoParryButton:setText('Auto Parry (On)')
        game:getService('RunService'):BindToRenderStep('AutoParry', 0, handleAutoParry)
    else
        autoParryButton:setText('Auto Parry (Off)')
        game:getService('RunService'):UnbindFromRenderStep('AutoParry')
    end
end

-- Function to handle Auto Parry
function handleAutoParry(deltaTime)
    local ball = game:GetService('Workspace'):FindFirstChild('Ball')
    if ball and ball.Velocity.Magnitude > 50 and ball.Velocity.Magnitude < 100 then
        player:parry()
    end
end

-- Function to toggle Auto Spam
function toggleAutoSpam()
    isAutoSpamActive = not isAutoSpamActive
    if isAutoSpamActive then
        autoSpamButton:setText('Auto Spam (On)')
        game:getService('RunService'):BindToRenderStep('AutoSpam', 0, handleAutoSpam)
    else
        autoSpamButton:setText('Auto Spam (Off)')
        game:getService('RunService'):UnbindFromRenderStep('AutoSpam')
    end
end

-- Function to handle Auto Spam
function handleAutoSpam(deltaTime)
    local ball = game:GetService('Workspace'):FindFirstChild('Ball')
    if ball and ball.Velocity.Magnitude > 100 then
        player:parry()
    end
end

-- Show the UI screen
screen:show()
