-- QA-only (Studio Play Client). Same standard camera as g1_performance.luau; records window-focus
-- events and rendering settings so foreground state is evidence, not assumption. Never shipped.
local p=game.Players.LocalPlayer
local RunService=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local camera=workspace.CurrentCamera
local startCF=CFrame.lookAt(Vector3.new(-820,28,40),Vector3.new(-760,10,113))
camera.CameraType=Enum.CameraType.Scriptable;camera.CFrame=startCF
local focusEvents={}
local t0=os.clock()
UIS.WindowFocused:Connect(function() table.insert(focusEvents,{t=os.clock()-t0,event="focused"}) end)
UIS.WindowFocusReleased:Connect(function() table.insert(focusEvents,{t=os.clock()-t0,event="released"}) end)
local gs=UserSettings():GetService("UserGameSettings")
local result={context={mode="Studio Play Client",camera={-820,28,40},look={-760,10,113},viewport=tostring(camera.ViewportSize),
 streaming=workspace.StreamingEnabled,savedQuality=tostring(gs.SavedQualityLevel)}}
pcall(function() result.context.renderingQuality=tostring(settings().Rendering.QualityLevel) end)
pcall(function() result.context.frameRateManager=tostring(settings().Rendering.FrameRateManager) end)
pcall(function() result.context.graphicsMode=tostring(settings().Rendering.GraphicsMode) end)
local function sample(name)
 task.wait(1)
 local dts={};local total=0
 while total<8 do local dt=RunService.RenderStepped:Wait();table.insert(dts,dt);total+=dt end
 table.sort(dts)
 result[name]={startT=os.clock()-t0-total,fps=#dts/total,seconds=total,frameMs50=dts[math.ceil(#dts*.5)]*1000,
  frameMs95=dts[math.ceil(#dts*.95)]*1000,frameMsMax=dts[#dts]*1000,memoryMB=game:GetService("Stats"):GetTotalMemoryUsageMb()}
end
p:SetAttribute("B0PerfResult",nil)
task.spawn(function()
 local ok,err=pcall(function()
  sample("auto1");sample("auto2")
  camera.CFrame=CFrame.lookAt(Vector3.new(-820,120,40),Vector3.new(-820,800,50));sample("sky")
  camera.CFrame=startCF
  local hidden={}
  for _,gui in p.PlayerGui:GetChildren() do if gui:IsA("ScreenGui") then hidden[gui]=gui.Enabled;gui.Enabled=false end end
  sample("noPlayerGui")
  for gui,enabled in hidden do if gui.Parent then gui.Enabled=enabled end end
 end)
 camera.CFrame=startCF
 result.error=if ok then nil else tostring(err)
 local parts=0;for _,o in workspace:GetDescendants() do if o:IsA("BasePart") then parts+=1 end end
 result.clientBaseParts=parts;result.focusEvents=focusEvents
 p:SetAttribute("B0PerfResult",game:GetService("HttpService"):JSONEncode(result))
end)
return "B0 performance: four 8-second samples started"
