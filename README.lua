-- Import necessary modules
local game = require('game')
local player = require('player')
local ui = require('ui')

-- Initialize variables
local isAutoParryActive = false
local isAutoSpamActive = false

-- Create UI buttons
local autoParryButton = ui.createButton('Auto Parry', function() toggleAutoParry() end)
local autoSpamButton = ui.createButton('Auto Spam', function() toggleAutoSpam() end)

-- Function to toggle Auto Parry
function toggleAutoParry()
    isAutoParryActive = not isAutoParryActive
    if isAutoParryActive then
        autoParryButton:setText('Auto Parry (On)')
        game.on('ballUpdate', handleAutoParry)
    else
        autoParryButton:setText('Auto Parry (Off)')
        game.off('ballUpdate', handleAutoParry)
    end
end

-- Function to handle Auto Parry
function handleAutoParry(ball)
    if ball.speed == 'medium' then
        player.parry()
    end
end

-- Function to toggle Auto Spam
function toggleAutoSpam()
    isAutoSpamActive = not isAutoSpamActive
    if isAutoSpamActive then
        autoSpamButton:setText('Auto Spam (On)')
        game.on('ballUpdate', handleAutoSpam)
    else
        autoSpamButton:setText('Auto Spam (Off)')
        game.off('ballUpdate', handleAutoSpam)
    end
end

-- Function to handle Auto Spam
function handleAutoSpam(ball)
    if ball.speed == 'high' then
        local interval = 100 -- Adjust the interval as needed
        local function spamParry()
            player.parry()
        end
        game:setTimeout(spamParry, interval)
        game:setTimeout(function() game.clearTimeout(spamParry) end, 5000) -- Stop spamming after 5 seconds
    end
end

-- Add buttons to the UI
ui.addButton(autoParryButton)
ui.addButton(autoSpamButton)
