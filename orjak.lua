-- leaked by 2017#0001
getgenv().orjak = {
    Silent = {
        SilentToggle = 'P',
        Enabled = true,
        Part = "HumanoidRootPart",
        Pred = 0.13295,
        ClosestPart = true
    },
    FOV = {
        Visible = false,
        Radius = 62
    },
    Tracer = {
        TracerToggle = "C",
        Enabled = true,
        Part = "HumanoidRootPart",
        Pred = 4.8,
        SmoothnessValue = 0.07,
        Smoothness = true,
        TraceClosestPart = false,
        UseTracerRadius = false,
        Radius = 60,
        ShowFOV = true
    },
    Extras = {
        WallCheck = true,
        UnlockedOnDeath = true
    },
}
getgenv().Settings = {
    Main = {
        Enable = true,
        
        HoldKey = false,
        ToggleKey = true,
        
        UseKeyBoardKey = true,
        KeyBoardKey = Enum.KeyCode.E, -- https://create.roblox.com/docs/reference/engine/enums/KeyCode
        
        UseMouseKey = false,
        MouseKey = Enum.UserInputType.MouseButton2, -- https://create.roblox.com/docs/reference/engine/enums/UserInputType
        
        ThirdPerson = true,
        FirstPerson = true,
        
        AutoPingSets = false,
        
        UseCircleRadius = false,
        DisableOutSideCircle = false,
        
        UseShake = true,
        ShakePower = 1,
        
        CheckForWalls = true
    },
    Check = {
        CheckIfKo = false, -- This Is For Da Hood
        DisableOnTargetDeath = false,
        DisableOnPlayerDeath = false
    },
    Horizontal = {
        PredictMovement = true,
        PredictionVelocity = 0.17221418
    },
    Smooth = {
        Smoothness = true,
        SmoothnessAmount = 0.019,
        SmoothMethod = Enum.EasingStyle.Circular,
        SmoothMethodV2 = Enum.EasingDirection.InOut
    },
    Part = {
        AimPart = "Head",
        CheckIfJumpedAimPart = "HumanoidRootPart",
        CheckIfJumped = true,
        GetClosestPart = false
    },
    Resolver = {
        UnderGround = false,
        UseUnderGroundKeybind = true,
        UnderGroundKey = Enum.KeyCode.X,
        DetectDesync = true,
        Detection = 75,
        
        UseDetectDesyncKeybind = true,
        DetectDesyncKey = Enum.KeyCode.V,
        SendNotification = true
    },
    Visual = {
        Fov = true,
        FovTransparency = 1,
        FovThickness = 1,
        FovColor = Color3.fromRGB(255, 185, 0),
        FovRadius = 60
    },
    Spoofer = {
        MemorySpoofer = false,
        MemoryTabColor = Color3.fromRGB(211, 88, 33),
        MemoryMost = 85000,
        MemoryLeast = 80000,
        
        PingSpoofer = false,
        PingTabColor = Color3.fromRGB(211, 88, 33),
        PingMost = 2000,
        PingLeast = 1000
    }
}

if not LPH_OBFUSCATED then
    LPH_JIT_MAX = function(...)
        return (...)
    end
    LPH_NO_VIRTUALIZE = function(...)
        return (...)
    end
end

LPH_JIT_MAX(
    function()
        local Players, Client, Mouse, RS, Camera, r =
            game:GetService("Players"),
            game:GetService("Players").LocalPlayer,
            game:GetService("Players").LocalPlayer:GetMouse(),
            game:GetService("RunService"),
            game.Workspace.CurrentCamera,
            math.random

        local Circle = Drawing.new("Circle")
        Circle.Color = Color3.new(1, 1, 1)
        Circle.Transparency = 0.5
        Circle.Thickness = 1

        local TracerCircle = Drawing.new("Circle")
        TracerCircle.Color = Color3.new(1, 1, 1)
        TracerCircle.Thickness = 1

        local prey
        local prey2
        local On

        local Vec2 = function(property)
            return Vector2.new(property.X, property.Y + (game:GetService("GuiService"):GetGuiInset().Y))
        end

        local UpdateSilentFOV = function()
            if not Circle then
                return Circle
            end
            Circle.Visible = getgenv().orjak.FOV["Visible"]
            Circle.Radius = getgenv().orjak.FOV["Radius"] * 3.05
            Circle.Position = Vec2(Mouse)

            return Circle
        end

        local UpdateTracerFOV = function()
            if not TracerCircle then
                return TracerCircle
            end

            TracerCircle.Visible = getgenv().orjak.Tracer["ShowFOV"]
            TracerCircle.Radius = getgenv().orjak.Tracer["Radius"]
            TracerCircle.Position = Vec2(Mouse)

            return TracerCircle
        end

        game.RunService.RenderStepped:Connect(function ()
            UpdateTracerFOV()
            UpdateSilentFOV()
        end)

        local WallCheck = function(destination, ignore)
            if getgenv().orjak.Extras.WallCheck then
                local Origin = Camera.CFrame.p
                local CheckRay = Ray.new(Origin, destination - Origin)
                local Hit = game.workspace:FindPartOnRayWithIgnoreList(CheckRay, ignore)
                return Hit == nil
            else
                return true
            end
        end

        local useVelocity = function (player) 
            player.Character.HumanoidRootPart.Velocity = Vector3.new(0.36, 0.21, 0.34) * 2
        end

        local checkVelocity = function (player, pos, neg)
            if player and player.Character:FindFirstChild("Humanoid") then
                local velocity = player.Character.HumanoidRootPart.Velocity
                if (velocity.Magnitude > neg or velocity.Magnitude < pos and
                (not player.Character.Humanoid.Jump == true)) then
                    useVelocity(player)
                end
            end
            return false
        end

        GetClosestToMouse = function()
            local Target, Closest = nil, 1 / 0

            for _, v in pairs(Players:GetPlayers()) do
                if (v.Character and v ~= Client and v.Character:FindFirstChild("HumanoidRootPart")) then
                    local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                    local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

                    if
                        (Circle.Radius > Distance and Distance < Closest and OnScreen and
                            WallCheck(v.Character.HumanoidRootPart.Position, {Client, v.Character}))
                     then
                        Closest = Distance
                        Target = v
                    end
                end
            end
            return Target
        end

        function TargetChecks(Target)
            if getgenv().orjak.Extras.UnlockedOnDeath == true and Target.Character then
                return Target.Character.BodyEffects["K.O"].Value and true or false
            end
            return false
        end

        function predictTargets(Target, Value)
            return Target.Character[getgenv().orjak.Silent.Part].CFrame +
                (Target.Character[getgenv().orjak.Silent.Part].Velocity * Value)
        end

        local WTS = function(Object)
            local ObjectVector = Camera:WorldToScreenPoint(Object.Position)
            return Vector2.new(ObjectVector.X, ObjectVector.Y)
        end

        local IsOnScreen = function(Object)
            local IsOnScreen = Camera:WorldToScreenPoint(Object.Position)
            return IsOnScreen
        end

        local FilterObjs = function(Object)
            if string.find(Object.Name, "Gun") then
                return
            end
            if table.find({"Part", "MeshPart", "BasePart"}, Object.ClassName) then
                return true
            end
        end
        GetClosestBodyPart = function(character)
            local ClosestDistance = 1 / 0
            local BodyPart = nil
            if (character and character:GetChildren()) then
                for _, x in next, character:GetChildren() do
                    if FilterObjs(x) and IsOnScreen(x) then
                        local Distance = (WTS(x) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                        if getgenv().orjak.Tracer.UseTracerRadius == true then
                            if (TracerCircle.Radius > Distance and Distance < ClosestDistance) then
                                ClosestDistance = Distance
                                BodyPart = x
                            end
                        else
                            if (Distance < ClosestDistance) then
                                ClosestDistance = Distance
                                BodyPart = x
                            end
                        end
                    end
                end
            end
            return BodyPart
        end

        Mouse.KeyDown:Connect(
            function(Key)
                if (Key == getgenv().orjak.Tracer.TracerToggle:lower()) then
                    if getgenv().orjak.Tracer.Enabled == true then
                        On = not On
                        if On then
                            prey2 = GetClosestToMouse()
                        else
                            if prey2 ~= nil then
                                prey2 = nil
                            end
                        end
                    end
                end
                if (Key == getgenv().orjak.Silent.SilentToggle:lower()) then
                    if getgenv().orjak.Silent.Enabled == true then
                        getgenv().orjak.Silent.Enabled = false
                    else
                        getgenv().orjak.Silent.Enabled = true
                    end
                end
            end
        )

        RS.RenderStepped:Connect(
            function()
                if prey then
                    if prey ~= nil and getgenv().orjak.Silent.Enabled and getgenv().orjak.Silent.ClosestPart == true then
                        getgenv().orjak.Silent["Part"] = tostring(GetClosestBodyPart(prey.Character))
                    end
                end
                if prey2 then
                    if
                        prey2 ~= nil and not TargetChecks(prey2) and getgenv().orjak.Tracer.Enabled and
                            getgenv().orjak.Tracer.TraceClosestPart == true
                     then
                        getgenv().orjak.Tracer["Part"] = tostring(GetClosestBodyPart(prey2.Character))
                    end
                end
            end
        )

        local TracerPrediction = function(Target, Value)
            return Target.Character[getgenv().orjak.Tracer.Part].Position +
                (Target.Character[getgenv().orjak.Tracer.Part].Velocity / Value)
        end

        RS.RenderStepped:Connect(
            function()
                if
                    prey2 ~= nil and not TargetChecks(prey2) and getgenv().orjak.Tracer.Enabled and
                        getgenv().orjak.Tracer.Smoothness == true
                 then
                    local Main = CFrame.new(Camera.CFrame.p, TracerPrediction(prey2, getgenv().orjak.Tracer.Pred))
                    Camera.CFrame =
                        Camera.CFrame:Lerp(
                        Main,
                        getgenv().orjak.Tracer.SmoothnessValue,
                        Enum.EasingStyle.Elastic,
                        Enum.EasingDirection.InOut,
                        Enum.EasingStyle.Sine,
                        Enum.EasingDirection.Out
                    )
                elseif prey2 ~= nil and getgenv().orjak.Tracer.Enabled and getgenv().orjak.Tracer.Smoothness == false then
                    Camera.CFrame =
                        CFrame.new(Camera.CFrame.Position, TracerPrediction(prey2, getgenv().orjak.Tracer.Pred))
                end
            end
        )

local grmt = getrawmetatable(game)
local backupindex = grmt.__index
setreadonly(grmt, false)

grmt.__index = newcclosure(function(self, v)
    if (Settings.Silent.Enabled and Mouse and tostring(v) == "Hit") then

        Prey = ClosestPlrFromMouse()

        if Prey then
            local endpoint = game.Players[tostring(Prey)].Character[Settings.Silent["Part"]].CFrame + (
                game.Players[tostring(Prey)].Character[Settings.Silent["Part"]].Velocity * Settings.Silent.Pred
            )
            return (tostring(v) == "Hit" and endpoint)
        end
    end
    return backupindex(self, v)
end)

        local grmt = getrawmetatable(game)
        local index = grmt.__index
        local properties = {
            "Hit" -- Ill Add more Mouse properties soon,
        }
        setreadonly(grmt, false)

        grmt.__index =
            newcclosure(
            function(self, v)
                if Mouse and (table.find(properties, v)) then
                    prey = GetClosestToMouse()
                    if prey ~= nil and getgenv().orjak.Silent.Enabled and not TargetChecks(prey) then
                        local endpoint = predictTargets(prey, getgenv().orjak.Silent.Pred)

                        return (table.find(properties, tostring(v)) and endpoint)
                    end
                end
                return index(self, v)
            end
        )
    end
)()

local Players, Uis, RService, Inset, CurrentCamera = 
game:GetService("Players"), 
game:GetService("UserInputService"), 
game:GetService("RunService"),
game:GetService("GuiService"):GetGuiInset().Y,
game:GetService("Workspace").CurrentCamera

local Client = Players.LocalPlayer;

local Mouse, Camera = Client:GetMouse(), workspace.CurrentCamera

local Circle2 = Drawing.new("Circle")

local CF, RNew, Vec3, Vec2 = CFrame.new, Ray.new, Vector3.new, Vector2.new

local OldAimPart = getgenv().Settings.Part.AimPart

local AimlockTarget, MousePressed, CanNotify = nil, false, false

getgenv().UpdateFOV = function()
    if (not Circle2) then
        return (Circle2)
    end
    Circle2.Color = Settings.Visual.FovColor
    Circle2.Visible = Settings.Visual.Fov
    Circle2.Radius = Settings.Visual.FovRadius
    Circle2.Thickness = Settings.Visual.FovThickness
    Circle2.Position = Vec2(Mouse.X, Mouse.Y + Inset)
    return (Circle2)
end

RService.Heartbeat:Connect(UpdateFOV)

-- // Functions

getgenv().WallCheck = function(destination, ignore)
    local Origin = Camera.CFrame.p
    local CheckRay = RNew(Origin, destination - Origin)
    local Hit = game.workspace:FindPartOnRayWithIgnoreList(CheckRay, ignore)
    return Hit == nil
end

getgenv().WTS = function(Object)
    local ObjectVector = Camera:WorldToScreenPoint(Object.Position)
    return Vec2(ObjectVector.X, ObjectVector.Y)
end

getgenv().IsOnScreen = function(Object)
    local IsOnScreen = Camera:WorldToScreenPoint(Object.Position)
    return IsOnScreen
end

getgenv().FilterObjs = function(Object)
    if string.find(Object.Name, "Gun") then
        return
    end
    if table.find({"Part", "MeshPart", "BasePart"}, Object.ClassName) then
        return true
    end
end

getgenv().GetClosestBodyPart = function(character)
    local ClosestDistance = 1 / 0
    local BodyPart = nil
    if (character and character:GetChildren()) then
        for _, x in next, character:GetChildren() do
            if FilterObjs(x) and IsOnScreen(x) then
                local Distance = (WTS(x) - Vec2(Mouse.X, Mouse.Y)).Magnitude
                if (Circle.Radius > Distance and Distance < ClosestDistance) then
                    ClosestDistance = Distance
                    BodyPart = x
                end
            end
        end
    end
    return BodyPart
end

getgenv().WorldToViewportPoint = function(P)
    return Camera:WorldToViewportPoint(P)
end

getgenv().WorldToScreenPoint = function(P)
    return Camera.WorldToScreenPoint(Camera, P)
end

getgenv().GetObscuringObjects = function(T)
    if T and T:FindFirstChild(getgenv().Settings.Part.AimPart) and Client and Client.Character:FindFirstChild("Head") then
        local RayPos =
            workspace:FindPartOnRay(RNew(T[getgenv().Settings.Part.AimPart].Position, Client.Character.Head.Position))
        if RayPos then
            return RayPos:IsDescendantOf(T)
        end
    end
end

getgenv().GetNearestTarget = function()
    local AimlockTarget, Closest = nil, 1 / 0

    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if (v.Character and v ~= Client and v.Character:FindFirstChild("HumanoidRootPart")) then
            local Position, OnScreen = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
            local Distance = (Vec2(Position.X, Position.Y) - Vec2(Mouse.X, Mouse.Y)).Magnitude
            if Settings.Main.CheckForWalls then
                if
                    (Circle2.Radius > Distance and Distance < Closest and OnScreen and
                        getgenv().WallCheck(v.Character.HumanoidRootPart.Position, {Client, v.Character}))
                 then
                    Closest = Distance
                    AimlockTarget = v
                end
            elseif Settings.Main.UseCircleRadius then
                if
                    (Circle2.Radius > Distance and Distance < Closest and OnScreen and
                        getgenv().WallCheck(v.Character.HumanoidRootPart.Position, {Client, v.Character}))
                 then
                    Closest = Distance
                    AimlockTarget = v
                end
            else
                if (Circle2.Radius > Distance and Distance < Closest and OnScreen) then
                    Closest = Distance
                    AimlockTarget = v
                end
            end
        end
    end
    return AimlockTarget
end

-- // Use KeyBoardKey Function

Uis.InputBegan:connect(
    function(input)
        if
            input.KeyCode == Settings.Main.KeyBoardKey and Settings.Main.UseKeyBoardKey == true and
                getgenv().Settings.Main.Enable == true and
                AimlockTarget == nil and
                getgenv().Settings.Main.HoldKey == true
         then
            pcall(
                function()
                    MousePressed = true
                    AimlockTarget = GetNearestTarget()
                end
            )
        end
    end
)Uis.InputEnded:connect(
    function(input)
        if
            input.KeyCode == Settings.Main.KeyBoardKey and getgenv().Settings.Main.HoldKey == true and
                Settings.Main.UseKeyBoardKey == true and
                getgenv().Settings.Main.Enable == true and
                AimlockTarget ~= nil
         then
            AimlockTarget = nil
            MousePressed = false
        end
    end
)

Uis.InputBegan:Connect(
    function(keyinput, stupid)
        if
            keyinput.KeyCode == Settings.Resolver.UnderGroundKey and getgenv().Settings.Main.Enable == true and
                Settings.Resolver.UseUnderGroundKeybind == true
         then
            if Settings.Resolver.UnderGround == true then
                Settings.Resolver.UnderGround = false
                if getgenv().Settings.Resolver.SendNotification then
                    game.StarterGui:SetCore(
                        "SendNotification",
                        {
                            Title = "Sanky Box",
                            Text = "Disabled UnderGround Resolver",
                            Icon = "rbxassetid://11394475200",
                            Duration = 1
                        }
                    )
                end
            else
                Settings.Resolver.UnderGround = true
                if getgenv().Settings.Resolver.SendNotification then
                    game.StarterGui:SetCore(
                        "SendNotification",
                        {
                            Title = "Sanky Box",
                            Text = "Enabled UnderGround Resolver",
                            Icon = "rbxassetid://11394475200",
                            Duration = 1
                        }
                    )
                end
            end
        end
    end
)

Uis.InputBegan:Connect(
    function(keyinput, stupid)
        if
            keyinput.KeyCode == Settings.Resolver.DetectDesyncKey and getgenv().Settings.Main.Enable == true and
                Settings.Resolver.UseDetectDesyncKeybind == true
         then
            if Settings.Resolver.DetectDesync == true then
                Settings.Resolver.DetectDesync = false
                if getgenv().Settings.Resolver.SendNotification then
                    game.StarterGui:SetCore(
                        "SendNotification",
                        {
                            Title = "Sanky Box",
                            Text = "Disabled Desync Resolver",
                            Icon = "rbxassetid://11394475200",
                            Duration = 1
                        }
                    )
                end
            else
                Settings.Resolver.DetectDesync = true
                if getgenv().Settings.Resolver.SendNotification then
                    game.StarterGui:SetCore(
                        "SendNotification",
                        {
                            Title = "Sanky Box",
                            Text = "Enabled Desync Resolver",
                            Icon = "rbxassetid://11394475200",
                            Duration = 1
                        }
                    )
                end
            end
        end
    end
)

Uis.InputBegan:Connect(
    function(keyinput, stupid)
        if
            keyinput.KeyCode == Settings.Main.KeyBoardKey and Settings.Main.UseKeyBoardKey == true and
                getgenv().Settings.Main.Enable == true and
                AimlockTarget == nil and
                getgenv().Settings.Main.ToggleKey == true
         then
            pcall(
                function()
                    MousePressed = true
                    AimlockTarget = GetNearestTarget()
                end
            )
        elseif
            keyinput.KeyCode == Settings.Main.KeyBoardKey and Settings.Main.UseKeyBoardKey == true and
                getgenv().Settings.Main.Enable == true and
                AimlockTarget ~= nil
         then
            AimlockTarget = nil
            MousePressed = false
        end
    end
)

-- // Use MouseKey Function

Uis.InputBegan:connect(
    function(input)
        if
            input.UserInputType == Settings.Main.MouseKey and Settings.Main.UseMouseKey == true and
                getgenv().Settings.Main.Enable == true and
                AimlockTarget == nil and
                getgenv().Settings.Main.HoldKey == true
         then
            pcall(
                function()
                    MousePressed = true
                    AimlockTarget = GetNearestTarget()
                end
            )
        end
    end
)Uis.InputEnded:connect(
    function(input)
        if
            input.UserInputType == Settings.Main.MouseKey and getgenv().Settings.Main.HoldKey == true and
                Settings.Main.UseMouseKey == true and
                getgenv().Settings.Main.Enable == true and
                AimlockTarget ~= nil
         then
            AimlockTarget = nil
            MousePressed = false
        end
    end
)

Uis.InputBegan:Connect(
    function(keyinput, stupid)
        if
            keyinput.UserInputType == Settings.Main.MouseKey and Settings.Main.UseMouseKey == true and
                getgenv().Settings.Main.Enable == true and
                AimlockTarget == nil and
                getgenv().Settings.Main.ToggleKey == true
         then
            pcall(
                function()
                    MousePressed = true
                    AimlockTarget = GetNearestTarget()
                end
            )
        elseif
            keyinput.UserInputType == Settings.Main.MouseKey and Settings.Main.UseMouseKey == true and
                getgenv().Settings.Main.Enable == true and
                AimlockTarget ~= nil
         then
            AimlockTarget = nil
            MousePressed = false
        end
    end
)

-- // Main Functions. RunService HeartBeat.

task.spawn(
    function()
        while task.wait() do
            if MousePressed == true and getgenv().Settings.Main.Enable == true then
                if AimlockTarget and AimlockTarget.Character then
                    if getgenv().Settings.Part.GetClosestPart == true then
                        getgenv().Settings.Part.AimPart = tostring(GetClosestBodyPart(AimlockTarget.Character))
                    end
                end
                if getgenv().Settings.Main.DisableOutSideCircle == true and AimlockTarget and AimlockTarget.Character then
                    if
                        Circle.Radius <
                            (Vec2(
                                Camera:WorldToScreenPoint(AimlockTarget.Character.HumanoidRootPart.Position).X,
                                Camera:WorldToScreenPoint(AimlockTarget.Character.HumanoidRootPart.Position).Y
                            ) - Vec2(Mouse.X, Mouse.Y)).Magnitude
                     then
                        AimlockTarget = nil
                    end
                end
            end
        end
    end
)

RService.Heartbeat:Connect(
    function()
        if getgenv().Settings.Main.Enable == true and MousePressed == true then
            if getgenv().Settings.Main.UseShake == true and AimlockTarget and AimlockTarget.Character then
                pcall(
                    function()
                        local TargetVelv1 = AimlockTarget.Character[getgenv().Settings.Part.AimPart]
                        TargetVelv1.Velocity =
                            Vec3(TargetVelv1.Velocity.X, TargetVelv1.Velocity.Y, TargetVelv1.Velocity.Z) +
                            Vec3(
                                math.random(-getgenv().Settings.Main.ShakePower, getgenv().Settings.Main.ShakePower),
                                math.random(-getgenv().Settings.Main.ShakePower, getgenv().Settings.Main.ShakePower),
                                math.random(-getgenv().Settings.Main.ShakePower, getgenv().Settings.Main.ShakePower)
                            ) *
                                0.1
                        TargetVelv1.AssemblyLinearVelocity =
                            Vec3(TargetVelv1.Velocity.X, TargetVelv1.Velocity.Y, TargetVelv1.Velocity.Z) +
                            Vec3(
                                math.random(-getgenv().Settings.Main.ShakePower, getgenv().Settings.Main.ShakePower),
                                math.random(-getgenv().Settings.Main.ShakePower, getgenv().Settings.Main.ShakePower),
                                math.random(-getgenv().Settings.Main.ShakePower, getgenv().Settings.Main.ShakePower)
                            ) *
                                0.1
                    end
                )
            end
            if getgenv().Settings.Resolver.UnderGround == true and AimlockTarget and AimlockTarget.Character then
                pcall(
                    function()
                        local TargetVelv2 = AimlockTarget.Character[getgenv().Settings.Part.AimPart]
                        TargetVelv2.Velocity = Vec3(TargetVelv2.Velocity.X, 0, TargetVelv2.Velocity.Z)
                        TargetVelv2.AssemblyLinearVelocity = Vec3(TargetVelv2.Velocity.X, 0, TargetVelv2.Velocity.Z)
                    end
                )
            end
            if
                getgenv().Settings.Resolver.DetectDesync == true and AimlockTarget and AimlockTarget.Character and
                    AimlockTarget.Character:WaitForChild("HumanoidRootPart").Velocity.magnitude >
                        getgenv().Settings.Resolver.Detection
             then
                pcall(
                    function()
                        local TargetVel = AimlockTarget.Character[getgenv().Settings.Part.AimPart]
                        TargetVel.Velocity = Vec3(0, 0, 0)
                        TargetVel.AssemblyLinearVelocity = Vec3(0, 0, 0)
                    end
                )
            end
            if getgenv().Settings.Main.ThirdPerson == true and getgenv().Settings.Main.FirstPerson == true then
                if
                    (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude > 1 or
                        (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude <= 1
                 then
                    CanNotify = true
                else
                    CanNotify = false
                end
            elseif getgenv().Settings.Main.ThirdPerson == true and getgenv().Settings.Main.FirstPerson == false then
                if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude > 1 then
                    CanNotify = true
                else
                    CanNotify = false
                end
            elseif getgenv().Settings.Main.ThirdPerson == false and getgenv().Settings.Main.FirstPerson == true then
                if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude <= 1 then
                    CanNotify = true
                else
                    CanNotify = false
                end
            end
            if getgenv().Settings.Main.AutoPingSets == true and getgenv().Settings.Horizontal.PredictionVelocity then
                local pingvalue = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
                local split = string.split(pingvalue, "(")
                local ping = tonumber(split[1])
                if ping > 190 then
                    getgenv().Settings.Horizontal.PredictionVelocity = 0.206547
                elseif ping > 180 then
                    getgenv().Settings.Horizontal.PredictionVelocity = 0.19284
                elseif ping > 170 then
                    getgenv().Settings.Horizontal.PredictionVelocity = 0.1923111
                elseif ping > 160 then
                    getgenv().Settings.Horizontal.PredictionVelocity = 0.1823111
                elseif ping > 150 then
                    getgenv().Settings.Horizontal.PredictionVelocity = 0.171
                elseif ping > 140 then
                    getgenv().Settings.Horizontal.PredictionVelocity = 0.165773
                elseif ping > 130 then
                    getgenv().Settings.Horizontal.PredictionVelocity = 0.1223333
                elseif ping > 120 then
                    getgenv().Settings.Horizontal.PredictionVelocity = 0.143765
                elseif ping > 110 then
                    getgenv().Settings.Horizontal.PredictionVelocity = 0.1455
                elseif ping > 100 then
                    getgenv().Settings.Horizontal.PredictionVelocity = 0.130340
                elseif ping > 90 then
                    getgenv().Settings.Horizontal.PredictionVelocity = 0.136
                elseif ping > 80 then
                    getgenv().Settings.Horizontal.PredictionVelocity = 0.1347
                elseif ping > 70 then
                    getgenv().Settings.Horizontal.PredictionVelocity = 0.119
                elseif ping > 60 then
                    getgenv().Settings.Horizontal.PredictionVelocity = 0.12731
                elseif ping > 50 then
                    getgenv().Settings.Horizontal.PredictionVelocity = 0.127668
                elseif ping > 40 then
                    getgenv().Settings.Horizontal.PredictionVelocity = 0.125
                elseif ping > 30 then
                    getgenv().Settings.Horizontal.PredictionVelocity = 0.11
                elseif ping > 20 then
                    getgenv().Settings.Horizontal.PredictionVelocity = 0.12588
                elseif ping > 10 then
                    getgenv().Settings.Horizontal.PredictionVelocity = 0.9
                end
            end
            if getgenv().Settings.Check.CheckIfKo == true and AimlockTarget and AimlockTarget.Character then
                local KOd = AimlockTarget.Character:WaitForChild("BodyEffects")["K.O"].Value
                local Grabbed = AimlockTarget.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
                if AimlockTarget.Character.Humanoid.health < 1 or KOd or Grabbed then
                    if MousePressed == true then
                        AimlockTarget = nil
                        MousePressed = false
                    end
                end
            end
            if
                getgenv().Settings.Check.DisableOnTargetDeath == true and AimlockTarget and
                    AimlockTarget.Character:FindFirstChild("Humanoid")
             then
                if AimlockTarget.Character.Humanoid.health < 1 then
                    if MousePressed == true then
                        AimlockTarget = nil
                        MousePressed = false
                    end
                end
            end
            if
                getgenv().Settings.Check.DisableOnPlayerDeath == true and Client.Character and
                    Client.Character:FindFirstChild("Humanoid") and
                    Client.Character.Humanoid.health < 1
             then
                if MousePressed == true then
                    AimlockTarget = nil
                    MousePressed = false
                end
            end
            if getgenv().Settings.Part.CheckIfJumped == true and getgenv().Settings.Part.GetClosestPart == false then
                if AimlockTarget and AimlockTarget.Character then
                    if AimlockTarget.Character.Humanoid.FloorMaterial == Enum.Material.Air then
                        getgenv().Settings.Part.AimPart = getgenv().Settings.Part.CheckIfJumpedAimPart
                    else
                        getgenv().Settings.Part.AimPart = OldAimPart
                    end
                end
            end
            if
                AimlockTarget and AimlockTarget.Character and
                    AimlockTarget.Character:FindFirstChild(getgenv().Settings.Part.AimPart)
             then
                if getgenv().Settings.Main.FirstPerson == true then
                    if CanNotify == true then
                        if getgenv().Settings.Horizontal.PredictMovement == true then
                            if getgenv().Settings.Smooth.Smoothness == true then
                                local Main =
                                    CF(
                                    Camera.CFrame.p,
                                    AimlockTarget.Character[getgenv().Settings.Part.AimPart].Position +
                                        AimlockTarget.Character[getgenv().Settings.Part.AimPart].Velocity *
                                            getgenv().Settings.Horizontal.PredictionVelocity
                                )

                                Camera.CFrame =
                                    Camera.CFrame:Lerp(
                                    Main,
                                    getgenv().Settings.Smooth.SmoothnessAmount,
                                    Enum.EasingStyle.Elastic,
                                    Enum.EasingDirection.InOut
                                )
                            else
                                Camera.CFrame =
                                    CF(
                                    Camera.CFrame.p,
                                    AimlockTarget.Character[getgenv().Settings.Part.AimPart].Position +
                                        AimlockTarget.Character[getgenv().Settings.Part.AimPart].Velocity *
                                            getgenv().Settings.Horizontal.PredictionVelocity + Vector3
                                )
                            end
                        elseif getgenv().Settings.Horizontal.PredictMovement == false then
                            if getgenv().Settings.Smooth.Smoothness == true then
                                local Main =
                                    CF(
                                    Camera.CFrame.p,
                                    AimlockTarget.Character[getgenv().Settings.Part.AimPart].Position
                                )
                                Camera.CFrame =
                                    Camera.CFrame:Lerp(
                                    Main,
                                    getgenv().Settings.Smooth.SmoothnessAmount,
                                    getgenv().Settings.Smooth.SmoothMethod,
                                    getgenv().Settings.Smooth.SmoothMethodV2
                                )
                            else
                                Camera.CFrame =
                                    CF(
                                    Camera.CFrame.p,
                                    AimlockTarget.Character[getgenv().Settings.Part.AimPart].Position
                                )
                            end
                        end
                    end
                end
            end
        end
    end
)

-- IK THIS IS SHITTY BRUH

local PerformanceStats = game:GetService("CoreGui"):WaitForChild("RobloxGui"):WaitForChild("PerformanceStats")

local MemLabel
local color,
    color1,
    color2,
    color3,
    color4,
    color5,
    color6,
    color7,
    color8,
    color9,
    color10,
    color11,
    color12,
    color13,
    color14,
    color15,
    color16,
    color17,
    color18,
    color19
for I, Child in next, PerformanceStats:GetChildren() do
    if Child.StatsMiniTextPanelClass.TitleLabel.Text == "Mem" then
        MemLabel = Child.StatsMiniTextPanelClass.ValueLabel
        color = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_0
        color1 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_1
        color2 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_2
        color3 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_3
        color4 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_4
        color5 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_5
        color6 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_6
        color7 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_7
        color8 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_8
        color9 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_9
        color10 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_10
        color11 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_11
        color12 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_12
        color13 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_13
        color14 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_14
        color15 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_15
        color16 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_16
        color17 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_17
        color18 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_18
        color19 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_19
        break
    end
end
MemLabel:GetPropertyChangedSignal("Text"):Connect(
    function()
        if Settings.Spoofer.MemorySpoofer == true then
            MemLabel.Text = math.random(Settings.Spoofer.MemoryLeast, Settings.Spoofer.MemoryMost) / 100 .. " MB"
            color.BackgroundColor3 = Settings.Spoofer.MemoryTabColor
            color1.BackgroundColor3 = Settings.Spoofer.MemoryTabColor
            color2.BackgroundColor3 = Settings.Spoofer.MemoryTabColor
            color3.BackgroundColor3 = Settings.Spoofer.MemoryTabColor
            color4.BackgroundColor3 = Settings.Spoofer.MemoryTabColor
            color5.BackgroundColor3 = Settings.Spoofer.MemoryTabColor
            color6.BackgroundColor3 = Settings.Spoofer.MemoryTabColor
            color7.BackgroundColor3 = Settings.Spoofer.MemoryTabColor
            color8.BackgroundColor3 = Settings.Spoofer.MemoryTabColor
            color9.BackgroundColor3 = Settings.Spoofer.MemoryTabColor
            color10.BackgroundColor3 = Settings.Spoofer.MemoryTabColor
            color11.BackgroundColor3 = Settings.Spoofer.MemoryTabColor
            color12.BackgroundColor3 = Settings.Spoofer.MemoryTabColor
            color13.BackgroundColor3 = Settings.Spoofer.MemoryTabColor
            color14.BackgroundColor3 = Settings.Spoofer.MemoryTabColor
            color15.BackgroundColor3 = Settings.Spoofer.MemoryTabColor
            color16.BackgroundColor3 = Settings.Spoofer.MemoryTabColor
            color17.BackgroundColor3 = Settings.Spoofer.MemoryTabColor
            color18.BackgroundColor3 = Settings.Spoofer.MemoryTabColor
            color19.BackgroundColor3 = Settings.Spoofer.MemoryTabColor
        end
    end
)

local PingLabel
for I, Child in next, PerformanceStats:GetChildren() do
    if Child.StatsMiniTextPanelClass.TitleLabel.Text == "Ping" then
        PingLabel = Child.StatsMiniTextPanelClass.ValueLabel
        color = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_0
        color1 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_1
        color2 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_2
        color3 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_3
        color4 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_4
        color5 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_5
        color6 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_6
        color7 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_7
        color8 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_8
        color9 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_9
        color10 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_10
        color11 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_11
        color12 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_12
        color13 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_13
        color14 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_14
        color15 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_15
        color16 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_16
        color17 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_17
        color18 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_18
        color19 = Child.PS_AnnotatedGraph.PS_BarFrame.Bar_19
        break
    end
end
PingLabel:GetPropertyChangedSignal("Text"):Connect(
    function()
        if Settings.Spoofer.PingSpoofer == true then
            local textrandom = math.random(Settings.Spoofer.PingLeast, Settings.Spoofer.PingMost) / 100
            PingLabel.Text = textrandom .. " ms"
            color.BackgroundColor3 = Settings.Spoofer.PingTabColor
            color1.BackgroundColor3 = Settings.Spoofer.PingTabColor
            color2.BackgroundColor3 = Settings.Spoofer.PingTabColor
            color3.BackgroundColor3 = Settings.Spoofer.PingTabColor
            color4.BackgroundColor3 = Settings.Spoofer.PingTabColor
            color5.BackgroundColor3 = Settings.Spoofer.PingTabColor
            color6.BackgroundColor3 = Settings.Spoofer.PingTabColor
            color7.BackgroundColor3 = Settings.Spoofer.PingTabColor
            color8.BackgroundColor3 = Settings.Spoofer.PingTabColor
            color9.BackgroundColor3 = Settings.Spoofer.PingTabColor
            color10.BackgroundColor3 = Settings.Spoofer.PingTabColor
            color11.BackgroundColor3 = Settings.Spoofer.PingTabColor
            color12.BackgroundColor3 = Settings.Spoofer.PingTabColor
            color13.BackgroundColor3 = Settings.Spoofer.PingTabColor
            color14.BackgroundColor3 = Settings.Spoofer.PingTabColor
            color15.BackgroundColor3 = Settings.Spoofer.PingTabColor
            color16.BackgroundColor3 = Settings.Spoofer.PingTabColor
            color17.BackgroundColor3 = Settings.Spoofer.PingTabColor
            color18.BackgroundColor3 = Settings.Spoofer.PingTabColor
            color19.BackgroundColor3 = Settings.Spoofer.PingTabColor
            if game.PlaceId == 9825515356 then
                game:GetService("ReplicatedStorage").MainEvent:FireServer("GetPing", textrandom)
            end
        end
    end
)