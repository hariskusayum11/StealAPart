--!strict
-- M2 session garage ownership. The server hands out the first free plot G1..G6 when a player joins and
-- releases it when they leave. Session only (no DataStore). Ownership is published read-only through
-- attributes: Player.PlotId and plot marker OwnerUserId (CargoTestCourse.Plots.<id>).
local Layout = require(game:GetService("ReplicatedStorage"):WaitForChild("RaceAndRaid"):WaitForChild("HubLayout"))

local GarageService = {}

export type Owner = {UserId: number, Name: string}

local ownerOf: {[string]: number} = {} -- plotId -> userId
local plotOf: {[number]: string} = {} -- userId -> plotId
local changed = Instance.new("BindableEvent")
GarageService.Changed = changed.Event -- (userId, plotId?) fired on assign/release

local function marker(plotId: string): Instance
 local folder = workspace:FindFirstChild("PlotOwnership")
 if not folder then
  folder = Instance.new("Folder")
  folder.Name = "PlotOwnership"
  folder.Parent = workspace
 end
 local m = (folder :: Instance):FindFirstChild(plotId)
 if not m then
  m = Instance.new("Configuration")
  m.Name = plotId;
  (m :: Instance).Parent = folder
 end
 return m :: Instance
end

function GarageService.plotOf(userId: number): string?
 return plotOf[userId]
end

function GarageService.ownerOf(plotId: string): number?
 return ownerOf[plotId]
end

-- Assign the first free plot in HubLayout order. Idempotent for an owner that already has one.
function GarageService.assign(owner: Owner): string?
 local existing = plotOf[owner.UserId]
 if existing then return existing end
 for _, plot in Layout.Plots do
  if ownerOf[plot.id] == nil then
   ownerOf[plot.id] = owner.UserId
   plotOf[owner.UserId] = plot.id
   local m = marker(plot.id)
   m:SetAttribute("OwnerUserId", owner.UserId)
   m:SetAttribute("OwnerName", owner.Name)
   changed:Fire(owner.UserId, plot.id)
   return plot.id
  end
 end
 return nil -- all six plots taken
end

function GarageService.release(userId: number)
 local plotId = plotOf[userId]
 if not plotId then return end
 plotOf[userId] = nil
 if ownerOf[plotId] == userId then ownerOf[plotId] = nil end
 local m = marker(plotId)
 m:SetAttribute("OwnerUserId", nil)
 m:SetAttribute("OwnerName", nil)
 changed:Fire(userId, nil)
end

function GarageService.frame(plotId: string): CFrame
 return Layout.PlotFrame(Layout.FindPlot(plotId))
end

function GarageService.spawnCFrame(plotId: string): CFrame
 return GarageService.frame(plotId) * CFrame.new(Layout.PlotLocal.Spawn)
end

function GarageService.bikeStart(plotId: string): CFrame
 return GarageService.frame(plotId) * CFrame.new(Layout.PlotLocal.BikeStart)
end

-- Test hook for the QA suite: snapshot of the assignment tables.
function GarageService.snapshot(): {[string]: number}
 local out = {}
 for plotId, userId in ownerOf do out[plotId] = userId end
 return out
end

return GarageService
