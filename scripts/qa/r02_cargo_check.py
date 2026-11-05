from pathlib import Path
import json,shutil
shutil.copy2('docs/mcp-check/r02-drive-status.json','docs/mcp-check/r02-final-turn-failed.json')
p=Path('src/server/CargoCourse.luau');s=p.read_text(encoding='utf-8').replace('Layout.RoutePoint(3050)+Vector3.new(65,0,35),130,190','Layout.RoutePoint(3050)+Vector3.new(130,0,65),260,260');p.write_text(s,encoding='utf-8')
sid='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c';r=[]
for label,key in [('pickup','Pickup'),('deposit','Deposit')]:
 code='local l=require(game.ReplicatedStorage.RaceAndRaid.HubLayout) local b=workspace.ChassisTestBike local s=b.DriveSeat local p=l.'+key+' b:PivotTo(CFrame.new(p+Vector3.new(0,2.85,0))*s.CFrame:Inverse()*b:GetPivot()) for _,v in b:GetDescendants() do if v:IsA("BasePart") then v.AssemblyLinearVelocity=Vector3.zero v.AssemblyAngularVelocity=Vector3.zero end end return "Separate Cargo-input test reposition; NOT part of route test"'
 r.append(dict(label='r02-cargo-'+label+'-setup',name='execute_luau',arguments=dict(studio_id=sid,datamodel_type='Server',code=code)))
 r.append(dict(label='r02-cargo-'+label+'-key',name='user_keyboard_input',arguments=dict(studio_id=sid,datamodel_type='Client',actions=[dict(action='wait',wait_time_ms=600),dict(action='keyDown',key_code='F'),dict(action='wait',wait_time_ms=650),dict(action='keyUp',key_code='F'),dict(action='wait',wait_time_ms=300)])))
 r.append(dict(label='r02-cargo-'+label+'-result',name='execute_luau',arguments=dict(studio_id=sid,datamodel_type='Client',code='local p=game.Players.LocalPlayer return {cargo=p:GetAttribute("TestCargo"),secured=p:GetAttribute("TestSecured"),message=p:GetAttribute("CargoMessage")}')))
r.append(dict(label='r02-dismount',name='execute_luau',arguments=dict(studio_id=sid,datamodel_type='Client',code='game.Players.LocalPlayer.Character.Humanoid.Sit=false return "Dismount for player-eye capture"')))
Path('docs/mcp-check/r02-cargo-request.json').write_text(json.dumps(r))