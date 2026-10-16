lua
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Steal an Egg | Auto Farm",
   LoadingTitle = "Delta Script Hub",
   LoadingSubtitle = "by Expert AI",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "EggFarmConfig",
      FileName = "StealAnEgg"
   }
})

-- Variables
_G.AutoFarm = false
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

-- Function to get the nearest egg
local function getNearestEgg()
    local target = nil
    local dist = math.huge
    
    -- Common locations for eggs in this game
    local eggFolder = workspace:FindFirstChild("Eggs") or workspace:FindFirstChild("DroppedEggs") or workspace
    
    for _, v in pairs(eggFolder:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:find("Egg") or v.Parent.Name:find("Egg")) then
            local d = (Player.Character.HumanoidRootPart.Position - v.Position).Magnitude
            if d < dist then
                dist = d
                target = v
            end
        end
    end
    return target
end

-- Function to find your team's nest/base
local function getBase()
    -- Attempts to find base based on Team color or Name
    local teamName = Player.Team and Player.Team.Name or "None"
    local base = workspace:FindFirstChild(teamName .. "Base") or workspace:FindFirstChild("Nests"):FindFirstChild(teamName)
    
    -- Fallback: If specific base not found, looks for generic delivery point
    if not base then
        base = workspace:FindFirstChild("DeliveryPart") or workspace:FindFirstChild("Deposit")
    end
    return base
end

-- Main Farm Logic
spawn(function()
    while true do
        task.wait(0.1)
        if _G.AutoFarm then
            pcall(function()
                local egg = getNearestEgg()
                local base = getBase()
                local root = Player.Character:WaitForChild("HumanoidRootPart")

                if egg and egg.Parent then
                    -- Teleport to Egg
                    root.CFrame = egg.CFrame * CFrame.new(0, 2, 0)
                    task.wait(0.3)
                    
                    -- Trigger interaction if game uses ProximityPrompts
                    local prompt = egg:FindFirstChildOfClass("ProximityPrompt") or egg.Parent:FindFirstChildOfClass("ProximityPrompt")
                    if prompt then
                        fireproximityprompt(prompt)
                    end
                    
                    task.wait(0.2)
                    
                    -- Teleport to Base to deliver
                    if base then
                        root.CFrame = base.CFrame * CFrame.new(0, 5, 0)
                        task.wait(0.5)
                    end
                end
            end)
        end
    end
end)

-- UI Tabs
local MainTab = Window:CreateTab("Main", 4483362458) -- Tab icon

local Toggle = MainTab:CreateToggle({
   Name = "Enable Auto Farm",
   CurrentValue = false,
   Flag = "AutoFarmToggle",
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then
          Rayfield:Notify({
             Title = "Auto Farm Active",
             Content = "The bot is now collecting eggs.",
             Duration = 3,
             Image = 4483362458,
          })
      end
   end,
})

MainTab:CreateButton({
   Name = "Anti-AFK",
   Callback = function()
       local vu = game:GetService("VirtualUser")
       game:GetService("Players").LocalPlayer.Idled:connect(function()
           vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
           wait(1)
           vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
       end)
       Rayfield:Notify({Title = "Success", Content = "Anti-AFK Enabled", Duration = 2})
   end,
})

Rayfield:LoadConfiguration()
