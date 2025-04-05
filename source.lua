local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local ESP = {
    Enabled = true,
    BoxColor = Color3.fromRGB(255, 255, 0), 
    TextColor = Color3.fromRGB(255, 255, 255),
    BoxThickness = 1,
    TextSize = 14,
    ShowDistance = true,
    ShowHealth = true,
    ShowName = true,
    Boxes = true,
    BoxShift = CFrame.new(0, -1.5, 0),
    BoxSize = Vector3.new(4, 6, 0),
    FaceCamera = false,
    TeamColor = false,
    AttachShift = 1,
    TeamMates = true,
    Players = true,
    Tracers = false,
    Objects = setmetatable({}, {__mode="kv"}),
    Overrides = {}
}

local function CreateESP(player)
    local esp = {
        box = Drawing.new("Square"), 
        name = Drawing.new("Text"),
        health = Drawing.new("Text"),
        distance = Drawing.new("Text"),
        tracer = Drawing.new("Line")
    }
    
    
    esp.box.Color = ESP.BoxColor
    esp.box.Thickness = ESP.BoxThickness
    esp.box.Transparency = 1
    esp.box.Filled = false
    esp.box.Visible = true
    
    
    for _, drawing in pairs(esp) do
        if drawing.ZIndex then 
            drawing.ZIndex = 1
        end
    end
    
    
    esp.name.Color = ESP.TextColor
    esp.name.Size = ESP.TextSize
    esp.name.Center = true
    esp.name.Outline = true
    
    esp.health.Color = ESP.TextColor
    esp.health.Size = ESP.TextSize
    esp.health.Center = true
    esp.health.Outline = true
    
    esp.distance.Color = ESP.TextColor
    esp.distance.Size = ESP.TextSize
    esp.distance.Center = true
    esp.distance.Outline = true
    
    esp.tracer.Color = ESP.BoxColor
    esp.tracer.Thickness = ESP.BoxThickness
    esp.tracer.Transparency = 1
    
    return esp
end

local function CreateGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ESPGui"
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 200, 0, 280)
    MainFrame.Position = UDim2.new(0.5, -100, 0.5, -140)
    MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    MainFrame.BorderSizePixel = 0
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui
    
   
    local HeaderFrame = Instance.new("Frame")
    HeaderFrame.Name = "Header"
    HeaderFrame.Size = UDim2.new(1, 0, 0, 25)
    HeaderFrame.Position = UDim2.new(0, 0, 0, 0)
    HeaderFrame.BackgroundColor3 = Color3.fromRGB(45, 65, 95)
    HeaderFrame.BorderSizePixel = 0
    HeaderFrame.Parent = MainFrame
    
    local Triangle = Instance.new("TextButton")
    Triangle.Name = "Triangle"
    Triangle.Size = UDim2.new(0, 25, 0, 25)
    Triangle.Position = UDim2.new(0, 0, 0, 0)
    Triangle.BackgroundTransparency = 1
    Triangle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Triangle.Text = "▼"
    Triangle.TextSize = 14
    Triangle.Font = Enum.Font.Code
    Triangle.Parent = HeaderFrame
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -25, 1, 0)
    Title.Position = UDim2.new(0, 25, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Text = "SpylxClient"
    Title.TextSize = 14
    Title.Font = Enum.Font.Code
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = HeaderFrame
    
    
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, 0, 1, -25)
    ContentFrame.Position = UDim2.new(0, 0, 0, 25)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame
    
    
    local ProcessInfo = Instance.new("Frame")
    ProcessInfo.Name = "ProcessInfo"
    ProcessInfo.Size = UDim2.new(1, 0, 0, 50)
    ProcessInfo.Position = UDim2.new(0, 0, 0, 0)
    ProcessInfo.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    ProcessInfo.BorderSizePixel = 0
    ProcessInfo.Parent = ContentFrame
    
    local PlaceName = Instance.new("TextLabel")
    PlaceName.Name = "PlaceName"
    PlaceName.Size = UDim2.new(1, -10, 0, 20)
    PlaceName.Position = UDim2.new(0, 5, 0, 5)
    PlaceName.BackgroundTransparency = 1
    PlaceName.TextColor3 = Color3.fromRGB(200, 200, 200)
    PlaceName.Text = "Place: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    PlaceName.TextSize = 14
    PlaceName.Font = Enum.Font.Code
    PlaceName.TextXAlignment = Enum.TextXAlignment.Left
    PlaceName.Parent = ProcessInfo
    
    local RunTime = Instance.new("TextLabel")
    RunTime.Name = "RunTime"
    RunTime.Size = UDim2.new(1, -10, 0, 20)
    RunTime.Position = UDim2.new(0, 5, 0, 25)
    RunTime.BackgroundTransparency = 1
    RunTime.TextColor3 = Color3.fromRGB(200, 200, 200)
    RunTime.Text = "Process Run Time: 00:00:00"
    RunTime.TextSize = 14
    RunTime.Font = Enum.Font.Code
    RunTime.TextXAlignment = Enum.TextXAlignment.Left
    RunTime.Parent = ProcessInfo
    
    
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Name = "ButtonContainer"
    ButtonContainer.Size = UDim2.new(1, -10, 1, -60)
    ButtonContainer.Position = UDim2.new(0, 5, 0, 55)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Parent = ContentFrame
    
    
    local function CreateButton(name, position)
        local Button = Instance.new("TextButton")
        Button.Name = name
        Button.Size = UDim2.new(1, 0, 0, 25)
        Button.Position = position
        Button.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        Button.TextColor3 = Color3.fromRGB(200, 200, 200)
        Button.Text = name
        Button.TextSize = 14
        Button.Font = Enum.Font.Code
        Button.BorderSizePixel = 0
        Button.AutoButtonColor = false
        Button.Parent = ButtonContainer
        
        
        Button.MouseEnter:Connect(function()
            if not ESP[name] then
                Button.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
            end
        end)
        
        Button.MouseLeave:Connect(function()
            Button.BackgroundColor3 = ESP[name] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(45, 45, 55)
        end)
        
        
        Button.MouseButton1Click:Connect(function()
            ESP[name] = not ESP[name]
            Button.BackgroundColor3 = ESP[name] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(45, 45, 55)
        end)
        
       
        Button.BackgroundColor3 = ESP[name] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(45, 45, 55)
        
        return Button
    end
    
   
    local buttons = {
        {name = "Enabled", pos = UDim2.new(0, 0, 0, 0)},
        {name = "Boxes", pos = UDim2.new(0, 0, 0, 30)},
        {name = "ShowName", pos = UDim2.new(0, 0, 0, 60)},
        {name = "ShowHealth", pos = UDim2.new(0, 0, 0, 90)},
        {name = "ShowDistance", pos = UDim2.new(0, 0, 0, 120)},
        {name = "Tracers", pos = UDim2.new(0, 0, 0, 150)},
        {name = "TeamColor", pos = UDim2.new(0, 0, 0, 180)}
    }
    
    for _, btn in ipairs(buttons) do
        CreateButton(btn.name, btn.pos)
    end
    
    
    local startTime = tick()
    RunService.RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        local hours = math.floor(elapsed / 3600)
        local minutes = math.floor((elapsed % 3600) / 60)
        local seconds = math.floor(elapsed % 60)
        RunTime.Text = string.format("Process Run Time: %02d:%02d:%02d", hours, minutes, seconds)
    end)
    
    
    local isCollapsed = false
    Triangle.MouseButton1Click:Connect(function()
        isCollapsed = not isCollapsed
        Triangle.Text = isCollapsed and "▶" or "▼"
        ContentFrame.Visible = not isCollapsed
        MainFrame.Size = isCollapsed and UDim2.new(0, 200, 0, 25) or UDim2.new(0, 200, 0, 280)
    end)
    
    
    local dragging
    local dragInput
    local dragStart
    local initialPos
    
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(initialPos.X.Scale, initialPos.X.Offset + delta.X, initialPos.Y.Scale, initialPos.Y.Offset + delta.Y)
    end
    
    HeaderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            initialPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    HeaderFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    -- Открытие/закрытие меню на кнопку Delete
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Delete then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)
    
    return MainFrame
end

local playerESPs = {}

Players.PlayerAdded:Connect(function(player)
    playerESPs[player] = CreateESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    if playerESPs[player] then
        for _, drawing in pairs(playerESPs[player]) do
            drawing:Remove()
        end
        playerESPs[player] = nil
    end
end)


CreateGUI()


local function UpdateESP()
    local camera = workspace.CurrentCamera
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local character = player.Character
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChild("Humanoid")
            
            if humanoidRootPart and playerESPs[player] then
                local pos, onScreen = camera:WorldToViewportPoint(humanoidRootPart.Position)
                
                if onScreen then
                    
                    local size = (camera:WorldToViewportPoint(humanoidRootPart.Position + Vector3.new(3, 0, 0)).X - 
                                camera:WorldToViewportPoint(humanoidRootPart.Position - Vector3.new(3, 0, 0)).X) / 2
                    
                    
                    if ESP.Boxes then
                        local cf = humanoidRootPart.CFrame
                        if ESP.FaceCamera then
                            cf = CFrame.new(cf.p, camera.CFrame.p)
                        end
                        
                        local boxShift = ESP.BoxShift
                        local boxSize = ESP.BoxSize
                        
                        local topLeft = cf * boxShift * CFrame.new(boxSize.X/2, boxSize.Y/2, 0)
                        local bottomRight = cf * boxShift * CFrame.new(-boxSize.X/2, -boxSize.Y/2, 0)
                        
                        
                        local topLeftPos, _ = camera:WorldToViewportPoint(topLeft.Position)
                        local bottomRightPos, _ = camera:WorldToViewportPoint(bottomRight.Position)
                        
                        
                        playerESPs[player].box.Visible = ESP.Enabled
                        playerESPs[player].box.Color = ESP.BoxColor
                        playerESPs[player].box.Size = Vector2.new(
                            math.abs(topLeftPos.X - bottomRightPos.X),
                            math.abs(topLeftPos.Y - bottomRightPos.Y)
                        )
                        playerESPs[player].box.Position = Vector2.new(
                            math.min(topLeftPos.X, bottomRightPos.X),
                            math.min(topLeftPos.Y, bottomRightPos.Y)
                        )
                    else
                        playerESPs[player].box.Visible = false
                    end
                    
                    
                    if ESP.ShowName then
                        playerESPs[player].name.Text = player.Name
                        playerESPs[player].name.Position = Vector2.new(pos.X, pos.Y - size * 2)
                        playerESPs[player].name.Visible = ESP.Enabled
                    else
                        playerESPs[player].name.Visible = false
                    end
                    
                    if ESP.ShowHealth and humanoid then
                        playerESPs[player].health.Text = "HP: " .. math.floor(humanoid.Health)
                        playerESPs[player].health.Position = Vector2.new(pos.X, pos.Y + size * 1.5)
                        playerESPs[player].health.Visible = ESP.Enabled
                    else
                        playerESPs[player].health.Visible = false
                    end
                    
                    if ESP.ShowDistance then
                        local distance = math.floor((humanoidRootPart.Position - Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                        playerESPs[player].distance.Text = distance .. " studs"
                        playerESPs[player].distance.Position = Vector2.new(pos.X, pos.Y + size * 2.5)
                        playerESPs[player].distance.Visible = ESP.Enabled
                    else
                        playerESPs[player].distance.Visible = false
                    end
                    
                   
                    if ESP.Tracers then
                        playerESPs[player].tracer.Visible = ESP.Enabled
                        playerESPs[player].tracer.From = Vector2.new(pos.X, pos.Y)
                        playerESPs[player].tracer.To = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/ESP.AttachShift)
                        playerESPs[player].tracer.Color = ESP.TeamColor and player.Team and player.Team.TeamColor.Color or ESP.BoxColor
                    else
                        playerESPs[player].tracer.Visible = false
                    end
                else
                    playerESPs[player].box.Visible = false
                    playerESPs[player].name.Visible = false
                    playerESPs[player].health.Visible = false
                    playerESPs[player].distance.Visible = false
                    playerESPs[player].tracer.Visible = false
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    if ESP.Enabled then
        UpdateESP()
    end
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
        playerESPs[player] = CreateESP(player)
    end
end 