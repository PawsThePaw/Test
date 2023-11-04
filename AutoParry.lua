if getgenv().executed then return end
--// CREDITS TO davidfish111

--//Hello! This Script Isn't Mine I just wanted to improve it in someway since return true & false is buggy and target parrys invisible and freeze but double parries so i switched it with highlight which dosent parry invis and freeze, thats either an upgrade for you or a degrade.

--//For davidfish111: You could dm me [User is pawsthepaw] in discord for it to be taken down if you wish too.
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Balls = game:GetService("Workspace").Balls

local IsTargeted = false
local CanHit = false

function FindBall()
    local RealBall
    for i, v in pairs(Balls:GetChildren()) do
        if v:GetAttribute("realBall") == true then
            RealBall = v
        end
    end
    return RealBall
end
  
function IsTarget()
    return (Player.Character and Player.Character:FindFirstChild("Highlight"))
end

function DetectBall()
    local Ball = FindBall()
    
  	if Ball then
        local BallVelocity = Ball.Velocity.Magnitude
        local BallPosition = Ball.Position
  
        local PlayerPosition = LocalPlayer.Character.HumanoidRootPart.Position
  
        local Distance = (BallPosition - PlayerPosition).Magnitude
        local PingAccountability = BallVelocity * (game.Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000)
  
        Distance -= PingAccountability
        Distance -= shared.config.adjustment
  
        local Hit = Distance / BallVelocity
  
        return Hit <= shared.config.hit_range
        end
end

function DeflectBall()
    if IsTargeted and DetectBall() then
        if shared.config.deflect_type == 'Key Press' then
            keypress(0x46)
        else
            ReplicatedStorage.Remotes.ParryButtonPress:Fire()
        end
    end
end

UserInputService.InputBegan:Connect(function(Input, IsTyping)
    if IsTyping then return end
    if shared.config.mode == 'Toggle' and Input.KeyCode == shared.config.keybind then
      CanHit = not CanHit
        if shared.config.notifications then
            game:GetService("StarterGui"):SetCore("SendNotification",{
                Title = "Blade Ball",
                Text = CanHit and 'Enabled!' or 'Disabled!',
            })
        end
    elseif shared.config.mode == 'Hold' and Input.KeyCode == shared.config.keybind and shared.config.notifications then
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "Blade Ball",
            Text = 'Holding keybind!',
        })
    end
end)

UserInputService.InputEnded:Connect(function(Input, IsTyping)
    if IsTyping then return end
    if shared.config.mode == 'Hold' and Input.KeyCode == shared.config.keybind and shared.config.notifications then
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "Blade Ball",
            Text = 'No longer holding keybind!',
        })
    end
end)

game:GetService('RunService').PostSimulation:Connect(function()
    IsTargeted = IsTarget()
    if shared.config.mode == 'Hold' and UserInputService:IsKeyDown(shared.config.keybind) then
        DeflectBall()
    elseif shared.config.mode == 'Toggle' and CanHit then
        DeflectBall()
    elseif shared.config.mode == 'Always' then
        DeflectBall()
    end
end)

getgenv().executed = true
