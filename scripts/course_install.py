import pathlib,json
p=pathlib.Path('src/server/Lab.server.luau');s=p.read_text(encoding='utf-8');s=s.replace('local bike = workspace:', 'local Course=require(script.Parent.CargoCourse)\nCourse.build()\nlocal bike = workspace:',1)
s=s.replace('part.Size = Vector3.new(4, 1, 4)','part.Size = Vector3.new(5, 0.05, 5)\n part.CanCollide = false').replace('part.Position = position','part.Position = position + Vector3.new(0,-0.46,0)')
s=s.replace('Vector3.new(-13, 0, -140)','Course.Pickup').replace('Vector3.new(-23, 0, 0)','Course.Deposit').replace('Vector3.new(-13,0,-140)','Course.Pickup').replace('Vector3.new(-23,0,0)','Course.Deposit')
p.write_text(s,encoding='utf-8')
p=pathlib.Path('src/client/LabHUD.client.luau');s=p.read_text(encoding='utf-8');s=s.replace('cargo.Text=string.format("CARGO %d / 1   •   ฝากแล้ว %d",player:GetAttribute("TestCargo") or 0,player:GetAttribute("TestSecured") or 0)','''local carrying=(player:GetAttribute("TestCargo") or 0)>0
 local point=workspace:FindFirstChild(if carrying then "TestGarageDeposit" else "TestScrapPickup")
 local root=character and character:FindFirstChild("HumanoidRootPart")
 local distance=if point and point:IsA("BasePart") and root and root:IsA("BasePart") then (point.Position-root.Position).Magnitude else 0
 cargo.Text=string.format("%s • %.0f studs | ฝากแล้ว %d",if carrying then "กลับฝาก CARGO" else "ไปลานอะไหล่",distance,player:GetAttribute("TestSecured") or 0)''').replace('local h=player.Character and player.Character:FindFirstChildOfClass("Humanoid")','local character=player.Character\n local h=character and character:FindFirstChildOfClass("Humanoid")')
p.write_text(s,encoding='utf-8')
sid='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c';code='local parent=game.ServerScriptService:FindFirstChild("Lab",true).Parent '
for name,path in [('CargoCourse','src/server/CargoCourse.luau'),('Lab','src/server/Lab.server.luau')]:
 source=pathlib.Path(path).read_text(encoding='utf-8');code+='do local m=parent:FindFirstChild("'+name+'") or Instance.new("ModuleScript") m.Name="'+name+'" m.Parent=parent game:GetService("ScriptEditorService"):UpdateSourceAsync(m,function() return [====['+source+']====] end) end '
source=p.read_text(encoding='utf-8');code+='game:GetService("ScriptEditorService"):UpdateSourceAsync(game.StarterPlayer.StarterPlayerScripts:FindFirstChild("LabHUD",true),function() return [====['+source+']====] end) return "course synced"'
r=[dict(label='course-stop',name='start_stop_play',arguments=dict(studio_id=sid,is_start=False)),dict(label='course-sync',name='execute_luau',arguments=dict(studio_id=sid,datamodel_type='Edit',code=code)),dict(label='course-play',name='start_stop_play',arguments=dict(studio_id=sid,is_start=True))]
pathlib.Path('docs/mcp-check/course-sync.json').write_text(json.dumps(r))