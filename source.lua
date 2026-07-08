-- =============================================================================
-- QRINZ UI LIBRARY BASE CODE (MODERN FRESH THEME)
-- =============================================================================

local QrinzUI = {}
QrinzUI.__index = QrinzUI
QrinzUI.Services = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Color Palette (Diperbarui agar lebih terang & fresh)
local Colors = {
    MainBG = Color3.fromRGB(15, 15, 22),
    ElementBG = Color3.fromRGB(28, 28, 40),
    Stroke = Color3.fromRGB(75, 75, 100), -- Diperterang dari sebelumnya
    StrokeActive = Color3.fromRGB(160, 90, 255),
    TextWhite = Color3.fromRGB(255, 255, 255),
    TextMuted = Color3.fromRGB(160, 165, 180),
    Blue = Color3.fromRGB(0, 200, 255),
    Purple = Color3.fromRGB(160, 90, 255),
    Red = Color3.fromRGB(255, 85, 85),
    Green = Color3.fromRGB(85, 255, 85)
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
NotifyContainer.Size = UDim2.new(0, 280, 0, 400)
NotifyContainer.Position = UDim2.new(1, -290, 1, -20)
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
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
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
    Stroke.Color = Colors.StrokeActive -- Highlight terang di notifikasi
    Stroke.Thickness = 1.2
    Stroke.Parent = NotifyFrame

    local AccentBar = Instance.new("Frame")
    AccentBar.Size = UDim2.new(0, 4, 1, 0)
    AccentBar.BorderSizePixel = 0
    AccentBar.Parent = NotifyFrame
    local AccentGradient = Instance.new("UIGradient")
    AccentGradient.Color = BluePurpleGradient
    AccentGradient.Parent = AccentBar

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
        closeTween.Completed:Connect(function()
            NotifyFrame:Destroy()
        end)
    end)
end

-- =============================================================================
-- WINDOW CREATION
-- =============================================================================
function QrinzUI:CreateWindow(options)
    local window = setmetatable({}, { __index = self })
    
    window.Title = options.Title or "Qrinz Window"
    window.Author = options.Author or ""
    window.Visible = true
    window.ToggleIcon = options.ToggleIcon or "rbxassetid://10734896206"
    window.Tabs = {}

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "QrinzUIHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui
    window.ScreenGui = ScreenGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 320, 0, 380) -- Ukuran diperkecil agar pas di mobile
    MainFrame.Position = UDim2.new(0.5, -160, 0.5, -190)
    MainFrame.BackgroundColor3 = Colors.MainBG
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    window.MainFrame = MainFrame
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame
    
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
    TitleLabel.Size = UDim2.new(1, -30, 0, 25)
    TitleLabel.Position = UDim2.new(0, 15, 0, 5)
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
        AuthorLabel.TextSize = 10
        AuthorLabel.TextColor3 = Colors.TextMuted
        AuthorLabel.TextXAlignment = Enum.TextXAlignment.Left
        AuthorLabel.BackgroundTransparency = 1
        AuthorLabel.Parent = TopBar
    end

    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, 0, 0, 1)
    Divider.Position = UDim2.new(0, 0, 0, 44)
    Divider.BackgroundColor3 = Colors.Stroke
    Divider.BackgroundTransparency = 0.4
    Divider.BorderSizePixel = 0
    Divider.Parent = TopBar

    -- Sistem Tab Header (Bisa digeser/scroll horizontal)
    local TabHeader = Instance.new("ScrollingFrame")
    TabHeader.Name = "TabHeader"
    TabHeader.Size = UDim2.new(1, -20, 0, 35)
    TabHeader.Position = UDim2.new(0, 10, 0, 50)
    TabHeader.BackgroundTransparency = 1
    TabHeader.ScrollBarThickness = 0 -- Scrollbar disembunyikan agar bersih
    TabHeader.ScrollingDirection = Enum.ScrollingDirection.X
    TabHeader.Parent = MainFrame
    window.TabHeader = TabHeader

    local TabHeaderLayout = Instance.new("UIListLayout")
    TabHeaderLayout.FillDirection = Enum.FillDirection.Horizontal
    TabHeaderLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabHeaderLayout.Padding = UDim.new(0, 8)
    TabHeaderLayout.Parent = TabHeader
    
    TabHeaderLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabHeader.CanvasSize = UDim2.new(0, TabHeaderLayout.AbsoluteContentSize.X, 0, 0)
    end)

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
    FloatButton.Size = UDim2.new(0, 45, 0, 45)
    FloatButton.Position = UDim2.new(0, 20, 0, 20)
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
                Size = UDim2.new(0, 320, 0, 380)
            }):Play()
        else
            local closeTween = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 320, 0, 0)
            })
            closeTween:Play()
            closeTween.Completed:Connect(function()
                if not window.Visible then MainFrame.Visible = false end
            end)
        end
    end)

    MakeDraggable(TopBar, MainFrame)
    MakeDraggable(FloatButton, FloatButton)

    return window
end

-- =============================================================================
-- TAB SYSTEM
-- =============================================================================
function QrinzUI:Tab(options)
    local tabName = options.Title or "Tab"
    local tab = {}
    
    -- Tombol Tab di Header
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabName.."_Btn"
    TabButton.Size = UDim2.new(0, 0, 1, -6)
    TabButton.Position = UDim2.new(0, 0, 0, 3)
    TabButton.BackgroundColor3 = Colors.ElementBG
    TabButton.Text = tabName
    TabButton.Font = Enum.Font.GothamMedium
    TabButton.TextSize = 12
    TabButton.TextColor3 = Colors.TextMuted
    TabButton.AutoButtonColor = false
    TabButton.Parent = self.TabHeader
    
    -- Menyesuaikan lebar tombol dengan teks
    local TextSize = game:GetService("TextService"):GetTextSize(tabName, 12, Enum.Font.GothamMedium, Vector2.new(math.huge, math.huge))
    TabButton.Size = UDim2.new(0, TextSize.X + 24, 1, -6)

    local TabBtnCorner = Instance.new("UICorner")
    TabBtnCorner.CornerRadius = UDim.new(0, 6)
    TabBtnCorner.Parent = TabButton
    
    local TabBtnStroke = Instance.new("UIStroke")
    TabBtnStroke.Color = Colors.Stroke
    TabBtnStroke.Thickness = 1
    TabBtnStroke.Parent = TabButton

    -- Halaman Tab
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Name = tabName.."_Page"
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.ScrollBarThickness = 2
    TabPage.ScrollBarImageColor3 = Colors.Purple
    TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabPage.Visible = false -- Default disembunyikan
    TabPage.Parent = self.Container

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 8)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = TabPage

    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingTop = UDim.new(0, 2)
    UIPadding.PaddingBottom = UDim.new(0, 5)
    UIPadding.PaddingLeft = UDim.new(0, 2)
    UIPadding.PaddingRight = UDim.new(0, 2)
    UIPadding.Parent = TabPage

    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabPage.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 15)
    end)

    -- Logika Ganti Tab
    local function ActivateTab()
        for _, otherTab in ipairs(self.Tabs) do
            otherTab.Page.Visible = false
            TweenService:Create(otherTab.Button, TweenInfo.new(0.2), {BackgroundColor3 = Colors.ElementBG, TextColor3 = Colors.TextMuted}):Play()
            otherTab.Stroke.Color = Colors.Stroke
        end
        TabPage.Visible = true
        TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Colors.MainBG, TextColor3 = Colors.TextWhite}):Play()
        TabBtnStroke.Color = Colors.StrokeActive
    end

    TabButton.MouseButton1Click:Connect(ActivateTab)

    tab.Page = TabPage
    tab.Button = TabButton
    tab.Stroke = TabBtnStroke
    
    table.insert(self.Tabs, tab)
    
    -- Auto buka tab pertama
    if #self.Tabs == 1 then
        ActivateTab()
    end

    for k, v in pairs(QrinzUI.Elements) do
        tab[k] = v
    end
    return tab
end

QrinzUI.Elements = {}

-- =============================================================================
-- BASE MENU ELEMENTS
-- =============================================================================
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
    Stroke.Color = Colors.Stroke
    Stroke.Thickness = 1
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
    CheckBoxStroke.Thickness = 1.2
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
        TweenService:Create(CheckBoxStroke, TweenInfo.new(0.2), {
            Color = state and Colors.StrokeActive or Colors.Stroke
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
    ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
    ButtonFrame.BackgroundColor3 = Colors.ElementBG
    ButtonFrame.Text = ""
    ButtonFrame.AutoButtonColor = false
    ButtonFrame.Parent = self.Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = ButtonFrame
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Colors.Stroke
    Stroke.Thickness = 1
    Stroke.Parent = ButtonFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.Text = options.Title
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 13
    Title.TextColor3 = Colors.TextWhite
    Title.TextXAlignment = Enum.TextXAlignment.Center
    Title.BackgroundTransparency = 1
    Title.Parent = ButtonFrame
    
    ButtonFrame.MouseEnter:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(36, 36, 50)}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Colors.StrokeActive}):Play()
    end)
    ButtonFrame.MouseLeave:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Colors.ElementBG}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Colors.Stroke}):Play()
    end)

    ButtonFrame.MouseButton1Click:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = Colors.Purple}):Play()
        task.wait(0.1)
        TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(36, 36, 50)}):Play()
        callback()
    end)
end

-- SISTEM TEXT INPUT BARU
function QrinzUI.Elements:Input(options)
    local callback = options.Callback or function() end
    
    local InputFrame = Instance.new("Frame")
    InputFrame.Size = UDim2.new(1, 0, 0, 42)
    InputFrame.BackgroundColor3 = Colors.ElementBG
    InputFrame.Parent = self.Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = InputFrame
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Colors.Stroke
    Stroke.Thickness = 1
    Stroke.Parent = InputFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.4, 0, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.Text = options.Title or "Input"
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 13
    Title.TextColor3 = Colors.TextWhite
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.Parent = InputFrame

    local TextBoxContainer = Instance.new("Frame")
    TextBoxContainer.Size = UDim2.new(0.6, -20, 0, 28)
    TextBoxContainer.Position = UDim2.new(0.4, 10, 0.5, -14)
    TextBoxContainer.BackgroundColor3 = Colors.MainBG
    TextBoxContainer.Parent = InputFrame
    
    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 6)
    BoxCorner.Parent = TextBoxContainer
    
    local BoxStroke = Instance.new("UIStroke")
    BoxStroke.Color = Colors.Stroke
    BoxStroke.Thickness = 1
    BoxStroke.Parent = TextBoxContainer

    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(1, -16, 1, 0)
    TextBox.Position = UDim2.new(0, 8, 0, 0)
    TextBox.BackgroundTransparency = 1
    TextBox.Text = ""
    TextBox.PlaceholderText = options.Placeholder or "Type here..."
    TextBox.PlaceholderColor3 = Colors.TextMuted
    TextBox.Font = Enum.Font.Gotham
    TextBox.TextSize = 12
    TextBox.TextColor3 = Colors.TextWhite
    TextBox.TextXAlignment = Enum.TextXAlignment.Left
    TextBox.ClipsDescendants = true
    TextBox.Parent = TextBoxContainer

    -- Efek terang/glow saat input diklik
    TextBox.Focused:Connect(function()
        TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Color = Colors.StrokeActive}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Colors.StrokeActive}):Play()
    end)
    
    TextBox.FocusLost:Connect(function()
        TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Color = Colors.Stroke}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Colors.Stroke}):Play()
        callback(TextBox.Text)
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
    Stroke.Color = Colors.Stroke
    Stroke.Thickness = 1
    Stroke.Parent = DropdownFrame

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
            Size = isOpen and UDim2.new(1, 0, 0, 42 + (#options.Values * 32) + 6) or UDim2.new(1, 0, 0, 42)
        }):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.2), {
            Color = isOpen and Colors.StrokeActive or Colors.Stroke
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
            TweenService:Create(OptionBtn, TweenInfo.new(0.2), {TextColor3 = Colors.TextWhite, BackgroundColor3 = Color3.fromRGB(36, 36, 50)}):Play()
            TweenService:Create(optStroke, TweenInfo.new(0.2), {Color = Colors.StrokeActive}):Play()
        end)
        OptionBtn.MouseLeave:Connect(function()
            TweenService:Create(OptionBtn, TweenInfo.new(0.2), {TextColor3 = Colors.TextMuted, BackgroundColor3 = Colors.MainBG}):Play()
            TweenService:Create(optStroke, TweenInfo.new(0.2), {Color = Colors.Stroke}):Play()
        end)

        OptionBtn.MouseButton1Click:Connect(function()
            Title.Text = options.Title .. " : " .. val
            isOpen = false
            TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, 42)}):Play()
            TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Colors.Stroke}):Play()
            callback({val})
        end)
    end
end

return QrinzUI
