print = function() end
warn = function() end
error = function() return end

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "PolariaUI"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0

local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        update(input)
    end
end)

local tabContainer = Instance.new("Frame", mainFrame)
tabContainer.Size = UDim2.new(1, 0, 0, 30)
tabContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
tabContainer.BorderSizePixel = 0

local contentContainer = Instance.new("Frame", mainFrame)
contentContainer.Size = UDim2.new(1, 0, 1, -30)
contentContainer.Position = UDim2.new(0, 0, 0, 30)
contentContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
contentContainer.BorderSizePixel = 0

local closeButton = Instance.new("TextButton", mainFrame)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.BorderSizePixel = 0
closeButton.Font = Enum.Font.SourceSansBold

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local tabs = {"Home", "Player", "Server", "Executor", "Scripts", "Admin Cmds"}
local tabFrames = {}

for i, name in ipairs(tabs) do
    local tabButton = Instance.new("TextButton", tabContainer)
    tabButton.Size = UDim2.new(0, 100, 1, 0)
    tabButton.Position = UDim2.new(0, (i - 1) * 95, 0, 0)
    tabButton.Text = name
    tabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    tabButton.TextColor3 = Color3.new(1, 1, 1)
    tabButton.BorderSizePixel = 0

    local frame = Instance.new("Frame", contentContainer)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = (i == 1)
    tabFrames[name] = frame

    tabButton.MouseButton1Click:Connect(function()
        for _, f in pairs(tabFrames) do
            f.Visible = false
        end
        frame.Visible = true
    end)
end

local home = tabFrames["Home"]

local thumbImage = Instance.new("ImageLabel", home)
thumbImage.Size = UDim2.new(0, 150, 0, 150)
thumbImage.Position = UDim2.new(0, 10, 0, 10)
thumbImage.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
thumbImage.BorderColor3 = Color3.fromRGB(140, 0, 255)
thumbImage.BorderSizePixel = 2
thumbImage.ScaleType = Enum.ScaleType.Fit

local content, isReady = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
thumbImage.Image = content

local info = {
    "Username: " .. player.Name,
    "DisplayName: " .. (player.DisplayName or ""),
    "Account Age: " .. player.AccountAge .. " days",
    "Run time: " .. os.date("%X"),
    "Game Name: " .. game.Name
}

for i, line in ipairs(info) do
    local label = Instance.new("TextLabel", home)
    label.Size = UDim2.new(1, -180, 0, 30) 
    label.Position = UDim2.new(0, 170, 0, 10 + (i - 1) * 35) 
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 22
    label.Text = line
end

local playerTab = tabFrames["Player"]

local playerListFrame = Instance.new("ScrollingFrame", playerTab)
playerListFrame.Size = UDim2.new(0.4, -10, 1, -10)
playerListFrame.Position = UDim2.new(0, 5, 0, 5)
playerListFrame.BackgroundColor3 = Color3.fromRGB(35, 0, 50)
playerListFrame.BorderSizePixel = 0
playerListFrame.ScrollBarThickness = 6
playerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

local playerListLayout = Instance.new("UIListLayout", playerListFrame)
playerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
playerListLayout.Padding = UDim.new(0, 4)

playerListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    playerListFrame.CanvasSize = UDim2.new(0, 0, 0, playerListLayout.AbsoluteContentSize.Y)
end)

local detailFrame = Instance.new("Frame", playerTab)
detailFrame.Size = UDim2.new(0.6, -10, 1, -10)
detailFrame.Position = UDim2.new(0.4, 5, 0, 5)
detailFrame.BackgroundColor3 = Color3.fromRGB(25, 0, 40)
detailFrame.BorderSizePixel = 0

local profileImage = Instance.new("ImageLabel", detailFrame)
profileImage.Size = UDim2.new(0, 100, 0, 100)
profileImage.Position = UDim2.new(0, 10, 0, 10)
profileImage.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
profileImage.BorderColor3 = Color3.fromRGB(140, 0, 255)

local nameLabel = Instance.new("TextLabel", detailFrame)
nameLabel.Size = UDim2.new(1, -120, 0, 30)
nameLabel.Position = UDim2.new(0, 120, 0, 10)
nameLabel.BackgroundTransparency = 1
nameLabel.TextColor3 = Color3.new(1, 1, 1)
nameLabel.TextScaled = true
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.Font = Enum.Font.SourceSansBold
nameLabel.Text = "Choose player you want."

local buttonHolder = Instance.new("Frame", detailFrame)
buttonHolder.Size = UDim2.new(1, -20, 0, 120)
buttonHolder.Position = UDim2.new(0, 10, 0, 120)
buttonHolder.BackgroundTransparency = 1

local buttonLayout = Instance.new("UIListLayout", buttonHolder)
buttonLayout.Padding = UDim.new(0, 5)
buttonLayout.FillDirection = Enum.FillDirection.Horizontal
buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
buttonLayout.Wraps = true

local function createActionButton(name, callback)
    local button = Instance.new("TextButton", buttonHolder)
    button.Size = UDim2.new(0, 90, 0, 30)
    button.Text = name
    button.BackgroundColor3 = Color3.fromRGB(100, 0, 100)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.BorderSizePixel = 0
    button.MouseButton1Click:Connect(callback)
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer
selectedPlayer = nil

local function selectPlayer(p)
	if not p then
		return
	end

	selectedPlayer = p

	nameLabel.Text = p.Name
	local thumb = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
	profileImage.Image = thumb

	for _, child in ipairs(buttonHolder:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

    createActionButton("Fling", function()
    local function SkidFling(TargetPlayer)
    local Character = player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart

    local TCharacter = TargetPlayer.Character
    local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter and TCharacter:FindFirstChild("Head")
    local Accessory = TCharacter and TCharacter:FindFirstChildOfClass("Accessory")
    local Handle = Accessory and Accessory:FindFirstChild("Handle")

    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end
        if THumanoid and THumanoid.Sit then return end

        if THead then
            workspace.CurrentCamera.CameraSubject = THead
        elseif Handle then
            workspace.CurrentCamera.CameraSubject = Handle
        else
            workspace.CurrentCamera.CameraSubject = THumanoid
        end

        if not TCharacter:FindFirstChildWhichIsA("BasePart") then return end

        local function FPos(BasePart, Pos, Ang)
            RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
            Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
            RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end

        local function SFBasePart(BasePart)
            local TimeToWait = 2
            local Time = tick()
            local Angle = 0

            repeat
                if RootPart and THumanoid then
                    if BasePart.Velocity.Magnitude < 50 then
                        Angle = Angle + 100
                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                    else
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                    end
                else
                    break
                end
            until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
        end

        workspace.FallenPartsDestroyHeight = 0/0

        local BV = Instance.new("BodyVelocity")
        BV.Name = "EpixVel"
        BV.Parent = RootPart
        BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
        BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)

        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

        if TRootPart and THead then
            if (TRootPart.Position - THead.Position).Magnitude > 5 then
                SFBasePart(THead)
            else
                SFBasePart(TRootPart)
            end
        elseif TRootPart then
            SFBasePart(TRootPart)
        elseif THead then
            SFBasePart(THead)
        elseif Handle then
            SFBasePart(Handle)
        else
            return
        end

        BV:Destroy()
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        workspace.CurrentCamera.CameraSubject = Humanoid

        repeat
            RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
            Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
            Humanoid:ChangeState("GettingUp")
            for _, x in ipairs(Character:GetChildren()) do
                if x:IsA("BasePart") then
                    x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                end
            end
            task.wait()
        until (RootPart.Position - getgenv().OldPos.Position).Magnitude < 25

        workspace.FallenPartsDestroyHeight = getgenv().FPDH
    end
end

    local TargetPlayer = selectedPlayer
    if not TargetPlayer or TargetPlayer == player then return end

    local Character = player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart

    local TCharacter = TargetPlayer.Character
    local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter and TCharacter:FindFirstChild("Head")
    local Accessory = TCharacter and TCharacter:FindFirstChildOfClass("Accessory")
    local Handle = Accessory and Accessory:FindFirstChild("Handle")

    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end
        if THumanoid and THumanoid.Sit then return end

        if THead then
            workspace.CurrentCamera.CameraSubject = THead
        elseif Handle then
            workspace.CurrentCamera.CameraSubject = Handle
        else
            workspace.CurrentCamera.CameraSubject = THumanoid
        end

        if not TCharacter:FindFirstChildWhichIsA("BasePart") then return end

        local function FPos(BasePart, Pos, Ang)
            RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
            Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
            RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end

        local function SFBasePart(BasePart)
            local TimeToWait = 2
            local Time = tick()
            local Angle = 0

            repeat
                if RootPart and THumanoid then
                    if BasePart.Velocity.Magnitude < 50 then
                        Angle += 100
                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                    else
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                    end
                else
                    break
                end
            until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
        end

        workspace.FallenPartsDestroyHeight = 0/0

        local BV = Instance.new("BodyVelocity")
        BV.Name = "EpixVel"
        BV.Parent = RootPart
        BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
        BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

        if TRootPart and THead then
            if (TRootPart.Position - THead.Position).Magnitude > 5 then
                SFBasePart(THead)
            else
                SFBasePart(TRootPart)
            end
        elseif TRootPart then
            SFBasePart(TRootPart)
        elseif THead then
            SFBasePart(THead)
        elseif Handle then
            SFBasePart(Handle)
        else
            return
        end

        BV:Destroy()
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        workspace.CurrentCamera.CameraSubject = Humanoid

        repeat
            RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
            Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
            Humanoid:ChangeState("GettingUp")
            for _, x in ipairs(Character:GetChildren()) do
                if x:IsA("BasePart") then
                    x.Velocity = Vector3.zero
                    x.RotVelocity = Vector3.zero
                end
            end
            task.wait()
        until (RootPart.Position - getgenv().OldPos.Position).Magnitude < 25
getgenv().FPDH = getgenv().FPDH or -500  

local height = tonumber(getgenv().FPDH)
if height then
    workspace.FallenPartsDestroyHeight = height
else
    workspace.FallenPartsDestroyHeight = -500
end
    end
end)

createActionButton("Spin", function()
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local camera = workspace.CurrentCamera
    if not selectedPlayer then return end
    local targetChar = selectedPlayer.Character
    if not humanoid or not hrp or not targetChar then return end
    local targetHead = targetChar:FindFirstChild("Head")
    if not targetHead then return end

    _G.isSpinning = _G.isSpinning or {}

    if _G.isSpinning[selectedPlayer] then
        local data = _G.isSpinning[selectedPlayer]
        if data.connection then
            data.connection:Disconnect()
        end

        camera.CameraSubject = humanoid
        camera.CameraType = Enum.CameraType.Custom

        humanoid.PlatformStand = false
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)

        if data.originalCFrame then
            hrp.CFrame = data.originalCFrame
            char:SetPrimaryPartCFrame(data.originalCFrame)
        end

        _G.isSpinning[selectedPlayer] = nil
        return
    end

    local originalCFrame = hrp.CFrame
    humanoid.PlatformStand = true
    hrp.Anchored = false

    camera.CameraSubject = targetHead
    camera.CameraType = Enum.CameraType.Custom

    local runService = game:GetService("RunService")
    local angle = 0

    local connection
    connection = runService.Heartbeat:Connect(function()
        if not char.Parent or not targetChar.Parent or _G.isSpinning[selectedPlayer] == nil then
            connection:Disconnect()
            humanoid.PlatformStand = false
            camera.CameraSubject = humanoid
            camera.CameraType = Enum.CameraType.Custom
            return
        end

        angle = (angle + 30) % 360
        local radians = math.rad(angle)
        local offset = Vector3.new(math.cos(radians) * 3, 0, math.sin(radians) * 3)

        local newPos = targetHead.Position + offset
        hrp.CFrame = CFrame.new(newPos, targetHead.Position)
    end)

    _G.isSpinning[selectedPlayer] = {
        connection = connection,
        originalCFrame = originalCFrame,
    }
end)

local activeESP = {}

createActionButton("ESP", function()
    if not selectedPlayer or selectedPlayer == player then return end

    local function removeESP(char)
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                for _, child in ipairs(part:GetChildren()) do
                    if child:IsA("BoxHandleAdornment") and child.Name == "ESPBox" then
                        child:Destroy()
                    end
                end
            end
        end

        local head = char:FindFirstChild("Head")
        if head then
            for _, adorn in ipairs(head:GetChildren()) do
                if adorn:IsA("BillboardGui") and adorn.Name == "NameTagESP" then
                    adorn:Destroy()
                end
            end
        end
    end

    local function applyESP(char)
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                local box = Instance.new("BoxHandleAdornment")
                box.Name = "ESPBox"
                box.Adornee = part
                box.AlwaysOnTop = true
                box.ZIndex = 10
                box.Size = part.Size + Vector3.new(0.1, 0.1, 0.1)
                box.Transparency = 0.25
                box.Color3 = Color3.new(1, 0, 0)
                box.Parent = part
            end
        end

        local head = char:FindFirstChild("Head")
        if head then
            local tag = Instance.new("BillboardGui")
            tag.Name = "NameTagESP"
            tag.Adornee = head
            tag.Size = UDim2.new(0, 200, 0, 50)
            tag.StudsOffset = Vector3.new(0, 2.5, 0)
            tag.AlwaysOnTop = true

            local text = Instance.new("TextLabel")
            text.Size = UDim2.new(1, 0, 1, 0)
            text.BackgroundTransparency = 1
            text.TextColor3 = Color3.new(1, 1, 0)
            text.TextStrokeTransparency = 0.5
            text.Font = Enum.Font.SourceSansBold
            text.TextScaled = true
            text.Text = selectedPlayer.DisplayName .. " (@" .. selectedPlayer.Name .. ")"
            text.Parent = tag

            tag.Parent = head
        end
    end

    if activeESP[selectedPlayer] then
        if selectedPlayer.Character then
            removeESP(selectedPlayer.Character)
        end

    
        if activeESP[selectedPlayer].connection then
            activeESP[selectedPlayer].connection:Disconnect()
        end

        activeESP[selectedPlayer] = nil
    else
       
        if selectedPlayer.Character then
            applyESP(selectedPlayer.Character)
        end

        local conn = selectedPlayer.CharacterAdded:Connect(function(char)
            applyESP(char)
        end)

        activeESP[selectedPlayer] = {
            connection = conn
        }
    end
end)

createActionButton("Aim lock", function()
    local localPlayer = game.Players.LocalPlayer
    local character = localPlayer.Character
    local camera = workspace.CurrentCamera

    if not character or not character:FindFirstChild("HumanoidRootPart") then
        warn("nil character")
        return
    end

    if not selectedPlayer or not selectedPlayer.Character or not selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        warn("unexpect player")
        return
    end

    if _G.AimlockConnection then
        _G.AimlockConnection:Disconnect()
        _G.AimlockConnection = nil
        _G.AimlockTarget = nil
        warn("unaimlocked")
        return
    end

    _G.AimlockTarget = selectedPlayer

    _G.AimlockConnection = game:GetService("RunService").RenderStepped:Connect(function()
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        if not _G.AimlockTarget or not _G.AimlockTarget.Character or not _G.AimlockTarget.Character:FindFirstChild("HumanoidRootPart") then return end

        local myHRP = character.HumanoidRootPart
        local targetHRP = _G.AimlockTarget.Character.HumanoidRootPart

        local myPos = myHRP.Position
        local targetPos = targetHRP.Position

        local direction = Vector3.new(targetPos.X - myPos.X, 0, targetPos.Z - myPos.Z)
        if direction.Magnitude > 0 then
            direction = direction.Unit
            myHRP.CFrame = CFrame.new(myPos, myPos + direction)
        end

    end)

    warn("aimlock person:", _G.AimlockTarget.Name)
end)

local bringEnabled = false
local runService = game:GetService("RunService")
local localPlayer = game.Players.LocalPlayer

local connection 

createActionButton("Character Bring", function()
    bringEnabled = not bringEnabled

    if bringEnabled then
        connection = runService.RenderStepped:Connect(function()
            local targetPlayer = selectedPlayer
            if not targetPlayer or targetPlayer == localPlayer then return end

            local localChar = localPlayer.Character
            local targetChar = targetPlayer.Character
            if not localChar or not targetChar then return end

            local localHRP = localChar:FindFirstChild("HumanoidRootPart")
            local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
            if not localHRP or not targetHRP then return end

            local frontPos = localHRP.CFrame.Position + (localHRP.CFrame.LookVector * 2)
            local newCFrame = CFrame.new(frontPos, frontPos + localHRP.CFrame.LookVector)
            targetHRP.CFrame = newCFrame
        end)
    else

        if connection then
            connection:Disconnect()
            connection = nil
        end
    end
end)

local frozenPlayers = {}

createActionButton("Hitbox Freeze", function()
    if not selectedPlayer or not selectedPlayer.Character then return end

    local character = selectedPlayer.Character
    local isFrozen = frozenPlayers[selectedPlayer] or false

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Anchored = not isFrozen
        end
    end

    frozenPlayers[selectedPlayer] = not isFrozen
end)

createActionButton("Reality pov", function()
    local player = game.Players.LocalPlayer
    local camera = workspace.CurrentCamera
    if not selectedPlayer then return end
    local targetChar = selectedPlayer.Character
    if not targetChar then return end
    local targetHead = targetChar:FindFirstChild("Head")
    if not targetHead then return end

    _G.isFirstPersonLock = _G.isFirstPersonLock or {}

    if _G.isFirstPersonLock[selectedPlayer] then
        local data = _G.isFirstPersonLock[selectedPlayer]
        if data.connection then
            data.connection:Disconnect()
        end

        camera.CameraType = Enum.CameraType.Custom
        camera.CameraSubject = player.Character and player.Character:FindFirstChildOfClass("Humanoid") or nil

        _G.isFirstPersonLock[selectedPlayer] = nil
        return
    end

    camera.CameraType = Enum.CameraType.Custom
    camera.CameraSubject = targetChar:FindFirstChildOfClass("Humanoid")

    local runService = game:GetService("RunService")
    local connection
    connection = runService.RenderStepped:Connect(function()
        if not player.Character or not selectedPlayer or not selectedPlayer.Character then
            camera.CameraSubject = player.Character and player.Character:FindFirstChildOfClass("Humanoid") or nil
            camera.CameraType = Enum.CameraType.Custom
            if connection then connection:Disconnect() end
            _G.isFirstPersonLock[selectedPlayer] = nil
            return
        end

        local lookVector = camera.CFrame.LookVector
        local camPos = targetHead.Position + (lookVector * 0.5) 

        camera.CFrame = CFrame.new(camPos, camPos + lookVector)
    end)

    _G.isFirstPersonLock[selectedPlayer] = {
        connection = connection,
    }
end)

createActionButton("View pov", function()
    local camera = workspace.CurrentCamera
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    if not selectedPlayer then return end

    if camera.CameraSubject == (selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("Head")) then

        if player.Character and player.Character:FindFirstChild("Head") then
            camera.CameraSubject = player.Character.Head
            camera.CameraType = Enum.CameraType.Custom
        end

        if rotateConnection then
            rotateConnection:Disconnect()
            rotateConnection = nil
        end
    else
        local targetChar = selectedPlayer.Character
        local targetHead = targetChar and targetChar:FindFirstChild("Head")
        if targetHead then
            camera.CameraSubject = targetHead
            camera.CameraType = Enum.CameraType.Custom

            if rotateConnection then
                rotateConnection:Disconnect()
            end

            rotateConnection = RunService.RenderStepped:Connect(function()
            end)
        end
    end
end)

createActionButton("Bring kill", function()
    bringEnabled = not bringEnabled

    local toggle = true
    local heartbeatTask
    if bringEnabled then
        heartbeatTask = task.spawn(function()
            while bringEnabled do
                local targetPlayer = selectedPlayer
                if not targetPlayer or targetPlayer == localPlayer then task.wait(0.2) continue end

                local localChar = localPlayer.Character
                local targetChar = targetPlayer.Character
                if not localChar or not targetChar then task.wait(0.2) continue end

                local localHRP = localChar:FindFirstChild("HumanoidRootPart")
                local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
                if not localHRP or not targetHRP then task.wait(0.2) continue end

                local distance = toggle and 7 or 2
                toggle = not toggle

                local frontPos = localHRP.CFrame.Position + (localHRP.CFrame.LookVector * distance)
                local newCFrame = CFrame.new(frontPos, frontPos + localHRP.CFrame.LookVector)
                targetHRP.CFrame = newCFrame

                task.wait(0.001)
            end
        end)
    else
        bringEnabled = false
    end
end)

createActionButton("FTI Kill", function()
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local hrp = character:FindFirstChild("HumanoidRootPart")

    _G.FTI_Toggled = _G.FTI_Toggled or false
    _G.FTI_Connection = _G.FTI_Connection or nil
    _G.FTI_OriginalCFrame = _G.FTI_OriginalCFrame or nil

    local function getBodyParts(character)
        local parts = {}
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and not part:IsA("Accessory") then
                table.insert(parts, part)
            end
        end
        return parts
    end

    local function startTouchLoop()
        if not selectedPlayer or not selectedPlayer.Character then return end

        if hrp then
            _G.FTI_OriginalCFrame = hrp.CFrame
        end

        local targetParts = getBodyParts(selectedPlayer.Character)

        _G.FTI_Connection = task.spawn(function()
            while _G.FTI_Toggled and localPlayer.Character and (localPlayer.Character:FindFirstChild("RightHand") or localPlayer.Character:FindFirstChild("Right Arm")) do
                local arm = localPlayer.Character:FindFirstChild("RightHand") or localPlayer.Character:FindFirstChild("Right Arm")
                for _, part in ipairs(targetParts) do
                    firetouchinterest(arm, part, 0)
                    task.wait(0.05)
                    firetouchinterest(arm, part, 1)
                end
                task.wait(0.1)
            end
        end)
    end

    local function stopTouchLoop()
        _G.FTI_Toggled = false
        if _G.FTI_Connection then
            task.cancel(_G.FTI_Connection)
            _G.FTI_Connection = nil
        end

        local char = localPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if _G.FTI_OriginalCFrame and hrp then
            hrp.CFrame = _G.FTI_OriginalCFrame
        end
        _G.FTI_OriginalCFrame = nil
    end

    if not _G.FTI_Toggled then
        _G.FTI_Toggled = true
        startTouchLoop()
    else
        stopTouchLoop()
    end
end)

createActionButton("loopgoto", function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")

    local localPlayer = Players.LocalPlayer
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root or not selectedPlayer then return end

    _G._following = _G._following or false
    _G._savedCFrame = _G._savedCFrame or nil
    _G._followConnection = _G._followConnection or nil

    if not _G._following then
        _G._following = true
        _G._savedCFrame = root.CFrame

        _G._followConnection = RunService.Heartbeat:Connect(function()
            local targetChar = selectedPlayer.Character
            local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
            if targetRoot and root then
                root.CFrame = targetRoot.CFrame + Vector3.new(0, 0, 2)
            end
        end)
    else
        _G._following = false

        if _G._followConnection then
            _G._followConnection:Disconnect()
            _G._followConnection = nil
        end

        if _G._savedCFrame then
            root.CFrame = _G._savedCFrame
            _G._savedCFrame = nil
        end
    end
end)

local savedPositions = {}

createActionButton("goto", function()
    if not selectedPlayer then return end
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    local targetCharacter = selectedPlayer.Character

    if character and character:FindFirstChild("HumanoidRootPart") then
        savedPositions["GOTO"] = character.HumanoidRootPart.CFrame
        print("현재 위치 GOTO로 저장됨")
    end

    if character and character:FindFirstChild("HumanoidRootPart") and targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = targetCharacter.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
        print("선택 플레이어에게 텔레포트 완료")
    end
end)

createActionButton("goto back", function()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character

    if character and character:FindFirstChild("HumanoidRootPart") and savedPositions["GOTO"] then
        character.HumanoidRootPart.CFrame = savedPositions["GOTO"]
        print("저장된 GOTO 위치로 복귀 완료")
    else
        print("저장된 GOTO 위치가 없습니다.")
    end
end)

local function SkidFling(TargetPlayer)
    local Character = player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart

    local TCharacter = TargetPlayer.Character
    local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter and TCharacter:FindFirstChild("Head")
    local Accessory = TCharacter and TCharacter:FindFirstChildOfClass("Accessory")
    local Handle = Accessory and Accessory:FindFirstChild("Handle")

    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end
        if THumanoid and THumanoid.Sit then return end

        if THead then
            workspace.CurrentCamera.CameraSubject = THead
        elseif Handle then
            workspace.CurrentCamera.CameraSubject = Handle
        else
            workspace.CurrentCamera.CameraSubject = THumanoid
        end

        if not TCharacter:FindFirstChildWhichIsA("BasePart") then return end

        local function FPos(BasePart, Pos, Ang)
            RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
            Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
            RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end

        local function SFBasePart(BasePart)
            local TimeToWait = 2
            local Time = tick()
            local Angle = 0

            repeat
                if RootPart and THumanoid then
                    if BasePart.Velocity.Magnitude < 50 then
                        Angle = Angle + 100
                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                        FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                    else
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                    end
                else
                    break
                end
            until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
        end

        workspace.FallenPartsDestroyHeight = 0/0

        local BV = Instance.new("BodyVelocity")
        BV.Name = "EpixVel"
        BV.Parent = RootPart
        BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
        BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

        if TRootPart and THead then
            if (TRootPart.Position - THead.Position).Magnitude > 5 then
                SFBasePart(THead)
            else
                SFBasePart(TRootPart)
            end
        elseif TRootPart then
            SFBasePart(TRootPart)
        elseif THead then
            SFBasePart(THead)
        elseif Handle then
            SFBasePart(Handle)
        else
            return
        end

        BV:Destroy()
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        workspace.CurrentCamera.CameraSubject = Humanoid

        repeat
            RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
            Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
            Humanoid:ChangeState("GettingUp")
            for _, x in ipairs(Character:GetChildren()) do
                if x:IsA("BasePart") then
                    x.Velocity = Vector3.zero
                    x.RotVelocity = Vector3.zero
                end
            end
            task.wait()
        until (RootPart.Position - getgenv().OldPos.Position).Magnitude < 25

        getgenv().FPDH = getgenv().FPDH or -500
        local height = tonumber(getgenv().FPDH)
        if height then
            workspace.FallenPartsDestroyHeight = height
        else
            workspace.FallenPartsDestroyHeight = -500
        end
    end
end

local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")

local Admins = {}

local function WaitForRBXGeneral()
    while not TextChatService.TextChannels:FindFirstChild("RBXGeneral") do
        task.wait()
    end
    return TextChatService.TextChannels.RBXGeneral
end

local function SendChatMessage(message)
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local textChannel = WaitForRBXGeneral()
        textChannel:SendAsync(message)
    else
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
    end
end

local function GetPlayerByPartialName(namePart)
    namePart = namePart:lower()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Name:lower():sub(1, #namePart) == namePart then
            return plr
        end
    end
    return nil
end

local function ToggleAdmin(plr)
    local idx = table.find(Admins, plr)
    if idx then
        table.remove(Admins, idx)
        SendChatMessage(plr.Name .. " has been deleted in admin list.")
    else
        table.insert(Admins, plr)
        SendChatMessage(plr.Name .. " is admin now! say '?cmds' to commands you can use.")
    end
end

createActionButton("Give Admin", function()
    if not selectedPlayer then
        SendChatMessage("Select player!")
        return
    end
    ToggleAdmin(selectedPlayer)
end)

local function OnPlayerChatted(player, message)
    if not table.find(Admins, player) then
        return
    end

    message = message:lower()

    if message == "?cmds" then
        SendChatMessage("commands you can use : ;fling (player)")
    elseif message:sub(1,6) == ";fling" then
        local targetName = message:sub(8)
        local targetPlayer = GetPlayerByPartialName(targetName)
        if targetPlayer then
            local localPlayer = Players.LocalPlayer
            if localPlayer and localPlayer.Character then
                SkidFling(targetPlayer)
            end
        else
            SendChatMessage("can't find player! : " .. targetName)
        end
    end
end

for _, plr in ipairs(Players:GetPlayers()) do
    plr.Chatted:Connect(function(msg)
        OnPlayerChatted(plr, msg)
    end)
end

Players.PlayerAdded:Connect(function(plr)
    plr.Chatted:Connect(function(msg)
        OnPlayerChatted(plr, msg)
    end)
end)
    end
if character and character:FindFirstChild("HumanoidRootPart") and targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = targetCharacter.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
    end

local function addPlayerToList(p)
    if p == player then return end

    for _, child in ipairs(playerListFrame:GetChildren()) do
        if child:IsA("TextButton") and child.Text == p.Name then
            return
        end
    end

    local button = Instance.new("TextButton", playerListFrame)
    button.Size = UDim2.new(1, -10, 0, 30)
    button.Text = p.Name
    button.BackgroundColor3 = Color3.fromRGB(70, 0, 100)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.BorderSizePixel = 0
    button.MouseButton1Click:Connect(function()
        selectPlayer(p)
    end)
	local playerButtons = {}

local function createPlayerButton(p)
	local button = Instance.new("TextButton", playerListFrame)
	button.Size = UDim2.new(1, -10, 0, 30)
	button.Text = p.Name
	button.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.BorderSizePixel = 0
	button.LayoutOrder = p.UserId

	button.MouseButton1Click:Connect(function()
		selectPlayer(p)
	end)

	playerButtons[p.UserId] = button
end

for _, p in ipairs(Players:GetPlayers()) do
	if p ~= player then
		createPlayerButton(p)
	end
end

Players.PlayerAdded:Connect(function(p)
	createPlayerButton(p)
end)

Players.PlayerRemoving:Connect(function(p)
	local button = playerButtons[p.UserId]
	if button and button.Parent then
		button:Destroy()
	end
	playerButtons[p.UserId] = nil
end)

local Players = game:GetService("Players")

Players.PlayerRemoving:Connect(function(removedPlayer)
	for _, button in ipairs(playerListFrame:GetChildren()) do
		if button:IsA("TextButton") and button.Text == removedPlayer.Name then
			button:Destroy()
		end
	end

if selectedPlayer == removedPlayer then
		selectPlayer(nil)
	end
end)

local function refreshPlayerList()
	for _, child in ipairs(playerListFrame:GetChildren()) do
		if child:IsA("TextButton") and child ~= serverButton then
			child:Destroy()
		end
	end

	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player then 
			local button = Instance.new("TextButton")
			button.Size = UDim2.new(1, -10, 0, 30)
			button.Text = p.Name
			button.BackgroundColor3 = Color3.fromRGB(70, 0, 120)
			button.TextColor3 = Color3.new(1, 1, 1)
			button.BorderSizePixel = 0
			button.Parent = playerListFrame

			button.MouseButton1Click:Connect(function()
				selectPlayer(p)
			end)
		end
	end
end

refreshPlayerList()

Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(function()
	refreshPlayerList()
end)

local connected = false

if not connected then
    Players.PlayerAdded:Connect(refreshPlayerList)
    Players.PlayerRemoving:Connect(refreshPlayerList)
    connected = true
end
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

local function refreshPlayerList()
    print("Refreshing Player List...")

    for _, child in ipairs(playerListFrame:GetChildren()) do
        if child:IsA("TextButton") and child ~= serverButton then
            child:Destroy()
        end
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= Players.LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 30)
            btn.Text = p.Name
            btn.BackgroundColor3 = Color3.fromRGB(80, 0, 100)
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.BorderSizePixel = 0
            btn.Parent = playerListFrame

            btn.MouseButton1Click:Connect(function()
                selectPlayer(p)
            end)
        end
    end
end

Players.PlayerAdded:Connect(function()
    task.wait(0.1)
    refreshPlayerList()
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.1)
    refreshPlayerList()
end)

refreshPlayerList()
end

local ServerTab = tabFrames["Server"]

local function countServerButtons()
    local count = 0
    for _, child in pairs(ServerTab:GetChildren()) do
        if child:IsA("TextButton") then
            count = count + 1
        end
    end
    return count
end

local function createServerButton(name, callback)
    local serverButton = Instance.new("TextButton")
    serverButton.Size = UDim2.new(0, 100, 0, 30)
    
    local existingButtons = countServerButtons()
    serverButton.Position = UDim2.new(0, 10, 0, 10 + existingButtons * 40)
    
    serverButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    serverButton.BackgroundTransparency = 0.6
    serverButton.BorderSizePixel = 0
    serverButton.Text = name
    serverButton.TextColor3 = Color3.new(1, 1, 1)
    serverButton.Font = Enum.Font.GothamSemibold
    serverButton.TextSize = 12

    serverButton.MouseEnter:Connect(function()
        serverButton.BackgroundTransparency = 0.3
    end)

    serverButton.MouseLeave:Connect(function()
        serverButton.BackgroundTransparency = 0.6
    end)

    serverButton.MouseButton1Click:Connect(function()
        serverButton:TweenSize(UDim2.new(0, 110, 0, 33), "Out", "Quad", 0.15, true)
        wait(0.15)
        serverButton:TweenSize(UDim2.new(0, 100, 0, 30), "Out", "Quad", 0.15, true)
        if callback then
            callback()
        end
    end)

    serverButton.Parent = ServerTab
end

createServerButton("Fling all", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/rvYNTuF8"))()
end)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

createServerButton("FTIKill all", function()
    local bringKillToggled = not _G.BringKillToggled
    _G.BringKillToggled = bringKillToggled

    if bringKillToggled then
        local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        _G.BringKillOriginalCFrame = hrp.CFrame

        local function getBodyParts(char)
            local parts = {}
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and not part:IsA("Accessory") then
                    table.insert(parts, part)
                end
            end
            return parts
        end

        _G.BringKillConnection = task.spawn(function()
            while _G.BringKillToggled do
                local arm = character:FindFirstChild("RightHand") or character:FindFirstChild("Right Arm")
                if not arm then break end

                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= localPlayer and plr.Character then
                        local parts = getBodyParts(plr.Character)
                        for _, part in ipairs(parts) do
                            firetouchinterest(arm, part, 0)
                            task.wait(0.05)
                            firetouchinterest(arm, part, 1)
                        end
                    end
                end

                task.wait(0.1)
            end
        end)

    else
        if _G.BringKillConnection then
            task.cancel(_G.BringKillConnection)
            _G.BringKillConnection = nil
        end

        local char = localPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and _G.BringKillOriginalCFrame then
            hrp.CFrame = _G.BringKillOriginalCFrame
        end

        _G.BringKillOriginalCFrame = nil
    end
end)

local activeESP = {}

createServerButton("ESP All", function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local function removeESP(char)
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                for _, child in ipairs(part:GetChildren()) do
                    if child:IsA("BoxHandleAdornment") and child.Name == "ESPBox" then
                        child:Destroy()
                    end
                end
            end
        end

        local head = char:FindFirstChild("Head")
        if head then
            for _, adorn in ipairs(head:GetChildren()) do
                if adorn:IsA("BillboardGui") and adorn.Name == "NameTagESP" then
                    adorn:Destroy()
                end
            end
        end
    end

    local function applyESP(char, player)
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                local box = Instance.new("BoxHandleAdornment")
                box.Name = "ESPBox"
                box.Adornee = part
                box.AlwaysOnTop = true
                box.ZIndex = 10
                box.Size = part.Size + Vector3.new(0.1, 0.1, 0.1)
                box.Transparency = 0.25
                box.Color3 = Color3.new(1, 0, 0)
                box.Parent = part
            end
        end

        local head = char:FindFirstChild("Head")
        if head then
            local tag = Instance.new("BillboardGui")
            tag.Name = "NameTagESP"
            tag.Adornee = head
            tag.Size = UDim2.new(0, 200, 0, 50)
            tag.StudsOffset = Vector3.new(0, 2.5, 0)
            tag.AlwaysOnTop = true

            local text = Instance.new("TextLabel")
            text.Size = UDim2.new(1, 0, 1, 0)
            text.BackgroundTransparency = 1
            text.TextColor3 = Color3.new(1, 1, 0)
            text.TextStrokeTransparency = 0.5
            text.Font = Enum.Font.SourceSansBold
            text.TextScaled = true
            text.Text = player.DisplayName .. " (@" .. player.Name .. ")"
            text.Parent = tag

            tag.Parent = head
        end
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if activeESP[plr] then
                if plr.Character then
                    removeESP(plr.Character)
                end
                if activeESP[plr].connection then
                    activeESP[plr].connection:Disconnect()
                end
                activeESP[plr] = nil
            else
                if plr.Character then
                    applyESP(plr.Character, plr)
                end
                local conn = plr.CharacterAdded:Connect(function(char)
                    applyESP(char, plr)
                end)
                activeESP[plr] = {
                    connection = conn
                }
            end
        end
    end
end)

createServerButton("Kick Shutdown", function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local function hideCharacter(player)
        local char = player.Character
        if not char then return end

        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
                part.CanCollide = false
            elseif part:IsA("Decal") then
                part.Transparency = 1
            elseif part:IsA("Accessory") then
                for _, accPart in ipairs(part:GetDescendants()) do
                    if accPart:IsA("BasePart") then
                        accPart.Transparency = 1
                        accPart.CanCollide = false
                    elseif accPart:IsA("Decal") then
                        accPart.Transparency = 1
                    end
                end
            end
        end

        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        end
    end

    local function destroyCharacter(player)
        if player.Character then
            player:Destroy()
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            hideCharacter(player)
            destroyCharacter(player)
        end
    end

    task.delay(1.5, function()
        hideCharacter(LocalPlayer)
        destroyCharacter(LocalPlayer)
    end)
end)

createServerButton("Console message all", function()
    local local_player = game:GetService("Players").LocalPlayer
local animate = local_player.Character.Animate
local idle_anim = animate.idle.Animation1

local old_animid = idle_anim.AnimationId
animate.Enabled = true
idle_anim.AnimationId = "active://This is a message from polaria+T0PK3K Remake ui, anyone can see this! say Hello!"
task.wait()
animate.Enabled = false
animate.Enabled = true
idle_anim.AnimationId = old_animid
task.wait()
animate.Enabled = false
animate.Enabled = true
end)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

createServerButton("BringKill all", function()
    _G.BringKillEnabled = not _G.BringKillEnabled
    local toggle = true

    if _G.BringKillEnabled then
        _G.BringKillConnection = task.spawn(function()
            while _G.BringKillEnabled do
                local localChar = localPlayer.Character
                local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")
                if not localHRP then task.wait(0.1) continue end

                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= localPlayer then
                        local targetChar = plr.Character
                        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                        if targetHRP then
                            local distance = toggle and 7 or 3
                            local frontPos = localHRP.Position + (localHRP.CFrame.LookVector * distance)
                            local newCFrame = CFrame.new(frontPos, frontPos + localHRP.CFrame.LookVector)
                            targetHRP.CFrame = newCFrame
                        end
                    end
                end

                toggle = not toggle
                task.wait(0.03)
            end
        end)
    else
        if _G.BringKillConnection then
            task.cancel(_G.BringKillConnection)
            _G.BringKillConnection = nil
        end
    end
end)

local executorTab = tabFrames["Executor"]

local consoleFrame = Instance.new("ScrollingFrame", executorTab)
consoleFrame.Size = UDim2.new(1, -20, 0.4, -50)
consoleFrame.Position = UDim2.new(0, 10, 0.55, 10)
consoleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
consoleFrame.BorderSizePixel = 0
consoleFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
consoleFrame.ScrollBarThickness = 6

local consoleLayout = Instance.new("UIListLayout", consoleFrame)
consoleLayout.SortOrder = Enum.SortOrder.LayoutOrder
consoleLayout.Padding = UDim.new(0, 2)

local inputBox = Instance.new("TextBox", executorTab)
inputBox.Size = UDim2.new(1, -20, 0.4, -10)
inputBox.Position = UDim2.new(0, 10, 0, 10)
inputBox.MultiLine = true
inputBox.TextWrapped = true
inputBox.ClearTextOnFocus = false
inputBox.Text = "-- Luau code here"
inputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
inputBox.TextColor3 = Color3.new(1, 1, 1)
inputBox.Font = Enum.Font.Code
inputBox.TextSize = 16

local runButton = Instance.new("TextButton", executorTab)
runButton.Size = UDim2.new(0, 100, 0, 40)
runButton.Position = UDim2.new(1, -110, 1, -50)
runButton.Text = "Execute"
runButton.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
runButton.TextColor3 = Color3.new(1, 1, 1)
runButton.Font = Enum.Font.SourceSansBold
runButton.TextSize = 18

local statusLabel = Instance.new("TextLabel", executorTab)
statusLabel.Size = UDim2.new(0, 180, 0, 40)
statusLabel.Position = UDim2.new(0, 10, 1, -50)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.Font = Enum.Font.SourceSansBold
statusLabel.TextSize = 18
statusLabel.Text = "Execute on : client"
statusLabel.Visible = true

local function addConsoleMessage(text, color)
	local msg = Instance.new("TextLabel")
	msg.Size = UDim2.new(1, -10, 0, 20)
	msg.BackgroundTransparency = 1
	msg.TextColor3 = color or Color3.new(1, 1, 1)
	msg.Font = Enum.Font.Code
	msg.TextSize = 14
	msg.TextXAlignment = Enum.TextXAlignment.Left
	msg.Text = text
	msg.Parent = consoleFrame

	task.wait()
	consoleFrame.CanvasSize = UDim2.new(0, 0, 0, consoleLayout.AbsoluteContentSize.Y + 10)
	consoleFrame.CanvasPosition = Vector2.new(0, consoleFrame.CanvasSize.Y.Offset)
end

_G.logToConsole = function(text, messageType)
	local colorMap = {
		info = Color3.fromRGB(200, 200, 200),
		warn = Color3.fromRGB(255, 200, 0),
		error = Color3.fromRGB(255, 100, 100),
		runtime = Color3.fromRGB(255, 50, 50),
		compile = Color3.fromRGB(255, 0, 0)
	}
	addConsoleMessage("[" .. messageType .. "] " .. text, colorMap[messageType] or Color3.fromRGB(255, 255, 255))
end

runButton.MouseButton1Click:Connect(function()
	local code = inputBox.Text

	local env = setmetatable({}, {__index = getfenv()})

	env.print = function(...)
		local args = {...}
		local text = ""
		for i, v in ipairs(args) do
			text = text .. tostring(v)
			if i < #args then
				text = text .. "\t"
			end
		end
		_G.logToConsole(text, "info")
	end

	env.warn = function(...)
		local args = {...}
		local text = "[warn] "
		for i, v in ipairs(args) do
			text = text .. tostring(v)
			if i < #args then
				text = text .. "\t"
			end
		end
		_G.logToConsole(text, "warn")
	end

	env.error = function(msg)
		_G.logToConsole(tostring(msg), "error")
	end

	local func, compileErr = loadstring(code)
	if func then
		setfenv(func, env)
		task.spawn(function()
			local success, runtimeErr = pcall(func)
			if not success then
				_G.logToConsole(runtimeErr, "runtime")
			end
		end)
	else
		_G.logToConsole(compileErr, "compile")
	end
end)

local scriptsTab = tabFrames["Scripts"]

local scriptList = {
    {
        Name = "Fe seraphic Blade",
        Code = [[
			print = function() end
warn = function() end
error = function() return end
            loadstring(game:HttpGet("https://pastefy.app/59mJGQGe/raw"))()
        ]]
    },
    {
        Name = "RC7",
        Code = [[
			print = function() end
warn = function() end
error = function() return end
            loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-RC7-7488"))()
        ]]
    },
    {
        Name = "Polaria",
        Code = [[
			print = function() end
warn = function() end
error = function() return end
            loadstring(game:HttpGet("https://pastefy.app/cDHeL11e/raw"))()
        ]]
    },
    {
        Name = "TSB star glitcher(any character)",
        Code = [[
			print = function() end
warn = function() end
error = function() return end
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Reapvitalized/TSB/refs/heads/main/SG_DEMO.lua"))()
        ]]
    },
    {
        Name = "John doe",
        Code = [[
			loadstring(game:HttpGet("https://rawscripts.net/raw/Client-Replication-John-doe-up-by-gojohdkaisenkt-34198"))()
        ]]
    },
    {
        Name = "DEX EXPLORER",
        Code = [[
			print = function() end
warn = function() end
error = function() return end
            loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Dex%20Explorer.txt"))()
        ]]
    },
        {
        Name = "T0PK3K old",
        Code = [[
			print = function() end
warn = function() end
error = function() return end
            loadstring(game:GetObjects('rbxassetid://376634699')[1].Source)()
        ]]
    }
}

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scriptsTab

for _, entry in ipairs(scriptList) do
    local button = Instance.new("TextButton", scriptsTab)
    button.Size = UDim2.new(1, -20, 0, 40)
    button.Position = UDim2.new(0, 10, 0, 10)
    button.Text = entry.Name
    button.BackgroundColor3 = Color3.fromRGB(0, 80, 130)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 16

    button.MouseButton1Click:Connect(function()
        local func, err = loadstring(entry.Code)
        if func then
            task.spawn(func)
        else
            print("")
        end
    end)

for _, p in ipairs(Players:GetPlayers()) do addPlayerToList(p) end
Players.PlayerAdded:Connect(addPlayerToList)
end

local adminTab = tabFrames["Admin Cmds"]

local commandsList = {
	"ALERT!! : This admin system is will not work on Legacy chat style",
    ";fling (player) {not work some game, fe}",
    ";to (player) {fe}",
	";toback",
    ";speed (amount) {client}",
	";unspeed",
    ";jumppower (amount) {client}",
	";unjumppower",
	";gravity (amount) {client}",
	";view (player)",
	";unview",
	";loopgoto (player) {fe}",
	";unloopgoto",
	";mimic (player) {fe}",
	";unmimic",
	";f3x {client}",
	";kick (player) {client}",
	";savepoint {client}",
	";adminscripts",
	";bringkill (player)",
	";unbringkill (player)"
}

local commandsText = Instance.new("TextLabel")
commandsText.Size = UDim2.new(1, -20, 1, -20)
commandsText.Position = UDim2.new(0, 10, 0, 10)
commandsText.BackgroundTransparency = 1
commandsText.TextColor3 = Color3.new(1, 1, 1)
commandsText.Font = Enum.Font.SourceSans
commandsText.TextSize = 16
commandsText.TextXAlignment = Enum.TextXAlignment.Left
commandsText.TextYAlignment = Enum.TextYAlignment.Top
commandsText.TextWrapped = true

commandsText.Text = table.concat(commandsList, "\n")

commandsText.Parent = adminTab

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function getRootPart(character)
    return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
end

local function getHead(character)
    return character:FindFirstChild("Head")
end

local function getAccessoryHandle(character)
    for _, accessory in ipairs(character:GetChildren()) do
        if accessory:IsA("Accessory") then
            local handle = accessory:FindFirstChild("Handle")
            if handle then return handle end
        end
    end
    return nil
end

local function SkidFling(TargetPlayer)
    if not TargetPlayer or TargetPlayer == player then return end
    local Character = player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Character and getRootPart(Character)

    local TCharacter = TargetPlayer.Character
    local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = TCharacter and getRootPart(TCharacter)
    local THead = TCharacter and getHead(TCharacter)
    local Handle = TCharacter and getAccessoryHandle(TCharacter)

    if not Character or not Humanoid or not RootPart or not TCharacter or not THumanoid then return end

    if not getgenv().OldPos or typeof(getgenv().OldPos) ~= "CFrame" then
        getgenv().OldPos = RootPart.CFrame
    elseif RootPart.Velocity.Magnitude < 50 then
        getgenv().OldPos = RootPart.CFrame
    end

    if THead then
        workspace.CurrentCamera.CameraSubject = THead
    elseif Handle then
        workspace.CurrentCamera.CameraSubject = Handle
    else
        workspace.CurrentCamera.CameraSubject = THumanoid
    end

    local function FPos(BasePart, Pos, Ang)
        if not RootPart or not RootPart.Parent then return end
        RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
        Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
        RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
        RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
    end

    local function SFBasePart(BasePart)
        local TimeToWait = 2
        local Time = tick()
        local Angle = 0

        repeat
            if not RootPart or not RootPart.Parent then break end
            if not THumanoid or THumanoid.Health <= 0 then break end
            if BasePart.Velocity.Magnitude < 50 then
                Angle = Angle + 100
                FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                task.wait()
                FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                task.wait()
                FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                task.wait()
                FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                task.wait()
            else
                FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                task.wait()
            end
        until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TCharacter or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
    end

    workspace.FallenPartsDestroyHeight = 0/0

    local oldBV = RootPart:FindFirstChild("EpixVel")
    if oldBV then oldBV:Destroy() end

    local BV = Instance.new("BodyVelocity")
    BV.Name = "EpixVel"
    BV.Parent = RootPart
    BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
    BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

    if TRootPart and THead then
        if (TRootPart.Position - THead.Position).Magnitude > 5 then
            SFBasePart(THead)
        else
            SFBasePart(TRootPart)
        end
    elseif TRootPart then
        SFBasePart(TRootPart)
    elseif THead then
        SFBasePart(THead)
    elseif Handle then
        SFBasePart(Handle)
    else
        BV:Destroy()
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        workspace.CurrentCamera.CameraSubject = Humanoid
        return
    end

    BV:Destroy()
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    workspace.CurrentCamera.CameraSubject = Humanoid

    repeat
        if not RootPart or not RootPart.Parent then break end
        RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
        Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
        Humanoid:ChangeState("GettingUp")
        for _, x in ipairs(Character:GetChildren()) do
            if x:IsA("BasePart") then
                x.Velocity = Vector3.new()
                x.RotVelocity = Vector3.new()
            end
        end
        task.wait()
    until (RootPart.Position - getgenv().OldPos.Position).Magnitude < 25 or Humanoid.Health <= 0

    workspace.FallenPartsDestroyHeight = tonumber(getgenv().FPDH) or -500
end

player.Chatted:Connect(function(msg)
    if msg:lower():sub(1,6) == ";fling" then
        local args = msg:split(" ")
        if #args < 2 then return end
        local query = args[2]:lower()

        local matches = {}
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player then
                local lowerName = plr.Name:lower()
                local lowerDisplayName = plr.DisplayName:lower()
                if lowerName:find(query) or lowerDisplayName:find(query) then
                    table.insert(matches, plr)
                end
            end
        end

        if #matches == 1 then
            SkidFling(matches[1])
        else
        end
    end
end)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local savedPositions = {}

local function findPlayerByNamePartial(namePart)
    namePart = namePart:lower()
    local foundPlayer = nil
    for _, plr in pairs(Players:GetPlayers()) do
        local displayName = plr.DisplayName:lower()
        local userName = plr.Name:lower()
        if userName == namePart or displayName == namePart or userName:find(namePart, 1, true) or displayName:find(namePart, 1, true) then
            if foundPlayer then
                return nil
            else
                foundPlayer = plr
            end
        end
    end
    return foundPlayer
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local savedPositions = {}

local function getRootPart(character)
    return character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso"))
end

local function findPlayerByNamePartial(name)
    name = name:lower()
    local matches = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        local lowerName = plr.Name:lower()
        local lowerDisplayName = plr.DisplayName:lower()
        if lowerName:find(name, 1, true) or lowerDisplayName:find(name, 1, true) then
            table.insert(matches, plr)
        end
    end
    if #matches == 1 then
        return matches[1]
    else
        return nil
    end
end

local function waitForRootPart(character)
    local rootPart = getRootPart(character)
    local tries = 0
    while not rootPart and tries < 20 do
        task.wait(0.1)
        rootPart = getRootPart(character)
        tries = tries + 1
    end
    return rootPart
end

local function toCommand(targetName)
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = waitForRootPart(character)
    if not rootPart then
        return
    end

    local targetPlayer = findPlayerByNamePartial(targetName)
    if not targetPlayer then
        return
    end

    local targetCharacter = targetPlayer.Character or targetPlayer.CharacterAdded:Wait()
    local targetRoot = waitForRootPart(targetCharacter)
    if not targetRoot then
        return
    end

    if not savedPositions["to"] then
        savedPositions["to"] = rootPart.CFrame
    end

    rootPart.CFrame = targetRoot._savedCFrame
end

local function tobackCommand()
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = waitForRootPart(character)
    if not rootPart then
        return
    end

    if not savedPositions["to"] then
        return
    end

    rootPart.CFrame = savedPositions["to"]
    savedPositions["to"] = nil
end

player.Chatted:Connect(function(msg)
    local args = msg:split(" ")
    local cmd = args[1]:lower()
    if cmd == ";to" and args[2] then
        toCommand(args[2])
    elseif cmd == ";toback" then
        tobackCommand()
    end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local humanoid = nil
local speedValue = 16
local jumpPowerValue = 50

RunService.Stepped:Connect(function()
	if humanoid then
		humanoid.WalkSpeed = speedValue
		humanoid.JumpPower = jumpPowerValue
	end
end)

local function updateHumanoid()
	local char = player.Character or player.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")
end
player.CharacterAdded:Connect(updateHumanoid)
updateHumanoid()

player.Chatted:Connect(function(msg)
	local args = msg:lower():split(" ")

	if args[1] == ";speed" and tonumber(args[2]) then
		local val = tonumber(args[2])
		speedValue = math.clamp(val, 0, 1000)

	elseif args[1] == ";jump" and tonumber(args[2]) then
		local val = tonumber(args[2])
		jumpPowerValue = math.clamp(val, 0, 1000)

	elseif msg:lower() == ";unspeed" then
		speedValue = 16

	elseif msg:lower() == ";unjumppower" then
		jumpPowerValue = 50
	end
end)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local flying = false
local bodyGyro, bodyVel
local direction = Vector3.zero
local flySpeedMultiplier = 1

local function getRootPart(character)
    return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
end

local function startFly()
    if flying then return end
    flying = true

    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = getRootPart(character)
    if not rootPart then return end

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart

    bodyVel = Instance.new("BodyVelocity")
    bodyVel.Velocity = Vector3.zero
    bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVel.Parent = rootPart

    RunService.RenderStepped:Connect(function()
        if flying and rootPart and bodyGyro and bodyVel then
            bodyVel.Velocity = (workspace.CurrentCamera.CFrame:VectorToWorldSpace(direction)) * (flySpeedMultiplier * 50)
            bodyGyro.CFrame = workspace.CurrentCamera.CFrame
        end
    end)
end

local function stopFly()
    flying = false
    if bodyGyro then bodyGyro:Destroy() end
    if bodyVel then bodyVel:Destroy() end
end

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.W then direction = Vector3.new(0, 0, -1)
    elseif input.KeyCode == Enum.KeyCode.S then direction = Vector3.new(0, 0, 1)
    elseif input.KeyCode == Enum.KeyCode.A then direction = Vector3.new(-1, 0, 0)
    elseif input.KeyCode == Enum.KeyCode.D then direction = Vector3.new(1, 0, 0)
    elseif input.KeyCode == Enum.KeyCode.Space then direction = Vector3.new(0, 1, 0)
    elseif input.KeyCode == Enum.KeyCode.LeftControl then direction = Vector3.new(0, -1, 0)
    end
end)

UIS.InputEnded:Connect(function(input, gpe)
    if gpe then return end
    direction = Vector3.zero
end)

player.Chatted:Connect(function(msg)
    msg = msg:lower()
    if msg:sub(1, 4) == ";fly" then
        local speedStr = msg:match("^;fly%s+(%d+)")
        local speed = tonumber(speedStr) or 1
        speed = math.clamp(speed, 1, 10)
        flySpeedMultiplier = speed
        startFly()
    elseif msg == ";unfly" then
        stopFly()
    end
end)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function setGravity(value)
    local gravityValue = tonumber(value)
    if not gravityValue then
        return
    end
    
    if gravityValue < 0 then
        gravityValue = 0
    elseif gravityValue > 500 then
        gravityValue = 500
    end
    
    workspace.Gravity = gravityValue
end

player.Chatted:Connect(function(msg)
    local args = msg:split(" ")
    local cmd = args[1]:lower()
    if cmd == ";gravity" and args[2] then
        setGravity(args[2])
    end
end)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local function findPlayerByNamePartial(name)
    local lowerName = name:lower()
    for _, plr in pairs(Players:GetPlayers()) do
        local plrNameLower = plr.Name:lower()
        local plrDisplayLower = ""
        if plr.DisplayName then
            plrDisplayLower = plr.DisplayName:lower()
        end

        if plrNameLower:find(lowerName, 1, true) or
           (plrDisplayLower ~= "" and plrDisplayLower:find(lowerName, 1, true)) then
            return plr
        end
    end
    return nil
end

local function viewCommand(targetName)
    local targetPlayer = findPlayerByNamePartial(targetName)
    if not targetPlayer or not targetPlayer.Character then
        return
    end

    local char = targetPlayer.Character
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local head = char:FindFirstChild("Head")

    if head then
        camera.CameraSubject = head
    elseif humanoid then
        camera.CameraSubject = humanoid
    else
    end
end

local function unviewCommand()
    local character = player.Character
    if not character then
        return
    end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        camera.CameraSubject = humanoid
    else
    end
end

player.Chatted:Connect(function(msg)
    local args = msg:split(" ")
    local cmd = args[1]:lower()
    if cmd == ";view" and args[2] then
        viewCommand(args[2])
    elseif cmd == ";unview" then
        unviewCommand()
    end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

_G._following = false
_G._savedCFrame = nil
_G._followConnection = nil

local function findPlayer(query)
    query = query:lower()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer then
            if p.Name:lower():find(query) or p.DisplayName:lower():find(query) then
                return p
            end
        end
    end
    return nil
end

local function onCommand(msg)
    msg = msg:lower()
    
    if msg:sub(1, 9) == ";loopgoto" then
        local name = msg:sub(11)
        local target = findPlayer(name)
        if not target then
            return
        end

        if not _G._following then
            _G._following = true
            _G._savedCFrame = root.CFrame

            _G._followConnection = RunService.Heartbeat:Connect(function()
                local targetChar = target.Character
                local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                if targetRoot and root then
                    root.CFrame = targetRoot.CFrame + Vector3.new(0, 0, 2)
                end
            end)
        end
    end

    if msg == ";unloopgoto" then
        if _G._followConnection then
            _G._followConnection:Disconnect()
            _G._followConnection = nil
        end

        if _G._savedCFrame then
            root.CFrame = _G._savedCFrame
            _G._savedCFrame = nil
        end

        _G._following = false
    end
end

Players.LocalPlayer.Chatted:Connect(onCommand)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()

_G._mimicConnection = nil

local function findPlayer(query)
    query = query:lower()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer then
            if p.Name:lower():find(query) or p.DisplayName:lower():find(query) then
                return p
            end
        end
    end
    return nil
end

local function mimic(target)
    local myParts = {
        Head = character:FindFirstChild("Head"),
        Torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso"),
        LArm = character:FindFirstChild("LeftUpperArm") or character:FindFirstChild("Left Arm"),
        RArm = character:FindFirstChild("RightUpperArm") or character:FindFirstChild("Right Arm"),
        LLeg = character:FindFirstChild("LeftUpperLeg") or character:FindFirstChild("Left Leg"),
        RLeg = character:FindFirstChild("RightUpperLeg") or character:FindFirstChild("Right Leg"),
    }

    _G._mimicConnection = RunService.Heartbeat:Connect(function()
        if not target.Character then return end
        for name, part in pairs(myParts) do
            local targetPart = target.Character:FindFirstChild(part.Name)
            if part and targetPart then
                part.CFrame = targetPart.CFrame
            end
        end
    end)
end

local function stopMimic()
    if _G._mimicConnection then
        _G._mimicConnection:Disconnect()
        _G._mimicConnection = nil
    end
end

Players.LocalPlayer.Chatted:Connect(function(msg)
    msg = msg:lower()
    if msg:sub(1, 7) == ";mimic " then
        local name = msg:sub(8)
        local target = findPlayer(name)
        if target then
            mimic(target)
        else
        end
    elseif msg == ";unmimic" then
        stopMimic()
    end
end)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

localPlayer.Chatted:Connect(function(msg)
    if msg:lower() == ";f3x" then
        local success, err = pcall(function()
            loadstring(game:GetObjects("rbxassetid://6695644299")[1].Source)()
        end)

        if success then
        else
        end
    end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

LocalPlayer.Chatted:Connect(function(msg)
    local prefix = ";kick "
    if msg:lower():sub(1, #prefix) == prefix then
        local input = msg:sub(#prefix + 1):lower()
        for _, player in pairs(Players:GetPlayers()) do
            if player.Name:lower():sub(1, #input) == input or (player.DisplayName and player.DisplayName:lower():sub(1, #input) == input) then
                player:Destroy()
                break
            end
        end
    end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local hiddenChars = {}

LocalPlayer.Chatted:Connect(function(msg)
    local prefix = ";kick "
    if msg:sub(1, #prefix):lower() == prefix then
        local targetName = msg:sub(#prefix + 1):lower()

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and
               (player.Name:lower():find(targetName) or player.DisplayName:lower():find(targetName)) then

                local char = player.Character
                if char and not hiddenChars[player] then
                    hiddenChars[player] = {}

                    for _, part in pairs(char:GetChildren()) do
                        if part:IsA("BasePart") then
                            hiddenChars[player][part] = {
                                Transparency = part.Transparency,
                                CanCollide = part.CanCollide
                            }
                            part.Transparency = 1
                            part.CanCollide = false
                        elseif part:IsA("Decal") then
                            hiddenChars[player][part] = {Transparency = part.Transparency}
                            part.Transparency = 1
                        elseif part:IsA("Accessory") then
                            for _, accPart in pairs(part:GetChildren()) do
                                if accPart:IsA("BasePart") then
                                    hiddenChars[player][accPart] = {
                                        Transparency = accPart.Transparency,
                                        CanCollide = accPart.CanCollide
                                    }
                                    accPart.Transparency = 1
                                    accPart.CanCollide = false
                                elseif accPart:IsA("Decal") then
                                    hiddenChars[player][accPart] = {Transparency = accPart.Transparency}
                                    accPart.Transparency = 1
                                end
                            end
                        end
                    end

                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        hiddenChars[player].DisplayDistanceType = humanoid.DisplayDistanceType
                        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                    end
                else
                end

                break
            end
        end
    end
end)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

local localPlayer = Players.LocalPlayer
local savedPosition = nil

TextChatService.OnIncomingMessage = function(message)
    if message.TextSource then
        local speaker = Players:GetPlayerByUserId(message.TextSource.UserId)
        if speaker == localPlayer then
            local text = message.Text:lower()
            
            if text == ";savepoint" then
                local char = localPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    savedPosition = char.HumanoidRootPart.CFrame
                end

            elseif text == ";unsavepoint" then
                savedPosition = nil
            end
        end
    end
end

localPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart")
    if savedPosition then
        task.wait(0.5)
        char:PivotTo(savedPosition)
    end
end)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local savedSpawnCFrame = nil
local runService = game:GetService("RunService")

player.Chatted:Connect(function(msg)
    if msg:lower() == ";savepoint" then
        local character = player.Character
        if character then
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                savedSpawnCFrame = hrp.CFrame
            else
            end
        else
        end
    end
end)

player.CharacterAdded:Connect(function(character)
    if savedSpawnCFrame then
        local hrp = character:WaitForChild("HumanoidRootPart", 5)
        if hrp then
            hrp.CFrame = savedSpawnCFrame
        end
    end
end)

local function loadInfiniteYield()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
	loadstring(game:HttpGet('https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source'))()
end

game.Players.LocalPlayer.Chatted:Connect(function(msg)
    if msg:lower() == ";adminscripts" then
        loadInfiniteYield()
    end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local bringkillTasks = {}

local function getPlayerByName(partialName)
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local lowerName = player.Name:lower()
			local lowerDisplay = player.DisplayName:lower()
			local lowerInput = partialName:lower()
			if lowerName:sub(1, #lowerInput) == lowerInput or lowerDisplay:sub(1, #lowerInput) == lowerInput then
				return player
			end
		end
	end
end

local function bringkillTarget(targetPlayer)
	if bringkillTasks[targetPlayer] then return end

	local running = true
	bringkillTasks[targetPlayer] = running

	task.spawn(function()
		local toggle = true
		while bringkillTasks[targetPlayer] do
			local localChar = LocalPlayer.Character
			local targetChar = targetPlayer.Character
			if not localChar or not targetChar then task.wait(0.2) continue end

			local localHRP = localChar:FindFirstChild("HumanoidRootPart")
			local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
			if not localHRP or not targetHRP then task.wait(0.2) continue end

			local distance = toggle and 7 or 2
			toggle = not toggle

			local frontPos = localHRP.Position + (localHRP.CFrame.LookVector * distance)
			local newCFrame = CFrame.new(frontPos, frontPos + localHRP.CFrame.LookVector)
			targetHRP.CFrame = newCFrame

			task.wait(0.001)
		end
	end)
end

local function unbringkillTarget(targetPlayer)
	if bringkillTasks[targetPlayer] then
		bringkillTasks[targetPlayer] = nil
	end
end

Players.LocalPlayer.Chatted:Connect(function(msg)
	local cmd, arg = msg:match("^;(%w+)%s+(.*)")
	if cmd == "bringkill" and arg then
		local target = getPlayerByName(arg)
		if target then
			bringkillTarget(target)
		end
	elseif cmd == "unbringkill" and arg then
		local target = getPlayerByName(arg)
		if target then
			unbringkillTarget(target)
		end
	end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local MAX_DISTANCE_DELTA = 90

local lastPositions = {}
local alertedPlayers = {}
local ignoreUntil = {}

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        ignoreUntil[player] = tick() + 3
        lastPositions[player] = nil
    end)
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            ignoreUntil[player] = tick() + 3
            lastPositions[player] = nil
        end)
    end
end

local function createAlertUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "HackAlertUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Name = "AlertFrame"
    frame.AnchorPoint = Vector2.new(1, 0.5)
    frame.Position = UDim2.new(1, -20, 0.5, 0)
    frame.Size = UDim2.new(0, 250, 0, 80)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "AlertText"
    textLabel.Size = UDim2.new(1, -90, 0, 40)
    textLabel.Position = UDim2.new(0, 10, 0, 10)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "Suspicious player detected"
    textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Parent = frame

    local thumbnail = Instance.new("ImageLabel")
    thumbnail.Name = "PlayerThumbnail"
    thumbnail.Size = UDim2.new(0, 60, 0, 60)
    thumbnail.Position = UDim2.new(1, -70, 0, 10)
    thumbnail.BackgroundTransparency = 1
    thumbnail.Image = ""
    thumbnail.Parent = frame

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "PlayerName"
    nameLabel.Size = UDim2.new(1, -80, 0, 20)
    nameLabel.Position = UDim2.new(0, 10, 1, -25)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextYAlignment = Enum.TextYAlignment.Center
    nameLabel.Parent = frame

    frame.Visible = false

    return {
        ScreenGui = screenGui,
        Frame = frame,
        TextLabel = textLabel,
        Thumbnail = thumbnail,
        NameLabel = nameLabel,
    }
end

local alertUI = createAlertUI()

local function showAlert(player)
    alertUI.Frame.Visible = true
    alertUI.TextLabel.Text = "Fling/bring/tp detector"
    alertUI.NameLabel.Text = player.DisplayName .. " (" .. player.Name .. ")"

    local userId = player.UserId
    local thumbUrl = Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size60x60)
    alertUI.Thumbnail.Image = thumbUrl

    task.delay(2, function()
        alertUI.Frame.Visible = false
    end)

    task.delay(3, function()
        alertedPlayers[player] = nil
    end)
end

local function detectOthersByPosition()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                if ignoreUntil[player] and tick() < ignoreUntil[player] then
                    lastPositions[player] = rootPart.Position
                    continue
                end

                local lastPos = lastPositions[player]
                if lastPos then
                    local delta = (rootPart.Position - lastPos).Magnitude
                    if delta > MAX_DISTANCE_DELTA then
                        if not alertedPlayers[player] then
                            alertedPlayers[player] = true
                            showAlert(player)
                        end
                    end
                end
                lastPositions[player] = rootPart.Position
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    detectOthersByPosition()
end)
