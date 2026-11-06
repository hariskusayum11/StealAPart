--!strict
-- M5 shared raid parts, Cargo and Inventory (server authoritative, session only).
--  * 5 parts per zone per round (60 total), shared: the first valid E press wins.
--  * A picked part is Cargo: unsafe, one slot, lost if dropped/caught or when the round ends.
--  * Crossing the Raid Gate westwards with Cargo deposits it into the player's Inventory (never lost).
-- Client-visible state: Player attributes Cargo (0/1), CargoType, CargoZone, InventoryTotal,
-- InventoryJson ({typeId=count}); part instances in workspace.RaidParts carry PartId/ZoneId/TypeId/State.
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("RaceAndRaid")
local Layout = require(Shared:WaitForChild("HubLayout"))
local Config = require(Shared:WaitForChild("RaidConfig"))
local Raid = require(script.Parent.RaidService)

local PartsService = {}

type PartRecord = {
 id: string, zoneId: number, typeId: string, slot: CFrame,
 state: string, -- "available" | "carried" | "dropped" | "returning" | "secured"
 holder: Player?, instance: BasePart?, round: number,
}
type InventoryEntry = {typeId: string, zoneId: number, round: number, at: number}

local parts: {[string]: PartRecord} = {}
local cargo: {[Player]: PartRecord} = {}
local inventory: {[Player]: {entries: {InventoryEntry}, counts: {[string]: number}}} = {}
local folder = Instance.new("Folder")
folder.Name = "RaidParts"
folder.Parent = workspace

local feedback: (Player, string) -> () = function() end
function PartsService.setFeedback(fn: (Player, string) -> ()) feedback = fn end

-- Listeners for NPC chase (M6): stolen(player, record), dropped(player, record, caughtInZone), secured(player, record)
local listeners = {stolen = {} :: {any}, released = {} :: {any}, secured = {} :: {any}}
function PartsService.on(event: string, fn: any) table.insert((listeners :: any)[event], fn) end
local function emit(event: string, ...: any) for _, fn in (listeners :: any)[event] do task.spawn(fn, ...) end end

local function publishCargo(player: Player)
 local rec = cargo[player]
 player:SetAttribute("Cargo", if rec then 1 else 0)
 player:SetAttribute("CargoType", if rec then rec.typeId else nil)
 player:SetAttribute("CargoZone", if rec then rec.zoneId else nil)
end

local function publishInventory(player: Player)
 local inv = inventory[player]
 if not inv then return end
 player:SetAttribute("InventoryTotal", #inv.entries)
 player:SetAttribute("InventoryJson", HttpService:JSONEncode(inv.counts))
end

local function groundAt(p: Vector3): Vector3
 local params = RaycastParams.new()
 params.FilterType = Enum.RaycastFilterType.Exclude
 local exclude: {Instance} = {folder}
 local vehicles = workspace:FindFirstChild("Vehicles")
 if vehicles then table.insert(exclude, vehicles) end
 for _, pl in Players:GetPlayers() do if pl.Character then table.insert(exclude, pl.Character) end end
 params.FilterDescendantsInstances = exclude
 local hit = workspace:Raycast(p + Vector3.new(0, 20, 0), Vector3.new(0, -80, 0), params)
 return if hit then hit.Position else p
end

local function destroyInstance(rec: PartRecord)
 if rec.instance then rec.instance:Destroy(); rec.instance = nil end
end

local pickUp: (Player, PartRecord) -> () -- forward declaration

-- Build the world item for a record at a CFrame (slot or drop point).
local function materialize(rec: PartRecord, at: CFrame)
 destroyInstance(rec)
 local t = Config.partType(rec.typeId)
 local p = Instance.new("Part")
 p.Name = "RaidPart"
 p.Size = Vector3.new(2.6, 2.6, 2.6)
 p.Shape = Enum.PartType.Block
 p.CFrame = at
 p.Anchored = true
 p.CanCollide = false
 p.CanTouch = false
 p.Material = Enum.Material.Neon
 p.Color = if t then t.color else Color3.new(1, 1, 1)
 p:SetAttribute("PartId", rec.id)
 p:SetAttribute("ZoneId", rec.zoneId)
 p:SetAttribute("TypeId", rec.typeId)
 p:SetAttribute("State", rec.state)
 local prompt = Instance.new("ProximityPrompt")
 prompt.Name = "PickupPrompt"
 prompt.ActionText = "เก็บอะไหล่"
 prompt.ObjectText = (if t then t.name else rec.typeId) .. " • Zone " .. string.format("%02d", rec.zoneId)
 prompt.KeyboardKeyCode = Enum.KeyCode.E -- VehicleInput.Actions.Pickup
 prompt.HoldDuration = 0
 prompt.MaxActivationDistance = Config.PickupRange
 prompt.RequiresLineOfSight = false
 prompt.Parent = p
 prompt.Triggered:Connect(function(player: Player) pickUp(player, rec) end)
 local label = Instance.new("BillboardGui")
 label.Name = "PartLabel"; label.Size = UDim2.fromOffset(150, 34); label.StudsOffset = Vector3.new(0, 3.2, 0)
 label.MaxDistance = 90; label.AlwaysOnTop = false; label.Parent = p
 local text = Instance.new("TextLabel"); text.Size = UDim2.fromScale(1, 1); text.BackgroundTransparency = 1
 text.Text = if t then t.name else rec.typeId; text.TextScaled = true; text.Font = Enum.Font.GothamBold
 text.TextColor3 = Color3.new(1, 1, 1); text.TextStrokeTransparency = 0.3; text.Parent = label
 p.Parent = folder
 rec.instance = p
end

local function setState(rec: PartRecord, state: string)
 rec.state = state
 if rec.instance then rec.instance:SetAttribute("State", state) end
end

local function reject(player: Player, reason: string, message: string?)
 player:SetAttribute("LastPickupResult", reason) -- diagnostics (QA / support)
 if message then feedback(player, message) end
end

pickUp = function(player: Player, rec: PartRecord)
 if not Raid.isOpen() then reject(player, "closed", "Raid ปิดอยู่ • รอรอบถัดไป"); return end
 if rec.state ~= "available" and rec.state ~= "dropped" then reject(player, "taken:" .. rec.state); return end -- someone else got it first
 if cargo[player] then reject(player, "full", "Cargo เต็ม (1/1) • หนีกลับไปฝากที่ประตู Raid"); return end
 local character = player.Character
 local humanoid = character and character:FindFirstChildOfClass("Humanoid")
 if not humanoid or humanoid.Health <= 0 or not rec.instance then reject(player, "noCharacter"); return end
 local p = Raid.trackedPosition(player)
 if not p or (p - rec.instance.Position).Magnitude > Config.PickupRange + 3 then
  reject(player, "range", "เข้าใกล้อะไหล่อีกนิดแล้วกด E"); return
 end
 if not Config.inRaidArea(p) then reject(player, "outsideRaid"); return end
 player:SetAttribute("LastPickupResult", "ok:" .. rec.id)
 -- Commit (no yields between check and state change).
 rec.holder = player
 setState(rec, "carried")
 destroyInstance(rec)
 cargo[player] = rec
 publishCargo(player)
 local t = Config.partType(rec.typeId)
 feedback(player, "ขโมยสำเร็จ! " .. (if t then t.name else "") .. " • หนีกลับประตู Raid!")
 player:SetAttribute("CargoEventId", (player:GetAttribute("CargoEventId") or 0) + 1)
 emit("stolen", player, rec)
end

-- Gate deposit (called by RaidService "exited").
function PartsService.deposit(player: Player): boolean
 local rec = cargo[player]
 if not rec then return false end
 cargo[player] = nil -- consume before credit
 setState(rec, "secured")
 rec.holder = nil
 local inv = inventory[player]
 if not inv then inv = {entries = {}, counts = {}}; inventory[player] = inv end
 table.insert(inv.entries, {typeId = rec.typeId, zoneId = rec.zoneId, round = rec.round, at = os.time()})
 inv.counts[rec.typeId] = (inv.counts[rec.typeId] or 0) + 1
 publishCargo(player)
 publishInventory(player)
 player:SetAttribute("DepositEventId", (player:GetAttribute("DepositEventId") or 0) + 1)
 feedback(player, "ฝากอะไหล่สำเร็จ! เข้าคลังแล้ว (" .. #inv.entries .. " ชิ้น)")
 emit("secured", player, rec)
 return true
end

-- Remove the player's Cargo because they were caught. caughtInZone -> the guard carries it home (case A);
-- otherwise it is dropped at the catch point for anyone to pick up again (case B).
function PartsService.release(player: Player, at: Vector3, caughtInZone: boolean): PartRecord?
 local rec = cargo[player]
 if not rec then return nil end
 cargo[player] = nil
 rec.holder = nil
 publishCargo(player)
 if caughtInZone then
  setState(rec, "returning")
  feedback(player, "ยามจับได้! ยามเอาอะไหล่กลับไปแล้ว")
 else
  setState(rec, "dropped")
  materialize(rec, CFrame.new(groundAt(at) + Vector3.new(0, 1.6, 0)))
  feedback(player, "ยามจับได้! อะไหล่ตกอยู่ตรงนี้ • กด E เก็บคืนได้")
 end
 emit("released", player, rec, caughtInZone)
 return rec
end

-- Guard brought a part home (case A): it becomes available again in its slot.
function PartsService.restore(partId: string)
 local rec = parts[partId]
 if rec and rec.state == "returning" and Raid.isOpen() then
  setState(rec, "available")
  materialize(rec, rec.slot)
 end
end

function PartsService.cargoOf(player: Player): PartRecord? return cargo[player] end
function PartsService.records(): {[string]: PartRecord} return parts end

-- Slot layout on a zone pad (pad-local, spread across the pad, clear of the connector centreline).
local SLOTS = {{-36, 0.30}, {-18, 0.72}, {0, 0.45}, {18, 0.72}, {36, 0.30}}
local function spawnRound(roundNo: number)
 for _, rec in parts do destroyInstance(rec) end
 table.clear(parts)
 local half = Layout.ZonePadSize / 2
 for _, zone in Layout.Zones do
  for i = 1, Config.PartsPerZone do
   local s = SLOTS[((i - 1) % #SLOTS) + 1]
   local depth = zone.padNear + Layout.ZonePadSize.Z * s[2]
   local pos = zone.position + Vector3.new(s[1], 0, zone.side * depth)
   pos = Vector3.new(math.clamp(pos.X, zone.padCentre.X - half.X + 4, zone.padCentre.X + half.X - 4), zone.position.Y + 1.6, pos.Z)
   local typeId = Config.PartTypes[((zone.id + i - 2) % #Config.PartTypes) + 1].id
   local rec: PartRecord = {id = string.format("R%d-Z%02d-%d", roundNo, zone.id, i), zoneId = zone.id, typeId = typeId,
    slot = CFrame.new(pos), state = "available", holder = nil, instance = nil, round = roundNo}
   parts[rec.id] = rec
   materialize(rec, rec.slot)
  end
 end
 workspace:SetAttribute("RaidPartsTotal", Config.PartsPerZone * #Layout.Zones)
end

local function endRound(_roundNo: number)
 for player in cargo do
  cargo[player] = nil
  publishCargo(player)
 end
 for _, rec in parts do destroyInstance(rec); rec.holder = nil; if rec.state ~= "secured" then rec.state = "expired" end end
end

function PartsService.start()
 Raid.on("roundStart", spawnRound)
 Raid.on("roundEnd", endRound)
 Raid.on("exited", function(player: Player) PartsService.deposit(player) end)
 local function init(player: Player)
  inventory[player] = inventory[player] or {entries = {}, counts = {}}
  publishCargo(player)
  publishInventory(player)
 end
 Players.PlayerAdded:Connect(init)
 for _, player in Players:GetPlayers() do init(player) end
 Players.PlayerRemoving:Connect(function(player: Player)
  local rec = cargo[player]
  if rec then cargo[player] = nil; rec.holder = nil; setState(rec, "available"); materialize(rec, rec.slot) end
  inventory[player] = nil
 end)
 -- Dying with Cargo drops it where the player fell (same as being caught outside the zone).
 local function watchDeath(player: Player, character: Model)
  local humanoid = character:WaitForChild("Humanoid", 10)
  if humanoid and humanoid:IsA("Humanoid") then
   humanoid.Died:Connect(function()
    local root = character:FindFirstChild("HumanoidRootPart")
    if cargo[player] and root and root:IsA("BasePart") then PartsService.release(player, root.Position, false) end
   end)
  end
 end
 Players.PlayerAdded:Connect(function(player) player.CharacterAdded:Connect(function(c) watchDeath(player, c) end) end)
 for _, player in Players:GetPlayers() do
  player.CharacterAdded:Connect(function(c) watchDeath(player, c) end)
  if player.Character then task.spawn(watchDeath, player, player.Character) end
 end
end

return PartsService
