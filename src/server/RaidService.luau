--!strict
-- M4 Raid Gate + shared round cycle (server authoritative).
-- Phase is published on workspace attributes: RaidPhase ("Closed"/"Open"), RaidPhaseEndsAt (server time,
-- compare with workspace:GetServerTimeNow()), RaidRound. Every client shows the same countdown.
-- Gate crossings are detected from each player's tracked point (own bike seat while riding, else root)
-- moving across X = GateX between two 10 Hz samples, so standing at or entering the gate never deposits.
local Players = game:GetService("Players")
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("RaceAndRaid")
local Config = require(Shared:WaitForChild("RaidConfig"))
local Vehicles = require(script.Parent.VehicleService)

local RaidService = {}

local phase = "Closed"
local phaseEndsAt = 0
local round = 0
local durations = {Closed = Config.ClosedSeconds, Open = Config.OpenSeconds}
local lastX: {[Player]: number} = {}

-- Hooks for later milestones (parts, NPCs). Each receives the documented arguments.
local hooks = {
 roundStart = {} :: {(number) -> ()}, -- (round)
 roundEnd = {} :: {(number) -> ()}, -- (round) before players are returned
 exited = {} :: {(Player) -> ()}, -- crossed the gate westwards (Raid Area -> Garage City)
 entered = {} :: {(Player) -> ()}, -- crossed the gate eastwards while Open
}
function RaidService.on(event: string, fn: any) table.insert((hooks :: any)[event], fn) end
local function fire(event: string, ...: any)
 for _, fn in (hooks :: any)[event] do task.spawn(fn, ...) end
end

local feedback: (Player, string) -> () = function() end
function RaidService.setFeedback(fn: (Player, string) -> ()) feedback = fn end

function RaidService.phase(): string return phase end
function RaidService.isOpen(): boolean return phase == "Open" end
function RaidService.round(): number return round end

-- Tracked world point of a player: own bike seat while riding, otherwise the character root.
function RaidService.trackedPosition(player: Player): Vector3?
 local _, seat = Vehicles.ridden(player)
 if seat then return seat.Position end
 local character = player.Character
 local root = character and character:FindFirstChild("HumanoidRootPart")
 if root and root:IsA("BasePart") then return root.Position end
 return nil
end

-- ===== gate visuals (blockout; no imported assets) =====
local gate = Instance.new("Model")
gate.Name = "RaidGate"
local function part(name: string, size: Vector3, cf: CFrame, color: Color3, material: Enum.Material?): Part
 local p = Instance.new("Part")
 p.Name = name; p.Size = size; p.CFrame = cf; p.Color = color; p.Anchored = true
 p.Material = material or Enum.Material.Metal; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth
 p.Parent = gate
 return p
end
local gx, hw = Config.GateX, Config.GateHalfWidth
local navy = Color3.fromRGB(14, 30, 58)
for _, s in {-1, 1} do part("GatePillar", Vector3.new(3, 18, 3), CFrame.new(gx, 9, s * (hw + 3)), navy) end
local beam = part("GateBeam", Vector3.new(3, 4, hw * 2 + 9), CFrame.new(gx, 19, 0), navy)
local barrier = part("GateBarrier", Vector3.new(1, 10, hw * 2), CFrame.new(gx, 5, 0), Color3.fromRGB(210, 50, 50), Enum.Material.ForceField)
barrier.CastShadow = false
local line = part("GateLine", Vector3.new(1.5, 0.05, hw * 2), CFrame.new(gx, 0.07, 0), Color3.fromRGB(242, 194, 53), Enum.Material.SmoothPlastic)
line.CanCollide = false; line.CanQuery = false; line.CanTouch = false
-- Both faces carry a SurfaceGui; the client writes the live countdown into "GateText" labels.
for _, face in {Enum.NormalId.Left, Enum.NormalId.Right} do
 local g = Instance.new("SurfaceGui"); g.Name = "GateSign"; g.Face = face
 g.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud; g.PixelsPerStud = 24; g.Parent = beam
 local l = Instance.new("TextLabel"); l.Name = "GateText"; l.Size = UDim2.fromScale(1, 1); l.BackgroundTransparency = 1
 l.TextColor3 = Color3.fromRGB(242, 194, 53); l.TextScaled = true; l.Font = Enum.Font.GothamBlack; l.Text = "RAID GATE"; l.Parent = g
end
gate.Parent = workspace

local function applyPhaseVisuals()
 local open = phase == "Open"
 barrier.CanCollide = not open
 barrier.Transparency = if open then 1 else 0.35
 barrier.CanQuery = not open
 gate:SetAttribute("Open", open)
end

local function publish()
 workspace:SetAttribute("RaidPhase", phase)
 workspace:SetAttribute("RaidPhaseEndsAt", phaseEndsAt)
 workspace:SetAttribute("RaidRound", round)
 applyPhaseVisuals()
end

-- ===== round end: send everyone still in the Raid Area back to the assembly line with their bike =====
local function returnToAssembly(player: Player, slot: number)
 local z = Config.AssemblySlotsZ[((slot - 1) % #Config.AssemblySlotsZ) + 1]
 local seatTarget = CFrame.lookAt(Vector3.new(Config.AssemblyX, 2.85, z), Vector3.new(Config.AssemblyX - 10, 2.85, z))
 local bike = Vehicles.bikeOf(player.UserId)
 local ridingBike = Vehicles.ridden(player)
 if bike then Vehicles.placeAt(bike, seatTarget) end -- a seated rider moves with the bike
 if not ridingBike then
  local character = player.Character
  if character then character:PivotTo(seatTarget * CFrame.new(-4, 0.5, 0)) end
 end
 lastX[player] = Config.AssemblyX
 feedback(player, "หมดเวลา Raid! กลับมาหน้าประตูแล้ว • อะไหล่ที่ยังไม่ฝากหายไป")
end

local function setPhase(newPhase: string)
 local previous = phase
 phase = newPhase
 phaseEndsAt = workspace:GetServerTimeNow() + durations[newPhase]
 if newPhase == "Open" then
  round += 1
  publish()
  fire("roundStart", round)
 else
  publish()
  if previous == "Open" then
   for _, fn in hooks.roundEnd do fn(round) end -- synchronous: cargo cleared before anyone is moved
   local slot = 0
   for _, player in Players:GetPlayers() do
    local p = RaidService.trackedPosition(player)
    if p and Config.inRaidArea(p) then slot += 1; returnToAssembly(player, slot) end
   end
  end
 end
end

-- QA (Studio hook): shorten phases or jump to the next phase immediately.
function RaidService.qaSetDurations(closed: number?, open: number?)
 if closed then durations.Closed = closed end
 if open then durations.Open = open end
end
function RaidService.qaAdvance()
 setPhase(if phase == "Open" then "Closed" else "Open")
end

-- ===== main loop: timer + gate crossing detection at 10 Hz =====
function RaidService.start()
 phase = "Closed"
 phaseEndsAt = workspace:GetServerTimeNow() + durations.Closed
 publish()
 task.spawn(function()
  while true do
   task.wait(0.1)
   if workspace:GetServerTimeNow() >= phaseEndsAt then
    setPhase(if phase == "Open" then "Closed" else "Open")
   end
   for _, player in Players:GetPlayers() do
    local p = RaidService.trackedPosition(player)
    if p then
     local prev = lastX[player]
     lastX[player] = p.X
     if prev and math.abs(p.Z) <= Config.GateHalfWidth + 12 then
      if prev > Config.GateX and p.X <= Config.GateX then
       fire("exited", player)
      elseif prev <= Config.GateX and p.X > Config.GateX then
       if phase == "Open" then
        fire("entered", player)
       else
        -- Barrier is solid while Closed; anyone who still gets through is put back.
        returnToAssembly(player, 1)
        feedback(player, "ประตู Raid ยังปิดอยู่ • รอเปิดรอบถัดไป")
       end
      end
     elseif prev and phase == "Closed" and p.X > Config.GateX and prev <= Config.GateX then
      -- Went around the gate (off-road) while closed.
      returnToAssembly(player, 1)
      feedback(player, "ประตู Raid ยังปิดอยู่ • รอเปิดรอบถัดไป")
     end
    end
   end
  end
 end)
end

Players.PlayerRemoving:Connect(function(player) lastX[player] = nil end)

return RaidService
