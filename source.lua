-- =============================================================================
-- QRINZ UI LIBRARY BASE CODE (MODERN BLUE & PURPLE THEME)
-- =============================================================================

local QrinzUI = {}
QrinzUI.__index = QrinzUI

-- Registrasi Service Key System
QrinzUI.Services = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Color Palette
local Colors = {
    MainBG = Color3.fromRGB(11, 11, 16),
    ElementBG = Color3.fromRGB(20, 20, 28),
    Stroke = Color3.fromRGB(45, 45, 65),
    TextWhite = Color3.fromRGB(255, 255, 255),
    TextMuted = Color3.fromRGB(140, 145, 160),
    Blue = Color3.fromRGB(0, 180, 255),
    Purple = Color3.fromRGB(140, 60, 255),
    Red = Color3.fromRGB(255, 75, 75),
    Green = Color3.fromRGB(75, 255, 75)
}

local BluePurpleGradient = ColorSequence.new{
    ColorSequenceKeypoint.new(0.0, Colors.Blue),
    ColorSequenceKeypoint.new(1.0, Colors.Purple)
}

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

function QrinzUI:CreateWindow(options)
    local window = setmetatable({}, { __index = self })
    
    window.Title = options.Title or "Qrinz Window"
    window.Author = options.Author or ""
    window.Visible = true
    window.ToggleIcon = options.ToggleIcon or "rbxassetid://10734896206"

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "QrinzUIHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui
    window.ScreenGui = ScreenGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 340, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -170, 0.5, -200)
    MainFrame.BackgroundColor3 = Colors.MainBG
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    window.MainFrame = MainFrame
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 14)
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
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundTransparency = 1
    TopBar.Parent = MainFrame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -30, 0, 25)
    TitleLabel.Position = UDim2.new(0, 15, 0, 8)
    TitleLabel.Text = window.Title
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.TextColor3 = Colors.TextWhite
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = TopBar

    if window.Author ~= "" then
        local AuthorLabel = Instance.new("TextLabel")
        AuthorLabel.Size = UDim2.new(1, -30, 0, 15)
        AuthorLabel.Position = UDim2.new(0, 15, 0, 27)
        AuthorLabel.Text = window.Author
        AuthorLabel.Font = Enum.Font.Gotham
        AuthorLabel.TextSize = 11
        AuthorLabel.TextColor3 = Colors.TextMuted
        AuthorLabel.TextXAlignment = Enum.TextXAlignment.Left
        AuthorLabel.BackgroundTransparency = 1
        AuthorLabel.Parent = TopBar
    end

    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, -30, 0, 1)
    Divider.Position = UDim2.new(0, 15, 0, 49)
    Divider.BackgroundColor3 = Colors.Stroke
    Divider.BackgroundTransparency = 0.5
    Divider.BorderSizePixel = 0
    Divider.Parent = TopBar

    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, -20, 1, -65)
    Container.Position = UDim2.new(0, 10, 0, 55)
    Container.BackgroundTransparency = 1
    Container.ClipsDescendants = true
    Container.Parent = MainFrame
    window.Container = Container

    local FloatButton = Instance.new("ImageButton")
    FloatButton.Name = "FloatToggleButton"
    FloatButton.Size = UDim2.new(0, 48, 0, 48)
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
                Size = UDim2.new(0, 340, 0, 400)
            }):Play()
        else
            local closeTween = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 340, 0, 0)
            })
            closeTween:Play()
            closeTween.Completed:Connect(function()
                if not window.Visible then MainFrame.Visible = false end
            end)
        end
    end)

    MakeDraggable(TopBar, MainFrame)
    MakeDraggable(FloatButton, FloatButton)

    -- =============================================================================
    -- TAMPILAN PREMIUM KEY SYSTEM INTEGRATION
    -- =============================================================================
    if options.KeySystem then
        Container.Visible = false
        
        local KeyConfig = options.KeySystem
        local ApiData = KeyConfig.API
        local Service = QrinzUI.Services[ApiData.Type]
        
        if Service then
            local ApiHandler = Service.New(ApiData.ServiceId, ApiData.SuperId)
            
            local KeyFrame = Instance.new("Frame")
            KeyFrame.Name = "KeyFrame"
            KeyFrame.Size = UDim2.new(1, -20, 1, -65)
            KeyFrame.Position = UDim2.new(0, 10, 0, 55)
            KeyFrame.BackgroundTransparency = 1
            KeyFrame.Parent = MainFrame
            
            -- Ikon Kunci Estetik di bagian Atas
            local KeyIcon = Instance.new("ImageLabel")
            KeyIcon.Name = "KeyIcon"
            KeyIcon.Size = UDim2.new(0, 40, 0, 40)
            KeyIcon.Position = UDim2.new(0.5, -20, 0, 15)
            KeyIcon.BackgroundTransparency = 1
            KeyIcon.Image = "rbxassetid://10734950309" -- Ikon Kunci modern bawaan roblox
            KeyIcon.ImageColor3 = Colors.Blue
            KeyIcon.Parent = KeyFrame
            
            local IconGradient = Instance.new("UIGradient")
            IconGradient.Color = BluePurpleGradient
            IconGradient.Parent = KeyIcon

            -- Label Informasi / Deskripsi Kunci
            local NoteLabel = Instance.new("TextLabel")
            NoteLabel.Size = UDim2.new(1, -10, 0, 50)
            NoteLabel.Position = UDim2.new(0, 5, 0, 65)
            NoteLabel.Text = KeyConfig.Note or "This script is secured. Please verify your product key."
            NoteLabel.Font = Enum.Font.GothamMedium
            NoteLabel.TextSize = 12
            NoteLabel.TextColor3 = Colors.TextMuted
            NoteLabel.TextWrapped = true
            NoteLabel.BackgroundTransparency = 1
            NoteLabel.Parent = KeyFrame
            
            -- Input Box Container (Tempat ngetik/paste key)
            local InputFrame = Instance.new("Frame")
            InputFrame.Size = UDim2.new(1, 0, 0, 46) -- Lebih tinggi agar mudah diklik di HP
            InputFrame.Position = UDim2.new(0, 0, 0, 130)
            InputFrame.BackgroundColor3 = Colors.ElementBG
            InputFrame.Parent = KeyFrame
            
            local InputCorner = Instance.new("UICorner")
            InputCorner.CornerRadius = UDim.new(0, 10)
            InputCorner.Parent = InputFrame
            
            local InputStroke = Instance.new("UIStroke")
            InputStroke.Color = Colors.Stroke
            InputStroke.Thickness = 1.5
            InputStroke.Parent = InputFrame
            
            local TextBox = Instance.new("TextBox")
            TextBox.Size = UDim2.new(1, -24, 1, 0)
            TextBox.Position = UDim2.new(0, 12, 0, 0)
            TextBox.BackgroundTransparency = 1
            TextBox.Text = ""
            TextBox.PlaceholderText = "Paste or enter your key here..."
            TextBox.PlaceholderColor3 = Color3.fromRGB(90, 95, 110)
            TextBox.Font = Enum.Font.GothamMedium
            TextBox.TextSize = 13
            TextBox.TextColor3 = Colors.TextWhite
            TextBox.TextXAlignment = Enum.TextXAlignment.Left
            TextBox.Parent = InputFrame
            
            -- Efek Glow Animasi saat Input Box aktif (Fokus)
            TextBox.Focused:Connect(function()
                TweenService:Create(InputStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Color = Colors.Blue}):Play()
                TweenService:Create(InputFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(24, 24, 35)}):Play()
            end)
            TextBox.FocusLost:Connect(function()
                TweenService:Create(InputStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Color = Colors.Stroke}):Play()
                TweenService:Create(InputFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundColor3 = Colors.ElementBG}):Play()
            end)
            
            -- Container Tombol (Bawah Input)
            local ButtonContainer = Instance.new("Frame")
            ButtonContainer.Size = UDim2.new(1, 0, 0, 45)
            ButtonContainer.Position = UDim2.new(0, 0, 0, 192)
            ButtonContainer.BackgroundTransparency = 1
            ButtonContainer.Parent = KeyFrame
            
            local UIList = Instance.new("UIListLayout")
            UIList.FillDirection = Enum.FillDirection.Horizontal
            UIList.Padding = UDim.new(0, 12)
            UIList.SortOrder = Enum.SortOrder.LayoutOrder
            UIList.Parent = ButtonContainer
            
            -- TOMBOL 1: COPY LINK (Glow Outline style)
            local CopyBtn = Instance.new("TextButton")
            CopyBtn.Size = UDim2.new(0.5, -6, 1, 0)
            CopyBtn.BackgroundColor3 = Colors.ElementBG
            CopyBtn.Text = "Copy Link"
            CopyBtn.Font = Enum.Font.GothamBold
            CopyBtn.TextSize = 13
            CopyBtn.TextColor3 = Colors.TextMuted
            CopyBtn.AutoButtonColor = false
            CopyBtn.Parent = ButtonContainer
            
            local CopyCorner = Instance.new("UICorner")
            CopyCorner.CornerRadius = UDim.new(0, 10)
            CopyCorner.Parent = CopyBtn
            
            local CopyStroke = Instance.new("UIStroke")
            CopyStroke.Color = Colors.Stroke
            CopyStroke.Thickness = 1
            CopyStroke.Parent = CopyBtn
            
            -- TOMBOL 2: VERIFY KEY (Premium Gradient style - Tombol Utama)
            local VerifyBtn = Instance.new("TextButton")
            VerifyBtn.Size = UDim2.new(0.5, -6, 1, 0)
            VerifyBtn.BackgroundColor3 = Colors.TextWhite -- Menggunakan putih dasar untuk diwarnai Gradasi
            VerifyBtn.Text = "Verify Key"
            VerifyBtn.Font = Enum.Font.GothamBold
            VerifyBtn.TextSize = 13
            VerifyBtn.TextColor3 = Colors.TextWhite
            VerifyBtn.AutoButtonColor = false
            VerifyBtn.Parent = ButtonContainer
            
            local VerifyCorner = Instance.new("UICorner")
            VerifyCorner.CornerRadius = UDim.new(0, 10)
            VerifyCorner.Parent = VerifyBtn
            
            local VerifyGradient = Instance.new("UIGradient")
            VerifyGradient.Color = BluePurpleGradient
            VerifyGradient.Parent = VerifyBtn
            
            -- Animasi Efek Hover & Klik Tombol Copy (Secondary)
            CopyBtn.MouseEnter:Connect(function() 
                TweenService:Create(CopyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(32, 32, 46), TextColor3 = Colors.TextWhite}):Play() 
                TweenService:Create(CopyStroke, TweenInfo.new(0.2), {Color = Colors.Blue}):Play()
            end)
            CopyBtn.MouseLeave:Connect(function() 
                TweenService:Create(CopyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.ElementBG, TextColor3 = Colors.TextMuted}):Play() 
                TweenService:Create(CopyStroke, TweenInfo.new(0.2), {Color = Colors.Stroke}):Play()
            end)
            CopyBtn.MouseButton1Click:Connect(function()
                ApiHandler.Copy()
                CopyBtn.Text = "Link Copied!"
                TweenService:Create(CopyStroke, TweenInfo.new(0.1), {Color = Colors.Green}):Play()
                task.wait(1.5)
                CopyBtn.Text = "Copy Link"
                TweenService:Create(CopyStroke, TweenInfo.new(0.2), {Color = Colors.Stroke}):Play()
            end)
            
            -- Animasi Efek Hover & Klik Tombol Verify (Primary Gradient)
            VerifyBtn.MouseEnter:Connect(function() 
                TweenService:Create(VerifyBtn, TweenInfo.new(0.2), {Size = UDim2.new(0.5, -2, 1, 2), Position = UDim2.new(0, -2, 0, -1)}):Play()
            end)
            VerifyBtn.MouseLeave:Connect(function() 
                TweenService:Create(VerifyBtn, TweenInfo.new(0.2), {Size = UDim2.new(0.5, -6, 1, 0), Position = UDim2.new(0, 0, 0, 0)}):Play()
            end)
            VerifyBtn.MouseButton1Click:Connect(function()
                VerifyBtn.Text = "Checking..."
                local success, msg = ApiHandler.Verify(TextBox.Text)
                
                if success then
                    VerifyBtn.Text = "Access Granted!"
                    VerifyGradient.Color = ColorSequence.new(Colors.Green)
                    TweenService:Create(InputStroke, TweenInfo.new(0.25), {Color = Colors.Green}):Play()
                    task.wait(1)
                    
                    -- Transisi Halus Membuka Menu Utama
                    local fadeTween = TweenService:Create(KeyFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 10, 0, -300)})
                    fadeTween:Play()
                    fadeTween.Completed:Connect(function()
                        KeyFrame:Destroy()
                        FloatButton.Visible = true
                        Container.Visible = true
                    end)
                else
                    VerifyBtn.Text = "Invalid Key!"
                    VerifyGradient.Color = ColorSequence.new(Colors.Red)
                    TweenService:Create(InputStroke, TweenInfo.new(0.25), {Color = Colors.Red}):Play()
                    NoteLabel.Text = msg or "The key is incorrect or expired."
                    NoteLabel.TextColor3 = Colors.Red
                    
                    task.wait(2)
                    VerifyBtn.Text = "Verify Key"
                    VerifyGradient.Color = BluePurpleGradient
                    NoteLabel.Text = KeyConfig.Note or "This script is secured. Please verify your product key."
                    NoteLabel.TextColor3 = Colors.TextMuted
                    TweenService:Create(InputStroke, TweenInfo.new(0.25), {Color = Colors.Stroke}):Play()
                end
            end)
        end
    end

    return window
end

function QrinzUI:Tab(options)
    local tab = {}
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Name = options.Title .. "Tab"
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.ScrollBarThickness = 3
    TabPage.ScrollBarImageColor3 = Colors.Purple
    TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
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

    tab.Page = TabPage
    for k, v in pairs(QrinzUI.Elements) do
        tab[k] = v
    end
    return tab
end

QrinzUI.Elements = {}

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
    Stroke.Thickness = 1
    Stroke.Parent = ToggleFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.Text = options.Title
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 14
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
    Stroke.Thickness = 1
    Stroke.Parent = ButtonFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.Text = options.Title
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 14
    Title.TextColor3 = Colors.TextWhite
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.Parent = ButtonFrame
    
    ButtonFrame.MouseEnter:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 42)}):Play()
    end)
    ButtonFrame.MouseLeave:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Colors.ElementBG}):Play()
    end)

    ButtonFrame.MouseButton1Click:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = Colors.Purple}):Play()
        task.wait(0.1)
        TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 42)}):Play()
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
    Stroke.Thickness = 1
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
    Title.TextSize = 14
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
    end)

    for i, val in ipairs(options.Values) do
        local OptionBtn = Instance.new("TextButton")
        OptionBtn.Size = UDim2.new(1, -24, 0, 30)
        OptionBtn.Position = UDim2.new(0, 12, 0, 44 + (i-1)*34)
        OptionBtn.BackgroundColor3 = Colors.MainBG
        OptionBtn.Text = val
        OptionBtn.Font = Enum.Font.Gotham
        OptionBtn.TextSize = 13
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
            TweenService:Create(OptionBtn, TweenInfo.new(0.2), {TextColor3 = Colors.TextWhite, BackgroundColor3 = Color3.fromRGB(30, 30, 42)}):Play()
        end)
        OptionBtn.MouseLeave:Connect(function()
            TweenService:Create(OptionBtn, TweenInfo.new(0.2), {TextColor3 = Colors.TextMuted, BackgroundColor3 = Colors.MainBG}):Play()
        end)

        OptionBtn.MouseButton1Click:Connect(function()
            Title.Text = options.Title .. " : " .. val
            isOpen = false
            TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, 44)}):Play()
            callback({val})
        end)
    end
end

return QrinzUI
