--!strict
-- Roblox Parts clamp at 2048 studs. Build small overlapping boundary spans explicitly.
local Layout=require(game.ReplicatedStorage.RaceAndRaid.HubLayout)
local Boundary={}
function Boundary.apply(model:Model)
 if model:GetAttribute("BoundaryVersion")==1 then return end
 for _,v in model:GetChildren() do if v.Name=="WorldBoundary" or v.Name=="WorldBoundaryCollision" then v:Destroy() end end
 local folder=Instance.new("Folder");folder.Name="WorldBoundaryCollision";folder.Parent=model
 local function wall(axis:string,low:number,high:number,fixed:number)
  local count=math.ceil((high-low)/1024);local length=(high-low)/count
  for i=1,count do
   local centre=low+(i-.5)*length
   local p=Instance.new("Part");p.Name="WorldBoundary";p.Anchored=true;p.Transparency=1;p.CastShadow=false
   p.Size=if axis=="X" then Vector3.new(length+1,160,4) else Vector3.new(4,160,length+1)
   p.Position=if axis=="X" then Vector3.new(centre,48,fixed) else Vector3.new(fixed,48,centre)
   p:SetAttribute("BoundaryAxis",axis);p:SetAttribute("IntendedStart",low+(i-1)*length);p:SetAttribute("IntendedEnd",low+i*length)
   p.Parent=folder
  end
 end
 for _,side in {-1,1} do wall("X",Layout.MinX,Layout.MaxX,side*(Layout.MaxZ-12)) end
 for _,x in {Layout.MinX+12,Layout.MaxX-12} do wall("Z",-Layout.MaxZ,Layout.MaxZ,x) end
 model:SetAttribute("BoundaryVersion",1)
end
return Boundary