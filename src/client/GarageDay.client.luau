--!strict
-- Client-local sample preset: six players in different zones do not change each other's lighting.
local Lighting=game:GetService("Lighting")
local Players=game:GetService("Players")
local player=Players.LocalPlayer
local old={ClockTime=Lighting.ClockTime,Brightness=Lighting.Brightness,Ambient=Lighting.Ambient,OutdoorAmbient=Lighting.OutdoorAmbient,ExposureCompensation=Lighting.ExposureCompensation}
local correction=Instance.new("ColorCorrectionEffect");correction.Name="G1BrightGarageDay";correction.Enabled=false;correction.Saturation=.08;correction.Contrast=.04;correction.TintColor=Color3.fromRGB(255,247,232);correction.Parent=Lighting
local active=false
local marker=workspace:WaitForChild("TestGarageDeposit") :: BasePart
local markerTransparency=marker.Transparency
local function apply(enabled:boolean)
 if active==enabled then return end
 active=enabled;correction.Enabled=enabled
 if enabled then
  Lighting.ClockTime=13.4;Lighting.Brightness=2.2;Lighting.ExposureCompensation=.05
  Lighting.Ambient=Color3.fromRGB(116,125,135);Lighting.OutdoorAmbient=Color3.fromRGB(139,151,164)
 else
  Lighting.ClockTime=old.ClockTime;Lighting.Brightness=old.Brightness;Lighting.Ambient=old.Ambient;Lighting.OutdoorAmbient=old.OutdoorAmbient;Lighting.ExposureCompensation=old.ExposureCompensation
 end
 player:SetAttribute("G1DayPresetActive",enabled)
end
while script.Parent do
 local character=player.Character;local root=character and character:FindFirstChild("HumanoidRootPart")
 local inside=false
 if root and root:IsA("BasePart") then local p=root.Position;inside=p.X>=-870 and p.X<=-690 and p.Z>=20 and p.Z<=330 end
 apply(inside)
 marker.Transparency=if inside and workspace:GetAttribute("ShowDevelopmentMarkers")~=true then 1 else markerTransparency
 task.wait(.5)
end
apply(false);correction:Destroy()