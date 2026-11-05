import pathlib,json
s=pathlib.Path('src/client/RideCamera.client.luau').read_text()
sid='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c'
code='local p=game.StarterPlayer.StarterPlayerScripts local s=p:FindFirstChild("RideCamera") or Instance.new("LocalScript") s.Name="RideCamera" s.Parent=p game:GetService("ScriptEditorService"):UpdateSourceAsync(s,function() return [====['+s+']====] end) return "camera synced"'
r=[dict(label='camera-sync',name='execute_luau',arguments=dict(studio_id=sid,datamodel_type='Edit',code=code)),dict(label='camera-play',name='start_stop_play',arguments=dict(studio_id=sid,is_start=True))]
pathlib.Path('docs/mcp-check/camera-request.json').write_text(json.dumps(r))