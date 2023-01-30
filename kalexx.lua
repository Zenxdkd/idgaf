getgenv().Kalexx = {
    SilentAim = {
        Key = "P",
        Enabled = true,
        Prediction = 0.11,
        AimingType = "Closest Part", -- Closest Part, Default
        AimPart = "HumanoidRootPart",
        
        ChanceData = {UseChance = false, Chance = 100},
        FOVData = {Radius = 80, Visibility = true, Filled = false},

        AimingData = {CheckKnocked = true, CheckGrabbed = true,
        CheckWalls = true},

    },
    Tracing = {
        Key = 'C',
        Enabled = true,
        Prediction = 5.2,
        AimPart = "HumanoidRootPart",
        TracingOptions = {Strength = "Hard", AimingType = "Closest Part",  Smoothness = 0.11} 
                            -- Hard, Soft
    }
}

local Kalexx = {functions = {}}

local Vector2New, Cam, Mouse, client, find, Draw, Inset, players, RunService, UIS=
    Vector2.new,
    workspace.CurrentCamera,
    game.Players.LocalPlayer:GetMouse(),
    game.Players.LocalPlayer,
    table.find,
    Drawing.new,
    game:GetService("GuiService"):GetGuiInset().Y,
    game.Players, 
    game.RunService,
    game:GetService("UserInputService")


local mf, rnew = math.floor, Random.new

local Targetting
local lockedCamTo

local Circle = Draw("Circle")
Circle.Thickness = 1
Circle.Transparency = 0.7
Circle.Color = Color3.new(1,1,1)

Kalexx.functions.update_FOVs = function ()
    if not (Circle) then
        return Circle
    end
    Circle.Radius =  getgenv().Kalexx.SilentAim.FOVData.Radius * 3
    Circle.Visible = getgenv().Kalexx.SilentAim.FOVData.Visibility
    Circle.Filled = getgenv().Kalexx.SilentAim.FOVData.Filled
    Circle.Position = Vector2New(Mouse.X, Mouse.Y + (Inset))
    return Circle
end

Kalexx.functions.onKeyPress = function(inputObject)
    if inputObject.KeyCode == Enum.KeyCode[getgenv().Kalexx.SilentAim.Key:upper()] then
        getgenv().Kalexx.SilentAim.Enabled = not getgenv().Kalexx.SilentAim.Enabled
    end

    if inputObject.KeyCode == Enum.KeyCode[getgenv().Kalexx.Tracing.Key:upper()] then
        getgenv().Kalexx.Tracing.Enabled = not getgenv().Kalexx.Tracing.Enabled
        if getgenv().Kalexx.Tracing.Enabled then
            lockedCamTo = Kalexx.functions.returnClosestPlayer(getgenv().Kalexx.SilentAim.ChanceData.Chance)
        end
    end
end

UIS.InputBegan:Connect(Kalexx.functions.onKeyPress)


Kalexx.functions.wallCheck = function(direction, ignoreList)
    if not getgenv().Kalexx.SilentAim.AimingData.CheckWalls then
        return true
    end

    local ray = Ray.new(Cam.CFrame.p, direction - Cam.CFrame.p)
    local part, _, _ = game:GetService("Workspace"):FindPartOnRayWithIgnoreList(ray, ignoreList)

    return not part
end

Kalexx.functions.pointDistance = function(part)
    local OnScreen = Cam.WorldToScreenPoint(Cam, part.Position)
    if OnScreen then
        return (Vector2New(OnScreen.X, OnScreen.Y) - Vector2New(Mouse.X, Mouse.Y)).Magnitude
    end
end

Kalexx.functions.returnClosestPart = function(Character)
    local data = {
        dist = math.huge,
        part = nil,
        filteredparts = {},
        classes = {"Part", "BasePart", "MeshPart"}
    }

    if not (Character and Character:IsA("Model")) then
        return data.part
    end
    local children = Character:GetChildren()
    for _, child in pairs(children) do
        if table.find(data.classes, child.ClassName) then
            table.insert(data.filteredparts, child)
            for _, part in pairs(data.filteredparts) do
                local dist = Kalexx.functions.pointDistance(part)
                if Circle.Radius > dist and dist < data.dist then
                    data.part = part
                    data.dist = dist
                end
            end
        end
    end
    return data.part
end

Kalexx.functions.returnClosestPlayer = function (amount)
    local data = {
        dist = 1/0,
        player = nil
    }

    amount = amount or nil

    for _, player in pairs(players:GetPlayers()) do
        if (player.Character and player ~= client) then
            local dist = Kalexx.functions.pointDistance(player.Character.HumanoidRootPart)
            if Circle.Radius > dist and dist < data.dist and 
            Kalexx.functions.wallCheck(player.Character.Head.Position,{client, player.Character}) then
                data.dist = dist
                data.player = player
            end
        end
    end
    local calc = mf(rnew().NextNumber(rnew(), 0, 1) * 100) / 100
    local use = getgenv().Kalexx.SilentAim.ChanceData.UseChance
    if use and calc <= mf(amount) / 100 then
        return calc and data.player
    else
        return data.player
    end
end

Kalexx.functions.setAimingType = function (player, type)
    local previousSilentAimPart = getgenv().Kalexx.SilentAim.AimPart
    local previousTracingPart = getgenv().Kalexx.Tracing.AimPart
    if type == "Closest Part" then
        getgenv().Kalexx.SilentAim.AimPart = tostring(Kalexx.functions.returnClosestPart(player.Character))
        getgenv().Kalexx.Tracing.AimPart = tostring(Kalexx.functions.returnClosestPart(player.Character))
    elseif type == "Closest Point" then
        Kalexx.functions.returnClosestPoint()
    elseif type == "Default" then
        getgenv().Kalexx.SilentAim.AimPart = previousSilentAimPart
        getgenv().Kalexx.Tracing.AimPart = previousTracingPart
    else
        getgenv().Kalexx.SilentAim.AimPart = previousSilentAimPart
        getgenv().Kalexx.Tracing.AimPart = previousTracingPart
    end
end

Kalexx.functions.aimingCheck = function (player)
    if getgenv().Kalexx.SilentAim.AimingData.CheckKnocked == true and player and player.Character then
        if player.Character.BodyEffects["K.O"].Value then
            return true
        end
    end
    if getgenv().Kalexx.SilentAim.AimingData.CheckGrabbed == true and player and player.Character then
        if player.Character:FindFirstChild("GRABBING_CONSTRAINT") then
            return true
        end
    end
    return false
end


local lastRender = 0
local interpolation = 0.01

RunService.RenderStepped:Connect(function(delta)
    local valueTypes = 1.375
    lastRender = lastRender + delta
    while lastRender > interpolation do
        lastRender = lastRender - interpolation
    end
    if getgenv().Kalexx.Tracing.Enabled and lockedCamTo ~= nil and getgenv().Kalexx.Tracing.TracingOptions.Strength == "Hard" then
        local Vel =  lockedCamTo.Character[getgenv().Kalexx.Tracing.AimPart].Velocity / (getgenv().Kalexx.Tracing.Prediction * valueTypes)
        local Main = CFrame.new(Cam.CFrame.p, lockedCamTo.Character[getgenv().Kalexx.Tracing.AimPart].Position + (Vel))
        Cam.CFrame = Cam.CFrame:Lerp(Main ,getgenv().Kalexx.Tracing.TracingOptions.Smoothness , Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        Kalexx.functions.setAimingType(lockedCamTo, getgenv().Kalexx.Tracing.TracingOptions.AimingType)
    elseif getgenv().Kalexx.Tracing.Enabled and lockedCamTo ~= nil and getgenv().Kalexx.Tracing.TracingOptions.Strength == "Soft" then
        local Vel =  lockedCamTo.Character[getgenv().Kalexx.Tracing.AimPart].Velocity / (getgenv().Kalexx.Tracing.Prediction / valueTypes)
        local Main = CFrame.new(Cam.CFrame.p, lockedCamTo.Character[getgenv().Kalexx.Tracing.AimPart].Position + (Vel))
        Cam.CFrame = Cam.CFrame:Lerp(Main ,getgenv().Kalexx.Tracing.TracingOptions.Smoothness , Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        Kalexx.functions.setAimingType(lockedCamTo, getgenv().Kalexx.Tracing.TracingOptions.AimingType)
    else

    end
end)

task.spawn(function ()
    while task.wait() do
        if Targetting then
            Kalexx.functions.setAimingType(Targetting, getgenv().Kalexx.SilentAim.AimingType)
        end
        Kalexx.functions.update_FOVs()
    end
end)


local __index
__index = hookmetamethod(game,"__index", function(Obj, Property)
    if Obj:IsA("Mouse") and Property == "Hit" then
        Targetting = Kalexx.functions.returnClosestPlayer(getgenv().Kalexx.SilentAim.ChanceData.Chance)
        if Targetting ~= nil and getgenv().Kalexx.SilentAim.Enabled and not Kalexx.functions.aimingCheck(Targetting) then
            local currentvelocity = Targetting.Character[getgenv().Kalexx.SilentAim.AimPart].Velocity
            local currentposition = Targetting.Character[getgenv().Kalexx.SilentAim.AimPart].CFrame

            return currentposition + (currentvelocity * getgenv().Kalexx.SilentAim.Prediction)
        end
    end
    return __index(Obj, Property)
end)
