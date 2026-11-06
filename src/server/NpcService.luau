--!strict
-- M6 NPC chase (prototype). Guards are light anchored part models (no Humanoid, no physics) moved by the
-- server only while chasing or returning; idle guards cost nothing. A guard chases only the player who
-- stole (or re-picked) a part from its own zone.
--  A caught inside the origin zone  -> Cargo goes back with the guard, part restored to its slot
--  B caught outside the origin zone -> Cargo dropped at the catch point, guard walks home
--  C thief deposits at the Raid Gate -> chase stops (guards never cross the gate line)
--  D round ends                      -> every guard resets home
local Players = game:GetService("Players")
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("RaceAndRaid")
local Layout = require(Shared:WaitForChild("HubLayout"))
local Config = require(Shared:WaitForChild("RaidConfig"))
local Raid = require(script.Parent.RaidService)
local Parts = require(script.Parent.PartsService)

local NpcService = {}

type Guard = {
 zone: any, tier: any, model: Model, root: BasePart, home: CFrame, position: Vector3,
 state: string, -- "idle" | "alert" | "chase" | "return"
 target: Player?, carrying: string?, lastCatch: number, alertUntil: number,
}
local guards: {Guard} = {}
local byZone: {[number]: {Guard}} = {}
local folder = Instance.new("Folder")
folder.Name = "RaidGuards"
folder.Parent = workspace

local RETURN_SPEED = 26
local TICK = 1 / 15

local function build(zone: any, tier: any, index: number): Guard
 local model = Instance.new("Model")
 model.Name = string.format("Guard_Z%02d_%d", zone.id, index)
 local function piece(name: string, size: Vector3, offset: CFrame, color: Color3, shape: Enum.PartType?): BasePart
  local p = Instance.new("Part")
  p.Name = name; p.Size = size; p.Color = color; p.Anchored = true; p.CanCollide = false; p.CanTouch = false
  p.CanQuery = false; p.CastShadow = false; p.Material = Enum.Material.SmoothPlastic
  if shape then p.Shape = shape end
  p:SetAttribute("Offset", offset)
  p.Parent = model
  return p
 end
 local root = piece("Body", Vector3.new(2.2, 3, 1.4), CFrame.identity, tier.color)
 piece("Head", Vector3.new(1.6, 1.6, 1.6), CFrame.new(0, 2.4, 0), Color3.fromRGB(240, 200, 160), Enum.PartType.Ball)
 piece("Cap", Vector3.new(1.8, 0.5, 1.9), CFrame.new(0, 3.2, -0.1), Color3.fromRGB(20, 28, 48))
 for _, s in {-1, 1} do piece("Leg", Vector3.new(0.8, 2, 0.8), CFrame.new(s * 0.55, -2.5, 0), Color3.fromRGB(30, 36, 52)) end
 local tag = Instance.new("BillboardGui")
 tag.Name = "GuardTag"; tag.Size = UDim2.fromOffset(120, 26); tag.StudsOffset = Vector3.new(0, 5, 0); tag.MaxDistance = 140
 tag.Parent = root
 local text = Instance.new("TextLabel"); text.Name = "Text"; text.Size = UDim2.fromScale(1, 1); text.BackgroundTransparency = 1
 text.Font = Enum.Font.GothamBold; text.TextScaled = true; text.TextColor3 = tier.color; text.TextStrokeTransparency = 0.2
 text.Text = "ยาม • " .. tier.name; text.Parent = tag
 model.PrimaryPart = root
 local spread = (index - (tier.guards + 1) / 2) * 14
 local homePos = zone.padCentre + Vector3.new(spread, 3.5, zone.side * 14)
 local home = CFrame.lookAt(homePos, Vector3.new(homePos.X, homePos.Y, zone.position.Z))
 model:SetAttribute("ZoneId", zone.id)
 model:SetAttribute("State", "idle")
 model.Parent = folder
 local g: Guard = {zone = zone, tier = tier, model = model, root = root, home = home, position = homePos,
  state = "idle", target = nil, carrying = nil, lastCatch = 0, alertUntil = 0}
 return g
end

local function place(g: Guard, cf: CFrame)
 for _, p in g.model:GetChildren() do
  if p:IsA("BasePart") then p.CFrame = cf * (p:GetAttribute("Offset") :: CFrame) end
 end
 g.position = cf.Position
end

local function setState(g: Guard, state: string, target: Player?)
 g.state = state
 g.target = target
 g.model:SetAttribute("State", state)
 g.model:SetAttribute("TargetUserId", if target then target.UserId else nil)
 local text = (g.root:FindFirstChild("GuardTag") :: BillboardGui):FindFirstChild("Text") :: TextLabel
 text.Text = if state == "alert" then "ยาม • !!" elseif state == "chase" then "ยาม • ไล่จับ!" elseif state == "return" then "ยาม • กลับโซน" else "ยาม • " .. g.tier.name
end

-- Ground height under a guard: the analytic road/pad heights are enough on this flat blockout.
local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Include
local function groundY(p: Vector3): number
 local course = workspace:FindFirstChild("CargoTestCourse")
 params.FilterDescendantsInstances = if course then {course, workspace.Terrain} else {workspace.Terrain}
 local hit = workspace:Raycast(Vector3.new(p.X, p.Y + 30, p.Z), Vector3.new(0, -80, 0), params)
 return if hit then hit.Position.Y else p.Y - 3.5
end

local function chaseFor(player: Player)
 local n = 0
 for _, g in guards do if (g.state == "chase" or g.state == "alert") and g.target == player then n += 1 end end
 player:SetAttribute("ChasedBy", n)
end

local function stopChasing(player: Player)
 for _, g in guards do
  if g.target == player and (g.state == "chase" or g.state == "alert") then setState(g, "return", nil) end
 end
 chaseFor(player)
end

local function startChase(player: Player, zoneId: number)
 for _, g in byZone[zoneId] or {} do
  if g.state ~= "chase" and g.state ~= "alert" and not g.carrying then
   g.alertUntil = os.clock() + Config.GuardAlertSeconds
   setState(g, "alert", player)
  end
 end
 chaseFor(player)
end

local function resetAll()
 for _, g in guards do
  g.carrying = nil
  setState(g, "idle", nil)
  place(g, g.home)
 end
 for _, player in Players:GetPlayers() do player:SetAttribute("ChasedBy", 0) end
end

local function step(dt: number)
 for _, g in guards do
  if g.state == "alert" and os.clock() >= g.alertUntil then setState(g, "chase", g.target) end
  if g.state == "alert" then
   local target = g.target
   local rec = target and Parts.cargoOf(target)
   if not target or not rec or rec.zoneId ~= g.zone.id or not Raid.isOpen() then setState(g, "return", nil); if target then chaseFor(target) end end
  elseif g.state == "chase" then
   local target = g.target
   local p = target and target.Parent and Raid.trackedPosition(target)
   local rec = target and Parts.cargoOf(target)
   if not target or not p or not rec or rec.zoneId ~= g.zone.id or not Raid.isOpen() then
    setState(g, "return", nil)
    if target then chaseFor(target) end
   else
    local flat = Vector3.new(p.X - g.position.X, 0, p.Z - g.position.Z)
    local dist = flat.Magnitude
    if dist <= g.tier.catchRadius and math.abs(p.Y - g.position.Y) < 10 then
     -- Catch.
     local inZone = Config.inZoneArea(g.zone, p)
     local released = Parts.release(target :: Player, p, inZone)
     g.lastCatch = os.clock()
     if released and inZone then g.carrying = released.id end
     stopChasing(target :: Player)
     setState(g, "return", nil)
     ;(target :: Player):SetAttribute("CaughtEventId", ((target :: Player):GetAttribute("CaughtEventId") or 0) + 1)
    else
     local move = math.min(dist, g.tier.speed * dt)
     local nextPos = g.position + flat.Unit * move
     -- Guards stop at the gate line (they never enter Garage City).
     if nextPos.X < Config.GateX + 6 then nextPos = Vector3.new(Config.GateX + 6, nextPos.Y, nextPos.Z) end
     nextPos = Vector3.new(nextPos.X, groundY(nextPos) + 3.5, nextPos.Z)
     place(g, CFrame.lookAt(nextPos, Vector3.new(p.X, nextPos.Y, p.Z)))
    end
   end
  elseif g.state == "return" then
   local h = g.home.Position
   local flat = Vector3.new(h.X - g.position.X, 0, h.Z - g.position.Z)
   if flat.Magnitude < 1 then
    place(g, g.home)
    if g.carrying then Parts.restore(g.carrying); g.carrying = nil end
    setState(g, "idle", nil)
   else
    local nextPos = g.position + flat.Unit * math.min(flat.Magnitude, RETURN_SPEED * dt)
    nextPos = Vector3.new(nextPos.X, groundY(nextPos) + 3.5, nextPos.Z)
    place(g, CFrame.lookAt(nextPos, Vector3.new(h.X, nextPos.Y, h.Z)))
   end
  end
 end
end

function NpcService.start()
 for _, zone in Layout.Zones do
  local tier = Config.tierOf(zone.id)
  byZone[zone.id] = {}
  for i = 1, tier.guards do
   local g = build(zone, tier, i)
   place(g, g.home)
   table.insert(guards, g)
   table.insert(byZone[zone.id], g)
  end
 end
 Parts.on("stolen", function(player: Player, rec: any) startChase(player, rec.zoneId) end)
 Parts.on("secured", function(player: Player) stopChasing(player) end)
 Raid.on("roundEnd", function() resetAll() end)
 Raid.on("roundStart", function() resetAll() end)
 Players.PlayerRemoving:Connect(function(player) stopChasing(player) end)
 task.spawn(function()
  local last = os.clock()
  while true do
   task.wait(TICK)
   local now = os.clock()
   local active = false
   for _, g in guards do if g.state ~= "idle" then active = true; break end end
   if active then step(math.min(now - last, 0.2)) end
   last = now
  end
 end)
end

function NpcService.guards(): {Guard} return guards end

return NpcService
