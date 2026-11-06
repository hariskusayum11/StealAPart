-- QA-only (Studio Play Server, bike parked, no rider). Read-only: is the body-fit aligned with the
-- chassis it is welded to? In the source model every mesh shares one rotation and the wheel axles are
-- perpendicular to the wheelbase, so a correct fit gives ~0 deg for every angle below.
local bike=workspace:WaitForChild("Vehicles"):WaitForChild("StreetCub_"..game.Players:GetPlayers()[1].UserId)
local seat=bike:WaitForChild("DriveSeat")
local F,R=bike.Wheels.F,bike.Wheels.R
local function deg(a,b) return math.deg(math.acos(math.clamp(math.abs(a.Unit:Dot(b.Unit)),0,1))) end
local function find(p,n) return p:FindFirstChild(n,true) end
local shell=find(bike.Body,"chassis");local black=find(F.Fixed,"black");local forks=find(F.Fixed,"forks_front")
local wf=find(F.Parts,"wheel_front");local wr=find(R.Parts,"wheel_rear");local fr=find(R.WheelFixed,"forks_rear")
local cf=seat.CFrame
-- Mesh local X is the source "across the bike" axis (wheel axle direction) for every mesh.
local out={
 seatRollDeg=math.deg(math.asin(math.clamp(cf.RightVector.Y,-1,1))),seatPitchDeg=math.deg(math.asin(math.clamp(cf.LookVector.Y,-1,1))),
 shellAcrossVsSeatRight=deg(shell.CFrame.RightVector,cf.RightVector),
 shellUpVsSeatUp=deg(shell.CFrame.UpVector,cf.UpVector),
 shellUpVsWorldUp=deg(shell.CFrame.UpVector,Vector3.yAxis),
 handlebarAcrossVsArmRight=deg(black.CFrame.RightVector,F.Arm.CFrame.RightVector),
 forksAcrossVsFrontAxle=deg(forks.CFrame.RightVector,F.CFrame.RightVector),
 frontMeshAxleVsWheelAxle=deg(wf.CFrame.RightVector,F.CFrame.RightVector),
 rearMeshAxleVsWheelAxle=deg(wr.CFrame.RightVector,R.CFrame.RightVector),
 swingarmAcrossVsRearAxle=deg(fr.CFrame.RightVector,R.CFrame.RightVector),
 frontAxleVsSeatRight=deg(F.CFrame.RightVector,cf.RightVector),rearAxleVsSeatRight=deg(R.CFrame.RightVector,cf.RightVector),
 bodyFitVersion=bike:GetAttribute("BodyFitVersion"),fitSeatRoll=bike:GetAttribute("BodyFitSeatRoll"),fitSeatSpeed=bike:GetAttribute("BodyFitSeatSpeed"),
}
for k,v in out do if type(v)=="number" then out[k]=math.floor(v*100+.5)/100 end end
return game:GetService("HttpService"):JSONEncode(out)
