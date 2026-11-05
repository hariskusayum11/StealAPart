import pathlib,json
sid='bc26bc01-2367-43e5-becd-edd0fac7ba3e'
s=pathlib.Path('src/server/Lab.server.luau').read_text(encoding='utf-8')
code='assert(workspace:FindFirstChild("ChassisTestBike")); game:GetService("ScriptEditorService"):UpdateSourceAsync(game.ServerScriptService.RaceAndRaid.Lab, function() return [====['+s+']====] end); return "Recovery source installed"'
r=[dict(label='recovery-stop',name='start_stop_play',arguments=dict(studio_id=sid,is_start=False)),dict(label='recovery-sync',name='execute_luau',arguments=dict(studio_id=sid,datamodel_type='Edit',code=code)),dict(label='recovery-play',name='start_stop_play',arguments=dict(studio_id=sid,is_start=True))]
pathlib.Path('docs/mcp-check/recovery.json').write_text(json.dumps(r),encoding='utf-8')