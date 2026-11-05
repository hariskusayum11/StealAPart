import json,pathlib
sid='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c';r=[]
def add(label,name,**args):r.append(dict(label=label,name=name,arguments=dict(studio_id=sid,**args)))
add('rider-final-metrics','execute_luau',datamodel_type='Client',code='local h=game.Players.LocalPlayer.Character.Humanoid local a={} for _,v in h:GetChildren() do if v:IsA("IKControl") then a[v.Name]={error=(v.EndEffector.Position-v.Target.WorldPosition).Magnitude,up=v.EndEffector.CFrame.UpVector.Y} end end return a')
add('rider-final-side','screen_capture',capture_id='rider-final-side',camera_position=[-23,5,-3],look_at_position=[-12,3.7,-3])
add('rider-final-front','screen_capture',capture_id='rider-final-front',camera_position=[-16,5,-13],look_at_position=[-12,3.7,-3])
add('rider-final-drive','user_keyboard_input',datamodel_type='Client',actions=[dict(action='keyPress',key_code='E'),dict(action='keyDown',key_code='W'),dict(action='wait',wait_time_ms=1500),dict(action='keyUp',key_code='W')])
add('rider-final-speed','execute_luau',datamodel_type='Server',code='local s=workspace.ChassisTestBike.DriveSeat return {speed=s.AssemblyLinearVelocity.Magnitude,seated=s.Occupant~=nil,up=s.CFrame.UpVector.Y}')
add('rider-final-brake','user_keyboard_input',datamodel_type='Client',actions=[dict(action='keyDown',key_code='S'),dict(action='wait',wait_time_ms=2200),dict(action='keyUp',key_code='S')])
add('rider-final-exit','execute_luau',datamodel_type='Client',code='game.Players.LocalPlayer.Character.Humanoid.Sit=false return "exit"')
add('rider-final-settle','user_keyboard_input',datamodel_type='Client',actions=[dict(action='wait',wait_time_ms=700)])
add('rider-final-cleanup','execute_luau',datamodel_type='Client',code='local p=game.Players.LocalPlayer local n=0 for _,v in p.Character.Humanoid:GetChildren() do if v:IsA("IKControl") and v.Name:sub(1,4)=="Ride" then n+=1 end end local targets=0 for _,v in workspace.ChassisTestBike:GetDescendants() do if v:IsA("Attachment") and v.Name:sub(1,4)=="Ride" then targets+=1 end end return {ik=n,targets=targets,seated=p.Character.Humanoid.SeatPart~=nil,cameraMin=p.CameraMinZoomDistance,cameraMax=p.CameraMaxZoomDistance,headVisible=p.Character.Head.Transparency==0}')
pathlib.Path('docs/mcp-check/rider-final-test.json').write_text(json.dumps(r))