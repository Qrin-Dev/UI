local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local QrinzUI = {}
QrinzUI.Elements = {}
QrinzUI.Services = {} -- Tempat untuk service Key System (jika ada)

-- =============================================================================
-- KONFIGURASI WARNA & VISUAL UTAMA
-- =============================================================================
local Colors = {
    MainBG = Color3.fromRGB(20, 20, 25),
    ElementBG = Color3.fromRGB(30, 30, 35),
    Stroke = Color3.fromRGB(50, 50, 60),
    StrokeActive = Color3.fromRGB(100, 100, 255),
    TextWhite = Color3.fromRGB(255, 255, 255),
    TextMuted = Color3.fromRGB(150, 150, 150),
    Purple = Color3.fromRGB(138, 43, 226),
    Green = Color3.fromRGB(46, 204, 113),
    Red = Color3.fromRGB(231, 76, 60)
}

local BluePurpleGradient = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(85, 85, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 85, 255))
})

-- =============================================================================
-- FUNGSI DRAGGABLE
-- =============================================================================
local function MakeDraggable(topbarobject, object)
    local Dragging = false
    local DragInput
    local DragStart
    local StartPosition

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local delta = input.Position - DragStart
            object.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + delta.Y)
        end
    end)
end

-- =============================================================================
-- SISTEM NOTIFIKASI SEMENTARA
-- =============================================================================
function QrinzUI:Notification(args)
    -- Ini adalah sistem notifikasi default jika belum ada modul notifikasi eksternal
    warn("[QrinzUI Notification] " .. tostring(args.Title) .. " - " .. tostring(args.Content))
end

-- =============================================================================
-- MAIN WINDOW MAKER
-- =============================================================================
function QrinzUI:MakeWindow(options)
    local window = {
        Visible = true,
        ToggleIcon = options.ToggleIcon or "rbxassetid://10618928818" -- Icon Default
    }
    options = options or {}
    
    -- MAIN GUI TIER
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "QrinzUI_Window"
    ScreenGui.ResetOnSpawn = false
    -- Otomatis mendeteksi apakah dijalankan di exploit (CoreGui) atau Studio (PlayerGui)
    local success, err = pcall(function() ScreenGui.Parent = CoreGui end)
    if not success then ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 310, 0, 370)
    MainFrame.Position = UDim2.new(0.5, -155, 0.5, -185)
    MainFrame.BackgroundColor3 = Colors.MainBG
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    window.MainFrame = MainFrame

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Colors.Stroke
    MainStroke.Thickness = 1.5
    MainStroke.Parent = MainFrame

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundTransparency = 1
    TopBar.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -30, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Text = options.Name or "Qrinz Hub"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextColor3 = Colors.TextWhite
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.Parent = TopBar

    -- ==================== KODE ASLI ANDA DIMULAI DARI SINI ====================
    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, -30, 0, 1)
    Divider.Position = UDim2.new(0, 15, 0, 49)
    Divider.BackgroundColor3 = Colors.Stroke
    Divider.BackgroundTransparency = 0.5
    Divider.BorderSizePixel = 0
    Divider.Parent = TopBar

    -- TAB BAR NAVIGATION (Scroll ke Samping)
    local TabBar = Instance.new("ScrollingFrame")
    TabBar.Name = "TabBar"
    TabBar.Size = UDim2.new(1, -20, 0, 35)
    TabBar.Position = UDim2.new(0, 10, 0, 55)
    TabBar.BackgroundTransparency = 1
    TabBar.ScrollBarThickness = 0
    TabBar.ScrollingDirection = Enum.ScrollingDirection.X
    TabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabBar.Parent = MainFrame
    self.TabBar = TabBar -- Diperbaiki menjadi self.TabBar untuk kompatibilitas QrinzUI:Tab()

    local TabList = Instance.new("UIListLayout")
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 8)
    TabList.Parent = TabBar

    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 2)
    TabPadding.PaddingBottom = UDim.new(0, 2)
    TabPadding.Parent = TabBar

    TabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabBar.CanvasSize = UDim2.new(0, TabList.AbsoluteContentSize.X, 0, 0)
    end)

    -- CONTAINER UTAMA
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, -20, 1, -100)
    Container.Position = UDim2.new(0, 10, 0, 95)
    Container.BackgroundTransparency = 1
    Container.ClipsDescendants = true
    Container.Parent = MainFrame
    self.Container = Container -- Diperbaiki menjadi self.Container

    local FloatButton = Instance.new("ImageButton")
    FloatButton.Name = "FloatToggleButton"
    FloatButton.Size = UDim2.new(0, 45, 0, 45)
    FloatButton.Position = UDim2.new(0, 25, 0, 25)
    FloatButton.BackgroundColor3 = Colors.ElementBG
    FloatButton.Image = window.ToggleIcon
    FloatButton.ImageColor3 = Colors.TextWhite
    FloatButton.Parent = ScreenGui
    FloatButton.Visible = not options.KeySystem

    local FloatCorner = Instance.new("UICorner")
    FloatCorner.CornerRadius = UDim.new(0, 12)
    FloatCorner.Parent = FloatButton

    local FloatStroke = Instance.new("UIStroke")
    FloatStroke.Thickness = 1.5
    FloatStroke.Parent = FloatButton
    local FloatGradient = Instance.new("UIGradient")
    FloatGradient.Color = BluePurpleGradient
    FloatGradient.Parent = FloatStroke

    FloatButton.MouseButton1Click:Connect(function()
        window.Visible = not window.Visible
        if window.Visible then
            MainFrame.Visible = true
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 310, 0, 370)
            }):Play()
        else
            local closeTween = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 310, 0, 0)
            })
            closeTween:Play()
            closeTween.Completed:Connect(function()
                if not window.Visible then MainFrame.Visible = false end
            end)
        end
    end)

    MakeDraggable(TopBar, MainFrame)
    MakeDraggable(FloatButton, FloatButton)

    -- INTEGRASI KEY SYSTEM
    if options.KeySystem then
        Container.Visible = false
        TabBar.Visible = false
        
        local KeyConfig = options.KeySystem
        local ApiData = KeyConfig.API and KeyConfig.API[1]
        
        -- Fallback jika service tidak ditemukan
        local Service = QrinzUI.Services[ApiData and ApiData.Type or "None"] 
        if Service then
            local ApiHandler = Service.New(ApiData.ServiceId, ApiData.SuperId)
            
            local KeyFrame = Instance.new("Frame")
            KeyFrame.Name = "KeyFrame"
            KeyFrame.Size = UDim2.new(1, -20, 1, -65)
            KeyFrame.Position = UDim2.new(0, 10, 0, 55)
            KeyFrame.BackgroundTransparency = 1
            KeyFrame.Parent = MainFrame
            
            local NoteLabel = Instance.new("TextLabel")
            NoteLabel.Size = UDim2.new(1, -10, 0, 70)
            NoteLabel.Position = UDim2.new(0, 5, 0, 10)
            NoteLabel.Text = KeyConfig.Note or "Please get and verify your secure key to access the hub features."
            NoteLabel.Font = Enum.Font.GothamMedium
            NoteLabel.TextSize = 13
            NoteLabel.TextColor3 = Colors.TextMuted
            NoteLabel.TextWrapped = true
            NoteLabel.TextYAlignment = Enum.TextYAlignment.Center
            NoteLabel.BackgroundTransparency = 1
            NoteLabel.Parent = KeyFrame
            
            local InputFrame = Instance.new("Frame")
            InputFrame.Size = UDim2.new(1, -10, 0, 46)
            InputFrame.Position = UDim2.new(0, 5, 0, 95)
            InputFrame.BackgroundColor3 = Colors.ElementBG
            InputFrame.Parent = KeyFrame
            
            local InputCorner = Instance.new("UICorner")
            InputCorner.CornerRadius = UDim.new(0, 10)
            InputCorner.Parent = InputFrame
            
            local InputStroke = Instance.new("UIStroke")
            InputStroke.Color = Colors.Stroke
            InputStroke.Thickness = 1.2
            InputStroke.Parent = InputFrame
            
            local TextBox = Instance.new("TextBox")
            TextBox.Size = UDim2.new(1, -24, 1, 0)
            TextBox.Position = UDim2.new(0, 12, 0, 0)
            TextBox.BackgroundTransparency = 1
            TextBox.Text = ""
            TextBox.PlaceholderText = "Enter key here..."
            TextBox.PlaceholderColor3 = Colors.TextMuted
            TextBox.Font = Enum.Font.GothamMedium
            TextBox.TextSize = 14
            TextBox.TextColor3 = Colors.TextWhite
            TextBox.TextXAlignment = Enum.TextXAlignment.Left
            TextBox.Parent = InputFrame
            
            TextBox.Focused:Connect(function()
                TweenService:Create(InputStroke, TweenInfo.new(0.25), {Color = Colors.StrokeActive}):Play()
            end)
            TextBox.FocusLost:Connect(function()
                TweenService:Create(InputStroke, TweenInfo.new(0.25), {Color = Colors.Stroke}):Play()
            end)
            
            local ButtonContainer = Instance.new("Frame")
            ButtonContainer.Size = UDim2.new(1, -10, 0, 44)
            ButtonContainer.Position = UDim2.new(0, 5, 0, 155)
            ButtonContainer.BackgroundTransparency = 1
            ButtonContainer.Parent = KeyFrame
            
            local UIList = Instance.new("UIListLayout")
            UIList.FillDirection = Enum.FillDirection.Horizontal
            UIList.Padding = UDim.new(0, 12)
            UIList.SortOrder = Enum.SortOrder.LayoutOrder
            UIList.Parent = ButtonContainer
            
            local CopyBtn = Instance.new("TextButton")
            CopyBtn.Size = UDim2.new(0.5, -6, 1, 0)
            CopyBtn.BackgroundColor3 = Colors.ElementBG
            CopyBtn.Text = "Copy Link"
            CopyBtn.Font = Enum.Font.GothamBold
            CopyBtn.TextSize = 13
            CopyBtn.TextColor3 = Colors.TextWhite
            CopyBtn.AutoButtonColor = false
            CopyBtn.Parent = ButtonContainer
            
            local CopyCorner = Instance.new("UICorner")
            CopyCorner.CornerRadius = UDim.new(0, 10)
            CopyCorner.Parent = CopyBtn
            
            local CopyStroke = Instance.new("UIStroke")
            CopyStroke.Color = Colors.Stroke
            CopyStroke.Thickness = 1
            CopyStroke.Parent = CopyBtn
            
            local VerifyBtn = Instance.new("TextButton")
            VerifyBtn.Size = UDim2.new(0.5, -6, 1, 0)
            VerifyBtn.BackgroundColor3 = Colors.Purple
            VerifyBtn.Text = "Verify"
            VerifyBtn.Font = Enum.Font.GothamBold
            VerifyBtn.TextSize = 13
            VerifyBtn.TextColor3 = Colors.TextWhite
            VerifyBtn.AutoButtonColor = false
            VerifyBtn.Parent = ButtonContainer
            
            local VerifyCorner = Instance.new("UICorner")
            VerifyCorner.CornerRadius = UDim.new(0, 10)
            VerifyCorner.Parent = VerifyBtn
            
            CopyBtn.MouseEnter:Connect(function() TweenService:Create(CopyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 50)}):Play() end)
            CopyBtn.MouseLeave:Connect(function() TweenService:Create(CopyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.ElementBG}):Play() end)
            CopyBtn.MouseButton1Click:Connect(function()
                ApiHandler.Copy()
                self:Notification({Title = "Key System", Content = "Link disalin!", Duration = 3})
                CopyBtn.Text = "Copied!"
                task.wait(1.5)
                CopyBtn.Text = "Copy Link"
            end)
            
            VerifyBtn.MouseEnter:Connect(function() TweenService:Create(VerifyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(155, 75, 255)}):Play() end)
            VerifyBtn.MouseLeave:Connect(function() TweenService:Create(VerifyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Purple}):Play() end)
            VerifyBtn.MouseButton1Click:Connect(function()
                VerifyBtn.Text = "..."
                local successKey, msg = ApiHandler.Verify(TextBox.Text)
                
                if successKey then
                    VerifyBtn.Text = "Granted!"
                    TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color = Colors.Green}):Play()
                    self:Notification({Title = "Key System", Content = "Akses diterima!", Duration = 4})
                    task.wait(0.8)
                    
                    KeyFrame:Destroy()
                    FloatButton.Visible = true
                    Container.Visible = true
                    TabBar.Visible = true
                else
                    VerifyBtn.Text = "Failed"
                    TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color = Colors.Red}):Play()
                    self:Notification({Title = "Error", Content = msg or "Key salah.", Duration = 4})
                    task.wait(1.5)
                    VerifyBtn.Text = "Verify"
                    TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color = Colors.Stroke}):Play()
                end
            end)
        end
    end

    return window
end

-- =============================================================================
-- BASE MENU ELEMENTS
-- =============================================================================
function QrinzUI:Tab(options)
    local tab = {}
    
    local TabButton = Instance.new("TextButton")
    TabButton.Name = options.Title .. "Btn"
    TabButton.Size = UDim2.new(0, 0, 1, 0)
    TabButton.AutomaticSize = Enum.AutomaticSize.X
    TabButton.BackgroundColor3 = Colors.ElementBG
    TabButton.Text = "  " .. options.Title .. "  "
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextSize = 12
    TabButton.TextColor3 = Colors.TextMuted
    TabButton.AutoButtonColor = false
    TabButton.Parent = self.TabBar

    local TabBtnCorner = Instance.new("UICorner")
    TabBtnCorner.CornerRadius = UDim.new(0, 6)
    TabBtnCorner.Parent = TabButton

    local TabBtnStroke = Instance.new("UIStroke")
    TabBtnStroke.Color = Colors.Stroke
    TabBtnStroke.Thickness = 1
    TabBtnStroke.Parent = TabButton

    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Name = options.Title .. "Page"
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.ScrollBarThickness = 3
    TabPage.ScrollBarImageColor3 = Colors.Purple
    TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabPage.Visible = false
    TabPage.Parent = self.Container

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 8)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = TabPage

    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingTop = UDim.new(0, 5)
    UIPadding.PaddingBottom = UDim.new(0, 5)
    UIPadding.PaddingLeft = UDim.new(0, 5)
    UIPadding.PaddingRight = UDim.new(0, 5)
    UIPadding.Parent = TabPage

    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabPage.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 20)
    end)

    TabButton.MouseButton1Click:Connect(function()
        if self.CurrentTab then
            self.CurrentTab.Page.Visible = false
            TweenService:Create(self.CurrentTab.Button.UIStroke, TweenInfo.new(0.2), {Color = Colors.Stroke}):Play()
            TweenService:Create(self.CurrentTab.Button, TweenInfo.new(0.2), {TextColor3 = Colors.TextMuted}):Play()
        end
        self.CurrentTab = {Page = TabPage, Button = TabButton}
        TabPage.Visible = true
        TweenService:Create(TabBtnStroke, TweenInfo.new(0.2), {Color = Colors.StrokeActive}):Play()
        TweenService:Create(TabButton, TweenInfo.new(0.2), {TextColor3 = Colors.TextWhite}):Play()
    end)

    if not self.CurrentTab then
        self.CurrentTab = {Page = TabPage, Button = TabButton}
        TabPage.Visible = true
        TabBtnStroke.Color = Colors.StrokeActive
        TabButton.TextColor3 = Colors.TextWhite
    end

    tab.Page = TabPage
    for k, v in pairs(QrinzUI.Elements) do
        tab[k] = v
    end
    return tab
end

-- =============================================================================
-- ELEMENTS
-- =============================================================================

function QrinzUI.Elements:Input(options)
    local callback = options.Callback or function() end
    local placeholder = options.Placeholder or "Enter text..."

    local InputFrame = Instance.new("Frame")
    InputFrame.Size = UDim2.new(1, 0, 0, 60)
    InputFrame.BackgroundColor3 = Colors.ElementBG
    InputFrame.Parent = self.Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = InputFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Colors.Stroke
    Stroke.Thickness = 1.2
    Stroke.Parent = InputFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -24, 0, 20)
    Title.Position = UDim2.new(0, 12, 0, 6)
    Title.Text = options.Title or "Text Input"
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 13
    Title.TextColor3 = Colors.TextWhite
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.Parent = InputFrame

    local BoxFrame = Instance.new("Frame")
    BoxFrame.Size = UDim2.new(1, -24, 0, 26)
    BoxFrame.Position = UDim2.new(0, 12, 0, 28)
    BoxFrame.BackgroundColor3 = Colors.MainBG
    BoxFrame.Parent = InputFrame

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 6)
    BoxCorner.Parent = BoxFrame

    local BoxStroke = Instance.new("UIStroke")
    BoxStroke.Color = Colors.Stroke
    BoxStroke.Thickness = 1
    BoxStroke.Parent = BoxFrame

    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(1, -16, 1, 0)
    TextBox.Position = UDim2.new(0, 8, 0, 0)
    TextBox.BackgroundTransparency = 1
    TextBox.Text = ""
    TextBox.PlaceholderText = placeholder
    TextBox.PlaceholderColor3 = Colors.TextMuted
    TextBox.Font = Enum.Font.Gotham
    TextBox.TextSize = 12
    TextBox.TextColor3 = Colors.TextWhite
    TextBox.TextXAlignment = Enum.TextXAlignment.Left
    TextBox.ClearTextOnFocus = false
    TextBox.Parent = BoxFrame

    TextBox.Focused:Connect(function()
        TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Color = Colors.StrokeActive}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Colors.StrokeActive}):Play()
    end)

    TextBox.FocusLost:Connect(function()
        TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Color = Colors.Stroke}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Colors.Stroke}):Play()
        callback(TextBox.Text)
    end)

    return {
        Set = function(text)
            TextBox.Text = text
            callback(text)
        end
    }
end

function QrinzUI.Elements:Toggle(options)
    local state = options.Value or false
    local callback = options.Callback or function() end

    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 44)
    ToggleFrame.BackgroundColor3 = Colors.ElementBG
    ToggleFrame.Parent = self.Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = ToggleFrame
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Colors.Stroke
    Stroke.Thickness = 1.2
    Stroke.Parent = ToggleFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.Text = options.Title
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 13
    Title.TextColor3 = Colors.TextWhite
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.Parent = ToggleFrame

    local Checkbox = Instance.new("TextButton")
    Checkbox.Size = UDim2.new(0, 22, 0, 22)
    Checkbox.Position = UDim2.new(1, -34, 0.5, -11)
    Checkbox.BackgroundColor3 = Colors.MainBG
    Checkbox.Text = ""
    Checkbox.Parent = ToggleFrame

    local CheckBoxCorner = Instance.new("UICorner")
    CheckBoxCorner.CornerRadius = UDim.new(0, 6)
    CheckBoxCorner.Parent = Checkbox

    local CheckBoxStroke = Instance.new("UIStroke")
    CheckBoxStroke.Color = Colors.Stroke
    CheckBoxStroke.Thickness = 1
    CheckBoxStroke.Parent = Checkbox

    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 14, 0, 14)
    Indicator.Position = UDim2.new(0.5, -7, 0.5, -7)
    Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Indicator.BackgroundTransparency = state and 0 or 1
    Indicator.Parent = Checkbox
    
    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(0, 4)
    IndicatorCorner.Parent = Indicator
    
    local IndicatorGradient = Instance.new("UIGradient")
    IndicatorGradient.Color = BluePurpleGradient
    IndicatorGradient.Parent = Indicator

    local function updateToggle()
        TweenService:Create(Indicator, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
            BackgroundTransparency = state and 0 or 1
        }):Play()
        TweenService:Create(CheckBoxStroke, TweenInfo.new(0.2), {Color = state and Colors.StrokeActive or Colors.Stroke}):Play()
        callback(state)
    end

    Checkbox.MouseButton1Click:Connect(function()
        state = not state
        updateToggle()
    end)
    
    if state then callback(state) end

    return { Set = function(val) state = val; updateToggle() end }
end

function QrinzUI.Elements:Button(options)
    local callback = options.Callback or function() end

    local ButtonFrame = Instance.new("TextButton")
    ButtonFrame.Size = UDim2.new(1, 0, 0, 44)
    ButtonFrame.BackgroundColor3 = Colors.ElementBG
    ButtonFrame.Text = ""
    ButtonFrame.AutoButtonColor = false
    ButtonFrame.Parent = self.Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = ButtonFrame
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Colors.Stroke
    Stroke.Thickness = 1.2
    Stroke.Parent = ButtonFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.Text = options.Title
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 13
    Title.TextColor3 = Colors.TextWhite
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.Parent = ButtonFrame
    
    ButtonFrame.MouseEnter:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 48)}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Colors.StrokeActive}):Play()
    end)
    ButtonFrame.MouseLeave:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Colors.ElementBG}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Colors.Stroke}):Play()
    end)

    ButtonFrame.MouseButton1Click:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = Colors.Purple}):Play()
        task.wait(0.1)
        TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 48)}):Play()
        callback()
    end)
end

function QrinzUI.Elements:Dropdown(options)
    local callback = options.Callback or function() end
    local selectedValues = options.Value or {}
    
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Size = UDim2.new(1, 0, 0, 44)
    DropdownFrame.BackgroundColor3 = Colors.ElementBG
    DropdownFrame.ClipsDescendants = true
    DropdownFrame.Parent = self.Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = DropdownFrame
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Colors.Stroke
    Stroke.Thickness = 1.2
    Stroke.Parent = DropdownFrame

    local TriggerButton = Instance.new("TextButton")
    TriggerButton.Size = UDim2.new(1, 0, 0, 44)
    TriggerButton.BackgroundTransparency = 1
    TriggerButton.Text = ""
    TriggerButton.Parent = DropdownFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -40, 0, 44)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.Text = options.Title .. " : " .. tostring(selectedValues[1] or "None")
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 13
    Title.TextColor3 = Colors.TextWhite
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.Parent = TriggerButton

    local isOpen = false
    TriggerButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
            Size = isOpen and UDim2.new(1, 0, 0, 44 + (#options.Values * 34) + 5) or UDim2.new(1, 0, 0, 44)
        }):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.3), {Color = isOpen and Colors.StrokeActive or Colors.Stroke}):Play()
    end)

    for i, val in ipairs(options.Values) do
        local OptionBtn = Instance.new("TextButton")
        OptionBtn.Size = UDim2.new(1, -24, 0, 30)
        OptionBtn.Position = UDim2.new(0, 12, 0, 44 + (i-1)*34)
        OptionBtn.BackgroundColor3 = Colors.MainBG
        OptionBtn.Text = val
        OptionBtn.Font = Enum.Font.Gotham
        OptionBtn.TextSize = 12
        OptionBtn.TextColor3 = Colors.TextMuted
        OptionBtn.Parent = DropdownFrame
        
        local optCorner = Instance.new("UICorner")
        optCorner.CornerRadius = UDim.new(0, 5)
        optCorner.Parent = OptionBtn
        
        local optStroke = Instance.new("UIStroke")
        optStroke.Color = Colors.Stroke
        optStroke.Thickness = 1
        optStroke.Parent = OptionBtn

        OptionBtn.MouseEnter:Connect(function()
            TweenService:Create(OptionBtn, TweenInfo.new(0.2), {TextColor3 = Colors.TextWhite, BackgroundColor3 = Color3.fromRGB(35, 35, 50)}):Play()
        end)
        OptionBtn.MouseLeave:Connect(function()
            TweenService:Create(OptionBtn, TweenInfo.new(0.2), {TextColor3 = Colors.TextMuted, BackgroundColor3 = Colors.MainBG}):Play()
        end)

        OptionBtn.MouseButton1Click:Connect(function()
            Title.Text = options.Title .. " : " .. val
            isOpen = false
            TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, 44)}):Play()
            TweenService:Create(Stroke, TweenInfo.new(0.3), {Color = Colors.Stroke}):Play()
            callback({val})
        end)
    end
end

return QrinzUI
