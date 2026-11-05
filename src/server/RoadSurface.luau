--!strict
-- R04.4 road geometry. Flat rectangles are partitioned, never stacked.
local Surface={}
export type Rect={x1:number,x2:number,z1:number,z2:number,y:number,name:string,color:Color3,priority:number}
function Surface.part(parent: Instance,name:string,size:Vector3,cf:CFrame,color:Color3,material:Enum.Material): Part
 local p=Instance.new("Part");p.Name=name;p.Size=size;p.CFrame=cf;p.Color=color;p.Material=material;p.Anchored=true
 p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth;p.Parent=parent;return p
end
function Surface.triangle(parent:Instance,a:Vector3,b:Vector3,c:Vector3,color:Color3,name:string)
 local ab=b-a;local ac=c-a;local bc=c-b
 if ab.Magnitude>ac.Magnitude and ab.Magnitude>bc.Magnitude then c,a=a,c elseif ac.Magnitude>bc.Magnitude then a,b=b,a end
 ab=b-a;ac=c-a;bc=c-b
 if ac:Cross(ab).Magnitude<.00001 then return end
 local right=ac:Cross(ab).Unit;local back=bc.Unit;local up=bc:Cross(right).Unit
 local normal=if right.Y>=0 then right else -right
 local h=math.abs(ab:Dot(up));local thickness=.4
 for _,v in {{a,b,right,back,math.abs(ab:Dot(back))},{a,c,-right,-back,math.abs(ac:Dot(back))}} do
  local length=v[5] :: number
  if length>.0001 and h>.0001 then
   local p=Instance.new("WedgePart");p.Name=name;p.Size=Vector3.new(thickness,h,length)
   p.CFrame=CFrame.fromMatrix(((v[1] :: Vector3)+(v[2] :: Vector3))/2-normal*thickness/2,v[3] :: Vector3,up,v[4] :: Vector3)
   p.Anchored=true;p.Color=color;p.Material=Enum.Material.Asphalt;p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth;p.Parent=parent
  end
 end
end
function Surface.quad(parent:Instance,a:Vector3,b:Vector3,c:Vector3,d:Vector3,color:Color3,name:string)
 Surface.triangle(parent,a,b,c,color,name);Surface.triangle(parent,b,d,c,color,name)
end
function Surface.flat(parent:Instance,rects:{Rect})
 local groups:{[number]:{Rect}}={}
 for _,r in rects do local key=math.round(r.y*10000)/10000;groups[key]=groups[key] or {};table.insert(groups[key],r) end
 for y,group in groups do
  local xset:{[number]:boolean}={};local zset:{[number]:boolean}={}
  for _,r in group do xset[r.x1]=true;xset[r.x2]=true;zset[r.z1]=true;zset[r.z2]=true end
  local xs={};local zs={};for x in xset do table.insert(xs,x) end;for z in zset do table.insert(zs,z) end;table.sort(xs);table.sort(zs)
  local merged:{[string]:Part}={}
  for iz=1,#zs-1 do
   local z1,z2=zs[iz],zs[iz+1];local z=(z1+z2)/2;local start:number?=nil;local chosen:Rect?=nil
   local function emit(lastX:number)
    if start and chosen then
     local key=string.format("%.4f:%.4f:%s",start,lastX,tostring(chosen.color))
     local previous=merged[key]
     if previous and math.abs(previous.Position.Z+previous.Size.Z/2-z1)<.0001 then
      local oldStart=previous.Position.Z-previous.Size.Z/2;previous.Size=Vector3.new(lastX-start,.4,z2-oldStart);previous.Position=Vector3.new((start+lastX)/2,y-.2,(oldStart+z2)/2)
     else merged[key]=Surface.part(parent,chosen.name,Vector3.new(lastX-start,.4,z2-z1),CFrame.new((start+lastX)/2,y-.2,(z1+z2)/2),chosen.color,Enum.Material.Asphalt) end
    end
   end
   for ix=1,#xs-1 do
    local x=(xs[ix]+xs[ix+1])/2;local winner:Rect?=nil
    for _,r in group do if x>r.x1 and x<r.x2 and z>r.z1 and z<r.z2 and (not winner or r.priority>winner.priority) then winner=r end end
    if (winner and not chosen) or (chosen and not winner) or (winner and chosen and winner.color~=chosen.color) then emit(xs[ix]);start=if winner then xs[ix] else nil end
    chosen=winner
   end
   emit(xs[#xs])
  end
  task.wait()
 end
end
return Surface