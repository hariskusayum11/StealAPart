--!strict
-- R03 Main HUD controller: one controller, live session data, no fake economy.
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")
local TweenService=game:GetService("TweenService")
local player=Players.LocalPlayer
local pg=player:WaitForChild("PlayerGui")
local shared=game:GetService("ReplicatedStorage"):WaitForChild("RaceAndRaid")
local Theme=require(shared.UITheme)
local Layout=require(shared.HubLayout)
local UI=require(script.Parent.UI.Components)
local old=pg:FindFirstChild("RaceAndRaidLabHUD");if old then old:Destroy() end
local gui=Instance.new("ScreenGui");gui.Name="RaceAndRaidLabHUD";gui.ResetOnSpawn=false;gui.DisplayOrder=10;gui.Parent=pg
local root=Instance.new("Frame");root.Name="HUDRoot";root.Size=UDim2.fromScale(1,1);root.BackgroundTransparency=1;root.Parent=gui
local scale=Instance.new("UIScale");scale.Name="PreferenceScale";scale.Parent=root
local brand=UI.panel(root,"Brand",UDim2.fromOffset(190,54),UDim2.fromOffset(14,62),Theme.Purple)
brand.Size=UDim2.fromOffset(190,62)
local logo=Instance.new("ImageLabel");logo.Name="Logo";logo.Image=Theme.IconAtlas;logo.ImageRectOffset=Vector2.zero;logo.ImageRectSize=Theme.LogoRect;logo.ScaleType=Enum.ScaleType.Fit;logo.Size=UDim2.new(1,-8,0,46);logo.Position=UDim2.fromOffset(4,0);logo.BackgroundTransparency=1;logo.Parent=brand
UI.label(brand,"State","PROTOTYPE • SESSION",UDim2.new(1,0,0,18),UDim2.fromOffset(0,45),10,Theme.Muted)
local resources=UI.panel(root,"Resources",UDim2.fromOffset(440,44),UDim2.new(.5,-220,0,10))
local resourceText=UI.label(resources,"Values","",UDim2.new(1,-12,1,0),UDim2.fromOffset(6,0),16)
local zone=UI.panel(root,"Zone",UDim2.fromOffset(300,46),UDim2.new(.5,-150,0,64),Theme.Gold)
local zoneText=UI.label(zone,"Name","Garage City",UDim2.new(1,-8,1,0),UDim2.fromOffset(4,0),18)
local nav=Instance.new("ScrollingFrame");nav.Name="Navigation";nav.Position=UDim2.fromOffset(14,128);nav.Size=UDim2.fromOffset(174,310);nav.BackgroundTransparency=1;nav.Parent=root
nav.AutomaticCanvasSize=Enum.AutomaticSize.Y;nav.CanvasSize=UDim2.fromScale(0,0);nav.ScrollBarThickness=3;nav.BorderSizePixel=0
local list=Instance.new("UIListLayout");list.Padding=UDim.new(0,6);list.SortOrder=Enum.SortOrder.LayoutOrder;list.Parent=nav
local dock=UI.panel(root,"DrivingDock",UDim2.fromOffset(450,94),UDim2.new(.5,-225,1,-116))
local speed=UI.label(dock,"Speed","000",UDim2.fromOffset(100,48),UDim2.fromOffset(10,2),36)
local unit=UI.label(dock,"Units","km/h",UDim2.fromOffset(100,20),UDim2.fromOffset(10,50),12,Theme.Muted)
local gear=UI.label(dock,"Gear","N",UDim2.fromOffset(40,44),UDim2.fromOffset(108,2),25,Theme.Gold)
local cargo=UI.label(dock,"Cargo","CARGO 0 / 1",UDim2.fromOffset(280,28),UDim2.fromOffset(160,5),20,Theme.Gold)
local returnLabel=UI.label(dock,"Return","",UDim2.fromOffset(280,24),UDim2.fromOffset(160,34),14)
local engine=UI.label(dock,"Engine","",UDim2.new(1,-12,0,22),UDim2.fromOffset(6,68),12,Theme.Muted)
local hint=UI.label(root,"Hint","",UDim2.new(.6,0,0,28),UDim2.new(.2,0,1,-151),13)
local toast=UI.panel(root,"CargoFeedback",UDim2.new(.62,0,0,44),UDim2.new(.19,0,0,120),Theme.Gold)
local toastText=UI.label(toast,"Message","",UDim2.new(1,-14,1,0),UDim2.fromOffset(7,0),15)
toast.Visible=false
local toastUntil=0
local history: {string}={}
local function notify(message: string)
 toastText.Text=message;toastUntil=os.clock()+3.5;toast.Visible=true
 table.insert(history,1,message);if #history>6 then table.remove(history) end
end
player:GetAttributeChangedSignal("CargoMessageId"):Connect(function() notify(tostring(player:GetAttribute("CargoMessage") or "")) end)
local menu=UI.panel(gui,"Menu",UDim2.fromScale(.68,.62),UDim2.fromScale(.16,.19),Theme.Purple)
local menuLimit=Instance.new("UISizeConstraint");menuLimit.MaxSize=Vector2.new(640,460);menuLimit.Parent=menu
menu.AnchorPoint=Vector2.new(.5,.5);menu.Position=UDim2.fromScale(.5,.5);menu.Visible=false
local menuTitle=UI.label(menu,"Title","",UDim2.new(1,-76,0,48),UDim2.fromOffset(12,8),22,Theme.Gold)
local menuBody=UI.label(menu,"Body","",UDim2.new(1,-32,1,-130),UDim2.fromOffset(16,62),17)
menuBody.TextXAlignment=Enum.TextXAlignment.Left;menuBody.TextYAlignment=Enum.TextYAlignment.Top
local close=UI.button(menu,"Close","×",function() menu.Visible=false end)
close.TextSize=30;close.Size=UDim2.fromOffset(44,44);close.Position=UDim2.new(1,-54,0,10)
local riding=false;local currentSpeed=0;local compact=false
local function open(title: string,body: string)
 if riding and currentSpeed>8 then notify("เบรกให้ช้าก่อนเปิดเมนู / Slow down to open");return end
 menuTitle.Text=title;menuBody.Text=body;menu.Visible=true
 menu.Size=UDim2.fromScale(.64,.57)
 TweenService:Create(menu,TweenInfo.new(.16,Enum.EasingStyle.Quad),{Size=UDim2.fromScale(if compact then .88 else .68,.62)}):Play()
end
local iconRects={{1220,715,250,210},{280,700,230,225},{975,700,260,225},{1480,715,180,210},{0,0,650,200},{10,700,260,225}}
local navNames={"Garage / อู่","Shop / ร้านค้า","Upgrade / อัปเกรด","Parts Market / ตลาด","Race Hub / สนามแข่ง","Event Plaza / กิจกรรม"}
for i,name in navNames do
 local button=UI.button(nav,"Nav"..i,name,function()
  local detail=if i==1 then string.format("ผู้เล่น: %s\nฝากอะไหล่แล้ว: %d ครั้ง (Session)\n\nPrototype: ยังไม่มีการจองอู่ รายได้ Coins/min หรือการขยายอู่",player.DisplayName,player:GetAttribute("TestSecured") or 0)
   else "UI Prototype Only\nสถานที่มีใน Blockout แต่ระบบนี้ยังไม่เปิดใช้งาน\nไม่มีการซื้อ ขาย อัปเกรด แจกเงิน หรือจัดอันดับจากเมนูนี้"
  open(name,detail)
 end)
 button.LayoutOrder=i;button.Text=""
 local rect=iconRects[i]
 local icon=Instance.new("ImageLabel");icon.Name="Icon";icon.Image=Theme.IconAtlas;icon.ImageRectOffset=Vector2.new(rect[1],rect[2])*Theme.AtlasScale;icon.ImageRectSize=Vector2.new(rect[3],rect[4])*Theme.AtlasScale;icon.ScaleType=Enum.ScaleType.Fit;icon.Size=UDim2.fromOffset(40,40);icon.Position=UDim2.fromOffset(3,3);icon.BackgroundTransparency=1;icon.Parent=button
 UI.label(button,"Label",name,UDim2.new(1,-50,1,-4),UDim2.fromOffset(46,2),15)
end
local menuToggle=UI.button(root,"MenuToggle","เมนู / MENU",function() nav.Visible=not nav.Visible end)
menuToggle.Size=UDim2.fromOffset(128,44);menuToggle.Position=UDim2.fromOffset(14,68);menuToggle.Visible=false
local mapButton=UI.button(root,"WorldMap","แผนที่ / MAP",function() open("World Map • Prototype","แผนที่พิกัดจริงจะทำใน Phase เมนูหลังอนุมัติ HUD\nป้ายจุดหมายในฉากยังใช้งานได้") end)
mapButton.Size=UDim2.fromOffset(154,44);mapButton.Position=UDim2.new(1,-168,0,64)
local alerts=UI.button(root,"Notifications","แจ้งเตือน",function() open("Notifications",if #history>0 then table.concat(history,"\n\n") else "ยังไม่มีการแจ้งเตือน / No notifications") end)
alerts.Size=UDim2.fromOffset(154,44);alerts.Position=UDim2.new(1,-168,0,116)
local settings: TextButton
settings=UI.button(root,"Scale","UI 100%",function()
 local nextScale=if scale.Scale>1 then 1 elseif scale.Scale==1 then .9 else 1.1
 scale.Scale=nextScale;root.Size=UDim2.fromScale(1/nextScale,1/nextScale);settings.Text=string.format("UI %.0f%%",nextScale*100)
end)
settings.Size=UDim2.fromOffset(154,44);settings.Position=UDim2.new(1,-168,0,168)
local waypoint=Instance.new("BillboardGui");waypoint.Name="CargoWaypoint";waypoint.Size=UDim2.fromOffset(160,36);waypoint.StudsOffsetWorldSpace=Vector3.new(0,5,0);waypoint.MaxDistance=220;waypoint.AlwaysOnTop=true;waypoint.Parent=gui
local waypointText=UI.label(waypoint,"Destination","",UDim2.fromScale(1,1),UDim2.fromOffset(0,0),15,Theme.Gold)
local function vendor(): ScreenGui?
 local v=pg:FindFirstChild("A-Chassis Interface");return if v and v:IsA("ScreenGui") then v else nil
end
local function responsive()
 local camera=workspace.CurrentCamera;if not camera then return end
 compact=camera.ViewportSize.X<1000 or camera.ViewportSize.Y<550
 brand.Visible=not compact;menuToggle.Visible=compact
 if compact then nav.Visible=false else nav.Visible=true end
 nav.Size=UDim2.fromOffset(174,if compact then math.max(132,camera.ViewportSize.Y-180) else 310)
 resources.Size=UDim2.fromOffset(if compact then 300 else 440,44);resources.Position=UDim2.new(.5,if compact then -150 else -220,0,8)
 zone.Position=UDim2.new(.5,-150,0,60)
 dock.Size=UDim2.fromOffset(if compact then 310 else 450,94);dock.Position=UDim2.new(.5,if compact then -155 else -225,1,if compact then -104 else -116)
 cargo.Position=UDim2.fromOffset(if compact then 126 else 160,5);cargo.Size=UDim2.fromOffset(if compact then 180 else 280,28);cargo.TextSize=if compact then 16 else 20
 returnLabel.Position=UDim2.fromOffset(if compact then 126 else 160,34);returnLabel.Size=UDim2.fromOffset(if compact then 180 else 280,24);returnLabel.TextSize=if compact then 11 else 14
 speed.Size=UDim2.fromOffset(if compact then 80 else 100,48);gear.Position=UDim2.fromOffset(if compact then 85 else 108,2)
 hint.Position=UDim2.new(.2,0,1,if compact then -137 else -151)
 mapButton.Visible=not compact;alerts.Visible=not compact;settings.Visible=not compact
end
responsive()
if workspace.CurrentCamera then workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(responsive) end
local elapsed=0
RunService.Heartbeat:Connect(function(dt: number)
 elapsed+=dt;if elapsed<.1 then return end;elapsed=0
 gui.Enabled=player:GetAttribute("EntryOpen")~=true
 local character=player.Character;local humanoid=character and character:FindFirstChildOfClass("Humanoid")
 local seat=humanoid and humanoid.SeatPart
 riding=seat~=nil and seat.Parent~=nil and seat.Parent:GetAttribute("StreetCub")==true
 local characterRoot=character and character:FindFirstChild("HumanoidRootPart")
 local pos=if characterRoot and characterRoot:IsA("BasePart") then characterRoot.Position else nil
 currentSpeed=if riding and seat then seat.AssemblyLinearVelocity.Magnitude else 0
 local carrying=player:GetAttribute("TestCargo") or 0
 local target=if carrying>0 then Layout.Deposit else Layout.Pickup
 local returnDistance=if pos then (pos-Layout.Deposit).Magnitude else 0
 local targetDistance=if pos then (pos-target).Magnitude else 0
 cargo.Text=string.format("CARGO %d / 1",carrying)
 returnLabel.Text=string.format("กลับอู่ %.0f studs • เส้นตรง",returnDistance)
 speed.Visible=riding;gear.Visible=riding;unit.Visible=riding;engine.Visible=riding
 if not riding then cargo.Position=UDim2.fromOffset(8,12);cargo.Size=UDim2.new(1,-16,0,28);returnLabel.Position=UDim2.fromOffset(8,45);returnLabel.Size=UDim2.new(1,-16,0,24)
 else cargo.Position=UDim2.fromOffset(if compact then 126 else 160,5);cargo.Size=UDim2.fromOffset(if compact then 180 else 280,28);returnLabel.Position=UDim2.fromOffset(if compact then 126 else 160,34);returnLabel.Size=UDim2.fromOffset(if compact then 180 else 280,24) end
 local label="Garage City"
 if pos and pos.X> -380 then
  label="ทางหลวง / Highway"
  for _,z in Layout.Zones do if pos.X>=z.position.X-70 then label=string.format("Zone %02d • %s",z.id,z.name) end end
  local road=Layout.RoutePoint(math.clamp(pos.X,-1000,3050));if math.abs(pos.Z-road.Z)>200 then label="นอกเส้นทาง / Off route" end
 end
 zoneText.Text=label
 local coins=player:GetAttribute("Coins");local power=player:GetAttribute("Power")
 local resourcesText=string.format("ฝากสำเร็จ %d ครั้ง • SESSION",player:GetAttribute("TestSecured") or 0)
 if typeof(coins)=="number" then resourcesText=string.format("Coins %d  •  ",coins)..resourcesText end
 if typeof(power)=="number" then resourcesText..=string.format("  •  Power %d",power) end
 resourceText.Text=resourcesText
 local v=vendor()
 if v then for _,item in v:GetChildren() do if item:IsA("GuiObject") and (item:FindFirstChild("Advanced") or item.Name=="GForces" or item.Name=="Tires") then item.Visible=false end end end
 local values=v and v:FindFirstChild("Values");local g=values and values:FindFirstChild("Gear")
 local number=if g and (g:IsA("NumberValue") or g:IsA("IntValue")) then g.Value else 0
 gear.Text=if number==0 then "N" elseif number<0 then "R" else tostring(number)
 speed.Text=string.format("%03d",math.floor(currentSpeed*1.008+.5))
 local on=v and v:FindFirstChild("IsOn");engine.Text=if on and on:IsA("BoolValue") and on.Value then "เครื่องยนต์ทำงาน / ENGINE ON" else "เครื่องยนต์ดับ / ENGINE OFF"
 local point=workspace:FindFirstChild(if carrying>0 then "TestGarageDeposit" else "TestScrapPickup")
 waypoint.Adornee=if point and point:IsA("BasePart") then point else nil;waypoint.Enabled=point~=nil
 waypointText.Text=if carrying>0 then "▼ ฝาก Cargo" else "▼ เก็บอะไหล่"
 local entry=pg:FindFirstChild("StealEntry")
 local tutorial=entry and entry:FindFirstChild("Tutorial")
 hint.Visible=not (entry and entry:IsA("ScreenGui") and entry.Enabled and tutorial and tutorial:IsA("GuiObject") and tutorial.Visible)
 hint.Text=if riding and targetDistance<14 then (if carrying>0 then "เบรก แล้วกด E • ฝาก Cargo" else "กด E เก็บอะไหล่") elseif UserInputService.TouchEnabled then "ใช้ปุ่มควบคุมรถและปุ่ม Interact ที่ปรากฏ" elseif riding then "W/S เร่ง–เบรก • A/D เลี้ยว • จอดนิ่งแล้วกด Space ลงรถ" else "เข้าใกล้รถ กด F ขึ้นรถ • E เก็บอะไหล่"
 root.Visible=not menu.Visible
 if menu.Visible then nav.Visible=not compact end
 toast.Visible=os.clock()<toastUntil
end)
UserInputService.InputBegan:Connect(function(input,processed)
 if not processed and input.KeyCode==Enum.KeyCode.Backspace then menu.Visible=false end
end)