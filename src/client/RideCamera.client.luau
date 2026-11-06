--!strict
-- Keep Roblox orbit/occlusion controls; do not replace the vendor mouse-steering camera.
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local cleanup: (() -> ())? = nil
local function bind(character: Model)
 if cleanup then cleanup(); cleanup=nil end
 local humanoid=character:WaitForChild("Humanoid") :: Humanoid
 local restore: (() -> ())? = nil
 local function update()
  local seat=humanoid.SeatPart
  local riding=seat~=nil and seat.Parent~=nil and seat.Parent:GetAttribute("StreetCub")==true
  if riding and not restore then
   local minimum,maximum=player.CameraMinZoomDistance,player.CameraMaxZoomDistance
   local offset=humanoid.CameraOffset
   player.CameraMaxZoomDistance=24
   player.CameraMinZoomDistance=10
   humanoid.CameraOffset=Vector3.new(0,0.65,0)
   restore=function()
    player.CameraMinZoomDistance=minimum
    player.CameraMaxZoomDistance=maximum
    humanoid.CameraOffset=offset
   end
  elseif not riding and restore then
   restore(); restore=nil
  end
 end
 local seated=humanoid.Seated:Connect(update)
 local died=humanoid.Died:Connect(function() if restore then restore();restore=nil end end)
 cleanup=function()
  seated:Disconnect();died:Disconnect()
  if restore then restore();restore=nil end
 end
 update()
end
player.CharacterAdded:Connect(bind)
player.CharacterRemoving:Connect(function() if cleanup then cleanup();cleanup=nil end end)
if player.Character then task.spawn(bind,player.Character) end