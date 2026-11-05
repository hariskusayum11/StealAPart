local p=game.Players.LocalPlayer
local camera=workspace.CurrentCamera
local startCF=CFrame.lookAt(Vector3.new(-820,28,40),Vector3.new(-760,10,113))
camera.CameraType=Enum.CameraType.Scriptable;camera.CFrame=startCF
local settingsGame=UserSettings():GetService("UserGameSettings")
local originalQuality=settingsGame.SavedQualityLevel
local result={context={mode="Studio Play Client",camera={-820,28,40},look={-760,10,113},viewport=tostring(camera.ViewportSize),streaming=workspace.StreamingEnabled,quality=tostring(originalQuality),foreground="unknown"}}
local function sample(name)
 task.wait(1)
 local dtList={};local total=0
 while total<8 do local dt=game:GetService("RunService").RenderStepped:Wait();table.insert(dtList,dt);total+=dt end
 table.sort(dtList);result[name]={fps=#dtList/total,seconds=total,frameMs50=dtList[math.ceil(#dtList*.5)]*1000,frameMs95=dtList[math.ceil(#dtList*.95)]*1000,memoryMB=game:GetService("Stats"):GetTotalMemoryUsageMb()}
end
task.spawn(function()
 local ok,err=pcall(function()
 sample("g1Auto1");sample("g1Auto2")
 local changed,why=pcall(function()settingsGame.SavedQualityLevel=Enum.SavedQualitySetting.QualityLevel1 end);result.qualityChange={allowed=changed,error=if changed then nil else tostring(why)};if changed then sample("g1Quality1") end
 camera.CFrame=CFrame.lookAt(Vector3.new(-820,120,40),Vector3.new(-820,800,50));sample("skyOriginalQuality")
 camera.CFrame=startCF
 local hidden={}
 for _,gui in p.PlayerGui:GetChildren() do if gui:IsA("ScreenGui") then hidden[gui]=gui.Enabled;gui.Enabled=false end end
 sample("noPlayerGuiOriginalQuality")
 for gui,enabled in hidden do if gui.Parent then gui.Enabled=enabled end end
 end)
 pcall(function()settingsGame.SavedQualityLevel=originalQuality end);camera.CFrame=startCF
 result.error=if ok then nil else tostring(err)
 local parts=0;for _,o in workspace:GetDescendants() do if o:IsA("BasePart") then parts+=1 end end
 result.parts=parts
 p:SetAttribute("G1PerfResult",game:GetService("HttpService"):JSONEncode(result))
 local sas=game:GetService("SceneAnalysisService")
 for _,q in {"GetTriangleCompositionAsync","GetScriptMemoryAsync"} do
 local success,data=pcall(function()return sas[q](sas) end);result[q]=if success then data else {error=tostring(data)} end
 p:SetAttribute("G1PerfResult",game:GetService("HttpService"):JSONEncode(result))
end)
return "Five fixed 8-second samples started; camera/quality controls restored afterward"