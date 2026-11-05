-- QA-only (Studio Play Client). Vehicle visibility probe: mount via RidePrompt, drive straight ~5 s with
-- VirtualInput, then report where the visible body meshes are relative to the DriveSeat. Never shipped.
local player=game.Players.LocalPlayer
local bike=workspace:WaitForChild("ChassisTestBike")
local seat=bike:WaitForChild("DriveSeat")
local hum=player.Character:WaitForChild("Humanoid")
local function snapshot(label)
 local body=bike:FindFirstChild("Body");local shell=body and body:FindFirstChild("BodyFitMesh")
 local meshes,anch,vis,maxD,sumD=0,0,0,0,0
 local wheelMeshes={}
 for _,d in bike:GetDescendants() do
  if d:IsA("BasePart") and d:GetAttribute("BodyFitMesh") then
   meshes+=1;if d.Anchored then anch+=1 end;if d.Transparency<1 and d.LocalTransparencyModifier<1 then vis+=1 end
   local dist=(d.Position-seat.Position).Magnitude;sumD+=dist;maxD=math.max(maxD,dist)
   if d.Name=="wheel_front" or d.Name=="wheel_rear" then table.insert(wheelMeshes,string.format("%s anchored=%s d=%.1f",d.Name,tostring(d.Anchored),dist)) end
  end
 end
 local visibleVendor=0
 for _,d in bike:GetDescendants() do if d:IsA("BasePart") and not d:GetAttribute("BodyFitMesh") and d.Transparency<1 then visibleVendor+=1 end end
 return {label=label,seat=tostring(seat.Position),bodyMeshes=meshes,anchoredMeshes=anch,visibleMeshes=vis,meanDistToSeat=meshes>0 and sumD/meshes or 0,maxDistToSeat=maxD,
  shellPivot=shell and tostring(shell:GetPivot().Position) or "none",visibleVendorParts=visibleVendor,wheels=wheelMeshes,streaming=workspace.StreamingEnabled,bikeStreamMode=tostring(bike.ModelStreamingMode)}
end
local out={before=snapshot("parked")}
local prompt=seat:FindFirstChild("RidePrompt");prompt:InputHoldBegin();task.wait(.15);prompt:InputHoldEnd()
local t=os.clock();while hum.SeatPart~=seat and os.clock()-t<5 do task.wait(.1) end
out.mounted=hum.SeatPart==seat;out.mounted_snapshot=snapshot("mounted")
local ui=player.PlayerGui:WaitForChild("A-Chassis Interface",10)
local function send(k,v,s) ui.Drive.VirtualInput:Fire({KeyCode=Enum.KeyCode[ui.Controls[k].Value],UserInputType=Enum.UserInputType.Gamepad1,UserInputState=s or Enum.UserInputState.Change,Position=v},false) end
send("ContlrShiftUp",Vector3.zero,Enum.UserInputState.Begin);send("ContlrShiftUp",Vector3.zero,Enum.UserInputState.End)
send("ContlrThrottle",Vector3.new(0,0,.6));task.wait(5);send("ContlrThrottle",Vector3.new(0,0,0));send("ContlrBrake",Vector3.new(0,0,1));task.wait(1.5)
out.after=snapshot("after 5s drive")
return game:GetService("HttpService"):JSONEncode(out)
