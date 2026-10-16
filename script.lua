--[[
    ENGINEERED BY CODESTER
    TARGET: STEAL AN EGG
    PLATFORM: DELTA EXECUTOR (MOBILE/PC)
    FEATURES: AUTO-DETECTION, INSTANT-COLLECT, ANTI-KICK
]]

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Codester Elite | Steal an Egg", HidePremium = false, SaveConfig = false})

-- Configuration States
getgenv().AutoFarm = false
getgenv().FarmSpeed = 0.5
getgenv().TPDistance = 3 -- Height above the egg

-- Technical Logic: Targeted Acquisition
local function findTargetEgg()
    local nearest = nil
    local lastDist = math.huge
    
    for _, obj in ipairs(game.Workspace:GetDescendants()) do
        -- Search for ProximityPrompts within objects containing "Egg"
        if obj:IsA("ProximityPrompt") then
            local parentName = obj.Parent.Name:lower()
            local promptText = obj.ObjectText:lower()
            
            if parentName:find("egg") or promptText:find("egg") then
                -- Only target if it's not currently "stolen" (invisible)
                if obj.Parent:IsA("BasePart") and obj.Parent.Transparency < 1 and obj.Enabled then
                    local dist = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - obj.Parent.Position).Magnitude
                    if dist < lastDist then
                        nearest = obj
                        lastDist = dist
                    end
                end
            end
        end
    end
    return nearest
end

-- Main Automation Tab
local FarmTab = Window:MakeTab({
	Name = "Auto-Farm",
	Icon = "rbxassetid://4483362458",
	PremiumOnly = false
})

FarmTab:AddToggle({
	Name = "Enable Auto-Steal",
	Default = false,
	Callback = function(Value)
		getgenv().AutoFarm = Value
        if Value then
            task.spawn(function()
                while getgenv().AutoFarm do
                    local eggPrompt = findTargetEgg()
                    local char = game.Players.LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    
                    if eggPrompt and root then
                        -- Precision Teleportation
                        root.CFrame = eggPrompt.Parent.CFrame * CFrame.new(0, getgenv().TPDistance, 0)
                        task.wait(0.1)
                        
                        -- Delta-Specific Interaction Bypass
                        if fireproximityprompt then
                            fireproximityprompt(eggPrompt)
                        else
                            eggPrompt:InputHoldBegin()
                            task.wait(eggPrompt.HoldDuration)
                            eggPrompt:InputHoldEnd()
                        end
                        task.wait(getgenv().FarmSpeed)
                    else
                        -- Idle wait for respawns
                        task.wait(1)
                    end
                end
            end)
        end
	end    
})

FarmTab:AddSlider({
	Name = "Farm Delay",
	Min = 0.1,
	Max = 3,
	Default = 0.5,
	Color = Color3.fromRGB(255,165,0),
	Increment = 0.1,
	ValueName = "sec",
	Callback = function(Value)
		getgenv().FarmSpeed = Value
	end    
})

-- Movement Tab
local MiscTab = Window:MakeTab({
	Name = "Movement",
	Icon = "rbxassetid://4483362458",
	PremiumOnly = false
})

MiscTab:AddSlider({
	Name = "WalkSpeed",
	Min = 16,
	Max = 200,
	Default = 16,
	Increment = 1,
	Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end
})

MiscTab:AddButton({
	Name = "Anti-AFK",
	Callback = function()
        local vu = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
        OrionLib:MakeNotification({Name = "System", Content = "Anti-AFK Enabled", Time = 3})
	end
})

OrionLib:Init()
