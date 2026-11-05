from pathlib import Path
import json
sid='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c';code=''
for service,name,path in [('game.ReplicatedStorage.RaceAndRaid','HubLayout','src/shared/HubLayout.luau'),('game.ServerScriptService.RaceAndRaid','CargoCourse','src/server/CargoCourse.luau'),('game.ServerScriptService.RaceAndRaid','Lab','src/server/Lab.server.luau')]:
 source=Path(path).read_text(encoding='utf-8');code+='do local parent='+service+' local m=parent:FindFirstChild("'+name+'") or Instance.new("ModuleScript") m.Name="'+name+'" m.Parent=parent game:GetService("ScriptEditorService"):UpdateSourceAsync(m,function() return [====['+source+']====] end) end '
code+='workspace.TestSurface.Transparency=1 workspace.TestSurface.CanCollide=false workspace.Spawn.CFrame=CFrame.new(-752,3,100) return "hub synced"'
r=[dict(label='hub-stop',name='start_stop_play',arguments=dict(studio_id=sid,is_start=False)),dict(label='hub-sync',name='execute_luau',arguments=dict(studio_id=sid,datamodel_type='Edit',code=code)),dict(label='hub-play',name='start_stop_play',arguments=dict(studio_id=sid,is_start=True))];Path('docs/mcp-check/hub-sync.json').write_text(json.dumps(r))