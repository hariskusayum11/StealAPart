from pathlib import Path
import json
s=Path('src/first/Entry.client.luau').read_text(encoding='utf-8')
code='local p=game.Players.LocalPlayer.PlayerGui local old=p:FindFirstChild("StealEntry") if old then old:Destroy() end local m=Instance.new("LocalScript") m.Name="EntryImageTest" m.Source=[====['+s+']====] m.Parent=p return "entry restarted for image check"'
r=[dict(label='image-entry-restart',name='execute_luau',arguments=dict(studio_id='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c',datamodel_type='Client',code=code))]
Path('docs/mcp-check/image-entry-restart.json').write_text(json.dumps(r))