import pathlib,json
sid='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c';r=[]
def lua(l,c,d='Client'):r.append(dict(label=l,name='execute_luau',arguments=dict(studio_id=sid,datamodel_type=d,code=c)))
state='local p=game.Players.LocalPlayer local h=p.Character:FindFirstChildOfClass("Humanoid") return {min=p.CameraMinZoomDistance,max=p.CameraMaxZoomDistance,offset=tostring(h.CameraOffset),seated=h.SeatPart~=nil}'
lua('camera-baseline',state)
lua('camera-seat','workspace.ChassisTestBike.DriveSeat:Sit(game.Players:GetPlayers()[1].Character:FindFirstChildOfClass("Humanoid")) return "seated"','Server')
r.append(dict(label='camera-settle',name='user_keyboard_input',arguments=dict(studio_id=sid,datamodel_type='Client',actions=[dict(action='wait',wait_time_ms=700)])))
lua('camera-riding',state)
lua('pose-inspect','local b=workspace.ChassisTestBike local p=game.Players:GetPlayers()[1] local h=p.Character:FindFirstChildOfClass("Humanoid") return {rig=tostring(h.RigType),seat=tostring(b.DriveSeat.Position),root=tostring(p.Character.HumanoidRootPart.Position)}','Server')
r.append(dict(label='pose-side',name='screen_capture',arguments=dict(studio_id=sid,capture_id='pose-side',camera_position=[-23,5,-1],look_at_position=[-13.5,3,-1])))
lua('camera-dismount','game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit=false return "exit"')
r.append(dict(label='camera-exit-settle',name='user_keyboard_input',arguments=dict(studio_id=sid,datamodel_type='Client',actions=[dict(action='wait',wait_time_ms=700)])))
lua('camera-restored',state)
pathlib.Path('docs/mcp-check/camera-test.json').write_text(json.dumps(r))