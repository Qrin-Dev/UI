-- =============================================================================
-- QRINZ UI LIBRARY BASE CODE (MODERN BLUE & PURPLE THEME - V2 MOBILE)
-- =============================================================================

local QrinzUI = {}
QrinzUI.__index = QrinzUI
QrinzUI.Services = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Color Palette (Dicerahkan agar tidak terlalu gelap)
local Colors = {
    MainBG = Color3.fromRGB(15, 15, 22),       -- Lebih terang sedikit dari sebelumnya
    ElementBG = Color3.fromRGB(26, 26, 38),    -- Background elemen lebih cerah
    Stroke = Color3.fromRGB(65, 65, 90),       -- Garis tepi default lebih terlihat
    StrokeActive = Color3.fromRGB(140, 60, 255),
    TextWhite = Color3.fromRGB(255, 255, 255),
    TextMuted = Color3.fromRGB(160, 165, 180), -- Teks abu-abu lebih terang
    Blue = Color3.fromRGB(0, 180, 255),
    Purple = Color3.fromRGB(140, 60, 255),
    Red = Color3.fromRGB(255, 75, 75),
    Green = Color3.fromRGB(75, 255, 75)
}

local BluePurpleGradient = ColorSequence.new{
    ColorSequenceKeypoint.new(0.0, Colors.Blue),
    ColorSequenceKeypoint.new(1.0, Colors.Purple)
}

-- Global Notification Container
local NotifyGui = Instance.new("ScreenGui")
NotifyGui.Name = "QrinzUINotifications"
NotifyGui.ResetOnSpawn = false
NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NotifyGui.Parent = PlayerGui

local NotifyContainer = Instance.new("Frame")
NotifyContainer.Name = "NotifyContainer"
NotifyContainer.Size = UDim2.new(0, 260, 0, 400) -- Dikecilkan untuk mobile
NotifyContainer.Position = UDim2.new(1, -270, 1, -20)
NotifyContainer.AnchorPoint = Vector2.new(0, 1)
NotifyContainer.BackgroundTransparency = 1
NotifyContainer.Parent = NotifyGui

local NotifyLayout = Instance.new("UIListLayout")
NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifyLayout.Padding = UDim.new(0, 8)
NotifyLayout.Parent = NotifyContainer

-- Draggable Function
local function MakeDraggable(uiInstance, targetFrame)
    local dragging, dragInput, dragStart, startPos
    uiInstance.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = targetFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    uiInstance.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            TweenService:Create(targetFrame, TweenInfo.new(0.12, Enum.EasingStyle.Sine), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
end

-- =============================================================================
-- NOTIFICATION SYSTEM
-- =============================================================================
function QrinzUI:Notification(options)
    local title = options.Title or "Notification"
    local content = options.Content or "Message body goes here."
    local duration = options.Duration or 3

    local NotifyFrame = Instance.new("Frame")
    NotifyFrame.Size = UDim2.new(1, 0, 0, 0)
    NotifyFrame.BackgroundColor3 = Colors.ElementBG
    NotifyFrame.ClipsDescendants = true
    NotifyFrame.Parent = NotifyContainer

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = NotifyFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Colors.Stroke
    Stroke.Thickness = 1.2
    Stroke.Parent = NotifyFrame
    local StrokeGrad = Instance.new("UIGradient")
    StrokeGrad.Color = BluePurpleGradient
    StrokeGrad.Parent = Stroke

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 0, 20)
    TitleLabel.Position = UDim2.new(0, 12, 0, 8)
    TitleLabel.Text = title
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 13
    TitleLabel.TextColor3 = Colors.TextWhite
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = NotifyFrame

    local ContentLabel = Instance.new("TextLabel")
    ContentLabel.Size = UDim2.new(1, -20, 0, 32)
    ContentLabel.Position = UDim2.new(0, 12, 0, 26)
    ContentLabel.Text = content
    ContentLabel.Font = Enum.Font.Gotham
    ContentLabel.TextSize = 11
    ContentLabel.TextColor3 = Colors.TextMuted
    ContentLabel.TextWrapped = true
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
    ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Parent = NotifyFrame

    TweenService:Create(NotifyFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 0, 0, 68)
    }):Play()

    task.delay(duration, function()
        local closeTween = TweenService:Create(NotifyFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1
        })
        closeTween:Play()
        closeTween.Completed:Connect(function() NotifyFrame:Destroy() end)
    end)
end

-- =============================================================================
-- WINDOW CREATION & KEY SYSTEM
-- =============================================================================
function QrinzUI:CreateWindow(options)
    local window = setmetatable({}, { __index = self })
    
    window.Title = options.Title or "Qrinz Window"
    window.Author = options.Author or ""
    window.Visible = true
    window.ToggleIcon = options.ToggleIcon or "rbxassetid://10734896206"
    window.Tabs = {}        -- Menyimpan referensi tombol tab
    window.TabPages = {}    -- Menyimpan referensi halaman tab

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "QrinzUIHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui
    window.ScreenGui = ScreenGui

    -- Ukuran diperkecil agar pas di mobile
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 315, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -157, 0.5, -190)
    MainFrame.BackgroundColor3 = Colors.MainBG
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    window.MainFrame = MainFrame
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame
    
    -- Efek Glowing / Terang di Tepi Jendela Utama
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Thickness = 1.5
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MainStroke.Parent = MainFrame
    local StrokeGradient = Instance.new("UIGradient")
    StrokeGradient.Color = BluePurpleGradient
    StrokeGradient.Parent = MainStroke

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 45)
    TopBar.BackgroundTransparency = 1
    TopBar.Parent = MainFrame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -30, 0, 22)
    TitleLabel.Position = UDim2.new(0, 15, 0, 6)
    TitleLabel.Text = window.Title
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 15
    TitleLabel.TextColor3 = Colors.TextWhite
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = TopBar

    if window.Author ~= "" then
        local AuthorLabel = Instance.new("TextLabel")
        AuthorLabel.Size = UDim2.new(1, -30, 0, 15)
        AuthorLabel.Position = UDim2.new(0, 15, 0, 24)
        AuthorLabel.Text = window.Author
        AuthorLabel.Font = Enum.Font.Gotham
        AuthorLabel.TextSize = 11
        AuthorLabel.TextColor3 = Colors.TextMuted
        AuthorLabel.TextXAlignment = Enum.TextXAlignment.Left
        AuthorLabel.BackgroundTransparency = 1
        AuthorLabel.Parent = TopBar
    end

    -- TAB CONTAINER (Bisa Di-scroll Ke Samping)
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, -20, 0, 34)
    TabContainer.Position = UDim2.new(0, 10, 0, 50)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0 -- Hilangkan scrollbar agar bersih
    TabContainer.ScrollingDirection = Enum.ScrollingDirection.X
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.Parent = MainFrame
    window.TabContainer = TabContainer

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.FillDirection = Enum.FillDirection.Horizontal
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 6)
    TabListLayout.Parent = TabContainer

    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, TabListLayout.AbsoluteContentSize.X, 0, 0)
    end)

    -- PAGE CONTAINER (Wadah untuk halaman-halaman menu)
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, -20, 1, -95)
    Container.Position = UDim2.new(0, 10, 0, 90)
    Container.BackgroundTransparency = 1
    Container.ClipsDescendants = true
    Container.Parent = MainFrame
    window.Container = Container

    local FloatButton = Instance.new("ImageButton")
    FloatButton.Name = "FloatToggleButton"
    FloatButton.Size = UDim2.new(0, 42, 0, 42)
    FloatButton.Position = UDim2.new(0, 25, 0, 25)
    FloatButton.BackgroundColor3 = Colors.ElementBG
    FloatButton.Image = window.ToggleIcon
    FloatButton.ImageColor3 = Colors.TextWhite
    FloatButton.Parent = ScreenGui
    FloatButton.Visible = not options.KeySystem

    local FloatCorner = Instance.new("UICorner")
    FloatCorner.CornerRadius = UDim.new(0, 10)
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
                Size = UDim2.new(0, 315, 0, 380)
            }):Play()
        else
            local closeTween = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 315, 0, 0)
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
        TabContainer.Visible = false
        
        local KeyConfig = options.KeySystem
        local ApiData = KeyConfig.API[1]
        local Service = QrinzUI.Services[ApiData.Type]
        
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
            NoteLabel.TextSize = 12
            NoteLabel.TextColor3 = Colors.TextMuted
            NoteLabel.TextWrapped = true
            NoteLabel.TextYAlignment = Enum.TextYAlignment.Center
            NoteLabel.BackgroundTransparency = 1
            NoteLabel.Parent = KeyFrame
            
            local InputFrame = Instance.new("Frame")
            InputFrame.Size = UDim2.new(1, -10, 0, 42)
            InputFrame.Position = UDim2.new(0, 5, 0, 95)
            InputFrame.BackgroundColor3 = Colors.ElementBG
            InputFrame.Parent = KeyFrame
            
            local InputCorner = Instance.new("UICorner")
            InputCorner.CornerRadius = UDim.new(0, 8)
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
            TextBox.TextSize = 13
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
            ButtonContainer.Size = UDim2.new(1, -10, 0, 40)
            ButtonContainer.Position = UDim2.new(0, 5, 0, 150)
            ButtonContainer.BackgroundTransparency = 1
            ButtonContainer.Parent = KeyFrame
            
            local UIList = Instance.new("UIListLayout")
            UIList.FillDirection = Enum.FillDirection.Horizontal
            UIList.Padding = UDim.new(0, 10)
            UIList.SortOrder = Enum.SortOrder.LayoutOrder
            UIList.Parent = ButtonContainer
            
            local CopyBtn = Instance.new("TextButton")
            CopyBtn.Size = UDim2.new(0.5, -5, 1, 0)
            CopyBtn.BackgroundColor3 = Colors.ElementBG
            CopyBtn.Text = "Copy Link"
            CopyBtn.Font = Enum.Font.GothamBold
            CopyBtn.TextSize = 12
            CopyBtn.TextColor3 = Colors.TextWhite
            CopyBtn.AutoButtonColor = false
            CopyBtn.Parent = ButtonContainer
            local CopyCorner = Instance.new("UICorner")
            CopyCorner.CornerRadius = UDim.new(0, 8)
            CopyCorner.Parent = CopyBtn
            local CopyStroke = Instance.new("UIStroke")
            CopyStroke.Color = Colors.Stroke
            CopyStroke.Thickness = 1
            CopyStroke.Parent = CopyBtn
            
            local VerifyBtn = Instance.new("TextButton")
            VerifyBtn.Size = UDim2.new(0.5, -5, 1, 0)
            VerifyBtn.BackgroundColor3 = Colors.Purple
            VerifyBtn.Text = "Verify"
            VerifyBtn.Font = Enum.Font.GothamBold
            VerifyBtn.TextSize = 12
            VerifyBtn.TextColor3 = Colors.TextWhite
            VerifyBtn.AutoButtonColor = false
            VerifyBtn.Parent = ButtonContainer
            local VerifyCorner = Instance.new("UICorner")
            VerifyCorner.CornerRadius = UDim.new(0, 8)
            VerifyCorner.Parent = VerifyBtn
            
            CopyBtn.MouseButton1Click:Connect(function()
                ApiHandler.Copy()
                self:Notification({Title = "System", Content = "Key link copied!", Duration = 3})
                CopyBtn.Text = "Copied!"
                task.wait(1.5)
                CopyBtn.Text = "Copy Link"
            end)
            
            VerifyBtn.MouseButton1Click:Connect(function()
                VerifyBtn.Text = "Checking..."
                local success, msg = ApiHandler.Verify(TextBox.Text)
                
                if success then
                    VerifyBtn.Text = "Granted!"
                    TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color = Colors.Green}):Play()
                    task.wait(0.8)
                    KeyFrame:Destroy()
                    FloatButton.Visible = true
                    Container.Visible = true
                    TabContainer.Visible = true -- Munculkan tab
                else
                    VerifyBtn.Text = "Failed"
                    TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color = Colors.Red}):Play()
                    self:Notification({Title = "Error", Content = msg or "Invalid key.", Duration = 4})
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
-- TAB SYSTEM & BASE MENU ELEMENTS
-- =============================================================================
function QrinzUI:Tab(options)
    local tabTitle = options.Title or "Tab"
    
    -- Membuat Tombol Tab di TabContainer
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabTitle .. "Btn"
    TabButton.Size = UDim2.new(0, 0, 1, 0) -- Lebar diatur dinamis di bawah
    TabButton.BackgroundColor3 = Colors.ElementBG
    TabButton.Text = tabTitle
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextSize = 12
    TabButton.TextColor3 = Colors.TextMuted
    TabButton.AutoButtonColor = false
    TabButton.Parent = self.TabContainer
    
    -- Sesuaikan lebar tombol tab dengan panjang teksnya
    local textBounds = game:GetService("TextService"):GetTextSize(tabTitle, 12, Enum.Font.GothamBold, Vector2.new(999, 999))
    TabButton.Size = UDim2.new(0, textBounds.X + 24, 1, 0)

    local TabBtnCorner = Instance.new("UICorner")
    TabBtnCorner.CornerRadius = UDim.new(0, 6)
    TabBtnCorner.Parent = TabButton
    
    local TabBtnStroke = Instance.new("UIStroke")
    TabBtnStroke.Color = Colors.Stroke
    TabBtnStroke.Thickness = 1
    TabBtnStroke.Parent = TabButton

    -- Membuat Halaman Tab di Container
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Name = tabTitle .. "Page"
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.ScrollBarThickness = 2
    TabPage.ScrollBarImageColor3 = Colors.Purple
    TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabPage.Visible = false -- Sembunyikan secara default
    TabPage.Parent = self.Container

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 8)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = TabPage

    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingTop = UDim.new(0, 2)
    UIPadding.PaddingBottom = UDim.new(0, 10)
    UIPadding.PaddingLeft = UDim.new(0, 2)
    UIPadding.PaddingRight = UDim.new(0, 2)
    UIPadding.Parent = TabPage

    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabPage.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 15)
    end)

    -- Simpan ke memori jendela UI
    table.insert(self.Tabs, TabButton)
    table.insert(self.TabPages, TabPage)

    -- Logika Pergantian Tab
    local function ActivateTab()
        -- Reset semua tab
        for _, btn in pairs(self.Tabs) do
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.ElementBG, TextColor3 = Colors.TextMuted}):Play()
            btn.UIStroke.Color = Colors.Stroke
        end
        for _, page in pairs(self.TabPages) do
            page.Visible = false
        end
        
        -- Aktifkan tab ini
        TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Purple, TextColor3 = Colors.TextWhite}):Play()
        TabBtnStroke.Color = Colors.StrokeActive
        TabPage.Visible = true
    end

    -- Jika ini tab pertama yang dibuat, aktifkan otomatis
    if #self.Tabs == 1 then
        ActivateTab()
    end

    TabButton.MouseButton1Click:Connect(ActivateTab)

    -- Memasukkan fungsionalitas UI Elements ke tab
    local tab = {}
    tab.Page = TabPage
    for k, v in pairs(QrinzUI.Elements) do
        tab[k] = v
    end
    return tab
end

QrinzUI.Elements = {}

-- UI ELEMENTS (Desain diperbarui dengan Edge Glowing / Stroke Gradient)
function QrinzUI.Elements:Toggle(options)
    local state = options.Value or false
    local callback = options.Callback or function() end

    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 42)
    ToggleFrame.BackgroundColor3 = Colors.ElementBG
    ToggleFrame.Parent = self.Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = ToggleFrame
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 1.2
    Stroke.Parent = ToggleFrame
    local StrokeGrad = Instance.new("UIGradient")
    StrokeGrad.Color = BluePurpleGradient
    StrokeGrad.Parent = Stroke

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
    Checkbox.Size = UDim2.new(0, 20, 0, 20)
    Checkbox.Position = UDim2.new(1, -32, 0.5, -10)
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
    Indicator.Size = UDim2.new(0, 12, 0, 12)
    Indicator.Position = UDim2.new(0.5, -6, 0.5, -6)
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
        callback(state)
    end

    Checkbox.MouseButton1Click:Connect(function()
        state = not state
        updateToggle()
    end)
    
    if state then callback(state) end

    return {
        Set = function(val)
            state = val
            updateToggle()
        end
    }
end

function QrinzUI.Elements:Button(options)
    local callback = options.Callback or function() end

    local ButtonFrame = Instance.new("TextButton")
    ButtonFrame.Size = UDim2.new(1, 0, 0, 42)
    ButtonFrame.BackgroundColor3 = Colors.ElementBG
    ButtonFrame.Text = ""
    ButtonFrame.AutoButtonColor = false
    ButtonFrame.Parent = self.Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = ButtonFrame
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 1.2
    Stroke.Parent = ButtonFrame
    local StrokeGrad = Instance.new("UIGradient")
    StrokeGrad.Color = BluePurpleGradient
    StrokeGrad.Parent = Stroke

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
        TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 50)}):Play()
    end)
    ButtonFrame.MouseLeave:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Colors.ElementBG}):Play()
    end)

    ButtonFrame.MouseButton1Click:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = Colors.Purple}):Play()
        task.wait(0.1)
        TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 50)}):Play()
        callback()
    end)
end

function QrinzUI.Elements:Dropdown(options)
    local callback = options.Callback or function() end
    local selectedValues = options.Value or {}
    
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Size = UDim2.new(1, 0, 0, 42)
    DropdownFrame.BackgroundColor3 = Colors.ElementBG
    DropdownFrame.ClipsDescendants = true
    DropdownFrame.Parent = self.Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = DropdownFrame
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 1.2
    Stroke.Parent = DropdownFrame
    local StrokeGrad = Instance.new("UIGradient")
    StrokeGrad.Color = BluePurpleGradient
    StrokeGrad.Parent = Stroke

    local TriggerButton = Instance.new("TextButton")
    TriggerButton.Size = UDim2.new(1, 0, 0, 42)
    TriggerButton.BackgroundTransparency = 1
    TriggerButton.Text = ""
    TriggerButton.Parent = DropdownFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -40, 0, 42)
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
            Size = isOpen and UDim2.new(1, 0, 0, 42 + (#options.Values * 32) + 5) or UDim2.new(1, 0, 0, 42)
        }):Play()
    end)

    for i, val in ipairs(options.Values) do
        local OptionBtn = Instance.new("TextButton")
        OptionBtn.Size = UDim2.new(1, -24, 0, 28)
        OptionBtn.Position = UDim2.new(0, 12, 0, 42 + (i-1)*32)
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
            TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, 42)}):Play()
            callback({val})
        end)
    end
end

return QrinzUI
