-- QA-only (Studio Play Server). Read-only A-Chassis assembly/weld/constraint inventory for C1.
local bike=workspace:WaitForChild("ChassisTestBike")
local seat=bike:WaitForChild("DriveSeat")
local out={seatDisabled=seat.Disabled,bodyFitVersion=bike:GetAttribute("BodyFitVersion"),wheels={},groups={},roots={},joints={},constraints={}}
local function rel(p) return p and p:GetFullName():gsub("^Workspace%.ChassisTestBike%.","") or "nil" end
for _,w in {"F","R"} do
 local wheel=bike.Wheels:FindFirstChild(w)
 local kids={}
 for _,c in wheel:GetChildren() do table.insert(kids,c.Name..":"..c.ClassName) end
 out.wheels[w]={children=kids,anchored=wheel.Anchored,massless=wheel.Massless,mass=wheel:GetMass(),root=rel(wheel.AssemblyRootPart)}
end
-- Body-fit meshes per container: anchored count, joint count, assembly root.
for _,d in bike:GetDescendants() do
 if d:IsA("BasePart") and d:GetAttribute("BodyFitMesh") then
  local key=rel(d.Parent)
  local g=out.groups[key] or {n=0,anchored=0,jointed=0,roots={}}
  g.n+=1;if d.Anchored then g.anchored+=1 end
  if #d:GetJoints()>0 then g.jointed+=1 end
  g.roots[rel(d.AssemblyRootPart)]=true
  out.groups[key]=g
 end
end
for k,g in out.groups do local r={} for n in g.roots do table.insert(r,n) end g.roots=r end
-- Distinct assemblies among vendor (non-body-fit) parts.
local mass=0
for _,d in bike:GetDescendants() do
 if d:IsA("BasePart") and not d:GetAttribute("BodyFitMesh") then
  local r=rel(d.AssemblyRootPart);out.roots[r]=(out.roots[r] or 0)+1
  if d.Anchored then out.anchoredVendor=(out.anchoredVendor or 0)+1 end
 end
 if d:IsA("JointInstance") or d:IsA("WeldConstraint") then
  local k=d.ClassName;out.joints[k]=(out.joints[k] or 0)+1
 elseif d:IsA("Constraint") then
  table.insert(out.constraints,string.format("%s %s A0=%s A1=%s",d.ClassName,d.Name,rel(d.Attachment0 and d.Attachment0.Parent),rel(d.Attachment1 and d.Attachment1.Parent)))
 end
end
out.assemblyMass=seat.AssemblyMass
out.seatPos=tostring(seat.Position)
return game:GetService("HttpService"):JSONEncode(out)
