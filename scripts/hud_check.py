import pathlib,json
s=pathlib.Path('src/client/LabHUD.client.luau').read_text(encoding='utf-8');sid='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c'
code='local m=game.StarterPlayer.StarterPlayerScripts:FindFirstChild("LabHUD",true) assert(m) game:GetService("ScriptEditorService"):UpdateSourceAsync(m,function() return [====['+s+']====] end) return "HUD synced"'
r=[dict(label='hud-stop',name='start_stop_play',arguments=dict(studio_id=sid,is_start=False)),dict(label='hud-sync',name='execute_luau',arguments=dict(studio_id=sid,datamodel_type='Edit',code=code)),dict(label='hud-play',name='start_stop_play',arguments=dict(studio_id=sid,is_start=True))]
pathlib.Path('docs/mcp-check/hud-sync-request.json').write_text(json.dumps(r))