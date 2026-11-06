-- QA-only (Studio Play Client). Park the camera beside the moving DriveSeat (chase-side view) for a capture.
local cam=workspace.CurrentCamera
local seat=(workspace:WaitForChild("Vehicles"):WaitForChild("StreetCub_"..game.Players:GetPlayers()[1].UserId)).DriveSeat
cam.CameraType=Enum.CameraType.Scriptable
local rs=game:GetService("RunService")
if _G.C1Cam then _G.C1Cam:Disconnect() end
_G.C1Cam=rs.RenderStepped:Connect(function()
 local f=seat.CFrame
 local flat=CFrame.lookAt(f.Position,f.Position+Vector3.new(f.LookVector.X,0,f.LookVector.Z))
 local eye=(flat*CFrame.new(__X__,__Y__,__Z__)).Position
 cam.CFrame=CFrame.lookAt(eye,f.Position+Vector3.new(0,0.6,0))
end)
task.wait(.4)
return "camera set "..tostring(cam.CFrame.Position)
