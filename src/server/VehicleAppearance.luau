--!strict
-- Static Creator Store mesh fitting. This is a local art/rig candidate, not release approval.
local Appearance = {}
local frontFixed: {[string]: boolean} = {
 black=true, ["default.001"]=true, ["default.004"]=true,
 ["default.006"]=true, ["default.008"]=true, ["default.009"]=true,
 ["default.011"]=true, ["default.013"]=true, speedook=true,
 forks_front=true, mudguard=true, ["mudguard.001"]=true,
}
function Appearance.apply(bike: Model, template: Model)
 if bike:GetAttribute("BodyFitVersion") == 1 then return end
 local wheels = bike:WaitForChild("Wheels")
 local front = wheels:WaitForChild("F") :: BasePart
 local rear = wheels:WaitForChild("R") :: BasePart
 for _,wheel in {front,rear} do
  for _,name in {"Parts","Fixed","WheelFixed"} do
   if not wheel:FindFirstChild(name) then
    local group=Instance.new("Model");group.Name=name;group.Parent=wheel
   end
  end
 end
 local seat=bike:FindFirstChild("DriveSeat")
 if seat and seat:IsA("BasePart") then seat.Transparency=1 end
 local body = bike:WaitForChild("Body")
 -- Hide vendor wheel display geometry, retaining its physics and weld hierarchy.
 for _,wheel in {front,rear} do
  for _,item in wheel:GetDescendants() do
   if item:IsA("BasePart") and not item:GetAttribute("BodyFitMesh") then item.Transparency=1 end
  end
 end
 local clone = template:Clone()
 local sourceFront = clone:FindFirstChild("wheel_front",true) :: MeshPart
 local sourceRear = clone:FindFirstChild("wheel_rear",true) :: MeshPart
 assert(sourceFront and sourceRear, "Body requires separated front/rear wheel meshes")
 local wheelbase = (front.Position-rear.Position).Magnitude
 clone:ScaleTo(wheelbase/(sourceFront.Position-sourceRear.Position).Magnitude)
 local from = CFrame.lookAt(sourceRear.Position, Vector3.new(sourceFront.Position.X,sourceRear.Position.Y,sourceFront.Position.Z))
 local target = CFrame.lookAt(rear.Position,Vector3.new(front.Position.X,rear.Position.Y,front.Position.Z))
 local transform = target * from:Inverse()
 for _,v in body:GetDescendants() do if v:IsA("BasePart") then v.Transparency=1 end end
 for _,v in bike:GetDescendants() do
  if v:IsA("Constraint") then v.Visible=false end
  if v:IsA("HandleAdornment") then v.Visible=false end
 end
 local shell = Instance.new("Model")
 shell.Name = "BodyFitMesh"
 shell.Parent = body
 local count=0
 for _,v in clone:GetDescendants() do
  if not v:IsA("MeshPart") then continue end
  if v.Name:lower():find("logo") then continue end
  v.CFrame = transform * v.CFrame
  v.CanCollide=false;v.CanTouch=false;v.CanQuery=false;v.Massless=true;v.Anchored=true
  -- Exclude the branded fairing atlas; keep unbranded mechanical textures.
  if v.TextureID == "rbxassetid://13114470501" then
   v.TextureID=""
   v.Color=Color3.fromRGB(39,197,229)
   v.Material=Enum.Material.Metal
  end
  if v.Name=="wheel_front" or v.Name=="wheel_rear" then
   local wheel = if v.Name=="wheel_front" then front else rear
   local diameter=math.max(v.Size.Y,v.Size.Z)
   v.Size *= wheel.Size.Y/diameter
   v.CFrame = v.CFrame.Rotation + wheel.Position
   v.Parent = wheel:WaitForChild("Parts")
  elseif v.Name=="disc" then
   v.Parent=front:WaitForChild("Parts")
  elseif frontFixed[v.Name] then
   v.Parent=front:WaitForChild("Fixed")
  elseif v.Name=="forks_rear" then
   v.Parent=rear:WaitForChild("WheelFixed")
  else v.Parent=shell end
  v:SetAttribute("BodyFitMesh",true)
  count+=1
 end
 clone:Destroy()
 -- Initialization can re-enable debug suspension visuals after the body is fitted.
 if seat and seat:IsA("VehicleSeat") then
  local function hideDebug()
   for _,item in bike:GetDescendants() do
    if item:IsA("Constraint") then item.Visible=false end
   end
  end
  seat:GetPropertyChangedSignal("Disabled"):Connect(function()
   if not seat.Disabled then hideDebug() end
  end)
  hideDebug()
 end
 bike:SetAttribute("BodyFitVersion",1)
 bike:SetAttribute("BodyMeshCount",count)
 bike:SetAttribute("BodySourceAssetId",13113759800)
end
return Appearance