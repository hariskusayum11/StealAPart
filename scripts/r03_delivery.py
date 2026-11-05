from pathlib import Path
import json
sid='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c';code=''
for root,name,path in [('game.ReplicatedStorage.RaceAndRaid','UITheme','src/shared/UITheme.luau'),('game.StarterPlayer.StarterPlayerScripts.RaceAndRaid','LabHUD','src/client/LabHUD.client.luau'),('game.StarterPlayer.StarterPlayerScripts.RaceAndRaid.UI','Components','src/client/UI/Components.luau'),('game.ReplicatedFirst','Entry','src/first/Entry.client.luau')]:
 source=Path(path).read_text(encoding='utf-8');code+='game:GetService("ScriptEditorService"):UpdateSourceAsync('+root+':FindFirstChild("'+name+'",true),function() return [====['+source+']====] end) '
code+='return "R03 final sources synchronized; waiting HUD approval"'
r=[dict(label='r03-delivery-stop',name='start_stop_play',arguments=dict(studio_id=sid,is_start=False)),dict(label='r03-delivery-sync',name='execute_luau',arguments=dict(studio_id=sid,datamodel_type='Edit',code=code))];Path('docs/mcp-check/r03-delivery-request.json').write_text(json.dumps(r))
p=Path('AGENTS.md');s=p.read_text(encoding='utf-8');s=s.replace('Latest authority is docs/MASTER_HANDOFF_30_1_SOURCE.md','Latest implementation order is docs/DEVELOPMENT_ORDER_R03_SOURCE.md (Audit/Main HUD approval gate), alongside docs/MASTER_HANDOFF_30_1_SOURCE.md');p.write_text(s,encoding='utf-8')
p=Path('TASKS.md');p.write_text(p.read_text(encoding='utf-8')+'''
## 2026-11-04 — R03 Audit/Foundation/Main HUD review gate
- Preserved source order and backed up pre-r03-ui-*. Retained LabHUD as sole HUD controller; reusable UITheme and Components added.
- Live chassis speed/gear, session Cargo/deposit count, real zone/location and next-target guidance. No fake economy/NOS/chase.
- All six navigation buttons open/close prototype status panels via real PC mouse input; UI scale100->90% tested. Last integrity check logoLoaded=true, gear1, menuClosed=true, no relevant runtime errors. Compact behavior fixed; Mobile not tested.
- Uploaded user UI kit 92686584842368 and cropped logo/icons only. Last atlas correction visually checked. Original artwork retained; native Entry compliance fix is Build checked, not fresh-Play verified.
- See docs/R03_AUDIT_AND_MAIN_HUD.md and r03-main-walking/driving.png. Build passed. R03 roundtrip and Street Hatch remain unpassed/unavailable; full UI menus/backends not complete.
- Waiting owner review of Main HUD before next UI phase per latest order. No publish, no WorldRepairSimulator changes.
''',encoding='utf-8')