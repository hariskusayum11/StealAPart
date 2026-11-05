--!strict
-- Pose the real R15 avatar; legacy cloned-rider scripts are disabled in the vendor model.
local RiderPose = {}
function RiderPose.bind(bike: Model)
 if bike:GetAttribute("RiderPoseBound") then return end
 bike:SetAttribute("RiderPoseBound",true)
 local seat=bike:WaitForChild("DriveSeat") :: VehicleSeat
 local fixed=bike:WaitForChild("Wheels"):WaitForChild("F"):WaitForChild("Fixed")
 local grip=fixed:WaitForChild("black") :: BasePart
 local controls: {Instance}={}
 local death: RBXScriptConnection?=nil
 local originalWeld: Weld?=nil
 local originalC0=CFrame.identity
 local function clear()
  for _,v in controls do v:Destroy() end
  table.clear(controls)
  if death then death:Disconnect();death=nil end
  if originalWeld and originalWeld.Parent then originalWeld.C0=originalC0 end
  originalWeld=nil
 end
 local function target(name: string, parent: BasePart, position: Vector3): Attachment
  local a=Instance.new("Attachment")
  a.Name=name
  a.Position=parent.CFrame:PointToObjectSpace(seat.CFrame:PointToWorldSpace(position))
  a.Parent=parent
  table.insert(controls,a)
  return a
 end
 local function update()
  clear()
  local h=seat.Occupant
  if not h or h.RigType~=Enum.HumanoidRigType.R15 then return end
  local character=h.Parent
  if not character then return end
  local weld=seat:FindFirstChild("SeatWeld")
  if weld and weld:IsA("Weld") then
   originalWeld=weld;originalC0=weld.C0
   weld.C0=CFrame.new(0,-0.25,-0.45)*CFrame.Angles(math.rad(-12),0,0)*CFrame.new(0,-0.35,-0.4)*weld.C0
  end
  local gripCenter=seat.CFrame:PointToObjectSpace(grip.Position)
  for _,side in {"Left","Right"} do
   local sign=if side=="Left" then -1 else 1
   for _,limb in {"Arm","Leg"} do
    local isArm=limb=="Arm"
    local root=character:FindFirstChild(side.."Upper"..limb)
    local tip=character:FindFirstChild(side..(if isArm then "Hand" else "Foot"))
    if not root or not tip then continue end
    local position=if isArm then gripCenter+Vector3.new(sign*1.08,0.06,0.02) else Vector3.new(sign*1.0,-0.95,-1.35)
    local goal=target("Ride"..side..limb,if isArm then grip else seat,position)
    local pole=target("RidePole"..side..limb,seat,if isArm then Vector3.new(sign*2,1.3,-0.8) else Vector3.new(sign*1.25,0,-2.1))
    local ik=Instance.new("IKControl")
    ik.Name="Ride"..side..limb
    ik.Type=if isArm then Enum.IKControlType.Position else Enum.IKControlType.Transform
    ik.ChainRoot=root;ik.EndEffector=tip;ik.Target=goal;ik.Pole=pole
    ik.Priority=10;ik.SmoothTime=0.1;ik.Weight=1
    ik.Parent=h
    table.insert(controls,ik)
   end
  end
  death=h.Died:Connect(clear)
 end
 seat:GetPropertyChangedSignal("Occupant"):Connect(function() task.defer(update) end)
 bike.Destroying:Connect(clear)
 update()
end
return RiderPose