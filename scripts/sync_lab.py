import pathlib,json
sid='bc26bc01-2367-43e5-becd-edd0fac7ba3e'
r=[dict(label='integration-stop',name='start_stop_play',arguments=dict(studio_id=sid,is_start=False))]
for label,path,inst in [('server','src/server/Lab.server.luau','game.ServerScriptService.RaceAndRaid.Lab'),('client','src/client/LabHUD.client.luau','game.StarterPlayer.StarterPlayerScripts.RaceAndRaid.LabHUD')]:
 s=pathlib.Path(path).read_text(encoding='utf-8')
 code='assert(workspace:FindFirstChild("ChassisTestBike"));game:GetService("ScriptEditorService"):UpdateSourceAsync('+inst+',function() return [====['+s+']====] end);return "updated"'
 r.append(dict(label='sync-'+label,name='execute_luau',arguments=dict(studio_id=sid,datamodel_type='Edit',code=code)))
r.append(dict(label='integration-play',name='start_stop_play',arguments=dict(studio_id=sid,is_start=True)))
pathlib.Path('docs/mcp-check/sync-final.json').write_text(json.dumps(r),encoding='utf-8')