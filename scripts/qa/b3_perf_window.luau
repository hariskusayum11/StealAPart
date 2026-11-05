-- QA-only (Studio Play Client). One timed 6-second frame sample, labelled with UTC start/end so it can be
-- correlated with Studio's RenderSchedulerState log lines. Label passed via __LABEL__. Never shipped.
local RunService=game:GetService("RunService")
local p=game.Players.LocalPlayer
local label="__LABEL__"
local t0=DateTime.now():ToIsoDate()
local dts={};local total=0
while total<6 do local dt=RunService.RenderStepped:Wait();table.insert(dts,dt);total+=dt end
table.sort(dts)
local r={label=label,startUtc=t0,endUtc=DateTime.now():ToIsoDate(),fps=#dts/total,p50ms=dts[math.ceil(#dts*.5)]*1000,viewport=tostring(workspace.CurrentCamera.ViewportSize)}
return game:GetService("HttpService"):JSONEncode(r)
