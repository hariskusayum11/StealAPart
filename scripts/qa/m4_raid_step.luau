-- QA-only (Studio Play Server). One step of the M4–M6 raid suite (__STEP__), returns a JSON state snapshot.
-- Steps place the real player's own bike (stationary placement before a drive) and drive the round
-- timer through ServerStorage.QAHook; key presses come from StudioMCP user_keyboard_input.
local P=game.Players:GetPlayers()[1]
local hook=game.ServerStorage:WaitForChild("QAHook")
local L=require(game.ReplicatedStorage.RaceAndRaid.HubLayout)
local C=require(game.ReplicatedStorage.RaceAndRaid.RaidConfig)
local H=game:GetService("HttpService")
local STEP="__STEP__"
local function r1(x) return math.floor(x*10+.5)/10 end
local bike=workspace.Vehicles:WaitForChild("StreetCub_"..P.UserId)
local seat=bike.DriveSeat
local hum=P.Character.Humanoid
local function ensureSeated() if hum.SeatPart~=seat then hook:Invoke("sit",P.UserId);task.wait(.8) end end
local function placeAt(p,look) hook:Invoke("placeBike",P.UserId,p,look);task.wait(1) end
local z1=L.Zones[1]
local note=""
local function nearestPart(zoneId,state)
 local best,bd=nil,math.huge
 for _,p in workspace.RaidParts:GetChildren() do
  if p:GetAttribute("ZoneId")==zoneId and p:GetAttribute("State")==state then local d=(p.Position-seat.Position).Magnitude;if d<bd then best,bd=p,d end end
 end
 return best
end
if STEP=="open" then
 hook:Invoke("raidDurations",8,90) -- closed 8 s, open 90 s during QA
 if workspace:GetAttribute("RaidPhase")~="Open" then hook:Invoke("raidAdvance") end
 task.wait(.5)
elseif STEP=="toPart" then -- park beside a Zone 01 part, seated, facing the road (west of the pad centre)
 ensureSeated()
 local part=nearestPart(1,"available") or workspace.RaidParts:FindFirstChildWhichIsA("BasePart")
 placeAt(Vector3.new(part.Position.X-6,z1.position.Y+2.85,part.Position.Z),Vector3.new(0,0,1))
 note=part:GetAttribute("PartId")
elseif STEP=="toGateEast" then -- just inside the Raid Area, facing Garage City (west)
 ensureSeated();placeAt(Vector3.new(C.GateX+14,2.85,-8),Vector3.new(-1,0,0))
elseif STEP=="toGateEastFacingEast" then
 ensureSeated();placeAt(Vector3.new(C.GateX+4,2.85,-8),Vector3.new(1,0,0))
elseif STEP=="toHighway" then -- out of Zone 01 on the highway (catch outside the zone = case B)
 ensureSeated();placeAt(L.RoutePoint(-120)+Vector3.new(0,2.85,-8),Vector3.new(1,0,0))
elseif STEP=="toCityFacingGate" then -- Garage City side facing the closed gate
 ensureSeated();placeAt(Vector3.new(C.GateX-22,2.85,-8),Vector3.new(1,0,0))
elseif STEP=="advance" then
 hook:Invoke("raidAdvance");task.wait(1)
elseif STEP=="wait" then
 task.wait(tonumber("__SECS__") or 3)
end
-- snapshot
local parts=hook:Invoke("parts");local counts={};local z1states={}
for _,rec in parts do counts[rec.state]=(counts[rec.state] or 0)+1;if rec.zone==1 then table.insert(z1states,rec.state) end end
local gs=hook:Invoke("guards");local active={}
for _,g in gs do if g.state~="idle" or g.name:match("Z01") then table.insert(active,{g.name,g.state,r1(g.x),r1(g.z),g.carrying}) end end
local barrier=workspace.RaidGate.GateBarrier
return H:JSONEncode({step=STEP,note=note,phase=workspace:GetAttribute("RaidPhase"),round=workspace:GetAttribute("RaidRound"),
 left=r1((workspace:GetAttribute("RaidPhaseEndsAt") or 0)-workspace:GetServerTimeNow()),barrierSolid=barrier.CanCollide,
 seated=hum.SeatPart==seat,seat={r1(seat.Position.X),r1(seat.Position.Z)},speed=r1(seat.AssemblyLinearVelocity.Magnitude),
 cargo=P:GetAttribute("Cargo"),cargoType=P:GetAttribute("CargoType"),cargoZone=P:GetAttribute("CargoZone"),
 inventory=P:GetAttribute("InventoryTotal"),inventoryJson=P:GetAttribute("InventoryJson"),chasedBy=P:GetAttribute("ChasedBy"),
 msg=P:GetAttribute("CargoMessage"),pickup=P:GetAttribute("LastPickupResult"),partStates=counts,zone01=z1states,guards=active,partsTotal=#workspace.RaidParts:GetChildren()})
