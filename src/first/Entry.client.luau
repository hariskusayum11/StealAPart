--!strict
-- Loading uses real readiness; Welcome never gates entry with a Play button.
local Players=game:GetService("Players")
local player=Players.LocalPlayer
local pg=player:WaitForChild("PlayerGui")
if pg:FindFirstChild("StealEntry") then return end
local gui=Instance.new("ScreenGui");gui.Name="StealEntry";gui.ResetOnSpawn=false;gui.DisplayOrder=100;gui.IgnoreGuiInset=true;gui.Parent=pg
local art=Instance.new("ImageLabel");art.Name="LoadingArtwork";art.Image="rbxassetid://107954772658752";art.ScaleType=Enum.ScaleType.Crop;art.Size=UDim2.fromScale(1,1);art.BackgroundColor3=Color3.fromRGB(5,12,30);art.Parent=gui
local shade=Instance.new("Frame");shade.Name="LoadingShade";shade.BackgroundColor3=Color3.fromRGB(5,12,30);shade.BackgroundTransparency=.2;shade.Size=UDim2.fromScale(1,1);shade.Active=true;shade.Parent=gui
local card=Instance.new("Frame");card.Name="ReadinessCard";card.AnchorPoint=Vector2.new(.5,.5);card.Position=UDim2.fromScale(.5,.5);card.Size=UDim2.fromScale(.82,.65);card.BackgroundColor3=Color3.fromRGB(7,17,46);card.Parent=shade
local cap=Instance.new("UISizeConstraint");cap.MaxSize=Vector2.new(600,410);cap.Parent=card
local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,18);corner.Parent=card
local stroke=Instance.new("UIStroke");stroke.Color=Color3.fromRGB(39,197,229);stroke.Thickness=2;stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;stroke.Parent=card
local logo=Instance.new("ImageLabel");logo.Name="Logo";logo.Image="rbxassetid://92686584842368";logo.ImageRectSize=Vector2.new(650,200)*(1024/1672);logo.Size=UDim2.fromScale(.7,.22);logo.Position=UDim2.fromScale(.15,.04);logo.BackgroundTransparency=1;logo.ScaleType=Enum.ScaleType.Fit;logo.Parent=card
local function label(name:string,text:string,y:number,h:number):TextLabel
 local l=Instance.new("TextLabel");l.Name=name;l.Text=text;l.Position=UDim2.fromScale(.06,y);l.Size=UDim2.fromScale(.88,h);l.BackgroundTransparency=1;l.TextColor3=Color3.fromRGB(240,246,255);l.TextWrapped=true;l.TextScaled=true;l.Font=Enum.Font.GothamBold;l.Parent=card
 local limit=Instance.new("UITextSizeConstraint");limit.MinTextSize=11;limit.MaxTextSize=20;limit.Parent=l;return l
end
local status=label("Status","กำลังเตรียม Garage City…",.28,.12)
local description=label("Description","เคล็ดลับ: F ขึ้นรถ • E เก็บอะไหล่ • จอดนิ่งแล้ว Space ลงรถ",.5,.22)
label("SessionNotice","สนามทดสอบ • ยังไม่บันทึกข้อมูล • Shared Loot ยังไม่เปิด",.77,.08)
local track=Instance.new("Frame");track.Position=UDim2.fromScale(.08,.43);track.Size=UDim2.fromScale(.84,.025);track.BackgroundColor3=Color3.fromRGB(40,54,78);track.Parent=card
local fill=Instance.new("Frame");fill.Name="ReadinessProgress";fill.Size=UDim2.fromScale(0,1);fill.BorderSizePixel=0;fill.BackgroundColor3=Color3.fromRGB(245,184,46);fill.Parent=track
local retry=Instance.new("TextButton");retry.Name="Retry";retry.Text="ตรวจความพร้อมอีกครั้ง";retry.Size=UDim2.fromScale(.7,.12);retry.Position=UDim2.fromScale(.15,.86);retry.BackgroundColor3=Color3.fromRGB(245,184,46);retry.TextSize=16;retry.Visible=false;retry.Parent=card
local close=Instance.new("TextButton");close.Name="Close";close.Text="×";close.Size=UDim2.fromOffset(44,44);close.Position=UDim2.new(1,-50,0,6);close.TextSize=28;close.BackgroundColor3=Color3.fromRGB(211,51,80);close.TextColor3=Color3.new(1,1,1);close.Visible=false;close.Parent=card
local tutorial=Instance.new("TextLabel");tutorial.Name="Tutorial";tutorial.AnchorPoint=Vector2.new(.5,1);tutorial.Position=UDim2.fromScale(.5,.8);tutorial.Size=UDim2.fromScale(.6,.065);tutorial.BackgroundColor3=Color3.fromRGB(7,17,46);tutorial.BackgroundTransparency=.12;tutorial.TextColor3=Color3.fromRGB(255,219,110);tutorial.TextScaled=true;tutorial.TextWrapped=true;tutorial.Font=Enum.Font.GothamBold;tutorial.Visible=false;tutorial.Parent=gui
local limit=Instance.new("UITextSizeConstraint");limit.MaxTextSize=18;limit.MinTextSize=11;limit.Parent=tutorial
local function resize()
 local camera=workspace.CurrentCamera;if not camera then return end
 local compact=camera.ViewportSize.X<900 or camera.ViewportSize.Y<500
 card.Size=if compact then UDim2.fromScale(.92,.88) elseif card.Name=="WelcomePopup" then UDim2.fromScale(.8,.55) else UDim2.fromScale(.82,.65)
 tutorial.Size=UDim2.fromScale(if compact then .84 else .6,if compact then .1 else .065)
end
resize();local camera=workspace.CurrentCamera;if camera then camera:GetPropertyChangedSignal("ViewportSize"):Connect(resize) end
local loading=false
local function dismiss()
 shade.Visible=false;player:SetAttribute("EntryOpen",false);player:SetAttribute("WelcomeSeen",true);tutorial.Visible=true
end
close.Activated:Connect(dismiss)
local function readyState():(number,string)
 local n=0;local missing={}
 if game:IsLoaded() then n+=1 else table.insert(missing,"เชื่อมต่อเกม") end
 local character=player.Character;local h=character and character:FindFirstChildOfClass("Humanoid")
 if character and h and h.Health>0 and character:FindFirstChild("HumanoidRootPart") then n+=1 else table.insert(missing,"Spawn ที่อู่") end
 if workspace:GetAttribute("WorldGeometryReady") and workspace:FindFirstChild("CargoTestCourse") then n+=1 else table.insert(missing,"สร้างพื้นและถนน") end
 local vehicles=workspace:FindFirstChild("Vehicles");local b=vehicles and vehicles:FindFirstChild("StreetCub_"..player.UserId);local s=b and b:FindFirstChild("DriveSeat")
 if ((s and s:IsA("VehicleSeat") and not s.Disabled) or player:GetAttribute("PlotId")=="") and workspace:FindFirstChild("RaidGate") then n+=1 else table.insert(missing,"รถของคุณและประตู Raid") end
 return n,table.concat(missing," · ")
end
local function load()
 if loading then return end;loading=true;retry.Visible=false
 task.spawn(function()
  local deadline=os.clock()+60
  while gui.Parent do
   local n,missing=readyState();fill.Size=UDim2.fromScale(n/4,1);status.Text="กำลังเตรียม: "..missing
   if n==4 then
    loading=false;art.Visible=false;track.Visible=false;shade.BackgroundTransparency=1;shade.Active=false
    card.Name="WelcomePopup";resize();close.Visible=true
    status.Text="ยินดีต้อนรับสู่ STEAL A PART!"
    description.Text="F ขึ้นรถของคุณ → รอประตู Raid เปิด → ขับไป Zone 01–12
กด E ขโมยอะไหล่ → หนียาม → ขับผ่านประตู Raid = ฝากอัตโนมัติ
Raid เปิด 5 นาที • ปิด 2 นาที"
    player:SetAttribute("LoadingComplete",true)
    if player:GetAttribute("WelcomeSeen") then dismiss() end
    return
   end
   if os.clock()>deadline then loading=false;status.Text="ยังไม่พร้อม: "..missing;description.Text="การตรวจหมดเวลา • ปุ่มด้านล่างตรวจใหม่จากสถานะจริง ไม่ได้สร้างหรือแจกข้อมูลใหม่";retry.Visible=true;return end
   task.wait(.2)
  end
 end)
end
retry.Activated:Connect(load)
player:SetAttribute("EntryOpen",true)
game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen()
load()
task.spawn(function()
 local seenRide=false;local seenCargo=false
 while gui.Parent do
  if tutorial.Visible then
   local character=player.Character;local h=character and character:FindFirstChildOfClass("Humanoid")
   if h and h.SeatPart then seenRide=true end
   local cargo=player:GetAttribute("Cargo");if type(cargo)=="number" and cargo>0 then seenCargo=true end
   local secured=player:GetAttribute("InventoryTotal")
   if type(secured)=="number" and secured>0 and seenCargo then tutorial.Text="ฝากเข้าคลังสำเร็จ! กลับเข้า Raid ขโมยต่อได้" elseif seenCargo then tutorial.Text="หนียาม! ขับกลับผ่านประตู Raid เพื่อฝากอัตโนมัติ" elseif seenRide then tutorial.Text="รอประตู Raid เปิด แล้วขับไปโซน กด E เก็บอะไหล่" else tutorial.Text="เข้าใกล้ Street Cub ของคุณ แล้วกด F เพื่อขึ้นรถ" end
  end
  task.wait(.3)
 end
end)