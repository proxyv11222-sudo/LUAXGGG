--// LUAX BLOCK + ESP
--// Roblox Studio / LocalScript
--// Funções oficiais: bloqueio pelo prompt do Roblox. ESP e recuperação de estados são locais.
--// Coloque como LocalScript em StarterPlayer > StarterPlayerScripts.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local SocialService = game:GetService("SocialService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local GUI_NAME = "LUAX_BLOCK"

local HIDDEN_USERNAME = "cofferingMons"

local COLORS = {
    Background = Color3.fromRGB(13, 16, 23),
    Panel = Color3.fromRGB(18, 22, 31),
    Row = Color3.fromRGB(23, 28, 39),
    RowHover = Color3.fromRGB(28, 35, 49),
    Accent = Color3.fromRGB(35, 140, 255),
    AccentDark = Color3.fromRGB(20, 91, 180),
    Success = Color3.fromRGB(55, 210, 130),
    Off = Color3.fromRGB(55, 62, 76),
    Text = Color3.fromRGB(240, 244, 255),
    SubText = Color3.fromRGB(145, 155, 175),
    Danger = Color3.fromRGB(220, 70, 80),
    Warning = Color3.fromRGB(255, 150, 55),
}

local Settings = {
    Ragdoll = false,
    ESP = false,
}

local ESPObjects = {}

local old = PlayerGui:FindFirstChild(GUI_NAME)
if old then
    old:Destroy()
end

local function tween(object, duration, properties)
    local t = TweenService:Create(
        object,
        TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        properties
    )
    t:Play()
    return t
end

local function corner(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = object
    return c
end

local function clearGuiObjects(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
end

local function isHiddenPlayer(player)
    return player
        and string.lower(player.Name) == string.lower(HIDDEN_USERNAME)
end

local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = PlayerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 340, 0, 450)
main.Position = UDim2.new(0.5, -170, 0.5, -225)
main.BackgroundColor3 = COLORS.Background
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = gui
corner(main, 16)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = COLORS.Accent
mainStroke.Transparency = 0.55
mainStroke.Thickness = 1
mainStroke.Parent = main

local header = Instance.new("Frame")
header.Size = UDim2.new(1, -20, 0, 58)
header.Position = UDim2.new(0, 10, 0, 6)
header.BackgroundTransparency = 1
header.Parent = main

local logo = Instance.new("Frame")
logo.Size = UDim2.new(0, 40, 0, 40)
logo.Position = UDim2.new(0, 0, 0.5, -20)
logo.BackgroundColor3 = COLORS.Accent
logo.BorderSizePixel = 0
logo.Parent = header
corner(logo, 11)

local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.fromScale(1, 1)
logoText.BackgroundTransparency = 1
logoText.Text = "L"
logoText.Font = Enum.Font.GothamBold
logoText.TextSize = 22
logoText.TextColor3 = Color3.new(1, 1, 1)
logoText.Parent = logo

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -92, 0, 23)
title.Position = UDim2.new(0, 51, 0, 7)
title.BackgroundTransparency = 1
title.Text = "LUAX BLOCK"
title.Font = Enum.Font.GothamBold
title.TextSize = 17
title.TextColor3 = COLORS.Text
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -92, 0, 18)
subtitle.Position = UDim2.new(0, 51, 0, 30)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Players • Settings • ESP"
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 10
subtitle.TextColor3 = COLORS.SubText
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 8)
closeButton.BackgroundColor3 = COLORS.Danger
closeButton.BorderSizePixel = 0
closeButton.AutoButtonColor = false
closeButton.Text = "×"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 20
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Parent = header
corner(closeButton, 9)

local openButton = Instance.new("TextButton")
openButton.Name = "LUAX_Open"
openButton.Size = UDim2.new(0, 58, 0, 58)
openButton.Position = UDim2.new(0, 14, 0.5, -29)
openButton.BackgroundColor3 = COLORS.Panel
openButton.BorderSizePixel = 0
openButton.AutoButtonColor = false
openButton.Text = "LUAX"
openButton.Font = Enum.Font.GothamBold
openButton.TextSize = 12
openButton.TextColor3 = Color3.new(1, 1, 1)
openButton.Visible = false
openButton.Parent = gui
corner(openButton, 16)

local openGradient = Instance.new("UIGradient")
openGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 60)),
    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 180, 50)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(80, 220, 100)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(60, 180, 255)),
    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(130, 80, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 60, 180)),
})
openGradient.Parent = openButton

task.spawn(function()
    while openGradient.Parent do
        for rotation = 0, 360, 3 do
            if not openGradient.Parent then
                return
            end
            openGradient.Rotation = rotation
            task.wait(0.03)
        end
    end
end)

local openStroke = Instance.new("UIStroke")
openStroke.Thickness = 2
openStroke.Color = Color3.new(1, 1, 1)
openStroke.Transparency = 0.35
openStroke.Parent = openButton

closeButton.MouseEnter:Connect(function()
    tween(closeButton, 0.12, {BackgroundColor3 = Color3.fromRGB(245, 75, 90)})
end)

closeButton.MouseLeave:Connect(function()
    tween(closeButton, 0.12, {BackgroundColor3 = COLORS.Danger})
end)

closeButton.MouseButton1Click:Connect(function()
    main.Visible = false
    openButton.Visible = true
end)

openButton.MouseButton1Click:Connect(function()
    openButton.Visible = false
    main.Visible = true
end)

local dragging = false
local dragStart
local startPosition

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local tabs = Instance.new("Frame")
tabs.Size = UDim2.new(1, -20, 0, 40)
tabs.Position = UDim2.new(0, 10, 0, 68)
tabs.BackgroundColor3 = COLORS.Panel
tabs.BorderSizePixel = 0
tabs.Parent = main
corner(tabs, 10)

local blockTab = Instance.new("TextButton")
blockTab.Size = UDim2.new(0.5, -6, 1, -8)
blockTab.Position = UDim2.new(0, 4, 0, 4)
blockTab.BackgroundColor3 = COLORS.Accent
blockTab.BorderSizePixel = 0
blockTab.AutoButtonColor = false
blockTab.Text = "👥 BLOCK"
blockTab.Font = Enum.Font.GothamBold
blockTab.TextSize = 10
blockTab.TextColor3 = Color3.new(1, 1, 1)
blockTab.Parent = tabs
corner(blockTab, 8)

local settingsTab = Instance.new("TextButton")
settingsTab.Size = UDim2.new(0.5, -6, 1, -8)
settingsTab.Position = UDim2.new(0.5, 2, 0, 4)
settingsTab.BackgroundColor3 = COLORS.Panel
settingsTab.BorderSizePixel = 0
settingsTab.AutoButtonColor = false
settingsTab.Text = "⚙ SETTINGS"
settingsTab.Font = Enum.Font.GothamBold
settingsTab.TextSize = 10
settingsTab.TextColor3 = COLORS.SubText
settingsTab.Parent = tabs
corner(settingsTab, 8)

local content = Instance.new("ScrollingFrame")
content.Name = "Content"
content.Size = UDim2.new(1, -20, 1, -120)
content.Position = UDim2.new(0, 10, 0, 114)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 3
content.ScrollBarImageColor3 = COLORS.Accent
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.CanvasSize = UDim2.new()
content.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 7)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = content

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 3)
padding.PaddingBottom = UDim.new(0, 8)
padding.Parent = content

local currentTab = "Block"

--==================================================
-- OFFICIAL BLOCK PROMPT
--==================================================

local function blockPlayer(player)
    if not player or player == LocalPlayer or isHiddenPlayer(player) then
        return false
    end

    local ok = pcall(function()
        StarterGui:SetCore("PromptBlockPlayer", player)
    end)

    return ok
end

--==================================================
-- OFFICIAL INVITE PROMPT
--==================================================

local function invitePlayer()
    local ok = pcall(function()
        SocialService:PromptGameInvite(LocalPlayer)
    end)
    return ok
end

--==================================================
-- BLOCK LIST
--==================================================

local function createPlayerRow(player)
    if isHiddenPlayer(player) then
        return
    end

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -6, 0, 62)
    row.BackgroundColor3 = COLORS.Row
    row.BorderSizePixel = 0
    row.ClipsDescendants = true
    row.Parent = content
    corner(row, 11)

    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.new(0, 44, 0, 44)
    avatar.Position = UDim2.new(0, 8, 0.5, -22)
    avatar.BackgroundColor3 = COLORS.Panel
    avatar.BorderSizePixel = 0
    avatar.Parent = row
    corner(avatar, 22)

    task.spawn(function()
        local ok, image = pcall(function()
            return Players:GetUserThumbnailAsync(
                player.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size100x100
            )
        end)

        if ok and avatar.Parent then
            avatar.Image = image
        end
    end)

    local username = Instance.new("TextLabel")
    username.Size = UDim2.new(1, -165, 0, 20)
    username.Position = UDim2.new(0, 61, 0, 9)
    username.BackgroundTransparency = 1
    username.Text = "@" .. player.Name
    username.Font = Enum.Font.GothamBold
    username.TextSize = 11
    username.TextColor3 = COLORS.Text
    username.TextXAlignment = Enum.TextXAlignment.Left
    username.TextTruncate = Enum.TextTruncate.AtEnd
    username.Parent = row

    local displayName = Instance.new("TextLabel")
    displayName.Size = UDim2.new(1, -165, 0, 17)
    displayName.Position = UDim2.new(0, 61, 0, 30)
    displayName.BackgroundTransparency = 1
    displayName.Text = player.DisplayName
    displayName.Font = Enum.Font.Gotham
    displayName.TextSize = 9
    displayName.TextColor3 = COLORS.SubText
    displayName.TextXAlignment = Enum.TextXAlignment.Left
    displayName.TextTruncate = Enum.TextTruncate.AtEnd
    displayName.Parent = row

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 80, 0, 32)
    button.Position = UDim2.new(1, -89, 0.5, -16)
    button.BackgroundColor3 = COLORS.Accent
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Text = "BLOQUEAR"
    button.Font = Enum.Font.GothamBold
    button.TextSize = 9
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Parent = row
    corner(button, 9)

    button.MouseEnter:Connect(function()
        tween(row, 0.12, {BackgroundColor3 = COLORS.RowHover})
        tween(button, 0.12, {BackgroundColor3 = COLORS.AccentDark})
    end)

    button.MouseLeave:Connect(function()
        tween(row, 0.12, {BackgroundColor3 = COLORS.Row})
        tween(button, 0.12, {BackgroundColor3 = COLORS.Accent})
    end)

    button.MouseButton1Click:Connect(function()
        button.Active = false
        button.Text = "ABRINDO..."

        local success = blockPlayer(player)

        if success then
            -- O jogador continua na lista enquanto estiver no servidor.
            -- A linha só é removida pelo evento Players.PlayerRemoving.
            button.Text = "BLOQUEADO"
            button.BackgroundColor3 = COLORS.Success
            button.Active = false
        else
            button.Text = "ERRO"
            task.delay(1, function()
                if button.Parent then
                    button.Text = "BLOQUEAR"
                    button.BackgroundColor3 = COLORS.Accent
                    button.Active = true
                end
            end)
        end
    end)
end

local function buildBlock()
    clearGuiObjects(content)

    local found = 0

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not isHiddenPlayer(player) then
            found += 1
            createPlayerRow(player)
        end
    end

    if found == 0 then
        local empty = Instance.new("TextLabel")
        empty.Size = UDim2.new(1, -6, 0, 45)
        empty.BackgroundTransparency = 1
        empty.Text = "Nenhum outro jogador disponível."
        empty.Font = Enum.Font.Gotham
        empty.TextSize = 10
        empty.TextColor3 = COLORS.SubText
        empty.Parent = content
    end
end

--==================================================
-- TOGGLE
--==================================================

local function createToggle(name, description, key, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -6, 0, 56)
    row.BackgroundColor3 = COLORS.Row
    row.BorderSizePixel = 0
    row.Parent = content
    corner(row, 11)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -85, 0, 20)
    label.Position = UDim2.new(0, 12, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextColor3 = COLORS.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local descriptionLabel = Instance.new("TextLabel")
    descriptionLabel.Size = UDim2.new(1, -85, 0, 16)
    descriptionLabel.Position = UDim2.new(0, 12, 0, 29)
    descriptionLabel.BackgroundTransparency = 1
    descriptionLabel.Text = description
    descriptionLabel.Font = Enum.Font.Gotham
    descriptionLabel.TextSize = 8
    descriptionLabel.TextColor3 = COLORS.SubText
    descriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
    descriptionLabel.TextTruncate = Enum.TextTruncate.AtEnd
    descriptionLabel.Parent = row

    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 48, 0, 25)
    track.Position = UDim2.new(1, -59, 0.5, -12)
    track.BackgroundColor3 = COLORS.Off
    track.BorderSizePixel = 0
    track.Parent = row
    corner(track, 14)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 19, 0, 19)
    knob.Position = UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = Color3.fromRGB(220, 225, 235)
    knob.BorderSizePixel = 0
    knob.Parent = track
    corner(knob, 10)

    local click = Instance.new("TextButton")
    click.Size = UDim2.fromScale(1, 1)
    click.BackgroundTransparency = 1
    click.Text = ""
    click.Parent = row

    local function render(animate)
        local duration = animate and 0.18 or 0

        if Settings[key] then
            tween(track, duration, {BackgroundColor3 = COLORS.Accent})
            tween(knob, duration, {
                Position = UDim2.new(1, -22, 0.5, -9),
                BackgroundColor3 = Color3.new(1, 1, 1),
            })
        else
            tween(track, duration, {BackgroundColor3 = COLORS.Off})
            tween(knob, duration, {
                Position = UDim2.new(0, 3, 0.5, -9),
                BackgroundColor3 = Color3.fromRGB(220, 225, 235),
            })
        end
    end

    click.MouseEnter:Connect(function()
        tween(row, 0.12, {BackgroundColor3 = COLORS.RowHover})
    end)

    click.MouseLeave:Connect(function()
        tween(row, 0.12, {BackgroundColor3 = COLORS.Row})
    end)

    click.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        render(true)

        if callback then
            callback(Settings[key])
        end
    end)

    render(false)
end

--==================================================
-- ANTI RAGDOLL
--==================================================

local function attachIncomingPlayerRecovery(player)
    local function recover(character)
        if not Settings.Ragdoll or not character then
            return
        end

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            humanoid = character:WaitForChild("Humanoid", 5)
        end
        if not humanoid then
            return
        end

        task.defer(function()
            if not Settings.Ragdoll or not humanoid.Parent then
                return
            end

            if humanoid.PlatformStand then
                humanoid.PlatformStand = false
            end

            local state = humanoid:GetState()
            if state == Enum.HumanoidStateType.Physics
                or state == Enum.HumanoidStateType.Ragdoll then
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end)
    end

    if player.Character then
        recover(player.Character)
    end

    player.CharacterAdded:Connect(recover)
end

local function recoverAllCharacters()
    if not Settings.Ragdoll then
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if humanoid.PlatformStand then
                    humanoid.PlatformStand = false
                end

                local state = humanoid:GetState()
                if state == Enum.HumanoidStateType.Physics
                    or state == Enum.HumanoidStateType.Ragdoll then
                    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
            end
        end
    end
end

local function updateRagdoll()
    if ragdollConnection then
        ragdollConnection:Disconnect()
        ragdollConnection = nil
    end

    if not Settings.Ragdoll then
        return
    end

    ragdollConnection = RunService.Heartbeat:Connect(function()
        local character = LocalPlayer.Character
        if not character then
            return
        end

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            return
        end

        if humanoid.PlatformStand then
            humanoid.PlatformStand = false
        end

        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll then
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
end

--==================================================
-- ESP
--==================================================

local function getBodyParts(character)
    local parts = {}

    local names = {
        "Head",
        "UpperTorso",
        "LowerTorso",
        "HumanoidRootPart",
        "LeftUpperArm",
        "LeftLowerArm",
        "LeftHand",
        "RightUpperArm",
        "RightLowerArm",
        "RightHand",
        "LeftUpperLeg",
        "LeftLowerLeg",
        "LeftFoot",
        "RightUpperLeg",
        "RightLowerLeg",
        "RightFoot",
    }

    for _, name in ipairs(names) do
        local part = character:FindFirstChild(name)
        if part and part:IsA("BasePart") then
            parts[name] = part
        end
    end

    return parts
end

local function createBeam(parent, attachment0, attachment1)
    local beam = Instance.new("Beam")
    beam.Attachment0 = attachment0
    beam.Attachment1 = attachment1
    beam.FaceCamera = true
    beam.Width0 = 0.035
    beam.Width1 = 0.035
    beam.LightEmission = 1
    beam.Color = ColorSequence.new(Color3.new(1, 1, 1))
    beam.Transparency = NumberSequence.new(0)
    beam.Parent = parent
    return beam
end

local function createAttachment(part, name)
    local attachment = Instance.new("Attachment")
    attachment.Name = name
    attachment.Parent = part
    return attachment
end

local function destroyESP(player)
    local data = ESPObjects[player]
    if not data then
        return
    end

    if data.folder then
        data.folder:Destroy()
    end

    if data.screenLineGui then
        data.screenLineGui:Destroy()
    end

    ESPObjects[player] = nil
end

local function healthColor(percent)
    percent = math.clamp(percent, 0, 1)

    if percent > 0.60 then
        return COLORS.Success
    elseif percent > 0.30 then
        return COLORS.Warning
    else
        return COLORS.Danger
    end
end

local function createHealthBar(player, character, humanoid, root)
    local guiBar = Instance.new("BillboardGui")
    guiBar.Name = "LUAX_Health"
    guiBar.Adornee = root
    guiBar.Size = UDim2.new(0, 120, 0, 18)
    guiBar.StudsOffset = Vector3.new(0, 4.2, 0)
    guiBar.AlwaysOnTop = true
    guiBar.MaxDistance = 500
    guiBar.Parent = root

    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 0, 8)
    background.Position = UDim2.new(0, 0, 0.5, -4)
    background.BackgroundColor3 = Color3.fromRGB(35, 38, 45)
    background.BorderSizePixel = 0
    background.Parent = guiBar
    corner(background, 5)

    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new(1, 0, 1, 0)
    fill.BackgroundColor3 = COLORS.Success
    fill.BorderSizePixel = 0
    fill.Parent = background
    corner(fill, 5)

    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not guiBar.Parent or not character.Parent or humanoid.Health <= 0 then
            connection:Disconnect()
            return
        end

        local maxHealth = math.max(humanoid.MaxHealth, 1)
        local percent = math.clamp(humanoid.Health / maxHealth, 0, 1)

        fill.Size = UDim2.new(percent, 0, 1, 0)
        fill.BackgroundColor3 = healthColor(percent)
    end)

    return guiBar
end

local function createESP(player)
    if player == LocalPlayer or isHiddenPlayer(player) then
        return
    end

    destroyESP(player)

    local character = player.Character
    if not character then
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")

    if not humanoid or not root then
        return
    end

    local folder = Instance.new("Folder")
    folder.Name = "LUAX_ESP_" .. player.UserId
    folder.Parent = gui

    local data = {
        folder = folder,
        character = character,
        attachments = {},
        beams = {},
    }

    ESPObjects[player] = data

    -- Caixa 3D sem preenchimento.
    local box = Instance.new("SelectionBox")
    box.Name = "Box3D"
    box.Adornee = character
    box.LineThickness = 0.025
    box.Color3 = Color3.new(1, 1, 1)
    box.SurfaceTransparency = 1
    box.Parent = folder
    data.box = box

    -- Linha branca da parte inferior da tela até o jogador.
    local screenLineGui = Instance.new("ScreenGui")
    screenLineGui.Name = "LUAX_ScreenLine_" .. player.UserId
    screenLineGui.IgnoreGuiInset = true
    screenLineGui.ResetOnSpawn = false
    screenLineGui.DisplayOrder = 998
    screenLineGui.Parent = PlayerGui

    local screenLine = Instance.new("Frame")
    screenLine.Name = "BottomLine"
    screenLine.AnchorPoint = Vector2.new(0.5, 1)
    screenLine.Size = UDim2.new(0, 2, 0, 100)
    screenLine.Position = UDim2.new(0.5, 0, 1, 0)
    screenLine.BackgroundColor3 = Color3.new(1, 1, 1)
    screenLine.BorderSizePixel = 0
    screenLine.Visible = true
    screenLine.Parent = screenLineGui
    data.screenLineGui = screenLineGui
    data.screenLine = screenLine

    -- Linha branca do jogador local até o alvo.
    local localCharacter = LocalPlayer.Character
    local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")

    if localRoot then
        local a0 = createAttachment(localRoot, "LUAX_Line_" .. player.UserId)
        local a1 = createAttachment(root, "LUAX_Target_" .. player.UserId)
        local beam = createBeam(folder, a0, a1)

        data.attachments.localRoot = a0
        data.attachments.targetRoot = a1
        data.beams.line = beam
    end

    -- Nome + distância.
    local info = Instance.new("BillboardGui")
    info.Name = "Info"
    info.Adornee = root
    info.Size = UDim2.new(0, 180, 0, 36)
    info.StudsOffset = Vector3.new(0, 3.1, 0)
    info.AlwaysOnTop = true
    info.MaxDistance = 500
    info.Parent = folder

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "Name"
    nameLabel.Size = UDim2.new(1, 0, 0, 18)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 11
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextStrokeTransparency = 0.4
    nameLabel.Text = "@" .. player.Name
    nameLabel.Parent = info
    data.nameLabel = nameLabel

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "Distance"
    distanceLabel.Size = UDim2.new(1, 0, 0, 16)
    distanceLabel.Position = UDim2.new(0, 0, 0, 18)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.TextSize = 9
    distanceLabel.TextColor3 = Color3.new(1, 1, 1)
    distanceLabel.TextStrokeTransparency = 0.4
    distanceLabel.Text = "0 studs"
    distanceLabel.Parent = info
    data.distanceLabel = distanceLabel

    data.healthBar = createHealthBar(player, character, humanoid, root)

    -- Esqueleto: somente as linhas existentes no rig.
    local skeletonPairs = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"},
        {"RightUpperLeg", "RightLowerLeg"},
        {"RightLowerLeg", "RightFoot"},
        {"UpperTorso", "LeftUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"},
        {"RightUpperArm", "RightLowerArm"},
        {"RightLowerArm", "RightHand"},
    }

    local parts = getBodyParts(character)

    for index, pair in ipairs(skeletonPairs) do
        local part0 = parts[pair[1]]
        local part1 = parts[pair[2]]

        if part0 and part1 then
            local a0 = createAttachment(part0, "LUAX_S0_" .. player.UserId .. "_" .. index)
            local a1 = createAttachment(part1, "LUAX_S1_" .. player.UserId .. "_" .. index)
            local beam = createBeam(folder, a0, a1)

            data.attachments["s0_" .. index] = a0
            data.attachments["s1_" .. index] = a1
            data.beams["s_" .. index] = beam
        end
    end
end

local function updateESP()
    if not Settings.ESP then
        for player in pairs(ESPObjects) do
            destroyESP(player)
        end
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not isHiddenPlayer(player) then
            local data = ESPObjects[player]
            local character = player.Character

            if character then
                local root = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChildOfClass("Humanoid")

                if root and humanoid then
                    if not data or data.character ~= character then
                        createESP(player)
                        data = ESPObjects[player]
                    end

                    if data and data.distanceLabel then
                        local camera = workspace.CurrentCamera
                        if camera and data.screenLine then
                            local screenPoint, onScreen = camera:WorldToViewportPoint(root.Position)
                            data.screenLine.Visible = onScreen and screenPoint.Z > 0

                            if data.screenLine.Visible then
                                local viewport = camera.ViewportSize
                                local startPoint = Vector2.new(viewport.X * 0.5, viewport.Y)
                                local endPoint = Vector2.new(screenPoint.X, screenPoint.Y)
                                local delta = endPoint - startPoint
                                local length = delta.Magnitude

                                data.screenLine.Position = UDim2.fromOffset(
                                    (startPoint.X + endPoint.X) * 0.5,
                                    (startPoint.Y + endPoint.Y) * 0.5
                                )
                                data.screenLine.Size = UDim2.fromOffset(2, math.max(length, 1))
                                data.screenLine.Rotation = math.deg(math.atan2(delta.Y, delta.X)) + 90
                            end
                        end

                        local localCharacter = LocalPlayer.Character
                        local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")

                        if localRoot then
                            local distance = (localRoot.Position - root.Position).Magnitude
                            data.distanceLabel.Text = string.format("%.0f studs", distance)
                        end
                    end
                end
            end
        end
    end
end

local espHeartbeat
local function setESPEnabled(enabled)
    if espHeartbeat then
        espHeartbeat:Disconnect()
        espHeartbeat = nil
    end

    if enabled then
        updateESP()

        local accumulator = 0
        espHeartbeat = RunService.Heartbeat:Connect(function(dt)
            accumulator += dt
            if accumulator >= 0.05 then
                accumulator = 0
                updateESP()
            end
        end)
    else
        updateESP()
    end
end

--==================================================
-- SETTINGS
--==================================================

local function createInviteButton()
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -6, 0, 56)
    row.BackgroundColor3 = COLORS.Row
    row.BorderSizePixel = 0
    row.Parent = content
    corner(row, 11)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -105, 0, 20)
    label.Position = UDim2.new(0, 12, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = "Convidar jogador"
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextColor3 = COLORS.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -105, 0, 16)
    desc.Position = UDim2.new(0, 12, 0, 29)
    desc.BackgroundTransparency = 1
    desc.Text = "Abre o convite oficial do Roblox"
    desc.Font = Enum.Font.Gotham
    desc.TextSize = 8
    desc.TextColor3 = COLORS.SubText
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Parent = row

    local invite = Instance.new("TextButton")
    invite.Size = UDim2.new(0, 82, 0, 30)
    invite.Position = UDim2.new(1, -91, 0.5, -15)
    invite.BackgroundColor3 = COLORS.Success
    invite.BorderSizePixel = 0
    invite.AutoButtonColor = false
    invite.Text = "CONVIDAR"
    invite.Font = Enum.Font.GothamBold
    invite.TextSize = 8
    invite.TextColor3 = Color3.new(1, 1, 1)
    invite.Parent = row
    corner(invite, 9)

    invite.MouseButton1Click:Connect(function()
        invite.Active = false
        invite.Text = "ABRINDO..."

        local ok = invitePlayer()

        task.delay(0.8, function()
            if invite.Parent then
                invite.Text = ok and "CONVIDAR" or "ERRO"
                invite.Active = true
            end
        end)
    end)
end

local function buildSettings()
    clearGuiObjects(content)

    createToggle(
        "Anti Ragdoll",
        "Proteção local contra estados de ragdoll",
        "Ragdoll",
        updateRagdoll
    )

    createToggle(
        "ESP Player",
        "Linha, box 3D, nome, distância, esqueleto e vida",
        "ESP",
        setESPEnabled
    )

    createInviteButton()
end

--==================================================
-- TABS / PLAYER EVENTS
--==================================================

local function selectTab(tab)
    currentTab = tab

    if tab == "Block" then
        tween(blockTab, 0.18, {BackgroundColor3 = COLORS.Accent})
        tween(settingsTab, 0.18, {BackgroundColor3 = COLORS.Panel})
        blockTab.TextColor3 = Color3.new(1, 1, 1)
        settingsTab.TextColor3 = COLORS.SubText
        buildBlock()
    else
        tween(settingsTab, 0.18, {BackgroundColor3 = COLORS.Accent})
        tween(blockTab, 0.18, {BackgroundColor3 = COLORS.Panel})
        settingsTab.TextColor3 = Color3.new(1, 1, 1)
        blockTab.TextColor3 = COLORS.SubText
        buildSettings()
    end
end

blockTab.MouseButton1Click:Connect(function()
    selectTab("Block")
end)

settingsTab.MouseButton1Click:Connect(function()
    selectTab("Settings")
end)

Players.PlayerAdded:Connect(function(player)
    attachIncomingPlayerRecovery(player)

    task.wait(0.1)

    if currentTab == "Block" then
        buildBlock()
    end

    if Settings.ESP then
        updateESP()
    end
end)

Players.PlayerRemoving:Connect(function(player)
    destroyESP(player)

    if currentTab == "Block" then
        task.wait()
        buildBlock()
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)

    if Settings.ESP then
        for player in pairs(ESPObjects) do
            destroyESP(player)
        end
        updateESP()
    end
end)

--==================================================
-- START
--==================================================

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        attachIncomingPlayerRecovery(player)
    end
end

selectTab("Block")
