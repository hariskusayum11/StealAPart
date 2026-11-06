-- QA-only (Studio Play Client). Release throttle, brake, restore camera, report body-to-seat distances.
local player=game.Players.LocalPlayer
local ui=player.PlayerGui:FindFirstChild("A-Chassis Interface")
local seat=workspace.ChassisTestBike.DriveSeat
local function key(name,state) ui.Drive.VirtualInput:Fire({KeyCode=Enum.KeyCode[ui.Controls[name].Value],UserInputType=Enum.UserInputType.Keyboard,UserInputState=state,Position=Vector3.zero},false) end
if ui then key("Throttle2",Enum.UserInputState.End);key("Brake2",Enum.UserInputState.Begin);task.wait(2);key("Brake2",Enum.UserInputState.End) end
if _G.C1Cam then _G.C1Cam:Disconnect();_G.C1Cam=nil end
workspace.CurrentCamera.CameraType=Enum.CameraType.Custom
local maxD,n,anch=0,0,0
for _,d in workspace.ChassisTestBike:GetDescendants() do if d:IsA("BasePart") and d:GetAttribute("BodyFitMesh") then n+=1;if d.Anchored then anch+=1 end;maxD=math.max(maxD,(d.Position-seat.Position).Magnitude) end end
return string.format("meshes=%d anchored=%d maxDistToSeat=%.1f speed=%.1f seat=%s",n,anch,maxD,seat.AssemblyLinearVelocity.Magnitude,tostring(seat.Position))
