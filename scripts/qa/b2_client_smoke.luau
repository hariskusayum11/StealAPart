-- QA-only (Studio Play Client). B2 smoke: HUD/Entry present, GarageDay active at G1 spawn, zone label.
local p=game.Players.LocalPlayer
local gui=p:WaitForChild("PlayerGui")
task.wait(3)
local names={};for _,g in gui:GetChildren() do table.insert(names,g.Name..(if g:IsA("ScreenGui") then (if g.Enabled then "+" else "-") else "")) end
table.sort(names)
local root=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
return game:GetService("HttpService"):JSONEncode({playerGui=names,g1DayPreset=p:GetAttribute("G1DayPresetActive"),
 rootPos=root and tostring((root :: BasePart).Position),testCargo=p:GetAttribute("TestCargo"),testSecured=p:GetAttribute("TestSecured"),
 loadingComplete=p:GetAttribute("LoadingComplete"),entryOpen=p:GetAttribute("EntryOpen")})
