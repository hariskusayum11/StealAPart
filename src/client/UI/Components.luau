--!strict
local TweenService=game:GetService("TweenService")
local Theme=require(game:GetService("ReplicatedStorage").RaceAndRaid.UITheme)
local UI={}
function UI.panel(parent: Instance,name: string,size: UDim2,pos: UDim2,accent: Color3?): Frame
 local f=Instance.new("Frame");f.Name=name;f.Size=size;f.Position=pos;f.BackgroundColor3=Theme.Background;f.BackgroundTransparency=.06;f.BorderSizePixel=0;f.Parent=parent
 local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,12);corner.Parent=f
 local stroke=Instance.new("UIStroke");stroke.Name="Outline";stroke.Color=accent or Theme.Cyan;stroke.Thickness=2;stroke.Parent=f
 local gradient=Instance.new("UIGradient");gradient.Color=ColorSequence.new(Color3.new(1,1,1),Color3.fromRGB(90,106,164));gradient.Rotation=90;gradient.Parent=f
 return f
end
function UI.label(parent: Instance,name: string,text: string,size: UDim2,pos: UDim2,fontSize: number,color: Color3?): TextLabel
 local t=Instance.new("TextLabel");t.Name=name;t.Text=text;t.Size=size;t.Position=pos;t.BackgroundTransparency=1;t.Font=Theme.Font;t.TextSize=fontSize;t.TextWrapped=true;t.TextColor3=color or Theme.White;t.Parent=parent
 return t
end
function UI.button(parent: Instance,name: string,text: string,action: () -> ()): TextButton
 local b=Instance.new("TextButton");b.Name=name;b.Size=UDim2.new(1,0,0,46);b.Text=text;b.TextColor3=Theme.White;b.Font=Theme.Font;b.TextSize=16;b.BackgroundColor3=Theme.Panel;b.AutoButtonColor=false;b.Parent=parent
 local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,10);c.Parent=b
 local s=Instance.new("UIStroke");s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;s.Color=Theme.Cyan;s.Thickness=1.5;s.Parent=b
 local function paint(color: Color3) TweenService:Create(b,TweenInfo.new(.12),{BackgroundColor3=color}):Play() end
 b.MouseEnter:Connect(function() if b.Active then paint(Color3.fromRGB(33,77,122)) end end)
 b.MouseLeave:Connect(function() paint(Theme.Panel) end)
 b.MouseButton1Down:Connect(function() if b.Active then paint(Color3.fromRGB(78,57,124)) end end)
 b.MouseButton1Up:Connect(function() paint(Theme.Panel) end)
 b.SelectionGained:Connect(function() s.Color=Theme.Gold end)
 b.SelectionLost:Connect(function() s.Color=Theme.Cyan end)
 b.Activated:Connect(function() if b.Active then action() end end)
 return b
end
function UI.disabled(button: TextButton,reason: string)
 button.Active=false;button.Selectable=false;button.Text=reason;button.TextColor3=Theme.Muted;button.BackgroundColor3=Color3.fromRGB(35,40,54)
end
return UI