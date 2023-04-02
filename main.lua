--[[
altxria#7302
hiii game devs, yall can patch it i prob wont fix it :)
--]]
_G.Enabled = true
local repo = 'https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local workspace = game:GetService("Workspace")
local player = game:GetService("Players").LocalPlayer
local hrp = player.Character.HumanoidRootPart
local mouse = player:GetMouse()
local renderservice = game:GetService("RunService")
local count = 0
local debounce = false
local Window = Library:CreateWindow({
    Title = 'altxria hub (sex)',
    Center = true, 
    AutoShow = true,
})
local Tabs = {
    Main = Window:AddTab('Main'), 
    ['UI Settings'] = Window:AddTab('UI Settings'),
}
local LeftGroupBox = Tabs.Main:AddLeftGroupbox('steal the ball urself')
LeftGroupBox:AddToggle('autogoal', {
    Text = 'AutoScore (lil buggy)',
    Size = UDim2.new(0, 300, 0, 100),
    Default = false, 
    Tooltip = 'Tweens you to the ball, if you have possession it scores.',
})
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' }) 
Library.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings() 
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' }) 
ThemeManager:SetFolder('MyScriptHub')
SaveManager:SetFolder('MyScriptHub/specific-game')
SaveManager:BuildConfigSection(Tabs['UI Settings']) 
ThemeManager:ApplyToTab(Tabs['UI Settings'])
function autoscore()
    for i, v in ipairs(workspace:GetDescendants()) do
        if v.Name == "Ball" and v.ClassName == "Part" and v.Parent.Name == "Balls" and _G.Enabled == true then
            local team = player.Character.Team.Value
            ball = v.ContactPart
            ball.CanCollide = false
            ball.Parent.CanCollide = false
            if ball.Size ~= Vector3.new(4, 4, 4) then
                ball.Size = Vector3.new(4, 4, 4)
            end
            if ball.Transparency ~= 0.5 then
                ball.Transparency = 0.5 
            end
            if ball.Parent.Owner.Value == nil then
                local tween_s = game:GetService("TweenService")
                local tweeninfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear)
                local goal = Vector3.new(ball.Position.X, ball.Position.Y, ball.Position.Z)
	            local Animation = tween_s:Create(hrp, tweeninfo, {Position = goal})
	            Animation:Play()
            elseif ball.Parent.Owner.Value ~= nil and ball.Parent.Owner.Value ~= player.Character then
                local tween_s = game:GetService("TweenService")
                local tweeninfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear)
                local goal = Vector3.new(ball.Position.X, ball.Position.Y, ball.Position.Z)
	            local Animation = tween_s:Create(hrp, tweeninfo, {Position = goal})
	            Animation:Play()
            elseif debounce == true then
                count = count + 1
                if count >= 100 then
                    debounce = false
                    count = 0
                end
	        end
            if ball.Parent.Owner.Value == player.Character then
                debounce = true
                local num = tonumber(team)
                if num > 1 then
                    ball.Parent.Position = Vector3.new(798, -3, -767)
                elseif num < 2 then
                    ball.Parent.Position = Vector3.new(1065, -3, -350)
                end
            end
        end
    end
end
Toggles.autogoal:OnChanged(function()
    if Toggles.autogoal.Value == true then
        renderservice:BindToRenderStep('autogoal', 1, autoscore)
        print('autos on')
    elseif Toggles.autogoal.Value == false then
        renderservice:UnbindFromRenderStep('autogoal')
        print('autos off')
    else 
        print("huh?")
    end
end)
