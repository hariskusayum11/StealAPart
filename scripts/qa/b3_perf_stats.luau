-- QA-only (Studio Play Client). Frame pacing + Stats render/physics timings + settings. Never shipped.
-- Works in any place (used for the Empty Place A/B as well as Garage City v11).
local RunService=game:GetService("RunService")
local Stats=game:GetService("Stats")
local UIS=game:GetService("UserInputService")
local p=game.Players.LocalPlayer
local camera=workspace.CurrentCamera
local result:{[string]:any}={place=game.Name,viewport=tostring(camera.ViewportSize)}
local function try(name:string,f:()->any) local ok,v=pcall(f);result[name]=if ok then tostring(v) else "n/a" end
try("savedQuality",function() return UserSettings():GetService("UserGameSettings").SavedQualityLevel end)
try("framerateCap",function() return (UserSettings():GetService("UserGameSettings") :: any).FramerateCap end)
try("renderingQuality",function() return settings().Rendering.QualityLevel end)
try("frameRateManager",function() return settings().Rendering.FrameRateManager end)
try("graphicsMode",function() return settings().Rendering.GraphicsMode end)
try("streaming",function() return workspace.StreamingEnabled end)
local focus={}
UIS.WindowFocusReleased:Connect(function() table.insert(focus,"released") end)
UIS.WindowFocused:Connect(function() table.insert(focus,"focused") end)
local function stat(name:string):number? local ok,v=pcall(function() return (Stats :: any)[name] end);return if ok and type(v)=="number" then v else nil end
local function sample(label:string,cf:CFrame?)
 if cf then camera.CameraType=Enum.CameraType.Scriptable;camera.CFrame=cf end
 task.wait(1)
 local dts={};local total=0;local acc:{[string]:number}={};local n=0
 local names={"FrameTime","RenderCPUFrameTime","RenderGPUFrameTime","PhysicsStepTime","HeartbeatTime"}
 while total<8 do
  local dt=RunService.RenderStepped:Wait();table.insert(dts,dt);total+=dt;n+=1
  for _,k in names do local v=stat(k);if v then acc[k]=(acc[k] or 0)+v end end
 end
 table.sort(dts)
 local s={fps=#dts/total,p50ms=dts[math.ceil(#dts*.5)]*1000,p95ms=dts[math.ceil(#dts*.95)]*1000,memMB=Stats:GetTotalMemoryUsageMb()}
 for k,v in acc do s["avg_"..k]=v/n end
 result[label]=s
end
p:SetAttribute("B3PerfResult",nil)
task.spawn(function()
 local ok,err=pcall(function()
  sample("default",nil)
  sample("sky",CFrame.lookAt(camera.CFrame.Position+Vector3.new(0,50,0),camera.CFrame.Position+Vector3.new(0,800,1)))
 end)
 camera.CameraType=Enum.CameraType.Custom
 result.error=if ok then nil else tostring(err);result.focusEvents=focus
 local parts=0;for _,o in workspace:GetDescendants() do if o:IsA("BasePart") then parts+=1 end end;result.clientBaseParts=parts
 p:SetAttribute("B3PerfResult",game:GetService("HttpService"):JSONEncode(result))
end)
return "B3 perf sampling started (2 x 8s)"
