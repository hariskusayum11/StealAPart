import pathlib,json
p=pathlib.Path('src/server/Lab.server.luau');s=p.read_text(encoding='utf-8');s=s.replace('appearance.apply(bike,template)','appearance.apply(bike,template)\nrequire(script.Parent.RiderPose).bind(bike)');p.write_text(s,encoding='utf-8')
s=pathlib.Path('src/server/RiderPose.luau').read_text(encoding='utf-8')
code='local parent=game.ServerScriptService:FindFirstChild("Lab",true).Parent local m=Instance.new("ModuleScript") m.Name="RiderPoseRuntimeTest" m.Source=[====['+s+']====] m.Parent=parent require(m).bind(workspace.ChassisTestBike) return "IK bound"'
r=[dict(label='rider-ik-bind',name='execute_luau',arguments=dict(studio_id='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c',datamodel_type='Server',code=code))]
pathlib.Path('docs/mcp-check/rider-bind-request.json').write_text(json.dumps(r))