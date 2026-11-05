import pathlib,json
p=pathlib.Path('src/server/RiderPose.luau');s=p.read_text();s=s.replace('CFrame.new(0,-0.35,-0.4)*weld.C0','CFrame.new(0,-0.25,-0.45)*CFrame.Angles(math.rad(-12),0,0)*CFrame.new(0,-0.35,-0.4)*weld.C0');s=s.replace('Vector3.new(sign*1.0,-1.15,-0.65)','Vector3.new(sign*1.0,-0.95,-0.65)');p.write_text(s,encoding='utf-8')
sid='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c'
code='local parent=game.ServerScriptService:FindFirstChild("Lab",true).Parent '
for name,path in [('RiderPose','src/server/RiderPose.luau'),('Lab','src/server/Lab.server.luau')]:
 s=pathlib.Path(path).read_text(encoding='utf-8')
 code+='do local m=parent:FindFirstChild("'+name+'") or Instance.new("ModuleScript") m.Name="'+name+'" m.Parent=parent game:GetService("ScriptEditorService"):UpdateSourceAsync(m,function() return [====['+s+']====] end) end '
code+='return "Rider source synced"'
r=[dict(label='rider-final-stop',name='start_stop_play',arguments=dict(studio_id=sid,is_start=False)),dict(label='rider-final-sync',name='execute_luau',arguments=dict(studio_id=sid,datamodel_type='Edit',code=code)),dict(label='rider-final-play',name='start_stop_play',arguments=dict(studio_id=sid,is_start=True))]
pathlib.Path('docs/mcp-check/rider-final-sync-request.json').write_text(json.dumps(r))