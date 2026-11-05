from pathlib import Path
import json
p=Path('default.project.json');c=json.loads(p.read_text());c['tree']['ReplicatedFirst']={'StealEntry':{'$path':'src/first'}};p.write_text(json.dumps(c,indent=2),encoding='utf-8')
p=Path('src/client/LabHUD.client.luau');s=p.read_text(encoding='utf-8');s=s.replace('local elapsed=0','''local function entryChanged()
 gui.Enabled=player:GetAttribute("EntryOpen")~=true
end
player:GetAttributeChangedSignal("EntryOpen"):Connect(entryChanged)
entryChanged()
local elapsed=0''');p.write_text(s,encoding='utf-8')
sid='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c';source=Path('src/first/Entry.client.luau').read_text(encoding='utf-8')
code='local m=game.ReplicatedFirst:FindFirstChild("Entry") or Instance.new("LocalScript") m.Name="Entry" m.Parent=game.ReplicatedFirst game:GetService("ScriptEditorService"):UpdateSourceAsync(m,function() return [====['+source+']====] end) '
source=Path('src/client/LabHUD.client.luau').read_text(encoding='utf-8');code+='game:GetService("ScriptEditorService"):UpdateSourceAsync(game.StarterPlayer.StarterPlayerScripts:FindFirstChild("LabHUD",true),function() return [====['+source+']====] end) return "entry synced"'
r=[dict(label='entry-stop',name='start_stop_play',arguments=dict(studio_id=sid,is_start=False)),dict(label='entry-sync',name='execute_luau',arguments=dict(studio_id=sid,datamodel_type='Edit',code=code)),dict(label='entry-play',name='start_stop_play',arguments=dict(studio_id=sid,is_start=True))];Path('docs/mcp-check/entry-sync.json').write_text(json.dumps(r))