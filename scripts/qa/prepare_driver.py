from pathlib import Path
import json
s=Path('scripts/qa/r02_virtual_driver.luau').read_text(encoding='utf-8')
r=[dict(label='r02-driver-start',name='execute_luau',arguments=dict(studio_id='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c',datamodel_type='Client',code=s))]
Path('docs/mcp-check/r02-driver-start.json').write_text(json.dumps(r))
r=[dict(label='r02-driver-progress',name='execute_luau',arguments=dict(studio_id='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c',datamodel_type='Client',code='local p=game.Players.LocalPlayer return {state=p:GetAttribute("RouteQAState"),progress=p:GetAttribute("RouteQAProgress"),result=p:GetAttribute("RouteQAResult")}'))]
Path('docs/mcp-check/r02-driver-progress.json').write_text(json.dumps(r))