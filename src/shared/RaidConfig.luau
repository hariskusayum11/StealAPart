--!strict
-- Raid gameplay constants (Master Owner Directive 2026-11-06). Read by server and client; no secrets.
local Layout = require(script.Parent.HubLayout)

local RaidConfig = {}

-- Shared server-wide cycle: Closed 2 min -> Open 5 min -> repeat.
RaidConfig.ClosedSeconds = 120
RaidConfig.OpenSeconds = 300

-- Main Raid Gate in the straight throat between the Y-fork gateway plaza and Zone 01.
-- Raid Area = X > GateX. Garage City = X < GateX. Deposit = crossing the line westwards with Cargo.
RaidConfig.GateX = -330
RaidConfig.GateHalfWidth = 22 -- throat road half-width (44-stud road)
-- Players still in the Raid Area when time runs out are returned here, on the Garage City side.
RaidConfig.AssemblyX = -378
RaidConfig.AssemblySlotsZ = {-14, -6, 2, 10, -22, 18}

-- Parts: shared, 5 per zone per round, first valid E press wins. One Cargo slot per player.
RaidConfig.PartsPerZone = 5
RaidConfig.CargoCapacity = 1
RaidConfig.PickupRange = 12
RaidConfig.PartTypes = {
 {id = "wheel", name = "ล้อแม็ก", color = Color3.fromRGB(70, 74, 82)},
 {id = "exhaust", name = "ท่อไอเสีย", color = Color3.fromRGB(196, 120, 52)},
 {id = "seat", name = "เบาะซิ่ง", color = Color3.fromRGB(176, 42, 52)},
 {id = "light", name = "ไฟหน้า LED", color = Color3.fromRGB(240, 226, 120)},
 {id = "shock", name = "โช้คหลัง", color = Color3.fromRGB(44, 132, 196)},
}

-- Difficulty by zone group; harder zones have more, faster guards with a longer reach.
RaidConfig.Tiers = {
 {name = "ง่าย", zones = {1, 2, 3, 4}, guards = 1, speed = 26, catchRadius = 7, color = Color3.fromRGB(70, 170, 90)},
 {name = "ปานกลาง", zones = {5, 6, 7, 8}, guards = 2, speed = 36, catchRadius = 8, color = Color3.fromRGB(230, 150, 40)},
 {name = "ยาก", zones = {9, 10, 11, 12}, guards = 2, speed = 46, catchRadius = 9, color = Color3.fromRGB(210, 50, 50)},
}

-- Guards spot the thief first ("!"), then chase: a fair head start for children on a standing start.
RaidConfig.GuardAlertSeconds = 1.2

function RaidConfig.tierOf(zoneId: number)
 for _, tier in RaidConfig.Tiers do
  if table.find(tier.zones, zoneId) then return tier end
 end
 return RaidConfig.Tiers[1]
end

function RaidConfig.partType(typeId: string)
 for _, t in RaidConfig.PartTypes do if t.id == typeId then return t end end
 return nil
end

-- True when a world position is inside the Raid Area (east of the gate, inside the world bounds).
function RaidConfig.inRaidArea(p: Vector3): boolean
 return p.X > RaidConfig.GateX and p.X < Layout.MaxX and math.abs(p.Z) < Layout.MaxZ
end

-- True when a position is inside a zone's own area (pad + connector, generous margin) -> catch case A.
function RaidConfig.inZoneArea(zone: any, p: Vector3): boolean
 local c = zone.padCentre
 local half = Layout.ZonePadSize / 2
 local road = Layout.RoutePoint(math.clamp(p.X, -1000, Layout.RouteEndX))
 local off = (p.Z - road.Z) * zone.side
 return math.abs(p.X - c.X) <= half.X + 25 and off >= 18 and off <= zone.padNear + Layout.ZonePadSize.Z + 25
end

return RaidConfig
