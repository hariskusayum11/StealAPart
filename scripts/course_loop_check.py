import pathlib,json
sid='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c';r=[]
for label,z in [('pickup',-140),('deposit',0)]:
 x=-13 if label=='pickup' else -23
 code=f'local b=workspace.ChassisTestBike local s=b.DriveSeat b:PivotTo(CFrame.new({x},2.85,{z})*s.CFrame:Inverse()*b:GetPivot()) for _,v in b:GetDescendants() do if v:IsA("BasePart") then v.AssemblyLinearVelocity=Vector3.zero v.AssemblyAngularVelocity=Vector3.zero end end s:Sit(game.Players:GetPlayers()[1].Character.Humanoid) return "Test reposition only"'
 r.append(dict(label='course-'+label+'-setup',name='execute_luau',arguments=dict(studio_id=sid,datamodel_type='Server',code=code)))
 r.append(dict(label='course-'+label+'-input',name='user_keyboard_input',arguments=dict(studio_id=sid,datamodel_type='Client',actions=[dict(action='wait',wait_time_ms=600),dict(action='keyPress',key_code='F'),dict(action='wait',wait_time_ms=400)])))
 r.append(dict(label='course-'+label+'-result',name='execute_luau',arguments=dict(studio_id=sid,datamodel_type='Client',code='local p=game.Players.LocalPlayer return {cargo=p:GetAttribute("TestCargo"),secured=p:GetAttribute("TestSecured"),hud=p.PlayerGui.RaceAndRaidLabHUD.Cargo.Status.Text}')))
pathlib.Path('docs/mcp-check/course-loop-check.json').write_text(json.dumps(r))