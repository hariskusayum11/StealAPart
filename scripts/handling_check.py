import json,pathlib
sid='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c'
r=[]
def lua(label,code):r.append(dict(label=label,name='execute_luau',arguments=dict(studio_id=sid,datamodel_type='Server',code=code)))
def keys(label,a):r.append(dict(label=label,name='user_keyboard_input',arguments=dict(studio_id=sid,datamodel_type='Client',actions=a)))
def key(action,k):return dict(action=action,key_code=k)
def wait(ms):return dict(action='wait',wait_time_ms=ms)
lua('handling-seat','local b=workspace.ChassisTestBike local p=game.Players:GetPlayers()[1] b.DriveSeat:Sit(p.Character:FindFirstChildOfClass("Humanoid")) return {body=b:GetAttribute("BodyMeshCount")}')
keys('handling-throttle',[wait(1000),key('keyPress','E'),key('keyDown','W'),wait(2500),key('keyUp','W')])
state='local s=workspace.ChassisTestBike.DriveSeat return {speed=s.AssemblyLinearVelocity.Magnitude,heading=tostring(s.CFrame.LookVector),up=s.CFrame.UpVector.Y,seated=s.Occupant~=nil}'
lua('handling-before-turn',state)
keys('handling-turn',[key('keyDown','A'),wait(900),key('keyUp','A')])
lua('handling-after-turn',state)
keys('handling-brake',[key('keyDown','S'),wait(2500),key('keyUp','S')])
lua('handling-after-brake',state)
r.append(dict(label='handling-seated-shot',name='screen_capture',arguments=dict(studio_id=sid,capture_id='handling-seated-shot')))
pathlib.Path('docs/mcp-check/handling-run.json').write_text(json.dumps(r))