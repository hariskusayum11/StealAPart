--!strict
-- M4–M6 child-friendly Raid HUD: one big round banner (open/closed + countdown), Cargo and Inventory line,
-- a chase warning, and short pop-ups for steal / deposit / caught. Also writes the Raid Gate sign.
-- Reads only replicated attributes; all rules run on the server.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("RaceAndRaid")
local Config = require(Shared:WaitForChild("RaidConfig"))
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "RaidHUD"; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = false; gui.DisplayOrder = 5
gui.Parent = player:WaitForChild("PlayerGui")

local banner = Instance.new("Frame")
banner.Name = "RoundBanner"; banner.AnchorPoint = Vector2.new(0.5, 0); banner.Position = UDim2.new(0.5, 0, 0, 10)
banner.Size = UDim2.fromOffset(440, 44) -- replaces LabHUD Resources slot; banner.BackgroundColor3 = Color3.fromRGB(14, 30, 58); banner.BackgroundTransparency = 0.1
banner.Parent = gui
Instance.new("UICorner", banner).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", banner); stroke.Thickness = 2
local phaseText = Instance.new("TextLabel")
phaseText.Name = "PhaseText"; phaseText.Size = UDim2.new(1, -12, 1, 0); phaseText.Position = UDim2.fromOffset(6, 0)
phaseText.BackgroundTransparency = 1; phaseText.Font = Enum.Font.GothamBlack; phaseText.TextScaled = true
phaseText.TextColor3 = Color3.new(1, 1, 1); phaseText.Parent = banner

local status = Instance.new("TextLabel")
status.Name = "CargoStatus"; status.AnchorPoint = Vector2.new(0.5, 0); status.Position = UDim2.new(0.5, 0, 0, 56)
status.Size = UDim2.fromOffset(360, 28); status.BackgroundColor3 = Color3.fromRGB(8, 16, 30); status.BackgroundTransparency = 0.25
status.Font = Enum.Font.GothamBold; status.TextScaled = true; status.TextColor3 = Color3.new(1, 1, 1); status.Parent = gui
status.Visible = false -- LabHUD dock shows Cargo / Inventory; kept for compact layouts
Instance.new("UICorner", status).CornerRadius = UDim.new(0, 8)

local chase = Instance.new("TextLabel")
chase.Name = "ChaseWarning"; chase.AnchorPoint = Vector2.new(0.5, 0); chase.Position = UDim2.new(0.5, 0, 0, 172)
chase.Size = UDim2.fromOffset(300, 34); chase.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
chase.Font = Enum.Font.GothamBlack; chase.TextScaled = true; chase.TextColor3 = Color3.new(1, 1, 1)
chase.Text = "⚠ ยามกำลังไล่! หนีไปประตู Raid"; chase.Visible = false; chase.Parent = gui
Instance.new("UICorner", chase).CornerRadius = UDim.new(0, 8)

local pop = Instance.new("TextLabel")
pop.Name = "Popup"; pop.AnchorPoint = Vector2.new(0.5, 0.5); pop.Position = UDim2.fromScale(0.5, 0.36)
pop.Size = UDim2.fromOffset(420, 60); pop.BackgroundTransparency = 1; pop.Font = Enum.Font.GothamBlack; pop.TextScaled = true
pop.TextStrokeTransparency = 0.1; pop.TextTransparency = 1; pop.TextStrokeColor3 = Color3.new(0, 0, 0); pop.Parent = gui

local function popup(text: string, color: Color3)
 pop.Text = text; pop.TextColor3 = color; pop.TextTransparency = 0; pop.TextStrokeTransparency = 0.1
 pop.Size = UDim2.fromOffset(300, 44)
 TweenService:Create(pop, TweenInfo.new(0.18, Enum.EasingStyle.Back), {Size = UDim2.fromOffset(420, 60)}):Play()
 task.delay(1.8, function()
  if pop.Text == text then
   TweenService:Create(pop, TweenInfo.new(0.4), {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
  end
 end)
end

local function watch(attr: string, text: string, color: Color3)
 player:GetAttributeChangedSignal(attr):Connect(function() popup(text, color) end)
end
watch("CargoEventId", "ขโมยสำเร็จ! หนีเลย!", Color3.fromRGB(255, 214, 60))
watch("DepositEventId", "ฝากอะไหล่สำเร็จ!", Color3.fromRGB(90, 230, 120))
watch("CaughtEventId", "โดนยามจับ! อะไหล่หลุด", Color3.fromRGB(255, 90, 80))

local function clock(seconds: number): string
 seconds = math.max(0, math.floor(seconds))
 return string.format("%d:%02d", seconds // 60, seconds % 60)
end

local gateTexts: {TextLabel} = {}
task.spawn(function()
 local gate = workspace:WaitForChild("RaidGate", 60)
 if not gate then return end
 for _, d in gate:GetDescendants() do if d:IsA("TextLabel") and d.Name == "GateText" then table.insert(gateTexts, d) end end
end)

local acc = 0
RunService.Heartbeat:Connect(function(dt)
 acc += dt
 if acc < 0.1 then return end
 acc = 0
 local phase = workspace:GetAttribute("RaidPhase")
 local endsAt = workspace:GetAttribute("RaidPhaseEndsAt")
 local left = if typeof(endsAt) == "number" then endsAt - workspace:GetServerTimeNow() else 0
 local open = phase == "Open"
 phaseText.Text = if phase == nil then "กำลังเตรียม Raid…" elseif open then "RAID เปิด • เหลือ " .. clock(left) else "RAID ปิด • เปิดใน " .. clock(left)
 banner.BackgroundColor3 = if open then Color3.fromRGB(20, 110, 60) else Color3.fromRGB(120, 30, 36)
 stroke.Color = if open and left < 30 then Color3.fromRGB(255, 214, 60) else Color3.fromRGB(255, 255, 255)
 for _, label in gateTexts do
  label.Text = if open then "RAID เปิด " .. clock(left) else "RAID ปิด • " .. clock(left)
  label.TextColor3 = if open then Color3.fromRGB(110, 240, 140) else Color3.fromRGB(255, 120, 110)
 end
 local carrying = (player:GetAttribute("Cargo") or 0) :: number
 local typeId = player:GetAttribute("CargoType")
 local t = if typeof(typeId) == "string" then Config.partType(typeId) else nil
 local total = player:GetAttribute("InventoryTotal") or 0
 status.Text = if carrying > 0 and t then string.format("CARGO 1/1 • %s (Zone %02d) • คลัง %d", t.name, player:GetAttribute("CargoZone") or 0, total)
  else string.format("CARGO 0/1 • คลังอะไหล่ %d ชิ้น", total)
 status.BackgroundColor3 = if carrying > 0 then Color3.fromRGB(150, 100, 10) else Color3.fromRGB(8, 16, 30)
 local chased = (player:GetAttribute("ChasedBy") or 0) :: number
 chase.Visible = chased > 0
end)
