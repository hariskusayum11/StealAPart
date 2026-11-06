-- QA-only (Studio Play Client). Trigger another owner's RidePrompt; server must refuse. Then walk back home.
local P=game.Players.LocalPlayer
local H=game:GetService("HttpService")
local foreign=workspace.Vehicles:WaitForChild("StreetCub_-102",10)
local root=P.Character.HumanoidRootPart;local hum=P.Character.Humanoid
task.wait(.5)
root.CFrame=foreign.DriveSeat.CFrame*CFrame.new(-4,1.5,0);task.wait(1)
local pr=foreign.DriveSeat:FindFirstChild("RidePrompt")
local m0=P:GetAttribute("CargoMessageId")
pr:InputHoldBegin();task.wait(.2);pr:InputHoldEnd();task.wait(1)
return H:JSONEncode({promptKey=pr.KeyboardKeyCode.Name,objectText=pr.ObjectText,seated=hum.SeatPart~=nil,msg=P:GetAttribute("CargoMessage"),msgChanged=P:GetAttribute("CargoMessageId")~=m0})
